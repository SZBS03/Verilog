
export CORE_ROOT=/mnt/c/Users/Dell/Documents/git/Verilog/Combination/Gates/and

all: icarus
	gtkwave $(CORE_ROOT)/temp/and.vcd

icarus: icarus_compile
	vvp $(CORE_ROOT)/temp/and.output

icarus_compile:
	mkdir -p temp
	iverilog -f flist -o $(CORE_ROOT)/temp/and.output

clean:
	rm -rf temp

