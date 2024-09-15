
export CORE_ROOT=/mnt/c/Users/Dell/Documents/git/Verilog/Combination/MUXcondBystatements/Ternary

all: icarus
	gtkwave $(CORE_ROOT)/temp/MuxTernary.vcd
icarus: icarus_compile
	vvp $(CORE_ROOT)/temp/MuxTernary.output

icarus_compile:
	mkdir -p temp
	iverilog -f flist -o $(CORE_ROOT)/temp/MuxTernary.output

clean:
	rm -rf temp

