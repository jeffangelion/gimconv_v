.PHONY: test

V_COMPILER ::= $(shell which v)

all:
	@mkdir -p ./bin
	$(V_COMPILER) gimconv_v.v -o ./bin/gimconv_v

test:
	$(V_COMPILER) run gimconv_v.v ./test/test_le.gim ./test/palette.png

run: test

clean:
	rm -rf bin/
