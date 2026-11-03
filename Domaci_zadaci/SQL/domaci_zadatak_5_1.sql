-- Ilija Vasiljević
-- Domaći zadatak 5.1 - SQL - Fudbalske utakmice
-- 26.10.2026.

-- 1. Za sezonu 2024/25 prikažite igrače i ukupan broj golova koje su postigli. Prikažite samo igrače koji su postigli bar jedan gol.
-- Pomoću DENSE_RANK() rangirajte igrače prema ukupnom broju golova, od najvećeg ka najmanjem. Igrači sa istim brojem golova treba da imaju isti rang.

SELECT p.first_name, p.last_name,
SUM (CASE WHEN me.event_type IN ('goal', 'penalty_goal') THEN 1 ELSE 0 END) AS golovi,
DENSE_RANK () OVER(ORDER BY (SUM (CASE WHEN me.event_type IN ('goal', 'penalty_goal') THEN 1 ELSE 0 END)) DESC) AS rang
FROM match_events me
JOIN players p ON p.player_id = me.player_id
JOIN matches m on me.match_id = m.match_id
WHERE m.season = '2024/25'
GROUP BY p.first_name, p.last_name, p.player_id
HAVING SUM (CASE WHEN me.event_type IN ('goal', 'penalty_goal') THEN 1 ELSE 0 END) >= 1
ORDER BY rang;

-- prvi query mi je bio malo rogobatan u glavi, pa sam onda pokušao i ovako da ga rešim....

WITH golovi AS(
    SELECT me.player_id,
    SUM (CASE WHEN me.event_type IN ('goal', 'penalty_goal') THEN 1 ELSE 0 END) AS golovi
    FROM match_events me
    JOIN matches m ON me.match_id = m.match_id
    WHERE m.season = '2024/25'
    GROUP BY player_id
)
SELECT p.first_name, p.last_name, g.golovi,
DENSE_RANK () OVER(ORDER BY g.golovi DESC) AS rang
FROM golovi g
JOIN players p ON p.player_id = g.player_id
WHERE g.golovi >= 1
ORDER BY rang;

--  2. Za sezonu 2024/25 prikažite tri igrača sa najviše postignutih golova za svaki klub.
-- Prikažite naziv kluba, ime i prezime igrača i broj postignutih golova. Pomoću ROW_NUMBER() odredite redosled igrača unutar svakog kluba, od najvećeg ka najmanjem broju golova.

WITH golovi AS(
    SELECT me.team_id, me.player_id,
    SUM (CASE WHEN me.event_type IN ('goal', 'penalty_goal') THEN 1 ELSE 0 END) AS golovi
    FROM match_events me
    JOIN matches m ON me.match_id = m.match_id
    WHERE m.season = '2024/25'
    GROUP BY me.team_id, me.player_id
)
SELECT t.team_name, p.first_name, p.last_name, g.golovi,
ROW_NUMBER () OVER(partition by g.team_id ORDER BY g.golovi DESC) AS rang
FROM golovi g
JOIN players p ON p.player_id = g.player_id
JOIN teams t on t.team_id = g.team_id
QUALIFY rang IN (1, 2, 3);

-- 3. Za sezonu 2024/25 prikažite sve utakmice svakog kluba, broj golova koje je klub postigao i broj golova koje je postigao u svojoj prethodnoj utakmici.

-- Pomoću LAG() pronađite broj golova iz prethodne utakmice. Izračunajte i razliku između broja golova na tekućoj i prethodnoj utakmici. Rezultate sortirajte po nazivu kluba i datumu utakmice.

WITH sides AS (
  SELECT match_id, season, matchday, kickoff_ts,
         home_team_id AS team_id, away_team_id AS opponent_id, 'home' AS venue,
         home_goals AS goals_for, away_goals AS goals_against
  FROM bootcamp.northern_star.matches
  WHERE status = 'played' AND season = '2024/25'
  UNION ALL
  SELECT match_id, season, matchday, kickoff_ts,
         away_team_id, home_team_id, 'away',
         away_goals, home_goals
  FROM bootcamp.northern_star.matches
  WHERE status = 'played'AND season = '2024/25'
),
red AS (
    SELECT s.kickoff_ts, t.team_name, s.goals_for
    FROM sides s
    JOIN teams t on t.team_id = s.team_id
    ORDER BY t.team_id, s.kickoff_ts, s.match_id
)
SELECT team_name, goals_for,
LAG (goals_for) OVER (PARTITION BY team_name ORDER BY kickoff_ts) AS golova_na_prethodnom_mecu,
goals_for - LAG (goals_for) OVER (PARTITION BY team_name ORDER BY kickoff_ts) AS razlika_golova
FROM red
ORDER BY team_name, kickoff_ts;
