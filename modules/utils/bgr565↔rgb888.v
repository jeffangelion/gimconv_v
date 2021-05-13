module utils

import henrixounez.vpng

pub fn bgr565_to_rgb888(input int) vpng.Pixel {
	// https://stackoverflow.com/a/9069480
	red := ((input & 0x1f) * 527 + 23) >> 6
	green := ((input & 0x7e0 >> 5) * 259 + 33) >> 6
	blue := ((input & 0xf800 >> 11) * 527 + 23) >> 6
	return vpng.Pixel(vpng.TrueColor {
		byte(red),
		byte(green),
		byte(blue)
	})
}

pub fn rgb888_to_bgr565(red byte, green byte, blue byte) int {
	// https://stackoverflow.com/a/9069480
	b := (blue * 249 + 1014) >> 11
	g := (green * 253 + 505) >> 10
	r := (red * 249 + 1014) >> 11
	bgr := (b << 11) + (g << 5) + r
	return bgr
}
