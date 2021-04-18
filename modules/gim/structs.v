module gim
import os
import utils

pub const gim_header_length = 16

pub struct GIMBlockHeader {
	pub:
	block_type u16 [required]
	// block_unknown u16 // Unused field?
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
	return "Block: $block_type_string, size: $b.block_size, next block at $b.next_block_location, data at $b.data_block_location"
}

pub fn get_block_header(f os.File, offset u64) GIMBlockHeader {
	return GIMBlockHeader {
		u16(utils.bytes_to_u32(f.read_bytes_at(2, offset)))
		// Skip 2 bytes
		utils.bytes_to_u32(f.read_bytes_at(4, offset + 4))
		utils.bytes_to_u32(f.read_bytes_at(4, offset + 8)) + u32(offset)
		utils.bytes_to_u32(f.read_bytes_at(4, offset + 12)) + u32(offset)
	}
}

pub struct GIMImageHeader {
	pub:
	block_data_length u16 [required]
	// block_unknown u16 // Unused field?
	image_format u16 [required]
	pixel_order u16 [required]
	width u16 [required]
	height u16 [required]
	bpp_align u16 [required]
	pitch_align u16 [required]
	height_align u16 [required]
	// block_unknown_2 u16 [required]
	// block_unknown_3 u32 [required]
	index_start u32 [required]
	pixels_start u32 [required]
	pixels_end u32 [required]
	plane_mask u32 [required]
	level_type u16 [required]
	level_count u16 [required]
	frame_type u16 [required]
	frame_count u16 [required]
	frame_n_offset u32 [required]
	// frame_n_offset_padding []byte // mod 16
}

pub fn (i GIMImageHeader) str() string {
	image_format_string := match i.image_format {
		0x00 { "rgba5650" } // (16 bit no alpha)
		0x01 { "rgba5551" } // (16 bit sharp alpha)
		0x02 { "rgba4444" } // (16 bit gradient alpha)
		0x03 { "rgba8888" } // (32 bit gradient alpha)
		0x04 { "index4" }   // (16 colors)
		0x05 { "index8" }   // (256 colors)
		0x06 { "index16" }  // (16 colors with alpha ?)
		0x07 { "index32" }  // (256 colors with alpha ?)
		0x08 { "dxt1" }
		0x09 { "dxt3" }
		0x0A { "dxt5" }
		0x108 { "dxt1ext" }
		0x109 { "dxt3ext" }
		0x10A { "dxt5ext" }
		else { "UNKNOWN" }
	}
	pixel_order_string := match i.pixel_order {
		0x00 { "normal" }
		0x01 { "faster" } // PSPIMAGE
		else { "UNKNOWN" }
	}
	level_type_string := match i.level_type {
		0x01 { "picture" }
		0x02 { "palette" }
		else { "UNKNOWN" }
	}
	return "Image: type: $level_type_string; " +
	"format: $image_format_string; " +
	"pixel order: $pixel_order_string; " +
	"size: $i.width" + "x" + "$i.height pixels"
}

pub fn get_image_header(f os.File, offset u64) GIMImageHeader {
	return GIMImageHeader {
		u16(utils.bytes_to_u32(f.read_bytes_at(2, offset)))      // header length
		// skip 2 bytes
		u16(utils.bytes_to_u32(f.read_bytes_at(2, offset + 4)))  // image format
		u16(utils.bytes_to_u32(f.read_bytes_at(2, offset + 6)))  // ?pixel order?
		u16(utils.bytes_to_u32(f.read_bytes_at(2, offset + 8)))  // image width
		u16(utils.bytes_to_u32(f.read_bytes_at(2, offset + 10))) // image height
		u16(utils.bytes_to_u32(f.read_bytes_at(2, offset + 12))) // ?BPP align?
		u16(utils.bytes_to_u32(f.read_bytes_at(2, offset + 14))) // ?pitch align?
		u16(utils.bytes_to_u32(f.read_bytes_at(2, offset + 16))) // ?height align?
		// skip 6 bytes
		utils.bytes_to_u32(f.read_bytes_at(4, offset + 24))      // index relative start offset
		utils.bytes_to_u32(f.read_bytes_at(4, offset + 28))      // first frame relative start offset
		utils.bytes_to_u32(f.read_bytes_at(4, offset + 32))      // last frame relative end offset
		utils.bytes_to_u32(f.read_bytes_at(4, offset + 36))      // ?alpha mask color?
		u16(utils.bytes_to_u32(f.read_bytes_at(2, offset + 40))) // picture (`0x01`) / palette (`0x02`)
		u16(utils.bytes_to_u32(f.read_bytes_at(2, offset + 42))) // number of mipmaps
		u16(utils.bytes_to_u32(f.read_bytes_at(2, offset + 44))) // frame type (only `0x03` so far)
		u16(utils.bytes_to_u32(f.read_bytes_at(2, offset + 46))) // number of frames
		utils.bytes_to_u32(f.read_bytes_at(4, offset + 48))      // frame offset
	}
}
