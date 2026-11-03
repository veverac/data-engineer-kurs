-- Ilija Vasiljević
-- Domaći zadatak 2.1 - SQL - Fudbalske utakmice
-- 15.10.2026.

USE bootcamp.northern_star;

-- 1. Dodajte kolonu empty_seats (kapacitet stadiona minus poseta) i prikažite 5 utakmica sa najviše praznih mesta. Šta je zajedničko prvim trima?

SELECT stadium_capacity, attendance, home_team, away_team, stadium_name,
stadium_capacity - attendance AS empty_seats
FROM matches_flat
ORDER BY empty_seats DESC
LIMIT 5;

-- Najviše praznih mesta na prva tri rezultata su sa istog stadiona, National Stadium.


-- 2. Koliko različitih sudija je sudilo domaće utakmice kluba Riverton Athletic?

SELECT DISTINCT referee_name, home_team
FROM matches_flat
WHERE home_team = 'Riverton Athletic';

-- Domaće utakmice kluba Riverton Athletic sudilo je 15 različitih sudija.

--3. U koliko utakmica je gost vodio na poluvremenu, a domaćin na kraju pobedio?

SELECT DISTINCT home_team, away_team, away_goals_ht, home_goals_ht, away_goals, home_goals
FROM matches_flat
WHERE away_goals_ht > home_goals_ht
AND home_goals > away_goals;

-- U 15 utakmica gost je vodio na poluvremenu, a domaćin je na kraju pobedio.

--4. U kojoj utakmici je palo najviše golova u drugom poluvremenu? Ko je igrao, rezultat na poluvremenu i rezultat na kraju?

SELECT DISTINCT home_team, away_team, away_goals_ht, home_goals_ht, away_goals, home_goals,
home_goals - home_goals_ht as hg_diff, away_goals - away_goals_ht as ag_diff
FROM matches_flat
WHERE (home_goals - home_goals_ht) IS NOT NULL AND (away_goals - away_goals_ht) IS NOT NULL
ORDER BY hg_diff + ag_diff DESC
LIMIT 1;
-- U utakmici između Northport United i	Newbury Forest, poluvreme 1:0, rezultat 6:3 na kraju utakmice.

-- 5. Koliko utakmica sezone 2023/24 je odigrano po snegu ili magli?

SELECT season, weather
FROM matches_flat
WHERE season = '2023/24'
AND (weather = 'snow' OR weather = 'fog'); 

-- 25 Utakmica je igrano po magli ili snegu u sezoni 2023/24.

--6. Prikažite sve utakmice gradskog derbija između Northport United i Northport City, bez obzira na to ko je domaćin, sortirane po datumu. Ko je pobedio u kom meču?

SELECT home_team, away_team, home_goals, away_goals, kickoff_ts
FROM matches_flat
WHERE (home_team = 'Northport United' OR home_team = 'Northport City')
AND (away_team = 'Northport United' OR away_team = 'Northport City')
ORDER BY kickoff_ts;

-- Odigrano je ukupno 4 utakmice.
-- U utakmici odigranoj 11.11.2023 - godine pobedio je northport United sa 1:0 (Odnosno 0:1 jer je igrao u gostima)
-- U utakmici odigranoj 16.03.2024 - bilo je nerešeno
-- U utakmici odigranoj 21.09.2024 - godine pobedio je Northport City sa 3:1 
-- U utakmici odigranoj 01.02.2025 - godine pobedio je Northport United sa 2:1 

-- 7. Prikažite prve 3 utakmice sezone 2024/25 po vremenu početka. Da li možete biti sigurni koja je druga, a koja treća? Kako biste to obezbedili?

SELECT home_team, away_team, season, kickoff_ts
FROM matches_flat
WHERE season = '2024/25'
ORDER BY kickoff_ts, match_id
LIMIT 3;

-- Harrowgate Albion	Ashford Rovers	2024/25	2024-08-17T12:30:00.000+00:00
-- Queensport FC	Northport City	2024/25	2024-08-17T15:00:00.000+00:00
-- Brackley Athletic	Stonebridge Rovers	2024/25	2024-08-17T15:00:00.000+00:00
-- Samo vreme ne određuje redosled druge i treće utakmice, pa sam zato dodao i sortiranje po match_id, kako bi redosled uvek bio isti.

-- 8. Prikažite sve utakmice u kojima je prvi gol dao Sean O'Neill. Koliko ih je?

SELECT home_team, away_team, first_goal_scorer
FROM matches_flat
WHERE first_goal_scorer = "Sean O'Neill";

-- Na ukupno dve utakmice je prvi pogodak postigao Sean O'Neill

