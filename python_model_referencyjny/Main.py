from ctypes import *


def encrypt(v1, v2, k):
    y = c_uint32(v1)
    z = c_uint32(v2)
    sum = c_uint32(0)
    delta = 0x9e3779b9
    n = 32
    w = [0, 0]

    while n > 0:
        sum.value += delta
        y.value += (z.value << 4) + k[0] ^ z.value + sum.value ^ (z.value >> 5) + k[1]
        z.value += (y.value << 4) + k[2] ^ y.value + sum.value ^ (y.value >> 5) + k[3]
        n -= 1

    w[0] = y.value
    w[1] = z.value
    return w


def decrypt(v1, v2, k):
    y = c_uint32(v1)
    z = c_uint32(v2)
    sum = c_uint32(0xc6ef3720)
    delta = 0x9e3779b9
    n = 32
    w = [0, 0]

    while n > 0:
        z.value -= (y.value << 4) + k[2] ^ y.value + sum.value ^ (y.value >> 5) + k[3]
        y.value -= (z.value << 4) + k[0] ^ z.value + sum.value ^ (z.value >> 5) + k[1]
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

                outfile.write(w[0].to_bytes(length=int(w[0].bit_length() / 8) + 1, byteorder='big'))
                outfile.write(w[1].to_bytes(length=int(w[1].bit_length() / 8) + 1, byteorder='big'))


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

    read("random_pdf.pdf", "encrypted.pdf", "hulk is the best", "encrypt")
    # read("encrypted.pdf", "decrypted.pdf", "hulk is the best", "decrypt")

    # v1 = 13854825223
    # v2 = 6398764994
    # print(bin(v2))
    # key = extract_key("hulk is the best")
    # w = encrypt(v1, v2, key)
    # print(bin(w[0]))
    # d = decrypt(w[0], w[1], key)
    # print(d)
