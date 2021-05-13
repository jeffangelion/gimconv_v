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

import henrixounez.vpng
import os
import gim
import utils

fn pixel(red byte, green byte, blue byte) vpng.Pixel {
	return vpng.Pixel(vpng.TrueColor {
		red,
		green,
		blue
	})
}

fn main() {
	if os.args.len != 3{
		println('Usage: $os.args[0] input_gim_file output_png_palette')
		return
	}
	palette_ihdr := vpng.IHDR {
		16, // Width
		16, // Height
		8,  // 8-bit color depth
		2,  // Color used
		0,  // Deflate
		0,  // Filter method
		0   // No interlace
	}
	mut palette := vpng.PngFile {
		palette_ihdr,
		16,
		16,
		vpng.PixelType.truecolor,
		[]vpng.Pixel{len: 256, init: pixel(0, 0, 0)}
	}
	input_gim_file := os.open(os.args[1]) or { panic("Can't open file") }
	eof := os.file_size(os.args[1])
	if utils.check_file_signature(input_gim_file.read_bytes_at(8, 0).bytestr()) == 0 {
		mut ftell := u64(16)
		for {
			block := gim.get_block_header(input_gim_file, ftell)
			match block.block_type {
				0x05 {
					for i in 0 .. 256 {
						bgr := int(utils.bytes_to_u32(input_gim_file.read_bytes_at(2, ftell + 0x50 + u64(i * 2))))
						palette.pixels[i] = utils.bgr565_to_rgb888(bgr)
					}
				}
				else {}
			}
			ftell = block.next_block_location
			if ftell == eof {
				break
			}
		}
	}
	palette.write(os.args[2])
}
