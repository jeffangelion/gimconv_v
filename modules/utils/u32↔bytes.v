module utils

pub fn bytes_to_u32(bytes []byte) u32 {
	mut temp := u32(0)
	for i in 0 .. bytes.len {
		temp += bytes[i] << (i * 8)
	}
	return temp
}
