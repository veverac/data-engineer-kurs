# for i in range (0,24): 
#     if i >= 6 and i < 12:
#         print (i,' sati jutro')
#     elif i >= 12 and i < 18:
#         print(i,' sati popodne')
#     elif i >= 18 and i < 22:
#         print (i,' sati veče')
#     else:
#         print (i,' sati noć')

for i in range (0,24): 
    if i >= 6 and i < 12:
        print (f'jutro, {i} sati')
    elif i >= 12 and i < 18:
        print(f'popodne, {i} sati')
    elif i >= 18 and i < 22:
        print (f'veče, {i} sati')
    else:
        print (f'noć, {i} sati')

