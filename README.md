- # **Verilog Practice Dir updated till 2nd Oct 2024** (COMPLETED)
---
  - **Combinational Circuits:**
    - Gates
    - halfadder
    - fulladder
    - concatination
    - multiplexors
    - buffer  
  
  - **Sequential Circuits:**  
      - Counters
      - assignment
      - d-flipflop
      - register-file
  - **Sequential-Combination Circuits**
    - finite state machines
---
- # **Single Cycle Processor Dev Dir updated till 11th Dec 2024** (COMPLETED)
---
  - **DRAM [4x72] :** -> Dram consists of address of `4 depth` and bit size of `72 bits`.
  - **Main :** -> Main consists of: 
    - fetch stage. 
    - ALU. 
    - control decode. 
    - counter. 
    - data memory interface.  
    - main top file. 
    - RAM. 
    - register file. 
    - write back. 
  - **TB :** 
    - main test bench.
  - file.mem
  - flist
  - instruction.txt
  - makefile
---
- # **Five Stage Processor Dev Dir updated till 15th Feb 2025** (COMPLETED)
---
  - **MAIN ->**
    - **fetch stage**
    - **fetch-decode pipeline register**
    - **decode stage**
    - **decode-execute pipeline register**
    - **execute stage**
    - **exec-mem pipeline register**
    - **memory stage**
    - **mem-writeback pipeline register**
    - **writeback stage**
    - **hazard detecion unit** 
       `A hazard detection unit is a control logic block in a pipelined processor that stalls or redirects instructions to prevent data, control, or structural hazards from causing incorrect execution.`
    - **forwarding unit**
      `A forwarding unit (also called a bypass unit) is a control block in a pipelined processor that resolves data hazards by forwarding (reusing) data from later pipeline stages to earlier ones without stalling the pipeline.`
  - **TB :**
    - main test bentch
  - instruction.txt
  - dumpfile.txt
  - flist
  - makefile
---
- # **Riscv Debug Module Dev Dir updated till 12th May 2025** (INCOMPLETE)
  - **DEBUG MODULE**
    **Address Name** 
      0x04    Abstract Data 0 (data0) 
      0x0f    Abstract Data 11 (data11)
      0x10    Debug Module Control (dmcontrol) 
      0x11    Debug Module Status (dmstatus) 
      0x12    Hart Info (hartinfo) 
      0x13    Halt Summary 1 (haltsum1) 
      0x14    Hart Array Window Select (hawindowsel) 
      0x15    Hart Array Window (hawindow) 
      0x16    Abstract Control and Status (abstractcs) 
      0x17    Abstract Command (command) 
      0x18    Abstract Command Autoexec (abstractauto) 
      0x19    Configuration String Pointer 0 (confstrptr0) 
      0x1a    Configuration String Pointer 1 (confstrptr1)
      0x1b    Configuration String Pointer 2 (confstrptr2)
      0x1c    Configuration String Pointer 3 (confstrptr3)
      0x1d    Next Debug Module (nextdm) 
      0x20    Program Buffer 0 (progbuf0) 
      0x2f    Program Buffer 15 (progbuf15)
      0x30    Authentication Data (authdata) 
      0x34    Halt Summary 2 (haltsum2) 
      0x35    Halt Summary 3 (haltsum3) 
      0x37    System Bus Address 127:96 (sbaddress3) 
      0x38    System Bus Access Control and Status (sbcs) 
      0x39    System Bus Address 31:0 (sbaddress0) 
      0x3a    System Bus Address 63:32 (sbaddress1) 
      0x3b    System Bus Address 95:64 (sbaddress2) 
      0x3c    System Bus Data 31:0 (sbdata0) 
      0x3d    System Bus Data 63:32 (sbdata1) 
      0x3e    System Bus Data 95:64 (sbdata2) 
      0x3f    System Bus Data 127:96 (sbdata3) 
      0x40    Halt Summary 0 (haltsum0)
---
  - # **extensions:**  
    - `Verilog-HDL/SystemVerilog/Bluespec SystemVerilog v1.15` 
    - `Makefile Tools v0.10.26.`
    
`src` directory contains `design` files `.v` ext.
`tb` directory contains `test bentch` files, that run on `gtkwave` simmulation file marked with `.vcd` ext.
`temp` contains `output` and `vcd` files.



