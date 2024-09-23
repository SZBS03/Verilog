
export CORE_ROOT=/mnt/c/Users/Dell/Documents/git/Verilog/Combination/Gates/or

all: icarus
	gtkwave $(CORE_ROOT)/temp/or.vcd

icarus: icarus_compile
	vvp $(CORE_ROOT)/temp/or.output

icarus_compile:
	mkdir -p temp
	iverilog -f flist -o $(CORE_ROOT)/temp/or.output

clean:
	rm -rf temp

