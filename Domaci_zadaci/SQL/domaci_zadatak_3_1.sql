USE bootcamp.northern_star;
-- Ilija Vasiljević
-- Domaći zadatak 3.1 - SQL - Fudbalske utakmice
-- 19.10.2026.

-- 1. Za svaku sezonu prikažite ukupan broj utakmica, ukupan broj postignutih golova i prosečan broj golova po utakmici.

SELECT
    season,
    COUNT (*) AS broj_utakmica,
    SUM (home_goals + away_goals) AS ukupan_broj_postignutih_golova,
    ROUND (AVG (home_goals + away_goals), 2) AS prosecan_broj_golova_po_utakmici
FROM matches_flat
GROUP BY season;

-- season	broj_utakmica	ukupan_broj_postignutih_golova	prosecan_broj_golova_po_utakmici
-- 2023/24	381	1046	2.75
-- 2024/25	380	1092	2.87

-- 2. Za svaki stadion prikažite najmanju, najveću i prosečnu zabeleženu posetu, kao i broj utakmica za koje je poseta poznata.
SELECT
    stadium_name,
    MIN (attendance) AS minimalna_poseta,
    MAX (attendance) AS maksimalna_poseta,
    ROUND (AVG (attendance), 2) AS prosecna_poseta,
    COUNT (attendance) AS poznata_poseta
FROM matches_flat
GROUP BY stadium_name;


-- 3. Prikažite sudije koje su sudile najmanje 10 utakmica i koje su ukupno pokazale najmanje 20 žutih kartona. Prikažite ime sudije, broj utakmica i ukupan broj žutih kartona.

SELECT
    referee_name,
    COUNT(*) AS broj_utakmica,
    SUM (home_yellow_cards + away_yellow_cards) AS broj_zutih_kartona
FROM matches_flat
GROUP BY referee_name
HAVING broj_utakmica >= 10 AND broj_zutih_kartona>=20;

-- 4. Podelite utakmice prema ukupnom broju golova na kategorije Bez golova (0), Malo golova (1 ili 2) i Mnogo golova (3 ili više). Prikažite broj utakmica u svakoj kategoriji i najveći broj golova na utakmici u toj kategoriji.

SELECT 
    COUNT (*) AS broj_utakmica,
    CASE WHEN home_goals + away_goals = 0 THEN 'Bez golova'
         WHEN home_goals + away_goals BETWEEN 1 AND 2 THEN 'Malo golova'
         WHEN home_goals + away_goals >= 3 THEN 'Mnogo golova'
         END AS kategorija_golova,
    MAX (home_goals + away_goals) AS najveci_broj_golova
FROM matches_flat
WHERE home_goals + away_goals IS NOT NULL
GROUP BY kategorija_golova;

-- broj_utakmica	kategorija_golova	najveci_broj_golova
-- 389	Mnogo golova	9
-- 330	Malo golova	2
-- 41	Bez golova	0

-- 5. Za svaki klub prikažite broj utakmica koje je odigrao kao domaćin, broj pobeda kod kuće i broj poraza kod kuće. U rezultat uključite samo klubove koji su kod kuće odigrali najmanje 10 utakmica.

SELECT
    home_team,
    COUNT(*) AS broj_utakmica_kao_domacin,
    SUM (CASE WHEN home_goals > away_goals THEN 1 ELSE 0 END) AS pobeda_kod_kuce,
    SUM (CASE WHEN home_goals < away_goals THEN 1 ELSE 0 END) AS poraz_kod_kuce 
FROM matches_flat
WHERE home_goals IS NOT NULL AND away_goals IS NOT NULL
GROUP BY home_team
HAVING broj_utakmica_kao_domacin >= 10;

-- 6. Za svakog sudiju prikažite ukupan broj utakmica, broj utakmica u kojima je pokazao bar jedan crveni karton i procenat takvih utakmica u odnosu na sve utakmice koje je sudio.

SELECT
    referee_name,
    COUNT (*) AS ukupan_broj_utakmica,
    SUM (CASE WHEN home_red_cards + away_red_cards > 0 THEN 1 ELSE 0 END) AS broj_utakmica_sa_crvenim_kartonom,
    ROUND (broj_utakmica_sa_crvenim_kartonom / ukupan_broj_utakmica * 100, 2) AS procenat
FROM matches_flat
GROUP BY referee_name;

-- 7. Za svaku sezonu prikažite broj pobeda domaćina, broj nerešenih utakmica i broj pobeda gostiju. Takođe prikažite procenat utakmica koje su završene nerešenim rezultatom.

SELECT
    season,
    SUM (CASE WHEN home_goals > away_goals THEN 1 ELSE 0 END) AS broj_pobeda_domacina,
    SUM (CASE WHEN home_goals = away_goals THEN 1 ELSE 0 END) AS broj_neresenih_utakmica,
    SUM (CASE WHEN home_goals < away_goals THEN 1 ELSE 0 END) AS broj_pobeda_gostiju,
    ROUND (broj_neresenih_utakmica / COUNT (*) * 100,2) AS procenat
FROM matches_flat
WHERE home_goals IS NOT NULL AND away_goals IS NOT NULL
GROUP BY season;

--season	broj_pobeda_domacina	broj_neresenih_utakmica	broj_pobeda_gostiju	procenat
-- 2023/24	172	96	112	25.26
-- 2024/25	157	95	128	25
