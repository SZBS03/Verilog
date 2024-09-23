
export CORE_ROOT=/mnt/c/Users/Dell/Documents/git/Verilog/Combination/Gates/xnor

all: icarus
	gtkwave $(CORE_ROOT)/temp/xnor.vcd

icarus: icarus_compile
	vvp $(CORE_ROOT)/temp/xnor.output

icarus_compile:
	mkdir -p temp
	iverilog -f flist -o $(CORE_ROOT)/temp/xnor.output

clean:
	rm -rf temp

