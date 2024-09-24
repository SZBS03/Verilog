
export CORE_ROOT=/home/sheikhzaid/Verilog/verilog_practice_tasks/Combination/alu

all: icarus
	gtkwave $(CORE_ROOT)/temp/alu.vcd

icarus: icarus_compile
	vvp $(CORE_ROOT)/temp/alu.output

icarus_compile:
	mkdir -p temp
	iverilog -f flist -o $(CORE_ROOT)/temp/alu.output

clean:
	rm -rf temp

	