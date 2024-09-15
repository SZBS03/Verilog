
export CORE_ROOT=/home/sheikhzaid/MyTasks/Verilog/full_adder/with_mkfile

all: icarus
	gtkwave $(CORE_ROOT)/temp/fulladder.vcd

icarus: icarus_compile
	vvp $(CORE_ROOT)/temp/fulladder.output

icarus_compile:
	mkdir -p temp
	iverilog -f flist -o $(CORE_ROOT)/temp/fulladder.output

clean:
	rm -rf temp

