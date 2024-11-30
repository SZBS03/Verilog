export CORE_ROOT = /home/sheikh_zaid/Verilog/single_cycle_dev/DRAM_4x72

all: icarus
	gtkwave $(CORE_ROOT)/temp/dram.vcd

icarus: icarus_compile
	vvp $(CORE_ROOT)/temp/dram.output

icarus_compile:
	mkdir -p $(CORE_ROOT)/temp
	iverilog -f flist -o $(CORE_ROOT)/temp/dram.output
	
clean:
	rm -rf $(CORE_ROOT)/temp
