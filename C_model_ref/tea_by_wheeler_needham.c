# include <stdio.h>
# include <stdint.h>


void encrypt (uint32_t v[2], uint32_t k[4]) {
// modified by SYCYproj_3
    uint32_t    v0=v[0],
                v1=v[1],
                sum=0,
                delta=0x9E3779B9;

    for (int i=0; i<32; i++) {
        sum += delta;
        v0 += ((v1<<4) + k[0]) ^ (v1 + sum) ^ ((v1>>5) + k[1]);
        v1 += ((v0<<4) + k[2]) ^ (v0 + sum) ^ ((v0>>5) + k[3]);
    }
    
    v[0]=v0;
    v[1]=v1;
    
}


void decrypt (uint32_t v[2], uint32_t k[4]) {
// modified by SYCYproj_3    
    uint32_t    v0=v[0],
                v1=v[1],
                sum=0xC6EF3720,
                delta=0x9E3779B9;

    for (int i=0; i<32; i++) {
        v1 -= ((v0<<4) + k[2]) ^ (v0 + sum) ^ ((v0>>5) + k[3]);
        v0 -= ((v1<<4) + k[0]) ^ (v1 + sum) ^ ((v1>>5) + k[1]);
        sum -= delta;
    }
    
    v[0]=v0;
    v[1]=v1;
    
}



int main (int argc, char* argv[]) {
// authored by SYCYproj_3
//    printf("int: %d\tlong: %d\n", sizeof(int), sizeof(long));

    // "%PDF-1.6" : hex: 2550_4446_2D31_2E36
    // on little-endian x86-64 machine:
                            // 0        // 1
    uint32_t dataIn[2] = {0x2D312E36, 0x25504446};
    
    // "Hulk is thalamic" : hex: 4875_6c6b_2069_7320_7468_616c_616d_6963
    // on little-endian x86-64 machine:
                        // 0        // 1        // 2        // 3
    uint32_t key[4] = {0x616d6963, 0x7468616c, 0x20697320, 0x48756c6b};
    
    printf("TEA reference model for SYCYProj_3. From original TEA implementation by Wheeler and Needham.\n");
    printf("plaintext:\tv[0]: %lx\tv[1]: %lx\n", dataIn[0], dataIn[1]);
    
    encrypt(dataIn, key);
    printf("cyphertext:\tv[0]: %lx\tv[1]: %lx\n", dataIn[0], dataIn[1]);
    
    decrypt(dataIn, key);
    printf("After decryption:\nplaintext:\tv[0]: %lx\tv[1]: %lx\n", dataIn[0], dataIn[1]);


    return 0;

}
