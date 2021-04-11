module utils

import math

pub fn bytes_to_u32(bytes []byte) u32 {
	mut temp := u32(0)
	for i in 0..bytes.len { 
		temp += u32(bytes[i]) * u32(math.pow(16, i * 2))
	}
	return temp
}

pub fn u32_to_bytes(nb u32) []byte {
	return [byte((nb >> 24) & 0xFF), byte((nb >> 16) & 0xFF), byte((nb >> 8) & 0xFF), byte(nb & 0xFF)]
}
