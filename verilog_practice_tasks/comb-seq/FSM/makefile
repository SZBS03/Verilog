export CORE_ROOT = /home/sheikhzaid/Verilog/verilog_practice_tasks/comb-seq/FSM

all: icarus
	gtkwave $(CORE_ROOT)/temp/fsm.vcd

icarus: icarus_compile
	vvp $(CORE_ROOT)/temp/fsm.output

icarus_compile:
	mkdir -p $(CORE_ROOT)/temp
	iverilog -f flist -o $(CORE_ROOT)/temp/fsm.output
	
clean:
	rm -rf $(CORE_ROOT)/temp
