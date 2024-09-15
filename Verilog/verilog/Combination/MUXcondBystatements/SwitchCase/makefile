
export CORE_ROOT=/home/sheikhzaid/MyTasks/Verilog/MUXcondBystatements/SwitchCase

all: icarus

icarus: icarus_compile
	vvp $(CORE_ROOT)/temp/MuxSwitch.output

icarus_compile:
	mkdir -p temp
	iverilog -f flist -o $(CORE_ROOT)/temp/MuxSwitch.output

clean:
	rm -rf temp

	