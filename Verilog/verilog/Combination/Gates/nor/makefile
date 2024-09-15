
export CORE_ROOT=/mnt/c/Users/Dell/Documents/git/Verilog/Combination/Gates/nor

all: icarus
	gtkwave $(CORE_ROOT)/temp/nor.vcd

icarus: icarus_compile
	vvp $(CORE_ROOT)/temp/nor.output

icarus_compile:
	mkdir -p temp
	iverilog -f flist -o $(CORE_ROOT)/temp/nor.output

clean:
	rm -rf temp

