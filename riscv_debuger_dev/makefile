CORE_ROOT := 'C:\Users\Hp\OneDrive - Higher Education Commission\ASSIGNMENT\merl\Verilog-main\Verilog-main' 

all: icarus
	gtkwave .\temp\main_dm.vcd

icarus: icarus_compile
	vvp .\temp\main.output

icarus_compile:
	if not exist "$(CORE_ROOT)\temp" mkdir "$(CORE_ROOT)\temp"
	iverilog -f flist -o "$(CORE_ROOT)\temp\main_dm.output"

clean:
	if exist "$(CORE_ROOT)\temp" rd /s /q "$(CORE_ROOT)\temp"
