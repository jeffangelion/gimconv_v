module gim

pub struct GIMBlockHeader {
	block_type u16 [required]
	block_header_unknown u16 // Unused field?
	block_size u32 [required]
	next_block_location u32 [required]
	data_block_location u32 [required]
}

pub fn (b GIMBlockHeader) str() string {
	block_type_string := match b.block_type {
		0x02 { "root" }
		0x03 { "picture" }
		0x04 { "image" }
		0x05 { "palette" }
		0xff { "fileinfo" }
		else { "UNKNOWN" }
	}
	return "Type: $block_type_string, size: $b.block_size, next block at $b.next_block_location, data at $b.data_block_location"
}

fn gim_image_format(i int) string {
	return match i {
	0x00 { "rgba5650" } // (16 bit no alpha)
	0x01 { "rgba5551" } // (16 bit sharp alpha)
	0x02 { "rgba4444" } // (16 bit gradient alpha)
	0x03 { "rgba8888" } // (32 bit gradient alpha)
	0x04 { "index4" }   // (16 colors)
	0x05 { "index8" }   // (256 colors)
	0x06 { "index16" }  // (16 colors with alpha ?)
	0x07 { "index32" }  // (256 colors with alpha ?)
	0x08 { "dxt1" }     // (no alpha)
	0x09 { "dxt3" }     // (sharp alpha)
	0x0A { "dxt5" }     // (gradient alpha)
	0x108 { "dxt1ext" }
	0x109 { "dxt3ext" }
	0x10A { "dxt5ext" }
	else { "UNKNOWN" }
	}
}
