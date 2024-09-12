
export CORE_ROOT=/home/sheikhzaid/MyTasks/Verilog/half_adder

all: icarus
	gtkwave $(CORE_ROOT)/temp/halfadder.vcd

icarus: icarus_compile
	vvp $(CORE_ROOT)/temp/halfadder.output

icarus_compile:
	mkdir -p temp
	iverilog -f flist -o $(CORE_ROOT)/temp/halfadder.output

clean:
	rm -rf temp


