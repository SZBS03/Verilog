export CORE_ROOT=/home/sheikhzaid/Verilog/verilog_practice_tasks/Combination/register

all: icarus
	gtkwave $(CORE_ROOT)/temp/reg.vcd

icarus: icarus_compile
	vvp $(CORE_ROOT)/temp/reg.output

icarus_compile:
	mkdir -p temp
	iverilog -f flist -o $(CORE_ROOT)/temp/reg.output

clean:
	rm -rf temp
	
