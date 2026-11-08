# Databricks notebook source
# Написати функцију get_header(path: str) -> list која враћа заглавље CSV фајла.

import csv
def get_header(path: str) -> list:
    with open (path, 'r') as f:
        reader = csv.reader(f)
        header = next(reader)
    return header
get_header('./row/teams.csv')


# Написати функцију read_rows(path: str) -> list која враћа све редове CSV фајла без заглавља, као листу листи.

import csv
def read_rows(path: str) -> list:
    with open (path, 'r') as f:
        svi_redovi = []
        reader = csv.reader(f)
        next(reader)
        for row in reader:
            svi_redovi.append(row)
    return svi_redovi
read_rows('./row/teams.csv')


# Написати функцију total_points(path: str) -> int која враћа збир бодова свих тимова.

# Користити csv.DictReader

import csv
def total_points(path: str)-> int:
    with open (path, 'r') as f:
        suma=0
        teams = csv.DictReader(f)
        points = [int(t['points']) for t in teams]
        for p in points:
            suma += p
    return suma
total_points('./row/teams.csv')


# Написати функцију write_rows(path: str, rows: list) -> None која листу листи уписује у CSV фајл.
import csv

def write_rows(path: str, rows: list) -> None:
    with open(path, 'w') as f:
        writer = csv.writer(f)
        for i, j in rows:
            writer.writerow([i,j])
write_rows('./processed/people.csv', [['name', 'age'], ['Ana', 20], ['Marko', 22]])
            


# Написати функцију write_dicts(path: str, rows: list) -> None која листу речника уписује у CSV фајл.

# Користити csv.DictWriter; заглавља су кључеви првог речника.
import csv
def write_dicts(path: str, rows: list) -> None:
    header = rows[0].keys()
    with open (path, 'w') as f:
        writer = csv.DictWriter(f, fieldnames=header)
        writer.writeheader()
        for i in rows:
            writer.writerow(i)
write_dicts('./processed/people1.csv', [
    {'name': 'Ana', 'age': 20},
    {'name': 'Marko', 'age': 22}
])