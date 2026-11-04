# Napisati program kojim se prevodi temperatura iz Celzijusove skale u Farenhajtovu skalu,
# ako je odgovarajuća formula oblika T[F] = T[C] * 1:80 + 32. Na ulazu se unosi vrednost
# temperature u stepenima Celzijusa (realan broj) a ispisuje se vrednost temperature u stepenima
# Farenhajta.

def faranhajt (temperatura):
    konverzija = temperatura * 1.80 + 32
    return konverzija
temperatura = 22
konverzija = faranhajt (temperatura)  
print (f' Za zadatu temperaturu od {temperatura} °C, odgovarajuća temperatura je {konverzija} °F.')


# Napisati program koji za uneti redni broj dana u nedelji (od 1 do 7) ispisuje naziv tog
# dana (ponedeljak - nedelja). Ukoliko je unet broj koji nije između 1 i 7, ispisati Pogresan
# unos.

# def dan_u_nedelji (broj):
#     if broj < 1 or broj > 7:
#         return "Pogrešan unos"
#     if broj == 1:
#         return 'Ponedeljak'
#     elif broj == 2:
#         return 'Utorak'
#     elif broj == 3:
#         return 'Sreda'
#     elif broj == 4:
#         return 'Četvrtak'
#     elif broj == 5:
#         return 'Petak'
#     elif broj == 6:
#         return 'Subota'
#     elif broj == 7:
#         return 'Nedelja'
# print (dan_u_nedelji (8))


dani = ['Ponedeljak', 'Utorak', 'Sreda', 'Četvrtak', 'Petak', 'Subota', 'Nedelja']
def dan_u_nedelji (broj):
    if broj < 1 or broj > 7:
        return 'Pogrešan unos'
    else:
        return dani[broj-1]
print (dan_u_nedelji(7))


# Napisati program koji računa najveći negativni element u listi.

lista = [7, -8, -1, -4, 60, 150, 33, -2]
i = None
for a in lista:
        if a < 0 and i == None:
            i = a
        elif (i is None or a > i) and a < 0:
            i = a
print (f'Najveći negativni element u listi je {i}.') 

           

# Napisati program koji računa broj parnih elemenata date liste.

lista = [7, -8, -10, -4, 60, 150, 33, -2, 3, 7, 14, 18, 21]
i= 0
for a in lista:
    if a % 2 == 0:
        i = i + 1 
print (f'Broj parnih elemenata liste je {i}.')


# Napisati program koji računa sume elemenata liste celih brojeva koji su deljivi sa 2 odnosno
# sa 3.

lista = [7, -8, -10, -4, 60, 150, 33, -2, 3, 7, 14, 18, 21]
i=0  
t=0
for a in lista:
        if a % 2 == 0:
            i = i + a
        if a % 3 == 0:
            t = t + a 
print (f'Suma brojeva deljivih sa 2 je {i} a suma brojeva deljivih sa 3 je {t}.')

