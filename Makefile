.PHONY: test
all:
	@mkdir -p ./bin
	v gimconv_v.v -o ./bin/gimconv_v
test:
	v run gimconv_v.v ./test/test_le.gim
