export CORE_ROOT = /home/sheikh_zaid/Verilog/single_cycle_dev/verilog_zaid/main

all: icarus
	gtkwave ./temp/main.vcd

icarus: icarus_compile
	vvp $(CORE_ROOT)/temp/main.output

icarus_compile:
	mkdir -p $(CORE_ROOT)/temp
	iverilog -f flist -o $(CORE_ROOT)/temp/main.output
	
clean:
	rm -rf $(CORE_ROOT)/temp
