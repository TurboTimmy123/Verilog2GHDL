#!/bin/bash
rm *.cf
rm *.tmp
rm *.o
rm *.lst

# Copy unisim library to working dir
cp /usr/local/lib/ghdl/vendors/xilinx-vivado/unisim/v08/unisim-obj08.cf .

#create work*.cf files
echo "Analyzing Core"
ghdl -a --std=08 -fsynopsys fft_core.vhd

echo "Analyzing Testbench"
ghdl -a --std=08 -fsynopsys fftmain_tb.vhd

echo "Running simulation"
ghdl -r --std=08 -fsynopsys -frelaxed fftmain_tb

#testing, ignore
#ghdl -r --std=08 --syn-binding out_tb
#ghdl -e --std=08 --syn-binding out_tb
#ghdl -m --syn-binding FILE
#ghdl -m -g --std=08 -Punisim --warn-unused -frelaxed --ieee=synopsys FILE
#ghdl -m -g --std=08 --syn-binding -frelaxed -fsynopsys FILE --gen-makefile -v
