import os
import math.big
import utils

// Example code for BGR565 -> RGB888 conversion

fn main() {
	input := big.from_hex_string(os.args[1])
	r, g, b := utils.bgr565_to_rgb888(input)
	println("RGB888: " + utils.hexstr_prepend(r) + utils.hexstr_prepend(g) + utils.hexstr_prepend(b))
	bgr := utils.rgb888_to_bgr565(r, g, b)
	println("BGR565: " + utils.hexstr_prepend_two_bytes(bgr))
}
