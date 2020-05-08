restart -nowave -force
add wave -radix unsigned *

# decrypting:
force encrypt 0 0

# ciphertext:
force inBlock64 64'h42C3_7893_FBC2_D912  0

# "Hulk is thalamic" :
force key 128'h4875_6c6b_2069_7320_7468_616c_616d_6963 0


# expected cleartext:  64'h2550_4446_2D31_2E36



force clk 0 0, 1 10 -r 20
force rst 1 0, 0 1

run 600
