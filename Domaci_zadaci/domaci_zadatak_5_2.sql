-- Ilija Vasiljević
-- Domaći zadatak 5.2 - SQL - Fudbalske utakmice
-- 27.10.2026.

-- 1. Prosek datih golova u poslednjih 5 utakmica, uz izričit okvir prozora. Koja je najveća vrednost? Računajte samo kada prozor zaista ima 5 utakmica.

SELECT 
        home_goals + away_goals as zbir, 
        kickoff_ts,
        --COUNT(*) OVER w as broj_utakmica, -- provera da li zaista pet utakmica ulazi u avg
        AVG (home_goals + away_goals) OVER w as prosek_pet_utakmica
FROM matches
WINDOW w as (
    ORDER BY kickoff_ts, match_id
    ROWS BETWEEN 4 PRECEDING AND CURRENT ROW
)
QUALIFY COUNT (*) OVER w =5
ORDER BY prosek_pet_utakmica DESC;

-- Najveći prosek utakmica je 5

--  2. Tekući zbir datih golova svakog kluba u sezoni 2024/25: ko je prvi stigao do 50 golova i kada?

WITH preko_50_golova as (
SELECT team_id, goals_for, kickoff_ts,
        SUM (goals_for) OVER (PARTITION BY team_id ORDER BY kickoff_ts) as broj_golova
FROM team_matches
WHERE season = '2024/25'
QUALIFY broj_golova >=50
ORDER BY kickoff_ts, team_id
)
SELECT t.team_name, p50.kickoff_ts, p50.broj_golova,
ROW_NUMBER () OVER (PARTITION BY p50.team_id ORDER BY p50.kickoff_ts) as rnk
FROM preko_50_golova p50
JOIN teams t on t.team_id = p50.team_id
QUALIFY rnk = 1
ORDER BY p50.kickoff_ts;

-- Kingsbridge City je dana 18.01.2025. godine prvi stigao do 50 golova.

-- 3. Za svaku domaću utakmicu izračunajte promenu posećenosti u odnosu na prethodnu domaću utakmicu istog kluba u istoj sezoni. Gde je najveći pad i zašto?

WITH razlika_posete AS (
SELECT match_id, home_team_id, season, attendance, kickoff_ts,
        LAG (attendance) OVER (PARTITION BY home_team_id, season ORDER BY kickoff_ts) AS prethodna_poseta,
        attendance - prethodna_poseta AS razlika_posete
FROM matches
)
SELECT match_id, home_team_id, kickoff_ts, razlika_posete,
        row_number() OVER (ORDER BY razlika_posete) AS rn
FROM razlika_posete
WHERE razlika_posete IS NOT NULL
QUALIFY rn =1;

SELECT * 
FROM matches
WHERE  match_id = 1220;

-- Oakfield Town and Fairhaven Town play behind closed doors, odnosno bez publike :D