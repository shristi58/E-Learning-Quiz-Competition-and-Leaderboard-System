/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */
/**
 * antiCheat.js — Anti-Cheating Module for Online Exam System
 * Drop this file into your Web Pages folder and include it in Exam.jsp
 *
 * Features:
 *  1. Tab-switch / visibility detection
 *  2. Fullscreen enforcement
 *  3. Right-click, copy, paste & text-selection blocking
 *  4. Violation counter → auto-submit after MAX_VIOLATIONS
 *  5. Non-intrusive UI overlay (does NOT break existing timer)
 */

(function () {
  "use strict";

  /* ─── Configuration ─────────────────────────────────────────── */
  const MAX_VIOLATIONS   = 3;          // auto-submit after this many
  const FORM_ID          = "examForm"; // id="" of your <form> in Exam.jsp
  const VIOLATION_FIELD  = "violations"; // hidden input name for server-side logging
  /* ─────────────────────────────────────────────────────────────── */

  let violationCount = 0;
  let warningVisible = false;

  /* ══════════════════════════════════════════════════════════════
     1.  BUILD THE WARNING OVERLAY (injected once into DOM)
  ══════════════════════════════════════════════════════════════ */
  function buildOverlay() {
    /* ── styles ── */
    const style = document.createElement("style");
    style.textContent = `
      /* ---- reset & base ---- */
      #ac-overlay *{box-sizing:border-box;margin:0;padding:0}

      /* ---- full-screen dim ---- */
      #ac-overlay{
        display:none;
        position:fixed;inset:0;z-index:99999;
        background:rgba(10,10,20,.72);
        backdrop-filter:blur(4px);
        align-items:center;justify-content:center;
        font-family:'Segoe UI',system-ui,sans-serif;
      }
      #ac-overlay.ac-show{display:flex;animation:acFadeIn .25s ease}

      @keyframes acFadeIn{from{opacity:0;transform:scale(.96)}to{opacity:1;transform:scale(1)}}
      @keyframes acShake{
        0%,100%{transform:translateX(0)}
        20%{transform:translateX(-8px)}
        40%{transform:translateX(8px)}
        60%{transform:translateX(-6px)}
        80%{transform:translateX(6px)}
      }

      /* ---- card ---- */
      #ac-card{
        background:#fff;
        border-radius:14px;
        padding:36px 40px 28px;
        max-width:440px;width:90%;
        box-shadow:0 24px 60px rgba(0,0,0,.35);
        text-align:center;
        position:relative;
        overflow:hidden;
      }
      #ac-card::before{          /* red accent bar at top */
        content:'';
        display:block;
        position:absolute;top:0;left:0;right:0;height:5px;
        background:linear-gradient(90deg,#e53935,#ff6f00);
      }

      /* ---- icon ---- */
      .ac-icon{
        width:62px;height:62px;border-radius:50%;
        background:linear-gradient(135deg,#ffebee,#fff3e0);
        display:flex;align-items:center;justify-content:center;
        margin:0 auto 18px;
        font-size:30px;
        box-shadow:0 4px 16px rgba(229,57,53,.18);
      }

      /* ---- text ---- */
      #ac-title{
        font-size:1.18rem;font-weight:700;
        color:#b71c1c;margin-bottom:10px;letter-spacing:-.01em;
      }
      #ac-msg{
        font-size:.93rem;color:#444;line-height:1.6;margin-bottom:22px;
      }

      /* ---- violation bar ---- */
      .ac-bar-wrap{
        background:#f5f5f5;border-radius:8px;
        height:8px;margin-bottom:6px;overflow:hidden;
      }
      .ac-bar-fill{
        height:100%;border-radius:8px;
        background:linear-gradient(90deg,#ff6f00,#e53935);
        transition:width .4s ease;
      }
      .ac-bar-label{
        font-size:.78rem;color:#888;margin-bottom:20px;
        text-align:right;
      }

      /* ---- buttons ---- */
      .ac-btn-row{display:flex;gap:10px;justify-content:center;}
      .ac-btn{
        padding:10px 26px;border-radius:8px;font-size:.9rem;
        font-weight:600;cursor:pointer;border:none;transition:all .18s;
      }
      .ac-btn-primary{
        background:linear-gradient(135deg,#e53935,#c62828);
        color:#fff;box-shadow:0 4px 12px rgba(229,57,53,.3);
      }
      .ac-btn-primary:hover{transform:translateY(-1px);box-shadow:0 6px 18px rgba(229,57,53,.4);}
      .ac-btn-secondary{
        background:#f5f5f5;color:#555;
      }
      .ac-btn-secondary:hover{background:#eeeeee;}

      /* ---- auto-submit banner ---- */
      #ac-banner{
        display:none;
        position:fixed;top:0;left:0;right:0;z-index:100000;
        background:linear-gradient(90deg,#b71c1c,#e53935);
        color:#fff;text-align:center;
        padding:14px 20px;
        font-family:'Segoe UI',system-ui,sans-serif;
        font-size:.96rem;font-weight:600;
        box-shadow:0 4px 20px rgba(0,0,0,.3);
        animation:acFadeIn .3s ease;
      }
      #ac-banner.ac-show{display:block;}

      /* ---- toast (non-blocking small notice) ---- */
      #ac-toast{
        display:none;
        position:fixed;bottom:28px;left:50%;transform:translateX(-50%);
        z-index:99998;
        background:#212121;color:#fff;
        padding:11px 22px;border-radius:8px;
        font-family:'Segoe UI',system-ui,sans-serif;
        font-size:.88rem;font-weight:500;
        box-shadow:0 6px 20px rgba(0,0,0,.3);
        white-space:nowrap;
        animation:acFadeIn .2s ease;
      }
      #ac-toast.ac-show{display:block;}

      /* ---- disable text select on exam body ---- */
      .ac-no-select{
        -webkit-user-select:none;
        -moz-user-select:none;
        user-select:none;
      }
    `;
    document.head.appendChild(style);

    /* ── overlay markup ── */
    const overlay = document.createElement("div");
    overlay.id = "ac-overlay";
    overlay.innerHTML = `
      <div id="ac-card">
        <div class="ac-icon">⚠️</div>
        <div id="ac-title">Warning — Suspicious Activity</div>
        <p  id="ac-msg">Tab switching detected. This may be considered cheating.</p>
        <div class="ac-bar-wrap">
          <div class="ac-bar-fill" id="ac-bar" style="width:0%"></div>
        </div>
        <div class="ac-bar-label" id="ac-bar-label">Violations: 0 / ${MAX_VIOLATIONS}</div>
        <div class="ac-btn-row">
          <button class="ac-btn ac-btn-secondary" id="ac-btn-fullscreen">Go Fullscreen</button>
          <button class="ac-btn ac-btn-primary"   id="ac-btn-resume">I Understand</button>
        </div>
      </div>
    `;
    document.body.appendChild(overlay);

    /* ── top banner (for final auto-submit warning) ── */
    const banner = document.createElement("div");
    banner.id = "ac-banner";
    banner.textContent = "⛔ Maximum violations reached. Your exam is being submitted automatically…";
    document.body.appendChild(banner);

    /* ── small toast ── */
    const toast = document.createElement("div");
    toast.id = "ac-toast";
    document.body.appendChild(toast);

    /* button handlers */
    document.getElementById("ac-btn-resume").addEventListener("click", hideWarning);
    document.getElementById("ac-btn-fullscreen").addEventListener("click", () => {
      requestFullscreen();
      hideWarning();
    });
  }

  /* ══════════════════════════════════════════════════════════════
     2.  VIOLATION MANAGEMENT
  ══════════════════════════════════════════════════════════════ */
  function recordViolation(reason) {
    violationCount++;
    updateViolationField();
    updateBar();

    if (violationCount >= MAX_VIOLATIONS) {
      triggerAutoSubmit();
      return;
    }

    showWarning(reason);
  }

  function updateBar() {
    const pct = Math.min((violationCount / MAX_VIOLATIONS) * 100, 100);
    const bar  = document.getElementById("ac-bar");
    const lbl  = document.getElementById("ac-bar-label");
    if (bar) bar.style.width = pct + "%";
    if (lbl) lbl.textContent  = `Violations: ${violationCount} / ${MAX_VIOLATIONS}`;
  }

  function updateViolationField() {
    /* Keep a hidden input in sync so the server can record it */
    let field = document.querySelector(`input[name="${VIOLATION_FIELD}"]`);
    if (!field) {
      field = document.createElement("input");
      field.type = "hidden";
      field.name = VIOLATION_FIELD;
      const form = document.getElementById(FORM_ID);
      if (form) form.appendChild(field);
    }
    field.value = violationCount;
  }

  /* ══════════════════════════════════════════════════════════════
     3.  OVERLAY SHOW / HIDE
  ══════════════════════════════════════════════════════════════ */
  function showWarning(message) {
    if (warningVisible) return;
    warningVisible = true;

    const overlay = document.getElementById("ac-overlay");
    const msgEl   = document.getElementById("ac-msg");
    const card    = document.getElementById("ac-card");

    if (msgEl)   msgEl.textContent = message;
    if (overlay) overlay.classList.add("ac-show");

    /* shake the card for emphasis */
    if (card) {
      card.style.animation = "none";
      void card.offsetWidth; // reflow
      card.style.animation  = "acShake .4s ease";
    }

    updateBar();
  }

  function hideWarning() {
    warningVisible = false;
    const overlay = document.getElementById("ac-overlay");
    if (overlay) overlay.classList.remove("ac-show");
  }

  function showToast(msg, durationMs = 3000) {
    const toast = document.getElementById("ac-toast");
    if (!toast) return;
    toast.textContent = msg;
    toast.classList.add("ac-show");
    setTimeout(() => toast.classList.remove("ac-show"), durationMs);
  }

  /* ══════════════════════════════════════════════════════════════
     4.  AUTO SUBMIT
  ══════════════════════════════════════════════════════════════ */
  function triggerAutoSubmit() {
    const banner = document.getElementById("ac-banner");
    if (banner) banner.classList.add("ac-show");

    hideWarning();

    setTimeout(() => {
      const form = document.getElementById(FORM_ID);
      if (form) {
        form.submit();
      } else {
        /* Fallback: click any submit button found */
        const btn = document.querySelector('input[type="submit"], button[type="submit"]');
        if (btn) btn.click();
      }
    }, 2500); // short delay so student sees the banner
  }

  /* ══════════════════════════════════════════════════════════════
     5.  TAB-SWITCH / VISIBILITY DETECTION
  ══════════════════════════════════════════════════════════════ */
  function initVisibilityDetection() {
    document.addEventListener("visibilitychange", () => {
      if (document.hidden) {
        recordViolation("Tab switching detected. This may be considered cheating.");
      }
    });

    window.addEventListener("blur", () => {
      /* fires when the window loses focus (e.g. another app) */
      if (document.visibilityState === "visible") {
        recordViolation("Browser window lost focus. Please stay on the exam tab.");
      }
    });
  }

  /* ══════════════════════════════════════════════════════════════
     6.  FULLSCREEN ENFORCEMENT
  ══════════════════════════════════════════════════════════════ */
  function requestFullscreen() {
    const el = document.documentElement;
    const req = el.requestFullscreen
              || el.webkitRequestFullscreen
              || el.mozRequestFullScreen
              || el.msRequestFullscreen;
    if (req) req.call(el).catch(() => {
      showToast("Fullscreen request was denied. Please allow fullscreen for this exam.");
    });
  }

  function initFullscreenEnforcement() {
    /* ask on page load */
    requestFullscreen();

    const handler = () => {
      const isFS = !!(document.fullscreenElement
                   || document.webkitFullscreenElement
                   || document.mozFullScreenElement
                   || document.msFullscreenElement);
      if (!isFS) {
        recordViolation("Fullscreen mode was exited. Please remain in fullscreen during the exam.");
      }
    };

    document.addEventListener("fullscreenchange",       handler);
    document.addEventListener("webkitfullscreenchange", handler);
    document.addEventListener("mozfullscreenchange",    handler);
    document.addEventListener("MSFullscreenChange",     handler);
  }

  /* ══════════════════════════════════════════════════════════════
     7.  DISABLE RIGHT-CLICK, COPY, PASTE, TEXT SELECTION
  ══════════════════════════════════════════════════════════════ */
  function initInputRestrictions() {
    /* disable text selection on the body */
    document.body.classList.add("ac-no-select");

    document.addEventListener("contextmenu", e => {
      e.preventDefault();
      showToast("Right-click is disabled during the exam.");
    });

    document.addEventListener("copy",  e => { e.preventDefault(); showToast("Copying is not allowed."); });
    document.addEventListener("paste", e => { e.preventDefault(); showToast("Pasting is not allowed."); });
    document.addEventListener("cut",   e => { e.preventDefault(); showToast("Cutting is not allowed.");  });

    /* block common keyboard shortcuts */
    document.addEventListener("keydown", e => {
      const ctrl = e.ctrlKey || e.metaKey;
      if (ctrl && ["c","v","x","a","u","s","p"].includes(e.key.toLowerCase())) {
        e.preventDefault();
        showToast("Keyboard shortcut disabled during exam.");
      }
      /* block F12 / DevTools */
      if (e.key === "F12") {
        e.preventDefault();
        showToast("Developer tools are disabled during the exam.");
      }
    });
  }

  /* ══════════════════════════════════════════════════════════════
     8.  INIT — wire everything up after DOM is ready
  ══════════════════════════════════════════════════════════════ */
  function init() {
    buildOverlay();
    initVisibilityDetection();
    initFullscreenEnforcement();
    initInputRestrictions();
    console.info("[AntiCheat] Monitoring active. Max violations:", MAX_VIOLATIONS);
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", init);
  } else {
    init();
  }
})();

