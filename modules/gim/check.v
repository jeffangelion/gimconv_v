module gim

pub fn check_file_signature(signature string) int {
	png := [byte(0x89), 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A].bytestr()
	return match signature {
		"MIG.00.1" { 0 } // GIM little endian (PSP)
		".GIM1.00" { 1 } // GIM big endian (PS3)
		png { 2 } // PNG
		else { -1 }
	}
}
