source /opt/Xilinx/Vivado/2021.2/settings64.sh

# Project name
PROJECT_NAME=fft_testing

# Part used for synthesis, whilst simulation results should be the same, 
# it's still recommended to use the same part for final product
FPGA_PART=xc7k70tfbv676-1

# Processing Jobs, set to number of CPU threads
THREADS=4

# Output name of VHDL file
OUTPUT_NAME=fft_core

# Sources subdir
V_SRC=Verilog_sources

# Remove any previous tasks performed
rm -r $PROJECT_NAME
mkdir $PROJECT_NAME
cd $PROJECT_NAME

# Find all Verilog files in this directory
VERI_FILES=$(find ../$V_SRC/ -type f -name "*.v")

# Specify any additional files
EXTRA_FILES=$(find ../$V_SRC/ -type f -name "*.hex")

# Specify any testbeds, only for debugging
#TB_FILES=$(find . -type f -name "*_tb.vhd") #add_files -norecurse { $TB_FILES }
#set_property is_global_include true [get_files $EXTRA_FILES ]

# Generate the Vivado TCL commands
echo "
create_project $PROJECT_NAME . -part $FPGA_PART
add_files -norecurse { $VERI_FILES }
add_files -norecurse { $EXTRA_FILES }
update_compile_order -fileset sources_1
launch_runs impl_1 -jobs $THREADS
wait_on_run impl_1
open_run impl_1
write_vhdl -force ../../GHDL/$OUTPUT_NAME.vhd
exit
" >> script.tcl

# Launch vivado (no gui) with new script
vivado -mode batch -source script.tcl
