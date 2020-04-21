

def encipher(v, key):
    y = ord(v[0]) + ord(v[1]) + ord(v[2]) + ord(v[3])
    z = ord(v[4]) + ord(v[5]) + ord(v[6]) + ord(v[7])
    k = []
    k.extend([
        ord(key[0]) + ord(key[1]) + ord(key[2]) + ord(key[3]),
        ord(key[4]) + ord(key[5]) + ord(key[6]) + ord(key[7]),
        ord(key[8]) + ord(key[9]) + ord(key[10]) + ord(key[11]),
        ord(key[12]) + ord(key[13]) + ord(key[14]) + ord(key[15])
    ])
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


def decipher(v, key):
    y = v[0]
    z = v[1]
    k = []
    k.extend([
        ord(key[0]) + ord(key[1]) + ord(key[2]) + ord(key[3]),
        ord(key[4]) + ord(key[5]) + ord(key[6]) + ord(key[7]),
        ord(key[8]) + ord(key[9]) + ord(key[10]) + ord(key[11]),
        ord(key[12]) + ord(key[13]) + ord(key[14]) + ord(key[15])
    ])
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


if __name__ == "__main__":
    key = "hulk is the awesom"
    text = "Agnieszk"
    encrypted = encipher(text, key)
    print(encrypted)

    decrypted = decipher(encrypted, key)

    print(decrypted)
