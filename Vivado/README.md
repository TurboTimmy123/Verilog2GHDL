# Veri2Unisim

Veri2Unisim is a bash script for automating the process of converting a Verilog file to a VHDL with unisim for GHDL simulation.



```
Usage: [OPTION=]...
Example: ./Veri2GHDL.sh -p=demo -s=./src -out=test -t=4

  -p=, --projname=    Vivado project name
  -s=, --searchpath=  Verilog or other source directory
  -p=, --fpgapart=    Name of FPGA part to used for synthesis
  -o=, --out=         Name out output VHDL file
  -t=, --threads=     Threads for Vivado to use
  -h, --help          Display this help screen

All parameters are optional except for searchpath
```

___

# fftgen-vhdl

Utilizing a Verilog FFT generator and Veri2GHDL, this is a simple script that creates both Verilog and VHDL FFT cores, parameters are forwarded to `fftgen` and usage is the same.

Example, create a FFT core:

```
./fftgen-vhdl.sh 
```

### Acknowledgment

https://github.com/ZipCPU/dblclockfft

Licensed under `LGPLv3`