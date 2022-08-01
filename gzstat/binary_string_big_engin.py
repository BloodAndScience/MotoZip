def binary_string_big_endian(v, num_bits):
    result = ''
    for i in range(num_bits-1,-1,-1):
        bs =v&(1<<i)
        result += '1' if bs != 0 else '0'
    return result;

r = binary_string_big_endian(41, 8);
# 00101001

print(r)

