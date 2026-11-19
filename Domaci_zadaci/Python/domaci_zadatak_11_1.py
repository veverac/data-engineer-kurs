# Databricks notebook source
import requests

# COMMAND ----------

# Napisati funkciju get_space_station() -> dict koja preko Open Notify API-ja preuzima trenutnu poziciju Međunarodne svemirske stanice (ISS).

# API: http://api.open-notify.org/iss-now.json

# Funkcija treba da vrati rečnik koji sadrži:
# - latitude – geografsku širinu
# - longitude – geografsku dužinu

def get_space_station() -> dict:
    url = 'http://api.open-notify.org/iss-now.json'
    response=requests.get(url)
    response.raise_for_status()
    data = response.json()
    return {
        'latitude' : data['iss_position']['latitude'], 
        'longitude': data['iss_position']['longitude']
    }
get_space_station()

# COMMAND ----------



# COMMAND ----------

# Napisati funkciju get_universities(country: str) -> list koja preko Hipolabs API-ja preuzima univerzitete iz zadate države i vraća listu njihovih naziva.

# API: http://universities.hipolabs.com/search
# Obavezno koristiti:
# params = {'country': country}
# Za primer poziva: get_universities("Serbia")
# Funkcija treba da vrati listu naziva univerziteta, a ne kompletne rečnike sa podacima.

def get_universities(country: str) -> list:
    url = 'http://universities.hipolabs.com/search'
    params = {'country': country}
    response = requests.get(url, params = params)
    response.raise_for_status()
    data = response.json()
    return [name['name'] for name in data]

get_universities("Serbia")   

# COMMAND ----------

# Napisati funkciju get_exchange_rate(base: str, target: str) -> float koja preko Frankfurter API-ja preuzima kurs između dve valute.

# API: https://api.frankfurter.dev/v1/latest

# Funkcija treba da vrati koliko jedinica ciljne valute (target) se dobija za jednu jedinicu početne valute (base).

def get_exchange_rate(base: str, target: str) -> float:
    url = 'https://api.frankfurter.dev/v1/latest'
    params = {
        'base': base,
        'symbols': target
    }
    response = requests.get(url, params = params)
    response.raise_for_status()      
    data = response.json() 
    return data['rates'][target]
get_exchange_rate('EUR','RSD')
