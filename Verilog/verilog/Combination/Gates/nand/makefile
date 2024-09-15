
export CORE_ROOT=/mnt/c/Users/Dell/Documents/git/Verilog/Combination/Gates/nand

all: icarus
	gtkwave $(CORE_ROOT)/temp/nand.vcd

icarus: icarus_compile
	vvp $(CORE_ROOT)/temp/nand.output

icarus_compile:
	mkdir -p temp
	iverilog -f flist -o $(CORE_ROOT)/temp/nand.output

clean:
	rm -rf temp

