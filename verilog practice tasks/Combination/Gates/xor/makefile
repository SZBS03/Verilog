
export CORE_ROOT=/mnt/c/Users/Dell/Documents/git/Verilog/Combination/Gates/xor

all: icarus
	gtkwave $(CORE_ROOT)/temp/xor.vcd

icarus: icarus_compile
	vvp $(CORE_ROOT)/temp/xor.output

icarus_compile:
	mkdir -p temp
	iverilog -f flist -o $(CORE_ROOT)/temp/xor.output

clean:
	rm -rf temp

