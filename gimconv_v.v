module main

import gim
import utils
import os

fn main() {
	input_file := os.open(os.args[1]) or { panic("Can't open file") }
	println(gim.check_file_signature(input_file.read_bytes_at(8, 0).bytestr()))
	if gim.check_file_signature(input_file.read_bytes_at(8, 0).bytestr()) != -1 {
		mut ftell := u64(0)
		for i := 0; i < 3; i++ {
			ftell += 16
			block := gim.GIMBlockHeader{
				u16(utils.bytes_to_u32(input_file.read_bytes_at(2, ftell)))
				u16(utils.bytes_to_u32(input_file.read_bytes_at(2, ftell + 2)))
				utils.bytes_to_u32(input_file.read_bytes_at(4, ftell + 4))
				utils.bytes_to_u32(input_file.read_bytes_at(4, ftell + 8)) + u32(ftell)
				utils.bytes_to_u32(input_file.read_bytes_at(4, ftell + 12)) + u32(ftell)
			}
			println(block)
		}
		
	}
}
