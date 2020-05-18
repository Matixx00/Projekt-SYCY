restart -nowave -force
add wave -radix hexadecimal *

# "Hulk is thalamic" :
force key 128'h4875_6c6b_2069_7320_7468_616c_616d_6963 0

# 64-bit block - 64'hfd2a_30ed_b5b9_087a

# inFirst - first chunk
force inFirst 32'hb5b9_087a 0

# inSecond - second chunk
force inSecond 32'hfd2a_30ed 0

# sum = delta*32
force sum 32'hc6ef_3720 0

# decrypting:
force encrypt 0 0

force clk 0 0, 1 10 -r 20

run 600