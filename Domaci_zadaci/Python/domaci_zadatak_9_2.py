# Databricks notebook source
# Domaći zadatak 9.2 — Zadatak 1: BankAccount
# Kreirati klasu BankAccount koja predstavlja bankovni račun.

# Klasa treba da ima sledeće atribute:
# - owner – ime vlasnika računa;
# - balance – trenutno stanje na računu.
# Implementirati sledeće metode:
# 1. deposit(amount: float) -> BankAccount – uvećava stanje na računu za zadati iznos. Ako je iznos pozitivan, izvršava uplatu. Vraća objekat nad kojim je metoda pozvana.
# 2. withdraw(amount: float) -> BankAccount – umanjuje stanje na računu za zadati iznos. Isplata se izvršava samo ako je iznos pozitivan i ako na računu ima dovoljno novca. Vraća objekat nad kojim je metoda pozvana.
# 3. display_balance() -> None – ispisuje trenutno stanje na računu.


class BankAccount:
    def __init__(self, owner, balance):
        self.owner = owner
        self.balance = balance
    
    def deposit (self, amount: float):
        if amount >0: 
            self.balance += amount
        return self
    
    def withdraw(self, amount: float):
        if amount >0 and amount <= self.balance: 
            self.balance -= amount
        return self
    
    def display_balance(self):
        print (f'Trenutno stanje na računu je: {self.balance}.')
    
account = BankAccount("Ana", 10000)
account.deposit(5000).withdraw(2000).deposit(1000)
account.display_balance()

# COMMAND ----------

# Domaći zadatak 9.2 — Zadatak 2: UserProfile
# Kreirati klasu UserProfile koja predstavlja profil korisnika.

# Klasa treba da ima sledeće atribute:
# - username – korisničko ime;
# - email – imejl adresa;
# - city – grad;
# - active – informacija o tome da li je profil aktivan.
# Prilikom kreiranja objekta, profil treba da bude aktivan.

# Implementirati sledeće metode:
# 1. change_email(email: str) -> UserProfile – menja imejl adresu korisnika i vraća objekat.
# 2. change_city(city: str) -> UserProfile – menja grad korisnika i vraća objekat.
# 3. deactivate() -> UserProfile – deaktivira profil i vraća objekat.
# 4. activate() -> UserProfile – aktivira profil i vraća objekat.
# 5. display_info() -> None – ispisuje sve informacije o korisniku.


class UserProfile:
    def __init__(self, username, email, city):
        self.username = username
        self.email = email
        self.city = city
        self.active = True

    def change_email(self, email):
        self.email = email
        return self
    
    def change_city(self, city):
        self.city = city
        return self
    
    def deactivate (self):
        self.active = False
        return self

    def activate (self):
        self.active = True
        return self

    def display_info(self):
        if self.active == True:
            status = 'aktivan'
        else:
            status = 'neaktivan'
        print (f'Korisnički nalog je {status}. Korisničko ime je {self.username}, email korisnika je {self.email} a korisnik je iz {self.city}a.')

user = UserProfile("ana123", "ana@gmail.com", "Nis")
user.change_email("ana@yahoo.com").change_city("Beograd").deactivate()
user.display_info()

# COMMAND ----------

# Domaći zadatak 9.2 — Zadatak 3: Product
# Kreirati klasu Product koja predstavlja proizvod u prodavnici.

# Klasa treba da ima sledeće atribute:
# - name – naziv proizvoda;
# - price – cena proizvoda;
# - quantity – količina proizvoda na stanju.
# Implementirati sledeće metode:
# 1. change_price(new_price: float) -> Product – menja cenu proizvoda ako je nova cena pozitivna. Vraća objekat.
# 2. add_stock(amount: int) -> Product – povećava količinu proizvoda na stanju za zadati iznos ako je iznos pozitivan. Vraća objekat.
# 3. sell(amount: int) -> Product – umanjuje količinu proizvoda na stanju ako ima dovoljno proizvoda i ako je količina pozitivna. Vraća objekat.
# 4. display_info() -> None – ispisuje informacije o proizvodu.

class Product:
    def __init__(self, name, price, quantity):
        self.name = name
        self.price = price
        self.quantity = quantity

    def change_price(self, new_price: float):
        if new_price > 0:
            self.price = new_price
        return self
    
    def add_stock(self, amount:int):
        if amount > 0:
            self.quantity += amount
        return self

    def sell(self, amount: int):
        if amount <= self.quantity and amount >0:
            self.quantity -= amount
        return self

    def display_info(self):
        print (f' Proizvod {self.name} ima cenu {self.price}. Ukupna količina na stanju je {self.quantity}.') 

product = Product("Laptop", 80000, 10)
product.change_price(75000).sell(2).add_stock(5).sell(3)
product.display_info()