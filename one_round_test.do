restart -nowave -force
add wave -radix hexadecimal *

# decrypting:
force encrypt 1 0

# sum = delta*32
# force sum 32'hc6ef_3720 0

# 64-bit block - 64'hfd2a_30ed_b5b9_087a
force inBlock64 64'hfd2a_30ed_b5b9_087a 0

# inRed - first chunk
# force inFirst 32'hfbc2_d912 0

#inBlack - second chunk
# force inSecond 32'h42c3_7893 0

# "Hulk is thalamic" :
force key 128'h4875_6c6b_2069_7320_7468_616c_616d_6963 0

# expected after one round - ???

force clk 0 0, 1 10 -r 20
force rst 1 0, 0 1
force ena 1 0

run 600
