# Simulating Verilog in GHDL

## Concept

Whilst there is currently no reliable method of accurately converting Verilog to synthesiable and readable VHDL, it is possible to convert an analyzed design in Vivado to a simulation-only VHDL using the unisim library which may be used within GHDL.

This way, simulation may be done in pure VHDL, and bitstream generation may be performed back in Vivado using the original Verilog along with other VHDL files seamlessly together.
___
## Requirements

- Linux (Tested on Debian 11 & Ubuntu 21)
- Vivado 2021.2
- GHDL 2.0+

Packages required:
```
git gnat make zlib1g-dev gcc
```
Packages required for Vivado installer
```
libncurses5 libtinfo5 libncurses5-dev libncursesw5-dev
```
___
## Installing GHDL with Unisim support

Download GHDL sources
```shell
git clone https://github.com/ghdl/ghdl.git
```

Compile and install with
```shell
cd ghdl
mkdir build
cd build
../configure --prefix=/usr/local
make
sudo make install 
```
Next, process Xilinx libraries. This process may take a while (approximately 10 minutes), you may get a couple of errors such as `SCRIPT ERROR: Unfiltered line` but these can be ignored.
```shell
cd /usr/local/lib/ghdl/vendors/
sudo chmod +x *.sh
sudo ./compile-xilinx-vivado.sh --vhdl2008 -a
```
Check if libraries were sucessfully created in the `xilinx-vivado` folder, specifically the `unisim` library which should be present in:
```
/usr/local/lib/ghdl/vendors/xilinx-vivado/unisim/v08/unisim-obj**.cf
```
___
## Converting Verilog to (simulatable) VHDL

Using Vivado, synthesizing a design allows the output to be converted to a unisim dependant VHDL file, this generated VHDL may not be re-synthesized or compiled to a bitstream, and should not be edited, it is only useful for simulation and should be treated as a black box. Everything gets concatonated into 1 large file, the original entity port names/sizes are unchanged and the entity top file declarations are present at the end of the file.

The following steps may be done automatically using the `Veri2GHDL.sh` script, which usage is described afterwards.

1. Create a blank Vivado project, leaving everything at default
2. Import all your Verilog `.v` files into the project, and make sure the top entity is correct, mark this by right-clicking the correct file and choosing **"Set as top"**.
3. Click **"Run Implementation"**, and open when complete.
4. In the **TCL Console** run the command `write_vhdl core.vhd` replacing `core` with whatever you want.

The file will be generated inside Vivado's working directory which is included in the output of the command, note this location and copy the new file into your GHDL source simulations directory.

___
## Using Veri2Ghdl

The whole process above may be automated using the `Veri2Ghdl.sh` script, the BASH script will process all Verilog files in the `Verilog_sources` directory.

The script has a couple customizable variables, which are explained further inside the file.
___
## Running GHDL

In order to reference the newly generated GHDL library, there are 2 methods possible.

1. Reference the library directory using the GHDL parameter `-P/usr/local/lib/ghdl/vendors/xilinx-vivado/unisim/v08/` for **every** command. 
   
2. Copy the `unisim-obj**.cf` file (Found in the directory above) into your working GHDL directory.

Method 1 is better practice, but method 2 results in shorter commands which will be used below.

**NOTE:** Due to the complexity of GHDL, more parameters may be required, such as if the library `std_logic_unsigned` is used, the `-fsynopsys` parameter will be required.

Analyze the main entity first using:

```bash
ghdl -a --std=08 -fsynopsys core.vhd
```
Analyze the testbench
```bash
ghdl -a --std=08 -fsynopsys core_tb.vhd
```
Run the simulation
```
ghdl -r --std=08 -fsynopsys -frelaxed core_tb
```
___