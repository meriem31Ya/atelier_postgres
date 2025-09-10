---------------------------------------------------------
-- 1) VÉRIFICATIONS RAPIDES
---------------------------------------------------------

-- [Q-01] Lister toutes les lignes de game
SELECT * FROM game;

-- [Q-02] Lister toutes les lignes de genre
SELECT * FROM genre;

-- [Q-03] Compter le nombre de jeux
SELECT COUNT(*) AS total_games FROM game;


---------------------------------------------------------
-- 2) JEUX & GENRES
---------------------------------------------------------

-- [Q-04] Jeux avec leur genre (y compris sans genre)
SELECT g.game_name, ge.genre_name
FROM game g
LEFT JOIN genre ge ON g.genre_id = ge.id
ORDER BY g.game_name ASC;

-- [Q-05] Compter les jeux par genre (tri décroissant)
SELECT ge.genre_name, COUNT(*) AS total_games
FROM game g
LEFT JOIN genre ge ON g.genre_id = ge.id
GROUP BY ge.genre_name
ORDER BY total_games DESC NULLS LAST;

-- [Q-06a] Jeux sans genres — Variante 1 (genre_id NULL)
SELECT g.game_name
FROM game g
WHERE g.genre_id IS NULL
ORDER BY g.game_name ASC;

-- [Q-06b] Jeux sans genres — Variante 2 (LEFT JOIN sans correspondance)
SELECT g.game_name
FROM game g
LEFT JOIN genre ge ON g.genre_id = ge.id
WHERE ge.id IS NULL
ORDER BY g.game_name ASC;


---------------------------------------------------------
-- 3) JEUX, ÉDITEURS & PLATEFORMES
---------------------------------------------------------

-- [Q-07] Jeux avec leur éditeur associé
SELECT g.game_name, p.publisher_name
FROM game g
JOIN game_publisher gp ON g.id = gp.game_id
JOIN publisher p ON gp.publisher_id = p.id
ORDER BY g.game_name ASC, p.publisher_name ASC;

-- [Q-08] Jeux avec éditeur & plateforme associée
SELECT g.game_name, p.publisher_name, pl.platform_name
FROM game g
JOIN game_publisher gp ON g.id = gp.game_id
JOIN publisher p ON gp.publisher_id = p.id
JOIN game_platform gpl ON gp.id = gpl.game_publisher_id
JOIN platform pl ON gpl.platform_id = pl.id
ORDER BY g.game_name ASC, p.publisher_name ASC, pl.platform_name ASC;

-- [Q-09] 5 jeux les plus récents (release_year)
SELECT g.game_name, gpl.release_year
FROM game g
JOIN game_publisher gp ON g.id = gp.game_id
JOIN game_platform gpl ON gp.id = gpl.game_publisher_id
ORDER BY gpl.release_year DESC, g.game_name ASC
LIMIT 5;

-- [Q-10] Jeux sans éditeur
SELECT g.game_name
FROM game g
LEFT JOIN game_publisher gp ON g.id = gp.game_id
WHERE gp.game_id IS NULL
ORDER BY g.game_name ASC;

-- [Q-11] Éditeurs distincts
SELECT DISTINCT p.publisher_name
FROM publisher p
ORDER BY p.publisher_name ASC;


---------------------------------------------------------
-- 4) AGRÉGATIONS : ÉDITEURS & PLATEFORMES
---------------------------------------------------------

-- [Q-12] Jeux par éditeur (Top 10)
SELECT p.publisher_name, COUNT(*) AS total_games
FROM publisher p
JOIN game_publisher gp ON p.id = gp.publisher_id
JOIN game g ON gp.game_id = g.id
GROUP BY p.id, p.publisher_name
ORDER BY total_games DESC, p.publisher_name ASC
LIMIT 10;

-- [Q-13] Jeux par plateforme (Top 10)
SELECT pl.platform_name, COUNT(*) AS total_games
FROM platform pl
JOIN game_platform gpl ON pl.id = gpl.platform_id
JOIN game_publisher gp ON gpl.game_publisher_id = gp.id
JOIN game g ON gp.game_id = g.id
GROUP BY pl.id, pl.platform_name
ORDER BY total_games DESC, pl.platform_name ASC
LIMIT 10;

-- [Q-14] Nombre de jeux pour la plateforme 'GBA'
SELECT pl.platform_name, COUNT(*) AS total_games
FROM platform pl
JOIN game_platform gpl ON pl.id = gpl.platform_id
JOIN game_publisher gp ON gpl.game_publisher_id = gp.id
JOIN game g ON gp.game_id = g.id
WHERE pl.platform_name = 'GBA'
GROUP BY pl.id, pl.platform_name
ORDER BY total_games DESC;

-- [Q-15] Nombre de jeux par plateforme (toutes)
SELECT pl.platform_name, COUNT(*) AS total_games
FROM platform pl
JOIN game_platform gpl ON pl.id = gpl.platform_id
JOIN game_publisher gp ON gpl.game_publisher_id = gp.id
JOIN game g ON gp.game_id = g.id
GROUP BY pl.id, pl.platform_name
ORDER BY total_games DESC, pl.platform_name ASC;

-- [Q-16] Plateformes sans jeux
SELECT pl.platform_name
FROM platform pl
LEFT JOIN game_platform gpl ON pl.id = gpl.platform_id
WHERE gpl.platform_id IS NULL
ORDER BY pl.platform_name ASC;


---------------------------------------------------------
-- 5) TRI & FILTRES TEXTE / REGEX
---------------------------------------------------------

-- [Q-17] Jeux par ordre alphabétique
SELECT g.game_name
FROM game g
ORDER BY g.game_name ASC;

-- [Q-18] 5 genres les plus populaires
SELECT ge.genre_name, COUNT(*) AS total_games
FROM genre ge
JOIN game g ON ge.id = g.genre_id
GROUP BY ge.id, ge.genre_name
ORDER BY total_games DESC, ge.genre_name ASC
LIMIT 5;

-- [Q-19] 5 genres les moins populaires
SELECT ge.genre_name, COUNT(*) AS total_games
FROM genre ge
JOIN game g ON ge.id = g.genre_id
GROUP BY ge.id, ge.genre_name
ORDER BY total_games ASC, ge.genre_name ASC
LIMIT 5;

-- [Q-20] Jeux commençant par 'Super'
SELECT g.game_name
FROM game g
WHERE g.game_name ILIKE 'Super%'
ORDER BY g.game_name ASC;

-- [Q-21] Jeux contenant 'Mario'
SELECT g.game_name
FROM game g
WHERE g.game_name ILIKE '%Mario%'
ORDER BY g.game_name ASC;

-- [Q-22] Jeux contenant un chiffre (regex)
SELECT g.game_name
FROM game g
WHERE g.game_name ~ '[0-9]'
ORDER BY g.game_name ASC;

-- [Q-23] Jeux finissant par 'Edition'
SELECT g.game_name
FROM game g
WHERE g.game_name ILIKE '% Edition'
ORDER BY g.game_name ASC;

-- [Q-24] Bonus regex : plateformes sans voyelles
SELECT g.game_name, pl.platform_name
FROM game g
JOIN game_publisher gp ON g.id = gp.game_id
JOIN game_platform gpl ON gp.id = gpl.game_publisher_id
JOIN platform pl ON gpl.platform_id = pl.id
WHERE pl.platform_name ~ '^[^AEIOUaeiou]*$'
ORDER BY g.game_name ASC;


---------------------------------------------------------
-- 6) VENTES & RÉGIONS
---------------------------------------------------------

-- [Q-25] Top 10 des jeux les plus vendus en Europe (EU=2)
SELECT g.game_name, rs.num_sales
FROM game g
JOIN game_publisher gp ON g.id = gp.game_id
JOIN game_platform gpl ON gp.id = gpl.game_publisher_id
JOIN region_sales rs ON gpl.id = rs.game_platform_id
WHERE rs.region_id = 2
ORDER BY rs.num_sales DESC, g.game_name ASC
LIMIT 10;

-- [Q-26] Ventes totales par éditeur (toutes régions)
SELECT p.publisher_name, SUM(rs.num_sales) AS total_sales
FROM publisher p
JOIN game_publisher gp ON p.id = gp.publisher_id
JOIN game_platform gpl ON gp.id = gpl.game_publisher_id
JOIN region_sales rs ON gpl.id = rs.game_platform_id
GROUP BY p.id, p.publisher_name
ORDER BY total_sales DESC, p.publisher_name ASC
LIMIT 10;

-- [Q-27] Top 5 éditeurs par ventes au Japon (JP=3)
SELECT p.publisher_name, SUM(rs.num_sales) AS total_sales
FROM publisher p
JOIN game_publisher gp ON p.id = gp.publisher_id
JOIN game_platform gpl ON gp.id = gpl.game_publisher_id
JOIN region_sales rs ON gpl.id = rs.game_platform_id
WHERE rs.region_id = 3
GROUP BY p.id, p.publisher_name
ORDER BY total_sales DESC, p.publisher_name ASC
LIMIT 5;

-- [Q-28] Ventes globales d’un jeu (multi-régions) — Top 20
SELECT g.game_name, SUM(rs.num_sales) AS total_sales
FROM game g
JOIN game_publisher gp ON g.id = gp.game_id
JOIN game_platform gpl ON gp.id = gpl.game_publisher_id
JOIN region_sales rs ON gpl.id = rs.game_platform_id
GROUP BY g.id, g.game_name
ORDER BY total_sales DESC, g.game_name ASC
LIMIT 20;


---------------------------------------------------------
-- 7) JOINTURES MULTIPLES & AGRÉGATIONS AVANCÉES
---------------------------------------------------------

-- [Q-29] Jeux + genre + liste des plateformes
SELECT g.game_name, ge.genre_name,
       STRING_AGG(DISTINCT pl.platform_name, ', ') AS platforms
FROM game g
LEFT JOIN genre ge ON g.genre_id = ge.id
JOIN game_publisher gp ON g.id = gp.game_id
JOIN game_platform gpl ON gp.id = gpl.game_publisher_id
JOIN platform pl ON gpl.platform_id = pl.id
GROUP BY g.id, g.game_name, ge.genre_name
ORDER BY g.game_name ASC
LIMIT 20;


---------------------------------------------------------
-- 8) FULL-TEXT SEARCH (FTS)
---------------------------------------------------------

-- [Q-30] FTS : "shooting & space"
SELECT g.game_name,
       g.game_name || ' ' || COALESCE(g.game_summary,'') AS document,
       TO_TSVECTOR('english', g.game_name || ' ' || COALESCE(g.game_summary,'')) AS document_vector
FROM game g
WHERE TO_TSVECTOR('english', g.game_name || ' ' || COALESCE(g.game_summary,'')) @@ TO_TSQUERY('english','shooting & space')
ORDER BY g.game_name ASC
LIMIT 20;


---------------------------------------------------------
-- 9) FENÊTRE TEMPORELLE
---------------------------------------------------------

-- [Q-31] Jeux sortis sur les 10 dernières années
SELECT g.game_name, gpl.release_year
FROM game g
JOIN game_publisher gp ON g.id = gp.game_id
JOIN game_platform gpl ON gp.id = gpl.game_publisher_id
WHERE gpl.release_year >= EXTRACT(YEAR FROM CURRENT_DATE) - 10
ORDER BY gpl.release_year DESC, g.game_name ASC
LIMIT 10;


---------------------------------------------------------
-- 10) VUES & QUALITÉ DES DONNÉES
---------------------------------------------------------

-- [Q-32] Créer une vue gameinfos (nom du jeu + genre)
CREATE OR REPLACE VIEW gameinfos AS
SELECT g.game_name, ge.genre_name
FROM game g
LEFT JOIN genre ge ON g.genre_id = ge.id;

-- [Q-33] Afficher les 10 premiers jeux depuis la vue
SELECT *
FROM gameinfos
ORDER BY game_name ASC
LIMIT 10;

-- [Q-34] Détecter les doublons de jeux (même nom + année)
SELECT g.game_name, gpl.release_year, COUNT(*) AS duplicate_count
FROM game g
JOIN game_publisher gp ON g.id = gp.game_id
JOIN game_platform gpl ON gp.id = gpl.game_publisher_id
GROUP BY g.game_name, gpl.release_year
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC, g.game_name ASC;

-- [Q-35] Détecter les éditeurs orphelins (sans jeux)
SELECT p.publisher_name
FROM publisher p
LEFT JOIN game_publisher gp ON p.id = gp.publisher_id
WHERE gp.publisher_id IS NULL
ORDER BY p.publisher_name ASC;

