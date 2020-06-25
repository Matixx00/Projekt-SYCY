restart -nowave -force
add wave -radix hexadecimal *

# let's encrypt:
#force encrypt 1 0

# let's decrypt:
#force encrypt 0 0

# plaintext: "%PDF-1.6"
#force inBlock64 64'h2550_4446_2D31_2E36  0
# expected ciphertext after single round -- outBlock64 :  64'h1682_590A_3746_8B19

# ciphertext:
force inBlock64  64'h8ade_e798_d279_2633   0
#force inBlock64  64'h756972636c677270    0

# "Hulk is thalamic" :
force key 128'h4875_6c6b_2069_7320_7468_616c_616d_6963 0
#force key 128'h7066_6f71_756a_6e62_636a_6762_7366_626d 0


force ena 1 0
force clk 0 0, 1 10 -r 20
force rst 1 0, 0 1

# for single dectryptor test:
#run 1500

# for 8 parallel decryptors:
run 13000
