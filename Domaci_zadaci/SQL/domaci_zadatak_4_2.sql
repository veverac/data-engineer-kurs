-- 1. Сезона у бројевима: утакмице, победе, нерешене, порази, дати и примљени голови, бодови.

WITH club AS(
    SELECT team_id FROM teams WHERE team_name ='Castlebrook United'
),
sides AS (
  SELECT match_id, season, matchday, kickoff_ts,
         home_team_id AS team_id, away_team_id AS opponent_id, 'home' AS venue,
         home_goals AS goals_for, away_goals AS goals_against
  FROM bootcamp.northern_star.matches
  WHERE status = 'played'
  UNION ALL
  SELECT match_id, season, matchday, kickoff_ts,
         away_team_id, home_team_id, 'away',
         away_goals, home_goals
  FROM bootcamp.northern_star.matches
  WHERE status = 'played'
)
SELECT COUNT (s.match_id) AS broj_utakmica,
SUM (CASE WHEN s.goals_for > s.goals_against THEN 1 ELSE 0 END) AS broj_pobeda,
SUM (CASE WHEN s.goals_for = s.goals_against THEN 1 ELSE 0 END) AS broj_neresenih_utakmica,
SUM (CASE WHEN s.goals_for < s.goals_against THEN 1 ELSE 0 END) AS broj_poraza,
SUM (goals_for) AS broj_datih_golova,
SUM (goals_against) AS broj_primljenih_golova,
SUM (CASE WHEN s.goals_for > s.goals_against THEN 3 ELSE 0 END) + SUM (CASE WHEN s.goals_for = s.goals_against THEN 1 ELSE 0 END) AS broj_bodova 
FROM sides s
JOIN club c on c.team_id = s.team_id
WHERE s.season = '2024/25'

-- broj_utakmica	broj_pobeda	broj_neresenih_utakmica	broj_poraza	broj_datih_golova	broj_primljenih_golova	broj_bodova
-- 38	18	15	5	82	43	69

-- 2. Код куће и у гостима: исти бројеви, одвојено за домаће и гостујуће утакмице.

WITH club AS(
    SELECT team_id FROM teams WHERE team_name ='Castlebrook United'
),
sides AS (
  SELECT match_id, season, matchday, kickoff_ts,
         home_team_id AS team_id, away_team_id AS opponent_id, 'home' AS venue,
         home_goals AS goals_for, away_goals AS goals_against
  FROM bootcamp.northern_star.matches
  WHERE status = 'played'
  UNION ALL
  SELECT match_id, season, matchday, kickoff_ts,
         away_team_id, home_team_id, 'away',
         away_goals, home_goals
  FROM bootcamp.northern_star.matches
  WHERE status = 'played'
)
SELECT s.venue, COUNT (s.team_id) AS broj_utakmica,
SUM (CASE WHEN s.goals_for > s.goals_against THEN 1 ELSE 0 END) AS broj_pobeda,
SUM (CASE WHEN s.goals_for = s.goals_against THEN 1 ELSE 0 END) AS broj_neresenih_utakmica,
SUM (CASE WHEN s.goals_for < s.goals_against THEN 1 ELSE 0 END) AS broj_poraza,
SUM (goals_for) AS broj_datih_golova,
SUM (goals_against) AS broj_primljenih_golova,
SUM (CASE WHEN s.goals_for > s.goals_against THEN 3 ELSE 0 END) + SUM (CASE WHEN s.goals_for = s.goals_against THEN 1 ELSE 0 END) AS broj_bodova 
FROM sides s
JOIN club c on c.team_id = s.team_id
WHERE s.season = '2024/25'
GROUP BY s.venue

-- venue	broj_utakmica	broj_pobeda	broj_neresenih_utakmica	broj_poraza	broj_datih_golova	broj_primljenih_golova	broj_bodova
-- home	19	8	8	3	42	23	32
-- away	19	10	7	2	40	20	37

-- 3 Strelci

WITH club AS(
    SELECT team_id FROM teams WHERE team_name ='Castlebrook United'
),
sides AS (
  SELECT match_id, season, matchday, kickoff_ts,
         home_team_id AS team_id, away_team_id AS opponent_id, 'home' AS venue,
         home_goals AS goals_for, away_goals AS goals_against
  FROM bootcamp.northern_star.matches
  WHERE status = 'played'
  UNION ALL
  SELECT match_id, season, matchday, kickoff_ts,
         away_team_id, home_team_id, 'away',
         away_goals, home_goals
  FROM bootcamp.northern_star.matches
  WHERE status = 'played'
)
SELECT s.team_id, p.first_name, p.last_name, 
SUM (CASE WHEN me.event_type IN ('goal', 'penalty_goal', 'own_goal') THEN 1 ELSE 0 END) as broj_golova
FROM sides s
JOIN club c on c.team_id = s.team_id
JOIN match_events me ON s.match_id = me.match_id AND me.team_id = s.team_id
JOIN players p ON me.player_id = p.player_id
WHERE  s.season = '2024/25'
GROUP BY s.team_id, p.first_name, p.last_name, p.player_id
ORDER BY broj_golova DESC;

-- first_name	last_name	broj_golova
-- José	Muñoz	24
-- Mads	Nielsen	8
-- Emil	Kristensen	7

--Najbolji asistent

SELECT p.first_name, p.last_name, COUNT(*) as broj
FROM players p
JOIN match_events me ON p.player_id = related_player_id
JOIN matches m ON m.match_id = me.match_id
WHERE me.event_type = 'goal' AND m.season = '2024/25' AND me.team_id = 7
GROUP BY p.player_id, p.first_name, p.last_name
ORDER BY broj DESC;

-- first_name	last_name	broj
-- Rafael	Oliveira	5
-- Mads	Nielsen	5
-- Emil	Kristensen	4

-- 4. Дисциплина:картони клуба по утакмици у поређењу са просеком лиге по тиму по утакмици.
WITH kartoni AS(
SELECT team_id, match_id,
SUM (CASE WHEN event_type IN ('red_card', 'yellow_card', 'second_yellow') THEN 1 ELSE 0 END) AS broj_kartona
FROM match_events
GROUP BY match_id, team_id
)
SELECT t.team_name, ROUND(AVG (k.broj_kartona),2) prosek_kartona
FROM matches m
JOIN kartoni k ON m.match_id = k.match_id AND m.season = '2024/25'
JOIN teams t ON t.team_id = k.team_id 
GROUP BY t.team_name
ORDER BY prosek_kartona DESC;


-- team_name	prosek_kartona
-- Castlebrook United	2.03 prosek 1.74 po sezoni

SELECT manager_name
FROM manager_spells
WHERE team_id = 7 AND start_date <= '2025-05-31'
AND COALESCE(end_date, '9999-12-31') >= '2024-08-01'

-- manager_name	start_date	end_date
-- Roberto De Zerbi	2021-05-20	2023-11-05
-- Frank Lampard	2023-11-06	2023-11-27
-- Unai Emery	2023-11-28	-
-- Steve Cooper	2021-07-01	2024-10-20
-- Jürgen Kloppmann	2024-10-21	2024-11-10
-- Ivan Jurić	2024-11-11	-

-- baš sam intuitivno uzeo tim sa ovim problematičnim setom podataka :D

WITH club AS(
    SELECT team_id FROM teams WHERE team_name ='Castlebrook United'
),
sides AS (
  SELECT match_id, season, matchday, kickoff_ts,
         home_team_id AS team_id, away_team_id AS opponent_id, 'home' AS venue,
         home_goals AS goals_for, away_goals AS goals_against
  FROM bootcamp.northern_star.matches
  WHERE status = 'played'
  UNION ALL
  SELECT match_id, season, matchday, kickoff_ts,
         away_team_id, home_team_id, 'away',
         away_goals, home_goals
  FROM bootcamp.northern_star.matches
  WHERE status = 'played'
),
stats as (SELECT COUNT (s.match_id) AS broj_utakmica,
SUM (CASE WHEN s.goals_for > s.goals_against THEN 3 ELSE 0 END) + SUM (CASE WHEN s.goals_for = s.goals_against THEN 1 ELSE 0 END) AS broj_bodova
FROM sides s
JOIN club c on c.team_id = s.team_id
WHERE s.season = '2024/25'
)
SElECT ROUND (st.broj_bodova / st.broj_utakmica,2) AS bodovi_po_utakmici
FROM stats st;
-- 1.82

-- 6. Највећа победа и најтежи пораз.

WITH club AS(
    SELECT team_id FROM teams WHERE team_name ='Castlebrook United'
),
sides AS (
  SELECT match_id, season, matchday, kickoff_ts,
         home_team_id AS team_id, away_team_id AS opponent_id, 'home' AS venue,
         home_goals AS goals_for, away_goals AS goals_against
  FROM bootcamp.northern_star.matches
  WHERE status = 'played'
  UNION ALL
  SELECT match_id, season, matchday, kickoff_ts,
         away_team_id, home_team_id, 'away',
         away_goals, home_goals
  FROM bootcamp.northern_star.matches
  WHERE status = 'played'
),
minmax AS (SELECT s.match_id, s.team_id, s.opponent_id, s.goals_for, s.goals_against,
s.goals_for - s.goals_against AS  gol_razlika
FROM sides s
JOIN club c on c.team_id = s.team_id
WHERE s.season = '2024/25'
)
SELECT mm.match_id, mm.gol_razlika, t.team_name, mm.goals_for, mm.goals_against
FROM minmax mm
JOIN teams t ON t.team_id = mm.opponent_id
WHERE mm.gol_razlika = (SELECT MAX(gol_razlika) FROM minmax) 
     OR mm.gol_razlika = (SELECT MIN(gol_razlika) FROM minmax)


-- match_id	gol_razlika	team_name	goals_for	goals_against
-- 2323	6	Redcliffe Athletic	6	0
-- 2146	-3	Harrowgate Albion	0	3


-- Публика: просечна посета и попуњеност на домаћим утакмицама, и колико утакмица немаподатак о посети.

WITH club AS(
    SELECT team_id FROM teams WHERE team_name ='Castlebrook United'
)
SELECT AVG (COALESCE (m.attendance, 0))AS prosecna_poseta_na_domacem_terenu, ROUND(AVG (COALESCE (m.attendance, 0)) / AVG (s.capacity) * 100.0,2) AS popunjenost, s.stadium_name
FROM matches m
JOIN club c ON c.team_id = m.home_team_id
JOIN stadiums s ON s.stadium_id = m.stadium_id
WHERE m.season = '2024/25'
GROUP BY s.stadium_name

-- prosecna_poseta_na_domacem_terenu	popunjenost	stadium_name
-- 28058	85.02	Castle Grounds