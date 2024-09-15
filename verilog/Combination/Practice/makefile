export PATH=/home/sheikhzaid/MyTasks/Verilog/Combination/xorGate

all: icarus
	gtkwave $(PATH)/temp/fulladder.vcd

icarus: icarus_compile
	vvp $(PATH)/temp/fulladder.output

icarus_compile:
	mkdir -p temp
	iverilog -f flist -o $(PATH)/temp/fulladder.output

clean:
	rm -rf temp