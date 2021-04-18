module utils

import math.big
/*
BGR565 bit structure:
xxxxx xxxxxx xxxxx
 BLUE  GREEN  RED
*/

pub fn bgr565_to_rgb888(input big.Number) (big.Number, big.Number, big.Number) {
	// https://stackoverflow.com/a/9069480
	red := big.from_int(((input.int() & 0x1f) * 527 + 23) >> 6)
	green := big.from_int(((input.int() & 0x7e0 >> 5) * 259 + 33) >> 6)
	blue := big.from_int(((input.int() & 0xf800 >> 11) * 527 + 23) >> 6)
	return red, green, blue
}

pub fn rgb888_to_bgr565(red big.Number, green big.Number, blue big.Number) big.Number {
	// https://stackoverflow.com/a/9069480
	b := (blue.int() * 249 + 1014) >> 11
	g := (green.int() * 253 + 505) >> 10
	r := (red.int() * 249 + 1014) >> 11
	bgr := (b << 11) + (g << 5) + r
	return big.from_int(bgr)
}
