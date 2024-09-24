export CORE_ROOT=/home/sheikhzaid/MyTasks/Verilog/Sequential/d-flipflop

all: icarus
	gtkwave $(CORE_ROOT)/temp/d_ff.vcd

icarus: icarus_compile
	vvp $(CORE_ROOT)/temp/d_ff.output

icarus_compile:
	mkdir -p temp
	iverilog -f flist -o $(CORE_ROOT)/temp/d_ff.output

clean:
	rm -rf temp
	