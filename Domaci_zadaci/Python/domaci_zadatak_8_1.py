
# Napisati funkciju get_even_positions(data: tuple) -> tuple koja vraća elemente torke koji se nalaze na parnim indeksima (0, 2, 4...).

def get_even_positions(data: tuple):
    return data[::2]

print (f'Vrednosti torke na parnim indeksima su: {get_even_positions ((10, 20, 30, 40, 50, 60))}.')


# Napisati funkciju find_exclusive_students(group1: set, group2: set) -> set koja vraća studente koji se nalaze u prvoj grupi, ali ne i u drugoj.

def find_exclusive_students(group1: set, group2: set):
    return group1 - group2

print (f'Studenti koji se nalaze u prvoj grupi a ne nalaze se u drugoj su: {find_exclusive_students({'Ana', 'Marko', 'Jovan', 'Milica'},{'Marko', 'Milica', 'Petar'})}.')


# Napisati funkciju clean_tags(text: str) -> str koja obrađuje tekst sa tagovima.

# Potrebno je:
# 1. Razdvojiti tagove koji su odvojeni karakterom |
# 2. Ukloniti početne i krajnje razmake svakog taga
# 3. Sva slova pretvoriti u mala slova
# 4. Spojiti tagove karakterom -

def clean_tags(text: str):
    parts = text.split('|')
    lista = []
    for p in parts:
        a = p.strip().lower()
        lista.append(a)
    clean = '-'.join(lista)
    return clean  

print (f'Transformacija ulaznog teksta je: {clean_tags(' Python | DATA | SQL ')}.')


# Napisati funkciju count_products(csv_lines: list) -> dict koja analizira porudžbine iz CSV podataka i vraća ukupan broj naručenih proizvoda.
# Svaki red sadrži ime kupca, naziv proizvoda i količinu, razdvojene zarezom. Prvi red predstavlja zaglavlje i treba ga zanemariti.
# Ako se isti proizvod pojavljuje u više redova, sabrati njegove količine

def count_products(csv_lines: list):
    total_order = {}
    for row in csv_lines[1:]:
        part = row.split(',')
        if part[1] in total_order:
            total_order[part[1]] += int(part[2])
        else:
            total_order[part[1]] = int(part[2])
    return total_order
print (f'Total order is: {count_products([
    'customer,product,quantity',
     'Alice,laptop,2',
    'Bob,mouse,3',
    'Alice,laptop,1',
    'Charlie,keyboard,2',
    'Bob,mouse,1'
])}.')