import sys


def encrypt(v1, v2, k):
    y = v1
    z = v2
    sum = 0
    delta = 0x9e3779b9
    n = 32
    w = [0, 0]

    while n > 0:
        sum += delta
        y += (z << 4) + k[0] ^ z + sum ^ (z >> 5) + k[1]
        z += (y << 4) + k[2] ^ y + sum ^ (y >> 5) + k[3]
        n -= 1

    w[0] = y
    w[1] = z
    return w


def decrypt(v1, v2, k):
    y = v1
    z = v2
    sum = 0xc6ef3720
    delta = 0x9e3779b9
    n = 32
    w = [0, 0]

    while n > 0:
        z -= (y << 4) + k[2] ^ y + sum ^ (y >> 5) + k[3]
        y -= (z << 4) + k[0] ^ z + sum ^ (z >> 5) + k[1]
        sum -= delta
        n -= 1

    w[0] = y
    w[1] = z
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
                v1 = infile.read(32).hex()
                if v1 != '':
                    v1 = int(v1, 16)
                else:
                    flag = True
                    v1 = 0

                v2 = infile.read(32).hex()
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
    # read("random_pdf.pdf", "encrypted.pdf", "hulk is the best", "encrypt")
    read("encrypted.pdf", "decrypted.pdf", "hulk is the best", "decrypt")
