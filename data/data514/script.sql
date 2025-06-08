-- 1. GAME
CREATE TABLE GAME (
    appid INTEGER PRIMARY KEY,
    name TEXT,
    type TEXT,
    required_age INTEGER,
    is_free BOOLEAN,
    short_description TEXT,
    capsule_image TEXT,
    release_date DATE,
    platforms TEXT,
    metacritic_score INTEGER,
    movies TEXT
);

-- 2. SYSTEMREQUIREMENTS
CREATE TABLE SYSTEMREQUIREMENTS (
    appid INTEGER,
    simplified_os TEXT,
    os TEXT,
    cpu TEXT,
    gpu TEXT,
    ram_gb INTEGER,
    storage_gb INTEGER,
    FOREIGN KEY (appid) REFERENCES GAME(appid)
);

-- 3. COMPANIES
CREATE TABLE COMPANIES (
    appid INTEGER,
    developers TEXT,
    publishers TEXT,
    FOREIGN KEY (appid) REFERENCES GAME(appid)
);

-- 4. CATEGORIES
CREATE TABLE CATEGORIES (
    appid INTEGER,
    categorie TEXT,
    FOREIGN KEY (appid) REFERENCES GAME(appid)
);

-- 5. GENRE
CREATE TABLE GENRE (
    appid INTEGER,
    genre_id INTEGER,
    FOREIGN KEY (appid) REFERENCES GAME(appid)
);

-- 6. MONTHLY_STATS
CREATE TABLE MONTHLY_STATS (
    appid INTEGER,
    month_year TEXT,
    avg_players_month REAL,
    max_players_month REAL,
    price REAL,
    positive_reviews INTEGER,
    negative_reviews INTEGER,
    avg_positive_reviews REAL,
    avg_negative_reviews REAL,
    FOREIGN KEY (appid) REFERENCES GAME(appid)
);

.import -skip 1 GAME.csv GAME
.import -skip 1 SYSTEMREQUIREMENTS.csv SYSTEMREQUIREMENTS
.import -skip 1 COMPANIES.csv COMPANIES
.import -skip 1 CATEGORIES.csv CATEGORIES
.import -skip 1 GENRE.csv GENRE
.import -skip 1 MONTHLY_STATS.csv MONTHLY_STATS

-- -- Query 1: Top 5 games by average players per month, including genre and developers
-- SELECT 
--     G.name AS Game,
--     COALESCE(GEN.genre_id, 'N/A') AS Genre_ID,
--     C.developers,
--     AVG(MS.avg_players_month) AS Avg_Players
-- FROM GAME G
-- JOIN MONTHLY_STATS MS ON G.appid = MS.appid
-- LEFT JOIN GAME_GENRE GEN ON G.appid = GEN.appid
-- LEFT JOIN COMPANIES C ON G.appid = C.appid
-- GROUP BY G.appid, GEN.genre_id
-- ORDER BY Avg_Players DESC
-- LIMIT 5;

-- -- Query 2: Games with high system requirements (RAM > 8GB) that are not free and have a Metacritic score above 80
-- SELECT 
--     G.name,
--     G.release_date,
--     G.platforms,
--     G.metacritic_score,
--     SR.ram_gb
-- FROM GAME G
-- JOIN SYSTEMREQUIREMENTS SR ON G.appid = SR.appid
-- WHERE SR.ram_gb > 8 AND G.is_free = 0 AND G.metacritic_score > 80;

-- -- Query 3: Total number of releases per category in 2023
-- SELECT 
--     C.categorie,
--     COUNT(*) AS Num_Releases
-- FROM GAME G
-- JOIN CATEGORIES C ON G.appid = C.appid
-- WHERE strftime('%Y', G.release_date) = '2023'
-- GROUP BY C.categorie
-- ORDER BY Num_Releases DESC;

