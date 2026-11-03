
-- 1. Na osnovu tabele players napravite tabelu dim_player koja sadrži sledeće kolone: player_id, ime, prezime, poziciju i nacionalnost igrača.

CREATE OR REPLACE TABLE dim_player AS  
SELECT player_id,first_name AS ime , last_name AS prezime, position AS pozicija, nationality AS nacionalnost
FROM bootcamp.northern_star.players;
    
    -- Koliko redova ima novokreirana tabela?   
    
    SELECT COUNT (*) FROM dim_player; -- 681

-- 2. Napravite tabelu dim_date na isti način kao na predavanju.

CREATE OR REPLACE TABLE dim_date AS
SELECT CAST(DATE_FORMAT(d, 'yyyyMMdd') AS INT) AS date_key,
       d                                       AS full_date,
       DATE_FORMAT(d, 'EEEE')                  AS weekday_name,
       DAYOFWEEK(d) IN (1, 7)                  AS is_weekend,
       CASE WHEN MONTH(d) >= 7 THEN CONCAT(YEAR(d), '/', SUBSTRING(CAST(YEAR(d) + 1 AS STRING), 3, 2))
            ELSbootcamp.sandbox.fact_player_match_qqE CONCAT(YEAR(d) - 1, '/', SUBSTRING(CAST(YEAR(d) AS STRING), 3, 2))
       END                                     AS season
FROM (SELECT EXPLODE(SEQUENCE(DATE'2023-07-01', DATE'2025-06-30', INTERVAL 1 DAY)) AS d);

/* Zatim napravite tabelu fact_player_match na osnovu tabela player_match_stats i matches. Tabela treba da sadrži sledeće kolone: match_id, date_key, player_id, team_id, minutes_played, shots, passes i rating.
U tabelu uključite samo podatke koji se odnose na odigrane utakmice. */

CREATE OR REPLACE TABLE fact_player_match AS
    SELECT pms.match_id, 
           CAST(DATE_FORMAT(m.kickoff_ts, 'yyyyMMdd') AS INT) AS date_key,
           pms.player_id, pms.team_id, pms.minutes_played, pms.shots, pms.passes, pms.rating
FROM bootcamp.northern_star.player_match_stats pms
JOIN bootcamp.northern_star.matches m ON m.match_id = pms.match_id
WHERE m.status = 'played';

/*- Kolika je granularnost tabele fact_player_match, odnosno šta predstavlja jedan njen red?

        Jedan red tabele fact_player_match predstavlja zbirnu statistiku svakog igrača po meču.

- Koliko redova ima ova tabela?*/

SELECT COUNT (*) FROM fact_player_match; -- Tabela fact_player_match sadrži 30400 redova.

-- 3. Koristeći napravljene dimenzije i činjeničnu tabelu, izračunajte prosečnu ocenu (rating) igrača za svaku poziciju tokom sezone 2024/25. Prikažite poziciju i odgovarajuću prosečnu ocenu.

UPDATE fact_player_match_qq
SET rating = Null
WHERE rating = 'nan';

SELECT 
dp.pozicija, ROUND (AVG (fpm.rating),2) as rat
FROM fact_player_match_qq fpm
JOIN dim_player dp ON dp.player_id = fpm.player_id
JOIN dim_date dd ON dd.date_key = fpm.date_key
WHERE dd.season = '2024/25'
GROUP BY dp.pozicija;

/*
FW	6.79
DF	6.64
MF	6.72
GK	6.6
*/

-- Proširite tabelu fact_player_match dodavanjem kolone koja predstavlja broj golova koje je svaki igrač postigao na određenoj utakmici.

-- Koliki je ukupan zbir golova svih igrača u tabeli fact_player_match?

CREATE OR REPLACE TABLE fact_player_match_qq_tmp AS
WITH test AS(
SELECT match_id, player_id, SUM (CASE WHEN event_type in ('goal', 'penalty_goal') THEN 1 END) AS goals_scored
FROM bootcamp.northern_star.match_events
GROUP BY match_id, player_id
)
SELECT f.*, COALESCE (t.goals_scored, 0) AS goals_scored
FROM fact_player_match_qq f
LEFT JOIN test t ON f.player_id = t.player_id AND t.match_id = f.match_id;

CREATE OR REPLACE TABLE fact_player_match AS
SELECT * FROM fact_player_match_qq_tmp;
