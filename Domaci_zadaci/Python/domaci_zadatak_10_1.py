# Databricks notebook source
import pandas as pd

R = '/Volumes/bootcamp/northern_star/raw_2025_26/'
m = pd.read_parquet(R + 'matches_2025_26.parquet')

# COMMAND ----------

# 1. Analiza rezultata utakmica:

# 1.Pronaći sve utakmice u kojima su oba tima postigla bar po jedan gol.

display(m.loc[(m['home_goals'] > 0) & (m['away_goals'] > 0)])


# 2.Pronaći sve utakmice u kojima je domaćin pobedio sa tačno jednim golom razlike.

display(m.loc[(m['home_goals'] - m['away_goals'] == 1)])

# 3.Koliko utakmica je završeno rezultatom 0:0?

print(f'Uupno {len(m.loc[(m['home_goals'] == 0) & (m['away_goals'] == 0)])} utakmica je završeno rezultatom 0:0.')

# 4.Prikazati 10 utakmica sa najviše ukupno postignutih golova.

m['total_goals'] = m['home_goals'] + m['away_goals']
display(m.nlargest(10, 'total_goals'))




# COMMAND ----------

# 2. Analiza jednog tima

# Za tim po izboru:
# 1.Prikazati sve utakmice u kojima je učestvovao.

m1 = m.loc[(m['home_team'] == 'IVU') | (m['away_team'] == 'IVU')].copy() 
print(f"Tim IVU je učestvovao u sledećim utakmicama:\n {display(m1.sort_values('kickoff_ts'))}")   

# 2.Koliko je puta pobedio, izgubio i odigrao nerešeno?

m1['results'] = 'D'
m1.loc[((m1['home_goals'] > m1['away_goals']) & (m1['home_team'] == 'IVU')) | ((m1['home_goals'] < m1['away_goals']) & (m1['away_team'] == 'IVU')), 'results'] = 'W'
m1.loc[((m1['home_goals'] < m1['away_goals']) & (m1['home_team'] == 'IVU')) | ((m1['home_goals'] > m1['away_goals']) & (m1['away_team'] == 'IVU')), 'results'] = 'L'
rezultati = m1['results'].value_counts()
print(f"Tim IVU je u sezoni imao {rezultati['W']} pobeda, {rezultati['L']} poraza i {rezultati['D']} nerešenih utakmica.\n")

# 3.Koliko je golova postigao kao domaćin, a koliko kao gost?

domacin = m1.loc[(m1['home_team'] == 'IVU'), 'home_goals'].sum()
gost = m1.loc[(m1['away_team'] == 'IVU'), 'away_goals'].sum()
print(f'Kao domaćin, IVU je postigao {domacin} golova, a kao gost {gost} golova.\n')

# 4.Pronaći utakmicu u kojoj je postigao najviše golova.
 
m1['IVU_GOALS'] = 0
m1.loc[(m1['home_team'] == 'IVU'), 'IVU_GOALS'] = m1['home_goals']
m1.loc[(m1['away_team'] == 'IVU'), 'IVU_GOALS'] = m1['away_goals']
najvise_golova = m1.nlargest(1,'IVU_GOALS', keep='all')
print(f'Najvise golova IVU je postigao na sledećoj utakmici:\n {display(najvise_golova)}')

## iz nekog razloga, kad stavim dispay, tekst pre njega u printu stavi ispod te tabele...prronaći ću opciju da i to rešim pa ću updatovati rešenje zadatka kad budem stigao

# COMMAND ----------

# 3. Analiza stadiona

# 1.Prikazati sve različite stadione na kojima su odigrane utakmice.

print(f'Svi stadioni na kojima su igrane utakmice su:\n {m['stadium'].unique()}\n')

# 2.Pronaći stadion na kojem je odigrano najviše utakmica.

print(f'Stadion na kom je odigrano najviše utakmica je:\n {m['stadium'].value_counts().nlargest(1, keep='all')}\n')

# 3.Za svaki stadion izračunati prosečnu posećenost.

avg_attendance = m.groupby('stadium')['attendance'].mean().round(2)
print(f'Prosečna posećenost na stadionima je:\n {avg_attendance}\n')

# 4.Prikazati pet stadiona sa najvećom prosečnom posećenošću.

npp = avg_attendance.nlargest(5)

print(f'Pet stadiona sa najvećom prosečnom posećenosti su:\n {npp}.')