module png

pub const PNG_IEND_CHUNK := [byte(0x00), 0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE, 0x60, 0x82]

pub struct PNGChunk {
	chunk_name string [required]
	chunk_data []byte
}

pub fn ihdr_chunk(width u32, heigth u32, bit_depth byte, color_type byte, interlace_method byte) PNGChunk {
	mut data := []byte{}
	data << u32_to_bytes(width)
	data << u32_to_bytes(heigth)
	data << bit_depth
	data << color_type
	data << byte(0) // Deflate compression method
	data << byte(0) // Filter method
	data << interlace_method
	return PNGChunk {
		chunk_name: "IHDR"
		chunk_data: data
	}
}
