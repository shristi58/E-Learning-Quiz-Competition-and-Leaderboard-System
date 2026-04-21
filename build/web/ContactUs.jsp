<%-- 
   
--%>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Contact Us ? Examily</title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;600;700&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        :root {
            --red: #C0392B;
            --red-dark: #96281B;
            --red-light: #E8472E;
            --cream: #FAF8F4;
            --ink: #1A1A1A;
            --muted: #6B6B6B;
            --border: #E5E0D8;
            --white: #FFFFFF;
            --shadow: 0 4px 32px rgba(0,0,0,0.08);
            --shadow-hover: 0 12px 48px rgba(192,57,43,0.18);
        }

        html { scroll-behavior: smooth; }

        body {
            font-family: 'DM Sans', sans-serif;
            background: var(--cream);
            color: var(--ink);
            min-height: 100vh;
            overflow-x: hidden;
        }

        /* ?? NAV ?? */
        nav {
            position: sticky;
            top: 0;
            z-index: 100;
            background: rgba(250,248,244,0.92);
            backdrop-filter: blur(12px);
            border-bottom: 1px solid var(--border);
            padding: 0 2rem;
            display: flex;
            align-items: center;
            height: 64px;
            gap: 1.5rem;
        }

        .nav-logo {
            display: flex;
            align-items: center;
            gap: 0.6rem;
            text-decoration: none;
            color: var(--ink);
        }

        .nav-logo-icon {
            width: 32px; height: 32px;
            background: var(--red);
            border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            color: white;
            font-family: 'Playfair Display', serif;
            font-weight: 700;
            font-size: 0.85rem;
            flex-shrink: 0;
        }

        .nav-brand {
            font-family: 'Playfair Display', serif;
            font-weight: 600;
            font-size: 1.1rem;
            letter-spacing: 0.02em;
        }

        .nav-links {
            display: flex;
            gap: 0.25rem;
            margin-left: auto;
            list-style: none;
        }

        .nav-links a {
            text-decoration: none;
            color: var(--muted);
            font-size: 0.88rem;
            font-weight: 400;
            padding: 0.4rem 0.85rem;
            border-radius: 6px;
            transition: color 0.2s, background 0.2s;
            letter-spacing: 0.01em;
        }

        .nav-links a:hover,
        .nav-links a.active {
            color: var(--red);
            background: rgba(192,57,43,0.07);
        }

        /* ?? HERO STRIP ?? */
        .hero-strip {
            background: var(--red);
            padding: 3.5rem 2rem 3rem;
            position: relative;
            overflow: hidden;
        }

        .hero-strip::before {
            content: '';
            position: absolute;
            top: -60px; right: -60px;
            width: 280px; height: 280px;
            border-radius: 50%;
            background: rgba(255,255,255,0.06);
            pointer-events: none;
        }

        .hero-strip::after {
            content: '';
            position: absolute;
            bottom: -80px; left: 5%;
            width: 200px; height: 200px;
            border-radius: 50%;
            background: rgba(255,255,255,0.04);
            pointer-events: none;
        }

        .hero-inner {
            max-width: 1100px;
            margin: 0 auto;
            position: relative;
            z-index: 1;
        }

        .hero-eyebrow {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            background: rgba(255,255,255,0.15);
            color: rgba(255,255,255,0.9);
            font-size: 0.75rem;
            font-weight: 500;
            letter-spacing: 0.12em;
            text-transform: uppercase;
            padding: 0.35rem 0.85rem;
            border-radius: 100px;
            margin-bottom: 1rem;
        }

        .hero-eyebrow::before {
            content: '';
            width: 6px; height: 6px;
            border-radius: 50%;
            background: rgba(255,255,255,0.7);
        }

        .hero-title {
            font-family: 'Playfair Display', serif;
            font-size: clamp(2rem, 4vw, 3rem);
            font-weight: 700;
            color: white;
            line-height: 1.15;
            margin-bottom: 0.6rem;
        }

        .hero-sub {
            color: rgba(255,255,255,0.75);
            font-size: 1rem;
            font-weight: 300;
            max-width: 440px;
        }

        /* ?? MAIN CONTENT ?? */
        .main-content {
            max-width: 1100px;
            margin: 0 auto;
            padding: 3rem 2rem 4rem;
            display: grid;
            grid-template-columns: 1fr 420px;
            gap: 2.5rem;
            align-items: start;
        }

        /* ?? FORM CARD ?? */
        .form-card {
            background: var(--white);
            border-radius: 16px;
            padding: 2.5rem;
            box-shadow: var(--shadow);
            border: 1px solid var(--border);
        }

        .form-card h3 {
            font-family: 'Playfair Display', serif;
            font-size: 1.35rem;
            font-weight: 600;
            color: var(--ink);
            margin-bottom: 0.3rem;
        }

        .form-card p {
            font-size: 0.87rem;
            color: var(--muted);
            margin-bottom: 2rem;
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            gap: 0.4rem;
            margin-bottom: 1.1rem;
        }

        .form-group label {
            font-size: 0.78rem;
            font-weight: 500;
            color: var(--muted);
            letter-spacing: 0.05em;
            text-transform: uppercase;
        }

        .form-group input,
        .form-group textarea {
            width: 100%;
            padding: 0.75rem 1rem;
            border: 1.5px solid var(--border);
            border-radius: 8px;
            font-family: 'DM Sans', sans-serif;
            font-size: 0.9rem;
            color: var(--ink);
            background: var(--cream);
            outline: none;
            transition: border-color 0.2s, box-shadow 0.2s, background 0.2s;
        }

        .form-group input:focus,
        .form-group textarea:focus {
            border-color: var(--red);
            background: white;
            box-shadow: 0 0 0 3px rgba(192,57,43,0.09);
        }

        .form-group input::placeholder,
        .form-group textarea::placeholder {
            color: #B0A99F;
        }

        .form-group textarea {
            resize: vertical;
            min-height: 120px;
        }

        .btn-submit {
            display: inline-flex;
            align-items: center;
            gap: 0.55rem;
            background: var(--red);
            color: white;
            border: none;
            padding: 0.85rem 2rem;
            border-radius: 8px;
            font-family: 'DM Sans', sans-serif;
            font-size: 0.92rem;
            font-weight: 500;
            cursor: pointer;
            transition: background 0.2s, transform 0.15s, box-shadow 0.2s;
            letter-spacing: 0.02em;
        }

        .btn-submit:hover {
            background: var(--red-dark);
            transform: translateY(-1px);
            box-shadow: var(--shadow-hover);
        }

        .btn-submit:active {
            transform: translateY(0);
        }

        .btn-submit svg {
            transition: transform 0.2s;
        }

        .btn-submit:hover svg {
            transform: translateX(3px);
        }

        /* ?? SIDE PANEL ?? */
        .side-panel {
            display: flex;
            flex-direction: column;
            gap: 1.25rem;
        }

        /* MAP */
        .map-card {
            background: var(--white);
            border-radius: 16px;
            overflow: hidden;
            box-shadow: var(--shadow);
            border: 1px solid var(--border);
        }

        .map-card iframe {
            display: block;
            width: 100%;
            height: 240px;
            border: none;
        }

        .map-label {
            padding: 1rem 1.25rem;
            border-top: 1px solid var(--border);
        }

        .map-label strong {
            display: block;
            font-size: 0.88rem;
            font-weight: 500;
            color: var(--ink);
            margin-bottom: 0.25rem;
        }

        .map-label span {
            font-size: 0.8rem;
            color: var(--muted);
        }

        /* ADDRESS CARD */
        .address-card {
            background: var(--white);
            border-radius: 16px;
            padding: 1.5rem;
            box-shadow: var(--shadow);
            border: 1px solid var(--border);
        }

        .address-card h4 {
            font-family: 'Playfair Display', serif;
            font-size: 1rem;
            font-weight: 600;
            color: var(--ink);
            margin-bottom: 1rem;
        }

        .contact-item {
            display: flex;
            align-items: flex-start;
            gap: 0.75rem;
            padding: 0.65rem 0;
            border-bottom: 1px solid var(--border);
        }

        .contact-item:last-child { border-bottom: none; }

        .contact-icon {
            width: 34px; height: 34px;
            border-radius: 8px;
            background: rgba(192,57,43,0.08);
            display: flex; align-items: center; justify-content: center;
            flex-shrink: 0;
        }

        .contact-icon svg { color: var(--red); }

        .contact-text {
            display: flex;
            flex-direction: column;
            gap: 0.1rem;
        }

        .contact-label {
            font-size: 0.72rem;
            font-weight: 500;
            color: var(--muted);
            text-transform: uppercase;
            letter-spacing: 0.08em;
        }

        .contact-value {
            font-size: 0.88rem;
            color: var(--ink);
        }

        .contact-value a {
            color: var(--ink);
            text-decoration: none;
            transition: color 0.2s;
        }

        .contact-value a:hover { color: var(--red); }

        /* ?? FOOTER ?? */
        footer {
            border-top: 1px solid var(--border);
            padding: 1.5rem 2rem;
            text-align: center;
            font-size: 0.82rem;
            color: var(--muted);
        }

        /* ?? ANIMATIONS ?? */
        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(20px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        .hero-inner { animation: fadeUp 0.5s ease both; }
        .form-card  { animation: fadeUp 0.55s 0.1s ease both; }
        .side-panel { animation: fadeUp 0.55s 0.18s ease both; }

        /* ?? RESPONSIVE ?? */
        @media (max-width: 820px) {
            .main-content {
                grid-template-columns: 1fr;
                padding: 2rem 1.25rem 3rem;
            }
            .form-row { grid-template-columns: 1fr; }
        }

        @media (max-width: 480px) {
            .hero-strip { padding: 2.5rem 1.25rem 2rem; }
            .form-card { padding: 1.5rem; }
        }
    </style>
</head>
<body>

    <!-- NAV -->
    <nav>
        <a href="index.html" class="nav-logo">
            <div class="nav-logo-icon">E</div>
            <span class="nav-brand">Examily</span>
        </a>
        <ul class="nav-links">
            <li><a href="index.html">Home</a></li>
            <li><a href="ContactUs.jsp" class="active">Contact Us</a></li>
        </ul>
    </nav>

    <!-- HERO -->
    <div class="hero-strip">
        <div class="hero-inner">
            <div class="hero-eyebrow">Get in Touch</div>
            <h1 class="hero-title">We'd love to<br>hear from you.</h1>
            <p class="hero-sub">Drop your inquiry below and our experts will get back to you as soon as possible.</p>
        </div>
    </div>

    <!-- MAIN -->
    <div class="main-content">

        <!-- FORM -->
        <div class="form-card">
            <h3>Send a Message</h3>
            <p>Fill in the form and we'll be in touch within 24 hours.</p>

            <form action="/">
                <div class="form-row">
                    <div class="form-group">
                        <label for="name">Your Name</label>
                        <input type="text" name="name" id="name" placeholder="Samrat" />
                    </div>
                    <div class="form-group">
                        <label for="email">Email Address</label>
                        <input type="email" name="email" id="email" placeholder="Samrat@gmail.com" />
                    </div>
                </div>

                <div class="form-group">
                    <label for="subject">Subject</label>
                    <input type="text" name="subject" id="subject" placeholder="How can we help you?" />
                </div>

                <div class="form-group">
                    <label for="message">Message</label>
                    <textarea name="message" id="message" placeholder="Write your message here?"></textarea>
                </div>

                <button type="submit" class="btn-submit">
                    Send Message
                    <svg width="16" height="16" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M17 8l4 4m0 0l-4 4m4-4H3" />
                    </svg>
                </button>
            </form>
        </div>

        <!-- SIDE PANEL -->
        <div class="side-panel">

            <!-- MAP -->
            <div class="map-card">
                <iframe
                    src="https://maps.google.com/maps?q=Chandigarh+University+Mohali+Punjab&t=&z=15&ie=UTF8&iwloc=&output=embed"
                    allowfullscreen=""
                    aria-hidden="false"
                    tabindex="0"
                    title="Examily New York Office Location">
                </iframe>
                <div class="map-label">
                    <strong>Chandigarh University</strong>
                    <span>NH-05 Chandigarh Ludhiana Highway, Mohali, Punjab 140413, India</span>
                </div>
            </div>

            <!-- ADDRESS -->
            <div class="address-card">
                <h4>Contact Information</h4>

                <div class="contact-item">
                    <div class="contact-icon">
                        <svg width="16" height="16" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
                            <path stroke-linecap="round" stroke-linejoin="round" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z" />
                        </svg>
                    </div>
                    <div class="contact-text">
                        <span class="contact-label">Address</span>
                        <span class="contact-value">NH-05 Chandigarh Ludhiana Highway, Mohali, Punjab 140413, India</span>
                    </div>
                </div>

                <div class="contact-item">
                    <div class="contact-icon">
                        <svg width="16" height="16" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M3 5a2 2 0 012-2h3.28a1 1 0 01.948.684l1.498 4.493a1 1 0 01-.502 1.21l-2.257 1.13a11.042 11.042 0 005.516 5.516l1.13-2.257a1 1 0 011.21-.502l4.493 1.498a1 1 0 01.684.949V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z" />
                        </svg>
                    </div>
                    <div class="contact-text">
                        <span class="contact-label">Telephone</span>
                        <span class="contact-value"><a href="tel:+12129771588">+91 9905014635</a></span>
                    </div>
                </div>

                <div class="contact-item">
                    <div class="contact-icon">
                        <svg width="16" height="16" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
                        </svg>
                    </div>
                    <div class="contact-text">
                        <span class="contact-label">Email</span>
                        <span class="contact-value"><a href="mailto:info@examily.com">info@examily.com</a></span>
                    </div>
                </div>
            </div>

        </div>
    </div>

    <!-- FOOTER -->
    <footer>
        © 2026 Examily, Inc. All rights reserved.
    </footer>

</body>
</html>
