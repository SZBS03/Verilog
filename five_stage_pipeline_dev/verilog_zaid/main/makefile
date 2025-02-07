CORE_ROOT := C:\git\Verilog\five_stage_pipeline_dev\verilog_zaid\main

all: icarus
	gtkwave .\temp\main.vcd

icarus: icarus_compile
	vvp .\temp\main.output

icarus_compile:
	if not exist "$(CORE_ROOT)\temp" mkdir "$(CORE_ROOT)\temp"
	iverilog -f flist -o "$(CORE_ROOT)\temp\main.output"

clean:
	if exist "$(CORE_ROOT)\temp" rd /s /q "$(CORE_ROOT)\temp"
