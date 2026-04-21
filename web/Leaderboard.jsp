<%@ page import="java.sql.*" %>
<%@ page import="oes.db.Provider" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Leaderboard ? Examily</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        :root {
            --red: #C0392B;
            --red-dark: #96281B;
            --cream: #FAF8F4;
            --ink: #1A1A1A;
            --muted: #6B6B6B;
            --border: #E5E0D8;
            --white: #FFFFFF;
            --shadow: 0 4px 32px rgba(0,0,0,0.07);

            --gold: #F5A623;
            --gold-bg: #FFF8EC;
            --silver: #8E99A4;
            --silver-bg: #F3F5F7;
            --bronze: #B5672A;
            --bronze-bg: #FDF0E6;
        }

        body {
            font-family: 'DM Sans', sans-serif;
            background: var(--cream);
            color: var(--ink);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        /* ?? NAV ?? */
        nav {
            background: rgba(250,248,244,0.95);
            backdrop-filter: blur(12px);
            border-bottom: 1px solid var(--border);
            padding: 0 2rem;
            display: flex;
            align-items: center;
            height: 64px;
            position: sticky;
            top: 0;
            z-index: 50;
            gap: 1rem;
        }

        .nav-logo {
            display: flex;
            align-items: center;
            gap: 0.6rem;
            text-decoration: none;
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
        }

        .nav-brand {
            font-family: 'Playfair Display', serif;
            font-size: 1.1rem;
            font-weight: 600;
            color: var(--ink);
        }

        .nav-back {
            margin-left: auto;
            display: inline-flex;
            align-items: center;
            gap: 0.45rem;
            font-size: 0.85rem;
            font-weight: 500;
            color: var(--muted);
            text-decoration: none;
            padding: 0.4rem 0.9rem;
            border-radius: 7px;
            border: 1.5px solid var(--border);
            transition: all 0.2s;
        }

        .nav-back:hover {
            color: var(--red);
            border-color: var(--red);
            background: rgba(192,57,43,0.04);
        }

        /* ?? HERO ?? */
        .hero {
            background: linear-gradient(135deg, var(--red) 0%, var(--red-dark) 100%);
            padding: 2.5rem 2rem 2rem;
            position: relative;
            overflow: hidden;
        }

        .hero::before {
            content: '';
            position: absolute;
            top: -60px; right: -60px;
            width: 260px; height: 260px;
            border-radius: 50%;
            background: rgba(255,255,255,0.05);
            pointer-events: none;
        }

        .hero::after {
            content: '';
            position: absolute;
            bottom: -80px; left: 3%;
            width: 180px; height: 180px;
            border-radius: 50%;
            background: rgba(255,255,255,0.04);
            pointer-events: none;
        }

        .hero-inner {
            max-width: 860px;
            margin: 0 auto;
            position: relative;
            z-index: 1;
            animation: fadeUp 0.4s ease both;
        }

        .hero-badge {
            display: inline-flex;
            align-items: center;
            gap: 0.45rem;
            background: rgba(255,255,255,0.15);
            color: rgba(255,255,255,0.9);
            font-size: 0.72rem;
            font-weight: 500;
            letter-spacing: 0.1em;
            text-transform: uppercase;
            padding: 0.3rem 0.8rem;
            border-radius: 100px;
            margin-bottom: 0.85rem;
        }

        .hero-badge::before {
            content: '?';
            font-size: 0.85rem;
        }

        .hero-title {
            font-family: 'Playfair Display', serif;
            font-size: clamp(1.7rem, 3.5vw, 2.4rem);
            font-weight: 700;
            color: white;
            line-height: 1.2;
        }

        .hero-sub {
            color: rgba(255,255,255,0.7);
            font-size: 0.88rem;
            font-weight: 300;
            margin-top: 0.4rem;
        }

        /* ?? PODIUM ?? */
        .podium-section {
            max-width: 860px;
            margin: 2.5rem auto 0;
            padding: 0 1.5rem;
            display: grid;
            grid-template-columns: 1fr 1fr 1fr;
            gap: 1rem;
            align-items: end;
            animation: fadeUp 0.45s 0.05s ease both;
        }

        .podium-card {
            background: var(--white);
            border-radius: 14px;
            border: 1px solid var(--border);
            padding: 1.5rem 1rem 1.25rem;
            text-align: center;
            box-shadow: var(--shadow);
            position: relative;
            overflow: hidden;
        }

        .podium-card.rank-1 {
            border-color: var(--gold);
            background: var(--gold-bg);
            transform: translateY(-10px);
        }

        .podium-card.rank-2 {
            border-color: var(--silver);
            background: var(--silver-bg);
        }

        .podium-card.rank-3 {
            border-color: var(--bronze);
            background: var(--bronze-bg);
        }

        .podium-medal {
            font-size: 2rem;
            margin-bottom: 0.5rem;
            display: block;
        }

        .podium-rank-label {
            font-size: 0.7rem;
            font-weight: 600;
            letter-spacing: 0.1em;
            text-transform: uppercase;
            margin-bottom: 0.3rem;
        }

        .rank-1 .podium-rank-label { color: var(--gold); }
        .rank-2 .podium-rank-label { color: var(--silver); }
        .rank-3 .podium-rank-label { color: var(--bronze); }

        .podium-name {
            font-family: 'Playfair Display', serif;
            font-size: 1rem;
            font-weight: 600;
            color: var(--ink);
            margin-bottom: 0.3rem;
            word-break: break-all;
        }

        .podium-score {
            font-size: 1.4rem;
            font-weight: 600;
            color: var(--ink);
        }

        .podium-score-label {
            font-size: 0.72rem;
            color: var(--muted);
            display: block;
        }

        /* ?? TABLE CARD ?? */
        main {
            flex: 1;
            max-width: 860px;
            width: 100%;
            margin: 1.75rem auto 2.5rem;
            padding: 0 1.5rem;
        }

        .table-card {
            background: var(--white);
            border-radius: 16px;
            border: 1px solid var(--border);
            box-shadow: var(--shadow);
            overflow: hidden;
            animation: fadeUp 0.45s 0.1s ease both;
        }

        .table-card-header {
            padding: 1.25rem 1.75rem;
            border-bottom: 1px solid var(--border);
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .table-card-header h3 {
            font-family: 'Playfair Display', serif;
            font-size: 1rem;
            font-weight: 600;
            color: var(--ink);
        }

        .table-card-header p {
            font-size: 0.78rem;
            color: var(--muted);
            margin-top: 0.1rem;
        }

        .header-icon {
            width: 36px; height: 36px;
            background: rgba(192,57,43,0.08);
            border-radius: 9px;
            display: flex; align-items: center; justify-content: center;
            flex-shrink: 0;
        }

        .header-icon svg { color: var(--red); }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        thead th {
            background: var(--cream);
            padding: 0.75rem 1.75rem;
            font-size: 0.72rem;
            font-weight: 600;
            color: var(--muted);
            text-transform: uppercase;
            letter-spacing: 0.08em;
            border-bottom: 1px solid var(--border);
            text-align: left;
        }

        thead th:last-child { text-align: right; }

        tbody tr {
            border-bottom: 1px solid var(--border);
            transition: background 0.15s;
            animation: fadeUp 0.4s ease both;
        }

        tbody tr:last-child { border-bottom: none; }
        tbody tr:hover { background: var(--cream); }

        tbody td {
            padding: 0.9rem 1.75rem;
            font-size: 0.9rem;
            color: var(--ink);
            vertical-align: middle;
        }

        tbody td:last-child {
            text-align: right;
            font-weight: 600;
        }

        /* rank badge */
        .rank-badge {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 28px; height: 28px;
            border-radius: 7px;
            font-size: 0.8rem;
            font-weight: 600;
        }

        .rank-badge.r1 { background: var(--gold-bg);   color: var(--gold);   }
        .rank-badge.r2 { background: var(--silver-bg); color: var(--silver); }
        .rank-badge.r3 { background: var(--bronze-bg); color: var(--bronze); }
        .rank-badge.rn { background: rgba(192,57,43,0.07); color: var(--muted); }

        /* score bar */
        .score-cell { display: flex; align-items: center; justify-content: flex-end; gap: 0.75rem; }

        .score-bar-wrap {
            width: 80px;
            height: 5px;
            background: var(--border);
            border-radius: 10px;
            overflow: hidden;
        }

        .score-bar {
            height: 100%;
            border-radius: 10px;
            background: var(--red);
            transition: width 0.6s ease;
        }

        /* user pill */
        .user-pill {
            display: inline-flex;
            align-items: center;
            gap: 0.6rem;
        }

        .user-avatar {
            width: 30px; height: 30px;
            border-radius: 50%;
            background: rgba(192,57,43,0.1);
            color: var(--red);
            font-size: 0.72rem;
            font-weight: 600;
            display: flex; align-items: center; justify-content: center;
            flex-shrink: 0;
            text-transform: uppercase;
        }

        /* ?? FOOTER ?? */
        footer {
            border-top: 1px solid var(--border);
            padding: 1.25rem 2rem;
            text-align: center;
            font-size: 0.8rem;
            color: var(--muted);
        }

        /* ?? ANIMATIONS ?? */
        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(16px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        @media (max-width: 600px) {
            .podium-section { grid-template-columns: 1fr; align-items: stretch; }
            .podium-card.rank-1 { transform: none; }
            thead th, tbody td { padding-left: 1rem; padding-right: 1rem; }
            .score-bar-wrap { display: none; }
        }
    </style>
</head>
<body>

    <%
        Connection con = Provider.getOracleConnection();
        Statement st = con.createStatement();
       ResultSet rs = st.executeQuery(
    "SELECT r.userid, s.name, MAX(r.score) as score " +
    "FROM resulttable r " +
    "LEFT JOIN studenttable s ON r.userid = s.userid " +
    "GROUP BY r.userid, s.name " +
    "ORDER BY MAX(r.score) DESC");

        // Collect all rows first so we can build the podium
        java.util.List<String[]> rows = new java.util.ArrayList<>();
int maxScore = 1;
while (rs.next()) {
    String uid   = rs.getString("userid");
    String name  = rs.getString("name");
    int score    = rs.getInt("score");
    if (name == null || name.isEmpty()) name = uid; // fallback
    if (score > maxScore) maxScore = score;
    rows.add(new String[]{ uid, String.valueOf(score), name });
}
        rs.close(); st.close(); con.close();

        String[] medals  = { "?", "?", "?" };
        String[] rankCls = { "rank-1", "rank-2", "rank-3" };
        String[] rankLbl = { "1st Place", "2nd Place", "3rd Place" };
        String[] bdgCls  = { "r1", "r2", "r3" };
    %>

    <!-- NAV -->
    <nav>
        <a href="#" class="nav-logo">
            <div class="nav-logo-icon">E</div>
            <span class="nav-brand">Examily</span>
        </a>
        <a href="AdminPanel.jsp" class="nav-back">
            <svg width="14" height="14" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                <path stroke-linecap="round" stroke-linejoin="round" d="M15 19l-7-7 7-7"/>
            </svg>
            Admin Panel
        </a>
    </nav>

    <!-- HERO -->
    <div class="hero">
        <div class="hero-inner">
            <div class="hero-badge">Live Rankings</div>
            <div class="hero-title">Leaderboard</div>
            <div class="hero-sub">Top performers ranked by exam score</div>
        </div>
    </div>

    <!-- PODIUM (top 3) -->
    <% if (rows.size() >= 3) { %>
    <div class="podium-section">
        <!-- show 2nd, 1st, 3rd left-to-right -->
        <%
            int[] podiumOrder = {1, 0, 2};
            for (int pi : podiumOrder) {
                if (pi >= rows.size()) continue;
                String uid   = rows.get(pi)[0];
                String score = rows.get(pi)[1];
                String initials = uid.length() >= 2 ? uid.substring(0,2).toUpperCase() : uid.toUpperCase();
        %>
        <div class="podium-card <%= rankCls[pi] %>">
            <span class="podium-medal"><%= medals[pi] %></span>
            <div class="podium-rank-label"><%= rankLbl[pi] %></div>
            <div class="podium-name"><%= uid %></div>
            <div class="podium-score"><%= score %></div>
            <span class="podium-score-label">pts</span>
        </div>
        <% } %>
    </div>
    <% } %>

    <!-- FULL TABLE -->
    <main>
        <div class="table-card">
            <div class="table-card-header">
                <div class="header-icon">
                    <svg width="17" height="17" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"/>
                    </svg>
                </div>
                <div>
                    <h3>Full Rankings</h3>
                    <p><%= rows.size() %> student<%= rows.size() != 1 ? "s" : "" %> on the board</p>
                </div>
            </div>

            <table>
                <thead>
                    <tr>
                        <th style="width:60px">Rank</th>
                        <th>Student ID</th>
                        <th>Score</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        for (int i = 0; i < rows.size(); i++) {
                            String uid   = rows.get(i)[0];
                            int score    = Integer.parseInt(rows.get(i)[1]);
                            int pct      = (int) Math.round((double) score / maxScore * 100);
                            String bCls  = i < 3 ? bdgCls[i] : "rn";
                            String initials = uid.length() >= 2 ? uid.substring(0,2).toUpperCase() : uid.toUpperCase();
                    %>
                    <tr style="animation-delay: <%= (i * 0.04) %>s">
                        <td><span class="rank-badge <%= bCls %>"><%= (i+1) %></span></td>
                        <td>
                            <div class="user-pill">
                                <div class="user-avatar"><%= initials %></div>
                                <%= uid %>
                            </div>
                        </td>
                        <td>
                            <div class="score-cell">
                                <div class="score-bar-wrap">
                                    <div class="score-bar" style="width:<%= pct %>%"></div>
                                </div>
                                <%= score %>
                            </div>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </main>

    <!-- FOOTER -->
    <footer>© 2026 Examily, Inc. All rights reserved.</footer>

</body>
</html>
