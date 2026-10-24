
-- 1. Прикажите утакмице са више од 40.000 гледалаца у марту 2025. Колико их је?
SELECT *
FROM matches_flat
WHERE attendance > 40000 AND DATE(kickoff_ts) BETWEEN '2025-03-1' AND '2025-03-31' --2 utakmice

-- 2.Прикажите све различите комбинације резултата (home_goals,away_goals) за одигранеутакмице, сортиране по укупном броју голова. Колико различитих резултата постоји?

SELECT DISTINCT home_goals, away_goals
FROM matches_flat
WHERE status = 'played'
order BY home_goals + away_goals --36

-- 3. Који стадиони у имену имају реч „Park“?

SELECT DISTINCT stadium_name
FROM matches_flat
WHERE stadium_name ILIKE ('%park%')

-- Harbourside Park
-- Stonebridge Park
-- Westmere Park
-- Pemberton Park
-- Valemont Park
-- Dunmore Park

--3. Прикажите утакмице без податка о посети или о времену: датум, тимове, посету и време, а уместоNULL нека пише непознато'. Колико их је?

SELECT DATE (kickoff_ts) AS datum, home_team, away_team,  COALESCE(weather, 'Nepoznato') AS vreme, COALESCE(CAST (attendance AS string), 'Nepoznato') AS poseta
FROM matches_flat
WHERE weather IS NULL OR attendance IS NULL;

-- Ukupno na 89 utakmica nedostaje podatak o poseti ili vremenu.

-- 1.ZA сваког судију прикажите националност (из referees), број утакмица, просечан број голова ипроценат победа домаћина. Код ког судије домаћини најчешће побеђују?

SELECT r.referee_name, r.nationality, COUNT(m.match_id), ROUND (AVG(home_goals+away_goals),2),
  ROUND (SUM (CASE WHEN home_goals > away_goals THEN 1 ELSE 0 END) / COUNT(*) * 100.0, 2) AS procenat
FROM referees r
LEFT JOIN matches m ON r.referee_id = m.referee_id AND m.status = 'played'
GROUP BY r.referee_name, r.nationality
ORDER BY procenat DESC;

-- referee_name	nationality	count(match_id)	round(avg((home_goals + away_goals)), 2)	procenat
-- Samuel Achebe	Nigeria	39	2.87	53.85

-- 2. Који клубови су у сезони 2024/25 имали више победа у гостима него код куће?

WITH home_wins AS (
        SELECT home_team_id AS team_id,
        SUM(CASE WHEN home_goals > away_goals THEN 1 ELSE 0 END) AS pobeda_domacina
        FROM matches 
        WHERE season = '2024/25' and status = 'played'
        GROUP BY team_id
        ),
away_wins  AS ( 
        SELECT away_team_id AS team_id,
        SUM (CASE WHEN away_goals > home_goals THEN 1 ELSE 0 END) AS pobeda_gosta
        FROM matches 
        WHERE season = '2024/25' and status = 'played'
        GROUP BY team_id
        )
SELECT t.team_name, SUM (w.pobeda_domacina) AS domacica, SUM (aw.pobeda_gosta) as gosca
FROM teams t
JOIN home_wins w ON w.team_id = t.team_id 
JOIN away_wins aw ON aw.team_id = t.team_id
GROUP BY t.team_name
HAVING SUM (aw.pobeda_gosta) > SUM (w.pobeda_domacina)

-- team_name	domacica	gosca
-- Newbury Forest	4	7
-- Pemberton United	6	13
-- Castlebrook United	8	10

-- 3. Колико играча је давало голове у обе сезоне?


SELECT me.player_id, COUNT(DISTINCT (m.season)) AS sezone
FROM match_events me
JOIN matches m ON m.match_id = me.match_id
WHERE me.event_type IN ('goal', 'penalty_goal', 'own_goal')
GROUP BY me.player_id
HAVING sezone = 2;

-- Ukupno 209 igrača u obe sezone je davalo golove.

-- Sesija 5

-- 1. Направите табелу лиге каква је била 1. јануара 2025. (сезона 2024/25) Ко је био на врху?

WITH sides AS (
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
SELECT t.team_name AS klub,
SUM (CASE WHEN s.goals_for > s.goals_against THEN 1 ELSE 0 END) AS broj_pobeda,
SUM (CASE WHEN s.goals_for = s.goals_against THEN 1 ELSE 0 END) AS broj_neresenih_utakmica,
SUM (CASE WHEN s.goals_for < s.goals_against THEN 1 ELSE 0 END) AS broj_poraza,
SUM (CASE WHEN s.goals_for > s.goals_against THEN 3 ELSE 0 END) + SUM (CASE WHEN s.goals_for = s.goals_against THEN 1 ELSE 0 END) AS broj_bodova 
FROM sides s
JOIN teams t ON s.team_id = t.team_id
WHERE s.season = '2024/25' AND s.kickoff_ts < '2025-01-02'
GROUP BY t.team_name
ORDER BY broj_bodova DESC;

-- klub	                    broj_pobeda	broj_neresenih_utakmica	broj_poraza	broj_bodova
-- Northport City  	        14	3	2	45
-- Kingsbridge City	        11	7	1	40
-- Harrowgate Albion	        11	4	4	37
-- Pemberton United	        9	7	3	34
-- Elmsworth Wanderers	        10	2	7	32
-- Riverton Athletic	        9	4	6	31
-- Northport United	        10	1	8	31
-- Castlebrook United	        7	10	2	31
-- Stonebridge Rovers	        7	8	4	29
-- Lakeside Rangers	        7	5	7	26
-- Oakfield Town	        6	7	6	25
-- Thornbury City	        6	6	7	24
-- Westmere Town	        5	5	9	20
-- Queensport FC	        6	2	11	20
-- Ashford Rovers	        5	3	10	18
-- Valemont United	        4	6	8	18
-- Brackley Athletic	        3	8	8	17
-- Newbury Forest	        4	5	10	17
-- Dunmore Celtic	        4	2	13	14
-- Redcliffe Athletic	        2	3	14	9

-- 2. Колико играча је дало гол за два различита клуба?
WITH stats AS (
SELECT COUNT (event_type) AS broj_golova, player_id, COUNT (DISTINCT(team_id)) AS broj_timova
FROM match_events
WHERE event_type IN ('goal', 'penalty_goal'/*, 'own_goal'*/)
GROUP BY player_id
ORDER BY player_id
)
SELECT p.first_name, p.last_name, p.player_id, s.broj_timova
FROM stats s
JOIN players p ON p.player_id = s.player_id
WHERE broj_timova = 2;

SELECT COUNT (player_id) AS broj, player_id
FROM player_contracts
GROUP BY player_id
HAVING broj = 2
ORDER BY player_id;

-- SELECT event_type, team_id
-- FROM match_events
-- Where event_type = 'own_goal'

-- first_name	last_name	player_id	broj_timova
-- Kenji	Endo	51	2
-- Jamal	Walker	171	2
-- Lukas	Becker	262	2
-- Declan	Foster	284	2
-- Sean	Doyle	303	2
-- Dominic	Gibbs	309	2
-- James	Nolan	322	2
-- Joe	Hughes	380	2
-- Raphaël	Rousseau	409	2
-- Dušan	Marković	431	2
-- Jack	Cole	470	2
-- Uroš	Jovanović	641	2

-- Ukupno 12 igrača je dalo golove za dva različita kluba.

-- 3. У колико утакмица је тим који је губио на полувремену на крају победио? Колико од тих преокрета су направили гости?

SELECT COUNT (match_id) AS broj_utakmica, 'preokret_gostiju' AS obrt
FROM matches
WHERE home_goals_ht >away_goals_ht AND away_goals > home_goals
UNION ALL
SELECT COUNT (match_id), 'preokret_domacina'
FROM matches
WHERE home_goals_ht < away_goals_ht AND away_goals < home_goals