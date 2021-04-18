/* Copyright © 2021 Ivan Vatlin <jenrus@riseup.net>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

module main

import gim
import utils
import os

fn main() {
	input_file := os.open(os.args[1]) or { panic("Can't open file") }
	eof := os.file_size(os.args[1])
	if utils.check_file_signature(input_file.read_bytes_at(8, 0).bytestr()) == 0 {
		mut ftell := u64(16)
		for {
			block := gim.get_block_header(input_file, ftell)
			println(block)
			match block.block_type {
				0x04, 0x05 { println(gim.get_image_header(input_file, ftell + gim.gim_header_length)) }
				else {}
			}
			ftell = block.next_block_location
			if ftell == eof {
				break
			}
		}
	}
}
