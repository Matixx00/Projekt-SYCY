from ctypes import *

'''
v1 - [31:0] bits
v2 - [63:32] bits
'''
def encrypt(v1, v2, k):
    y = c_uint32(v1)
    z = c_uint32(v2)
    sum = c_uint32(0)
    delta = 0x9e3779b9
    n = 32
    w = [0, 0]

    while n > 0:
        sum.value += delta
        y.value += (z.value << 4) + k[3] ^ z.value + sum.value ^ (z.value >> 5) + k[2]
        z.value += (y.value << 4) + k[1] ^ y.value + sum.value ^ (y.value >> 5) + k[0]
        n -= 1

    w[0] = y.value
    w[1] = z.value
    return w


'''
v1 - [31:0] bits
v2 - [63:32] bits
'''


def decrypt(v1, v2, k):
    y = c_uint32(v1)
    z = c_uint32(v2)
    sum = c_uint32(0xc6ef3720)
    delta = 0x9e3779b9
    n = 32
    w = [0, 0]

    while n > 0:
        print(abs(n - 33), 'f:', hex((y.value << 4) + k[1] ^ y.value + sum.value ^ (y.value >> 5) + k[0]))
        z.value -= (y.value << 4) + k[1] ^ y.value + sum.value ^ (y.value >> 5) + k[0]
        y.value -= (z.value << 4) + k[3] ^ z.value + sum.value ^ (z.value >> 5) + k[2]
        #print(abs(n - 33), "first", hex(y.value))
        #print(abs(n - 33), "second", hex(z.value))
        sum.value -= delta
        n -= 1

    w[0] = y.value
    w[1] = z.value
    return w


def extract_key(key):
    endkey = [0, 0, 0, 0]
    for i in range(0, 4):
        for j in range(0, 4):
            endkey[i] += ord(key[j + (4 * i)]) << 8 * (3 - j)
    return endkey


def read(input, output, key, mode):
    endkey = extract_key(key)
    flag = False
    with open(input, 'rb') as infile:
        with open(output, 'wb') as outfile:
            while True:
                v1 = infile.read(4).hex()
                if v1 != '':
                    v1 = int(v1, 16)
                else:
                    flag = True
                    v1 = 0

                v2 = infile.read(4).hex()
                if v2 != '':
                    v2 = int(v2, 16)
                else:
                    v2 = 0
                if flag:
                    break
                if mode == "encrypt":
                    w = encrypt(v1, v2, endkey)
                elif mode == "decrypt":
                    w = decrypt(v1, v2, endkey)

                outfile.write(w[0].to_bytes(length=4, byteorder='big'))
                outfile.write(w[1].to_bytes(length=4, byteorder='big'))


def break_key(input, wordlist):
    with open(input, 'rb') as infile:
        v1 = int(infile.read(4).hex(), 16)
        v2 = int(infile.read(4).hex(), 16)
        with open(wordlist, 'rb') as list:
            i = int(list.readline())
            while i > 0:
                key = str(list.readline())[2:]
                endkey = extract_key(key)
                w = decrypt(v1, v2, endkey)
                if w[0] == 626017350:
                    return key
                i -= 1


if __name__ == "__main__":
    # =============================================================================================
    # How to use?
    # Świry nie będę po angielsku pisał.
    # Może zacznijmy od kolejnych funkcji:
    # encrypt() - funkcja do szyfrowania wg schematu działania algorytmu TEA
    # przyjmuje: v1 - pierwsze 32 bity, v2 - drugie 32 bity, k - 128 bitowy klucz
    # zwraca tablicę dwuelementową 32 bitowych zaszyfrowanych bloków
    #
    # decrypt() - funkcja do odszyfrowywania wg schematu działania algorytmu TEA
    # podobnie jak w encrypt: v1 - pierwsze 32 bity, v2 - drugie 32 bity, k - 128 bitowy klucz
    # zwraca dwuelementową tablicę 32 bitowych odszyfrowanych bloków
    #
    # extract_key() - funkcja do zamiany klucza w postaci tekstowej do liczbowej
    # przyjmuje klucz w formie tekstu
    # zwraca klucz z pierwszych 16 znaków tekstu w formie 128 bitowej liczby
    #
    # read() - funkcja do odczytywania i zapisywania do pliku
    # input - nazwa pliku z którego chcemy odczytywać dane
    # output - nazwa pliku do którego chcemy zapisywać dane
    # key - klucz w formie tekstu, którym szyfrujemy/odszyfrowujemy
    # mode - przyjmuje "encrypt" - gdy chcemy zaszyfrować lub "decrypt" - aby odszyfrować
    #
    # UWAGA: program ma problem z szyfrowaniem plików ze względu na budowę języka Python,
    # który "obcina" początkowe wartości bloku bitów jeśli są zerami, co przekłada się
    # na błędne szyfrowanie/deszyfrowanie
    # (fukcje encrypt() oraz decrypt() otrzymują <32bity do obliczania)
    # 
    # poniżej znajdują się przykładowe sposoby użycia programu.
    # =============================================================================================

    # read("random_pdf.pdf", "encrypted.pdf", "Hulk is the best", "encrypt")
    # read("encrypted.pdf", "decrypted.pdf", "Hulk is the best", "decrypt")
    # %PDF-1.6 = 0x2550_4446_2d31_2e36
    key = extract_key('Hulk is the best')
    print('key:', hex(key[0]), hex(key[1]), hex(key[2]), hex(key[3]))
    pdf15 = [0x2550_4446, 0x2d31_2e35]
    e = encrypt(pdf15[1], pdf15[0], extract_key('Hulk is the best'))

    # print(hex(e[1]), hex(e[0]))
    # D239B836A0B24FD3
    d = decrypt(0xA0B24FD3, 0xD239B836, extract_key('Hulk is the best'))
    print(hex(d[1]), hex(d[0]))
    # 64-bit block - 64'h42c3_7893_fbc2_d912
    # first = 0xFBC2_D912
    # second = 0x42C3_7893
    # # print(bin(v2))
    # key = extract_key("Hulk is thalamic")
    # print(len(bin(key[0])[2:] + bin(key[1])[2:] + bin(key[2])[2:] + bin(key[3])[2:]))
    # w = encrypt(v1, v2, key)
    # print(bin(w[0]))
    # d = decrypt(second, first, key)
    # print(hex(d[0]), hex(d[1]))

    f = ["cyber_napis.pdf",
         # "wersja1.1_zaszyfrowana.pdf",
         # "wersja1.2_zaszyfrowana(1).pdf",
         # "wersja1.2_zaszyfrowana(2).pdf",
         # "wersja1.3_zaszyfrowana(1).pdf",
         # "wersja1.3_zaszyfrowana(2).pdf",
         # "wersja1.4_zaszyfrowana(1).pdf",
         # "wersja1.4_zaszyfrowana(2).pdf",
         # "wersja1.5_zaszyfrowana(1).pdf",
         # "wersja1.5_zaszyfrowana(2).pdf",
         # "wersja1.6_zaszyfrowana(1).pdf",
         # "wersja1.6_zaszyfrowana(2).pdf",
         # "wersja1.7_zaszyfrowana(1).pdf",
         # "wersja1.7_zaszyfrowana(2).pdf",
         # "wersja1.8_zaszyfrowana(1).pdf",
         # "wersja1.8_zaszyfrowana(2).pdf",
         # "wersja1.9_zaszyfrowana(1).pdf",
         # "wersja1.9_zaszyfrowana(2).pdf"
         ]
    i = len(f)-1
    while i >= 0:
        input = f[i]
        output = "decrypted/(decrypted)" + f[i]
        read(input, output, 'Hulk is the best', "encrypt")
        i -= 1