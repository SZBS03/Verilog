export CORE_ROOT=/home/sheikhzaid/MyTasks/Verilog/Sequential/register file

all: icarus
	gtkwave $(CORE_ROOT)/temp/register.vcd

icarus: icarus_compile
	vvp $(CORE_ROOT)/temp/register.output

icarus_compile:
	mkdir -p temp
	iverilog -f flist -o $(CORE_ROOT)/temp/register.output

clean:
	rm -rf temp
	
