.PHONY: test
all:
	@mkdir -p ./bin
	v . -o ./bin/gimconv_v
test:
	v run . ./test/test_le.gim
