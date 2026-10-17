-- Ilija Vasiljević
-- Domaći zadatak 2.2 - SQL - Fudbalske utakmice
-- 16.10.2026.

USE bootcamp.northern_star;

-- 1. Pronađite sve utakmice čiji naslov (`match_report`) sadrži reč `goal` , bez obzira na velika i mala slova.

SELECT * FROM matches_flat
WHERE match_report ILIKE('%goal%');

-- 2. Napravite kolonu referee_name tako da sadrži ime sudije ako postoji, a tekst Unknown ako nedostaje podatak. Prikažite 20 utakmica.

SELECT home_team, away_team, 
coalesce(referee_name, 'Unknown') AS referee_name
FROM matches_flat
LIMIT 20;

-- 3. Prikažite utakmice čiji je naslov duži od 40 znakova. Prikažite naslov i broj znakova u njemu.

SELECT match_report, length(match_report) AS duzina_naslova
FROM matches_flat
WHERE length(match_report) > 40;

-- 4. Prikažite utakmice odigrane od 1. do 15. januara 2025, uključujući oba datuma.

SELECT * FROM matches_flat
WHERE YEAR(kickoff_ts) = 2025 AND MONTH(kickoff_ts) = 1
AND DAY(kickoff_ts) BETWEEN 1 AND 15;

-- 5. Prebrojte utakmice odigrane petkom. Prikažite datum i dan u nedelji za svaku od njih.

SELECT  DATE(kickoff_ts) AS datum, DAYOFWEEK(kickoff_ts) AS dan
FROM matches_flat
WHERE DAYOFWEEK(kickoff_ts) = 6;

-- Nema utakmica igranih petkom.

-- 6. Koliko utakmica sezone 2024/25 je imalo između 20.000 i 35.000 gledalaca, uključujući obe granice?

SELECT COUNT (*)
FROM matches_flat
WHERE season = '2024/25' AND attendance BETWEEN 20000 AND 35000;

-- U sezoni 2024/25 ukupno 188 utakmica imalo je između 20.000 i 35.000 gledalaca, uključujući obe granice.

-- 7. Pronađite strelce prvog gola čije ime počinje slovom A ili sadrži crticu. Prikažite samo različita imena.

SELECT DISTINCT first_goal_scorer
FROM matches_flat
WHERE first_goal_scorer LIKE ('A%') OR first_goal_scorer LIKE ('%-%');

-- 8. Prikažite utakmice sezone 2024/25 koje su počele između 18:00 i 21:00, uključujući obe granice. Prikažite vreme početka i nazive timova.

SELECT TIME(kickoff_ts) as vreme, home_team, away_team
FROM matches_flat
WHERE season = '2024/25' AND TIME(kickoff_ts) BETWEEN '18:00' AND '21:00';

-- 9. Prebrojte utakmice odigrane u martu, aprilu ili maju 2025. godine čiji naslov sadrži reč win, bez obzira na veličinu slova.

SELECT COUNT (*)
FROM matches_flat
WHERE YEAR(kickoff_ts) = 2025 AND MONTH(kickoff_ts) BETWEEN 3 AND 5 AND match_report ILIKE('%win%');

-- Dodatni zadatak 1: Prebrojte utakmice za koje nisu evidentirani ni sudija ni poseta.

SELECT COUNT (*)
FROM matches_flat
WHERE referee_name IS NULL AND attendance IS NULL;

-- Nema utakmica za koje istovremeno nedostaju podaci o sudiji i poseti.

-- Dodatni zadatak 2: Prikažite sve utakmice odigrane između 1. i 31. marta 2025. godine, uključujući oba datuma. Rezultate sortirajte po datumu odigravanja.

SELECT * FROM matches_flat
WHERE DATE(kickoff_ts) BETWEEN '2025-03-01' AND '2025-03-31' 
ORDER BY DATE(kickoff_ts); 

-- Dodatni zadatak 3: Koliko je utakmica odigrano u periodu od 20. decembra 2024. do 10. januara 2025. godine, uključujući oba datuma?

SELECT COUNT (*)
FROM matches_flat
WHERE DATE(kickoff_ts) BETWEEN '2024-12-20' AND '2025-01-10';

-- Ukupno 51 utakmica je odigrana u periodu od 20. decembra 2024. do 10. januara 2025. godine.


-- Dodatni zadatak 4: Napravite kolonu attendance_status koja prikazuje broj gledalaca ako je poseta evidentirana, a tekst Unknown ako podatak o poseti nedostaje. Prikažite datum utakmice, domaći tim, gostujući tim i novu kolonu.

SELECT DATE(kickoff_ts) AS datum_utakmice, home_team, away_team, 
    coalesce (cast (attendance AS STRING), 'Unknown') AS attendance_status
FROM matches_flat;

-- Dodatni zadatak 5: Prikažite utakmice odigrane od 1. do 30. aprila 2025. godine kod kojih je postignuto između 2 i 4 gola ukupno, uključujući obe granice. Rezultate sortirajte po datumu.

SELECT * FROM matches_flat
WHERE DATE(kickoff_ts) BETWEEN '2025-4-1' AND '2025-4-30'
AND home_goals + away_goals BETWEEN 2 AND 4
ORDER BY DATE(kickoff_ts);

-- Dodatni zadatak 6: Pronađite utakmice kod kojih je rezultat na poluvremenu bio nerešen, ali je konačni rezultat bio različit. Prikažite datum, timove, rezultat na poluvremenu i konačni rezultat.

SELECT DATE(kickoff_ts) AS datum, 
    CONCAT(home_team,' - ', away_team) AS timovi, 
    CONCAT(home_goals_ht, ' - ', away_goals_ht) AS poluvreme, 
    CONCAT (home_goals, ' - ', away_goals) AS rezultat 
FROM matches_flat
WHERE home_goals_ht = away_goals_ht AND home_goals <> away_goals;