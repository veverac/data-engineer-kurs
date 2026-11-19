# Databricks notebook source
import numpy as np

# COMMAND ----------

# Domaći 10.2 – Zadatak 1
# Sistem beleži broj aktivnih korisnika tokom 12 uzastopnih sati.
# Potrebno je:

korisnici = np.array([120, 135, 142, 160, 185, 210, 198, 175, 230, 245, 220, 190])

# 1. Prikazati broj korisnika za peti sat.

print('Broj korisnika za peti sat:', korisnici[4])

# 2. Prikazati broj korisnika za poslednja četiri sata.

print('Broj korisnika za poslednja četiri sata:', korisnici[-4:])

# 3. Izračunati ukupan broj aktivnih korisnika kroz svih 12 sati.

print('Broj aktivnih korisnika kroz svih 12 sati:', korisnici.sum())

# 4. Izračunati prosečan broj korisnika po satu.

print('Prosečan broj korisnika po satu:', round(korisnici.mean(),2))

# 5. Pronaći sat sa najvećim brojem korisnika.

print('Sat sa najvećim brojem korisnika:', (korisnici.argmax()+1))

# COMMAND ----------

# Domaći 10.2 – Zadatak 2: Resursi servera
# Sistem beleži CPU, RAM i disk usage za pet različitih servera.
# Redovi predstavljaju servere, a kolone CPU, RAM i disk usage.

serveri = np.array([
    [45, 60, 70],
    [80, 75, 65],
    [35, 50, 40],
    [90, 85, 95],
    [60, 55, 70]
])

# Potrebno je:
# 1. Prikazati dimenzije matrice.

print('Dimenzije matrice su:', serveri.shape)

# 2. Prikazati broj servera i broj metrika.

print(f'Broj servera je {serveri.shape[0]}, a broj metrika je {serveri.shape[1]}.')

# 3. Izračunati prosečnu vrednost svake metrike.

print('Prosečna vrednost svake metrike je:', np.mean(serveri, axis=0))

# 4. Izračunati prosečnu potrošnju resursa za svaki server.

prosecna = np.mean(serveri, axis=1)
print('Prosečna potrošnja resursa za svaki server:', np.round(prosecna, 2))

# 5. Pronaći server sa najvećom prosečnom potrošnjom resursa.

print ('Server sa najvećom prosečnom potrošnjom resursa je:', (prosecna.argmax())+1)


# COMMAND ----------

# Domaći 10.2 – Zadatak 3: Vreme izvršavanja procesa
# Sistem beleži vreme izvršavanja 15 različitih procesa u sekundama.

procesi = np.array([35, 120, 85, 45, 160, 95, 30, 110, 75, 200, 50, 40, 145, 65, 100])

# Potrebno je:
# 1. Pronaći sve procese koji su trajali duže od 100 sekundi.

dugi = procesi[procesi > 100]
print ('Procesi duži od 100 sekundi su:', dugi)

# 2. Pronaći procese koji su trajali između 40 i 100 sekundi.

izmedju = procesi[(procesi >= 40) & (procesi <= 100)] # Interval od 40 do 100 sekundi, uključujući granice
print ('Procesi koji su trajali između 40 i 100 sekundi su:', izmedju)

# 3. Izbrojati procese koji su trajali kraće od 50 sekundi.

kratki = procesi[procesi < 50]
print (f'Ukupno {len(kratki)} procesa je kraće od 50 sekundi.')

# 4. Pronaći indekse procesa koji su trajali duže od 100 sekundi.

indeksi = np.where(procesi > 100)
print('Indeksi procesa koji su trajali duže od 100 sekundi su:', indeksi[0])

# 5. Izračunati prosečno vreme izvršavanja svih procesa.

prosek = procesi.mean()

print(f'Prosečno vreme izvršenja svih procesa je: {round(prosek,2)} sekundi.')

# COMMAND ----------

# Domaći 10.2 – Zadatak 4: Prihodi prodavnice
# Prodavnica beleži prihode od četiri različite kategorije proizvoda tokom šest meseci. Redovi predstavljaju kategorije proizvoda, a kolone mesece.

prihodi = np.array([
    [120000, 135000, 142000, 160000, 155000, 175000],
    [85000,  92000,  88000,  105000, 110000, 125000],
    [210000, 195000, 225000, 240000, 230000, 260000],
    [65000,  72000,  68000,  80000,  85000,  95000]
])

# Potrebno je:
# 1. Izračunati ukupan prihod svake kategorije proizvoda.

ukupni = np.sum(prihodi, axis=1)
print ('Ukupni prihodi svake kategorije proizvoda su:', ukupni)

# 2. Izračunati ukupan prihod za svaki mesec.

mesecni = np.sum(prihodi, axis=0)
print ('Ukupni mesečni prihodi su:', mesecni)

# 3. Pronaći kategoriju proizvoda sa najvećim ukupnim prihodom.

print('Kategorija sa najvećim ukupnim prihodom je:', ukupni.argmax()+1) 

# 4. Pronaći mesec sa najvećim ukupnim prihodom.

print ('Mesec sa najvećim ukupnim prihodom je:', mesecni.argmax()+1)

# 5. Izračunati prosečan prihod po kategoriji proizvoda.

prosek_kat = np.mean(prihodi, axis=1)
print('Prosečan prihod po kategoriji proizvoda je:', np.round(prosek_kat,2))

# 6. Izračunati prosečan mesečni prihod svih kategorija.

prosek_mesec = np.mean(prihodi, axis=0)
print('Prosečan mesečni prihod svih kategorija je:', np.round(prosek_mesec,2))


# COMMAND ----------

# Domaći 10.2 – Zadatak 5: Dnevne temperature
# Sistem beleži prosečne dnevne temperature tokom 15 dana. Neki podaci nedostaju ili nisu validni.

temperature = np.array([
    22.5, 24.0, np.nan, 26.5, 55.0,
    19.5, -25.0, 21.0, np.nan, 28.5,
    23.0, 51.0, 18.5, -20.0, 50.0
])

# Validna temperatura mora biti između -20 i 50 stepeni.

# Potrebno je:
# 1. Identifikovati nedostajuće vrednosti.

nedostajuce = np.isnan(temperature)
print('Nedostajuce vrednosti:', nedostajuce)

# 2. Identifikovati nevalidne temperature (vrednosti manje od -20 ili veće od 50).

nevalid = (temperature < -20) | (temperature > 50) 
print ('Nevalidne temperature su:', temperature[nevalid])

# 3. Pronaći indekse nevalidnih vrednosti.

indeksi = np.where((temperature < -20) | (temperature > 50) )
print ('Indeksi nevalidnih temperatura su:', indeksi[0])

# 4. Izračunati broj nedostajućih i nevalidnih vrednosti.

broj_nan_nvalid = np.sum(nedostajuce) + np.sum(nevalid)
print('Broj nedostajućih i nevalidnih vrednosti je:', broj_nan_nvalid)

# 5. Izračunati procenat nevalidnih i nedostajućih zapisa zajedno.

procenat = (broj_nan_nvalid / temperature.size)*100
print('Procenat nevalidnih i nedostajućih zapisa je:', round(procenat,2),'%')

# 6. Kreirati novi niz koji sadrži samo validne temperature.

samo_validni= temperature[~nevalid & ~nedostajuce]
print('Validne temperature su:', samo_validni)

# 7. Izračunati prosečnu temperaturu bez nedostajućih i nevalidnih vrednosti.

prosek_bez_nan_nevalid = np.mean(samo_validni)
print('Prosecna temperatura bez nedostajućih i nevalidnih vrednosti je:', prosek_bez_nan_nevalid)
