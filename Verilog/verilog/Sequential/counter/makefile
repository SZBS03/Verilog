export CORE_ROOT=/home/sheikhzaid/MyTasks/Verilog/Sequential/counter

all: icarus
	gtkwave $(CORE_ROOT)/temp/counter.vcd

icarus: icarus_compile
	vvp $(CORE_ROOT)/temp/counter.output

icarus_compile:
	mkdir -p temp
	iverilog -f flist -o $(CORE_ROOT)/temp/counter.output

clean:
	rm -rf temp
	