-- Ilija Vasiljević
-- Domaći zadatak 3.2 - SQL - Fudbalske utakmice
-- 20.10.2026.

USE bootcamp.northern_star;

-- Osnovni nivo:

-- 1. Prikažite naziv svakog kluba i naziv stadiona na kojem igra domaće utakmice.

SELECT t.team_name, s.stadium_name
FROM teams t
LEFT JOIN stadiums s ON t.stadium_id = s.stadium_id;


-- 2. Prikažite ime i prezime igrača i naziv kluba za koji je igrao u sezoni 2024/25. Uklonite duplikate iz rezultata.

SELECT DISTINCT p.first_name, p.last_name, t.team_name --,m.season
FROM player_match_stats pms
JOIN players p on pms.player_id = p.player_id
JOIN teams t ON pms.team_id = t.team_id
JOIN matches m on pms.match_id = m.match_id
WHERE m.season = '2024/25';

-- 3. Prikažite datum odigravanja utakmice, naziv stadiona i broj gledalaca za sve utakmice u sezoni 2024/25.

SELECT DATE(m.kickoff_ts), s.stadium_name, m.attendance
FROM matches m
JOIN stadiums s ON m.stadium_id = s.stadium_id
WHERE m.season = '2024/25';

--  Srednji nivo:

-- 1. Prikažite sve utakmice za koje nije evidentiran broj gledalaca. Prikažite datum, domaći klub i gostujući klub.

SELECT DATE(m.kickoff_ts), th.team_name, ta.team_name
FROM matches m
JOIN teams th ON th.team_id = m.home_team_id
JOIN teams ta ON ta.team_id = m.away_team_id
WHERE m.attendance IS NULL;

-- 2. Pronađite stadione na kojima nije odigrana ni jedna utakmica u sezoni 2024/25.

SELECT DISTINCT s.stadium_name
FROM stadiums s 
LEFT JOIN matches m  ON m.stadium_id = s.stadium_id AND m.season = '2024/25'
WHERE  m.stadium_id IS NULL

-- U sezoni 2024/25 ni jedna utakmica nije odigrana na stadionu Fairhaven Lane.

-- 3. Za svaki klub izračunajte ukupan broj žutih kartona koje su dobili njegovi igrači u sezoni 2024/25. Rezultat sortirajte opadajuće prema broju kartona.

SELECT t.team_name, COUNT (*) AS broj_zutih_kartona
FROM match_events me
JOIN teams t ON me.team_id = t.team_id
JOIN matches m ON me.match_id = m.match_id
WHERE (me.event_type = 'yellow_card' OR me.event_type = 'second_yellow') AND m.season = '2024/25'
GROUP BY t.team_name
ORDER BY broj_zutih_kartona DESC;

-- Napredni nivo:

-- 1. Pronađite pet igrača sa najvećim brojem asistencija u sezoni 2024/25. Prikažite ime igrača i broj asistencija.

SELECT p.first_name, p.last_name, COUNT (*) as broj_asistencija
FROM matches m
JOIN match_events me ON m.match_id = me.match_id
LEFT JOIN players p ON me.related_player_id = p.player_id
WHERE me.related_player_id IS NOT NULL AND me.event_type = 'goal' AND m.season = '2024/25'
GROUP BY p.first_name, p.last_name, p.player_id
ORDER BY broj_asistencija DESC, p.player_id
LIMIT 5;

-- Pablo	Fernández	9
-- Lucas	Pereira	7
-- Filip	Petrović	7
-- Eirik	Solberg	7
-- Mikkel	Nielsen	6

-- 2. Pronađite tri igrača sa najvećim ukupnim brojem odigranih minuta u sezoni 2024/25. Prikažite ime igrača, klub i ukupan broj minuta.

SELECT p.first_name, p.last_name, t.team_name, SUM (pms.minutes_played) AS ukupno_na_terenu
FROM matches m
JOIN player_match_stats pms ON pms.match_id = m.match_id
JOIN players p ON pms.player_id = p.player_id
JOIN teams t ON t.team_id = pms.team_id
WHERE m.season = '2024/25'
GROUP BY p.first_name, p.last_name, p.player_id, t.team_name
ORDER BY ukupno_na_terenu DESC, p.player_id
LIMIT 3;

-- Ibrahima	Ndiaye	Ashford Rovers	3240
-- Aaron	Lowe	Kingsbridge City	3240
-- Morgan	Nolan	Redcliffe Athletic	3240

-- 3. Za svaku sezonu prikažite broj isključenja po klubovima. Računajte događaje red_card i second_yellow. Uključite samo klubove koji su imali najmanje jedno isključenje.

SELECT m.season, t.team_name, COUNT (*) AS broj_iskljucenja
FROM matches m
JOIN match_events me ON m.match_id = me.match_id
JOIN teams t ON t.team_id = me.team_id
WHERE (me.event_type = 'red_card' OR me.event_type = 'second_yellow')
GROUP BY m.season, t.team_name;

-- Dodatni zadaci

-- 1. Za svakog sudiju prikažite njegovo ime i broj utakmica koje je sudio. Uključite i sudije koje nisu sudile ni jednu utakmicu.

SELECT r.referee_name, COUNT(m.match_id)
FROM referees r
LEFT JOIN matches m ON m.referee_id = r.referee_id
GROUP BY r.referee_name, r.referee_id;

-- 2. Prikažite imena i prezimena igrača koji nemaju ni jedan zapis u tabeli player_match_stats.
SELECT p.first_name, p.last_name--, pms.match_id
FROM players p  
LEFT JOIN player_match_stats pms ON pms.player_id = p.player_id
WHERE pms.player_id IS NULL
ORDER BY p.player_id;

-- 3. Prikažite broj golova koji je svaki klub postigao kao domaćin u sezoni 2024/25. Rezultat sortirajte od najvećeg ka najmanjem broju golova.

SELECT t.team_name, SUM (m.home_goals) AS ukupno_golova_na_domacem_terenu
FROM matches m
JOIN teams t ON m.home_team_id = t.team_id
WHERE m.season = '2024/25'
GROUP BY t.team_name, t.team_id
ORDER BY ukupno_golova_na_domacem_terenu DESC;

-- Srednji nivo:

-- 1. Za svaku sezonu prikažite broj golova koje su postigli igrači na pozicijama FW, MF i DF. Rezultat grupišite prema sezoni i poziciji igrača.

SELECT m.season, p.position, COUNT (*) AS broj_golova
FROM matches m
JOIN match_events me ON m.match_id = me.match_id
JOIN players p ON p.player_id = me.player_id
WHERE p.position IN ('FW', 'MF', 'DF') AND me.event_type = 'goal'
GROUP BY m.season, p.position
ORDER BY m.season, p.position;

-- 2. Za svaki stadion prikažite njegov naziv i ukupan broj gledalaca na utakmicama odigranim na njemu. Uključite i stadione za koje nema evidentiranih utakmica.

SELECT s.stadium_name, SUM (m.attendance) AS ukupna_poseta
FROM stadiums s
LEFT JOIN matches m ON s.stadium_id = m.stadium_id
GROUP BY s.stadium_name
ORDER BY ukupna_poseta DESC;

-- 3. Za svakog sudiju prikažite broj različitih utakmica u kojima je dosuđen penal, bez obzira na to da li je penal realizovan. Uključite i sudije za koje nema takvih utakmica.

SELECT r.referee_name, COUNT( DISTINCT me.match_id) AS broj_utakmica_sa_dosudjenim_penalom
FROM referees r
LEFT JOIN matches m ON r.referee_id = m.referee_id
LEFT JOIN match_events me ON me.match_id = m.match_id AND (me.event_type = 'penalty_miss' OR me.event_type = 'penalty_goal')
GROUP BY r.referee_name
ORDER BY broj_utakmica_sa_dosudjenim_penalom DESC, r.referee_name;


-- Napredni nivo:

-- 1. Za svaki klub prikažite naziv kluba i broj utakmica koje je odigrao kao domaćin u sezoni 2024/25. Rešite zadatak na dva načina: koristeći INNER JOIN; koristeći LEFT JOIN. Objasnite da li se rezultati razlikuju i zašto. Obratite pažnju na klubove koji nemaju ni jednu domaću utakmicu.


SELECT t.team_name, COUNT(m.match_id)
FROM teams t
INNER JOIN matches m ON t.team_id = m.home_team_id AND m.season = '2024/25'
GROUP BY t.team_name;

-- Ukupno 20 timova obuhvaćeno pretragom

SELECT t.team_name, COUNT(m.match_id)
FROM teams t
LEFT JOIN matches m ON t.team_id = m.home_team_id AND m.season = '2024/25'
GROUP BY t.team_name;

-- Ukupno 24 tima obuhvaćeno pretragom. Prikazuju se 4 tima koji imaju 0 utakmica odigranih na domaćem terenu

-- 2. Za svaki autogol u sezoni 2024/25 prikažite ime igrača, klub za koji je igrač nastupao na toj utakmici i klub kojem je gol priznat.

SELECT p.first_name, p.last_name, t.team_name,
CASE   WHEN t.team_name = th.team_name THEN ta.team_name
       ELSE th.team_name
       END AS tim_kom_je_gol_priznat
FROM matches m
JOIN match_events me ON m.match_id = me.match_id AND m.season = '2024/25'
JOIN players p ON p.player_id = me.player_id
JOIN teams t ON t.team_id = me.team_id
JOIN teams th ON th.team_id = m.home_team_id
JOIN teams ta ON ta.team_id = m.away_team_id
WHERE me.event_type = 'own_goal';

-- 3. Pronađite sve klubove koji imaju najmanje jednog igrača koji nema ni jedan zapis u player_match_stats. Prikažite naziv kluba i broj takvih igrača. Rezultat sortirajte opadajuće prema broju igrača.

SELECT t.team_name, COUNT (*) AS broj_igraca_bez_zapisa_u_player_match_stats
FROM players p
LEFT JOIN player_match_stats pms ON p.player_id = pms.player_id
JOIN player_contracts pc ON pc.player_id = p.player_id
JOIN teams t ON t.team_id = pc.team_id
WHERE pms.player_id IS NULL
GROUP BY t.team_name
ORDER BY broj_igraca_bez_zapisa_u_player_match_stats DESC;

-- Count(*) može brojati i ako igrač ima više ugovora sa istim klubom, al sad nemam živaca više da razmišljam :D

-- 4. Za svaki grad prikažite broj odigranih utakmica i ukupan broj gledalaca. Pronađite grad sa najvećim ukupnim brojem gledalaca.

SELECT s.city, COUNT (m.match_id) as broj_utakmica, SUM (m.attendance) AS ukupna_posecenost
FROM matches m
JOIN stadiums s ON s.stadium_id = m.stadium_id
GROUP BY s.city
ORDER BY ukupna_posecenost DESC;

-- 5. Pronađite sudije koje su sudile utakmice u sezoni 2023/24, ali nisu sudile ni jednu utakmicu u sezoni 2024/25. Prikažite ime sudije i njegovu nacionalnost.

SELECT r.referee_name, r.nationality,
SUM (CASE WHEN m.season = '2023/24' THEN 1 ELSE 0 END) AS broj_utakmica_2023_24, 
SUM (CASE WHEN m.season = '2024/25' THEN 1 ELSE 0 END) AS broj_utakmica_2024_25
FROM referees r
LEFT JOIN matches m ON r.referee_id = m.referee_id
GROUP BY r.referee_name, r.nationality
HAVING broj_utakmica_2023_24 >0 AND broj_utakmica_2024_25 = 0;

-- Nema sudija koje su sudile utakmice u sezoni 2023/24 a da nisu sudili ni jednu utakmicu u sezoni 2024/25


-- Od 08:00 do 15:00 na poslu radih zadatke za domaći. Kad me neko provali da sam zabušavao ceo dan upućujem ga na tebe...:PPPP

--P.S. mnogo sam spor :///
