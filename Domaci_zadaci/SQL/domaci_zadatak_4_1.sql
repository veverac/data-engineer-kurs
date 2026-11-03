-- Ilija Vasiljević
-- Domaći zadatak 4.1 - SQL - Fudbalske utakmice
-- 22.10.2026.

USE bootcamp.northern_star; -- I dalje nisam ubeđen da ovo radi kako treba :D

-- 1. Koliko redova ima spoj matches i player_match_stats za sezonu 2024/25? Objasnite.

SELECT COUNT (*)
FROM matches m
JOIN player_match_stats pms ON m.match_id = pms.match_id
WHERE m.season = '2024/25';

-- Ukupno 15200 redova ima spoj tabela matches i player_match_stats. Svaka utakmica u tabeli matches  ima tačno jedan red (match_id).  Svaki red iz matches se ponavlja onoliko puta koliko ima odgovarajućih redova u match_id koloni tabele player_match_stats. Kada se spoje dolazi do "umnožavanja redova" te dve tabele, i zato JOIN tabela ima 15200 redova za sezonu 2024/25.


-- 2. Koliko puta je igrač u istoj sezoni igrao za dva različita kluba?

WITH igraci AS (
        SELECT COUNT (DISTINCT (pms.team_id)) AS broj_timova, pms.player_id, m.season 
        FROM player_match_stats pms
        JOIN matches m ON pms.match_id = m.match_id
        GROUP BY pms.player_id, m.season
        HAVING broj_timova > 1
        )
SELECT COUNT (*)
FROM igraci;

-- Ukupno 35 puta je igrač iz iste sezone igrao za dva različita kluba.

-- 3. Koliko utakmica ima više kartona od prosečne utakmice? Bez kartona računajte sa 0.

WITH kartoni AS (
        SELECT match_id,
        SUM (CASE WHEN event_type IN ('yellow_card', 'red_card', 'second_yellow') THEN 1 ELSE 0 END) AS broj_kartona
        FROM match_events
        GROUP BY match_id
        ),
utakmice AS (
          SELECT m.match_id, COALESCE(k.broj_kartona, 0) AS kartoni
          FROM matches m
          LEFT JOIN kartoni k ON m.match_id = k.match_id
          WHERE m.status = 'played'
          )
SELECT COUNT (*)
FROM utakmice
WHERE kartoni > (SELECT AVG(kartoni) FROM utakmice);

-- Ukupno 370 utakmica ima više kartona od prosečne utakmice. U slučaju da nema, ovaj maksimalno zakoplikovani način rešavanja mi je za džaba uzeo dva sata života :D

-- 4. Koliko igrača je odigralo više od 10 utakmica u sezoni 2024/25?

WITH igraci AS (
                SELECT COUNT (m.match_id) AS broj_utakmica, pms.player_id
                FROM player_match_stats pms
                JOIN matches m ON m.match_id = pms.match_id AND m.season = '2024/25'
                GROUP BY pms.player_id
                HAVING broj_utakmica > 10
                )
SELECT COUNT (*)
FROM igraci;

-- Ukupno 483 igrača je igralo više od 10 utakmica u sezoni 2024/25. I opet...ne mogu da se otrgnem utisku da postoji i jednostavniji način za ovo....

-- 5. Prikažite sve klubove koji su igrali u sezoni 2024/25, bilo kao domaćini ili kao gosti. Koristite UNION, a zatim izmenite upit tako da koristi UNION ALL. Objasnite razliku u broju redova koji dobijate.

WITH klubovi AS (
                SELECT home_team_id as team_id
                FROM matches
                WHERE season ='2024/25'
                UNION
                SELECT away_team_id as team_id
                FROM matches
                WHERE season = '2024/25'
                )
SELECT t.team_name
FROM klubovi k
JOIN teams t ON k.team_id = t.team_id; -- Ukupno 20 redova

WITH klubovi AS (
                SELECT home_team_id as team_id
                FROM matches
                WHERE season ='2024/25'
                UNION ALL
                SELECT away_team_id as team_id
                FROM matches
                WHERE season = '2024/25'
                )
SELECT t.team_name
FROM klubovi k
JOIN teams t ON k.team_id = t.team_id; -- Ukupno 760 redova

-- Funkcija UNION prilikom spajanja briše duplikate, i iz tog razloga ostavlja samo 20 timova koji su igrali utakmice u sezoni 2024/2025. S druge strane UNION ALL ostavlja sve redove. Pošto u sezoni 2024/25 ima 380 odigranih utakmica, kada funkcijom UNION ALL spojimo i home_team i away team dobijamo 760 redova za naš upit. 
--Q.E.D. (Quod erat demonstrandum!)

-- P.S. Samo jedno pitanje iz čiste radoznalosti: Kakav je osećaj kada pritisneš SHIFT + ENTER, a iz prvog pokušaja ti se ništa ne zacrveni? Pitam za drugara :D