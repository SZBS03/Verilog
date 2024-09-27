export CORE_ROOT = /home/sheikhzaid/Verilog/verilog_practice_tasks/Sequential/register_file

all: icarus
	gtkwave $(CORE_ROOT)/temp/register.vcd

icarus: icarus_compile
	vvp $(CORE_ROOT)/temp/register.output

icarus_compile:
	mkdir -p $(CORE_ROOT)/temp
	iverilog -f flist -o $(CORE_ROOT)/temp/register.output
	
clean:
	rm -rf $(CORE_ROOT)/temp
