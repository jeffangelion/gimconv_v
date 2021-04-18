module utils

import math.big

pub fn hexstr_prepend(input big.Number) string { // workaround for prepending '0' if hex digit is odd
	output := input.hexstr()
	return match output.len % 2 {
		1 { "0" + output }
		else { output }
	}
}

pub fn hexstr_prepend_two_bytes(input big.Number) string {
	return match input.int() <= 255 {
		true { "00" + hexstr_prepend(input)}
		else { hexstr_prepend(input) }
	}
}
