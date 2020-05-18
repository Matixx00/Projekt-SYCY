restart -nowave -force
add wave -radix hexadecimal *

# k3 = 32'h4875_6c6b
force inKeyR 32'h4875_6c6b 0

# k2 = 32'h2069_7320
force inKeyL 32'h2069_7320 0

# sum = delta*32
force sum 32'hc6ef_3720 0

# first 32 bit chunk
force chunk32 32'hd2792633 0

run 600