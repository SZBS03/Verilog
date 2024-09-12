
export CORE_ROOT=/home/sheikhzaid/MyTasks/Verilog/MUXcondBystatements

all: icarus
	gtkwave $(CORE_ROOT)/temp/MuxIFELSE.vcd
icarus: icarus_compile
	vvp $(CORE_ROOT)/temp/MuxIFELSE.output

icarus_compile:
	mkdir -p temp
	iverilog -f flist -o $(CORE_ROOT)/temp/MuxIFELSE.output

clean:
	rm -rf temp

