-- -- Query 1: Top 5 Games with Highest Average Monthly Players (Across All Time), Showing Their Genre(s) and Developers
-- SELECT 
--     G.name AS game_name,
--     GROUP_CONCAT(DISTINCT GE.genre_id) AS genre_ids,
--     C.developers,
--     AVG(MS.avg_players_month) AS avg_players
-- FROM GAME G
-- JOIN MONTHLY_STATS MS ON G.appid = MS.appid
-- LEFT JOIN GENRE GE ON G.appid = GE.appid
-- LEFT JOIN COMPANIES C ON G.appid = C.appid
-- GROUP BY G.appid
-- ORDER BY avg_players DESC
-- LIMIT 5;

-- -- Query 2: List all games released after 2020 that belong to more than one genre and have a Metacritic score above 75. Also show how many genres each game has.
-- SELECT 
--     G.name,
--     G.release_date,
--     G.metacritic_score,
--     COUNT(GE.genre_id) AS num_genres
-- FROM GAME G
-- JOIN GENRE GE ON G.appid = GE.appid
-- WHERE G.release_date > '2020-12-31'
--   AND G.metacritic_score > 75
-- GROUP BY G.appid
-- HAVING num_genres > 1
-- ORDER BY num_genres DESC, G.metacritic_score DESC;

-- -- Query 3: Games with High Positive Reviews but Low Average Player Base (“Critically Loved, Undiscovered” Games)
-- WITH avg_player_median AS (
--     SELECT 
--         AVG(avg_players_month) AS median_players
--     FROM (
--         SELECT 
--             MS.appid,
--             AVG(MS.avg_players_month) AS avg_players_month
--         FROM MONTHLY_STATS MS
--         GROUP BY MS.appid
--     )
-- ),
-- latest_month AS (
--     SELECT
--         appid,
--         MAX(month_year) AS latest_month
--     FROM MONTHLY_STATS
--     GROUP BY appid
-- )
-- SELECT 
--     G.name,
--     C.developers,
--     MS.avg_players_month,
--     MS.positive_reviews,
--     MS.negative_reviews,
--     ROUND(100.0 * MS.positive_reviews / (MS.positive_reviews + MS.negative_reviews), 2) AS positive_pct
-- FROM GAME G
-- JOIN MONTHLY_STATS MS ON G.appid = MS.appid
-- JOIN latest_month LM ON MS.appid = LM.appid AND MS.month_year = LM.latest_month
-- LEFT JOIN COMPANIES C ON G.appid = C.appid
-- WHERE (MS.positive_reviews + MS.negative_reviews) > 100
--   AND (100.0 * MS.positive_reviews / (MS.positive_reviews + MS.negative_reviews)) > 90
--   AND MS.avg_players_month < (SELECT median_players FROM avg_player_median)
-- ORDER BY positive_pct DESC, MS.avg_players_month ASC
-- LIMIT 10;

-- -- Query 4: Games with High Metacritic Scores but Low Positive Review Percentage
-- WITH latest_month AS (
--     SELECT
--         appid,
--         MAX(month_year) AS latest_month
--     FROM MONTHLY_STATS
--     GROUP BY appid
-- )
-- SELECT
--     G.name,
--     G.metacritic_score,
--     MS.positive_reviews,
--     MS.negative_reviews,
--     ROUND(100.0 * MS.positive_reviews / (MS.positive_reviews + MS.negative_reviews), 2) AS positive_pct
-- FROM GAME G
-- JOIN MONTHLY_STATS MS ON G.appid = MS.appid
-- JOIN latest_month LM ON MS.appid = LM.appid AND MS.month_year = LM.latest_month
-- WHERE G.metacritic_score > 85
--   AND (MS.positive_reviews + MS.negative_reviews) > 20
--   AND (100.0 * MS.positive_reviews / (MS.positive_reviews + MS.negative_reviews)) < 70
-- ORDER BY G.metacritic_score DESC, positive_pct ASC
-- LIMIT 10;

-- Query 5: Show the top 10 games (by Metacritic score) released after 2022, with their release date, developers, and platforms:
SELECT
    G.name,
    G.release_date,
    C.developers,
    G.platforms,
    G.metacritic_score
FROM GAME G
LEFT JOIN COMPANIES C ON G.appid = C.appid
WHERE G.release_date > '2022-12-31'
ORDER BY G.metacritic_score DESC
LIMIT 10;
