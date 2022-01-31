source /opt/Xilinx/Vivado/2021.2/settings64.sh

HELP_STRING="Usage: [OPTION=]...\n\n
Example: ./Veri2Unisim.sh -p=demo -s=./src -out=test -t=4\n
\n
  -p=, --projname=    Vivado project name\n
  -s=, --searchpath=  Verilog or other source directory\n
  -p=, --fpgapart=    Name of FPGA part to used for synthesis\n
  -o=, --out=         Name out output VHDL file\n
  -t=, --threads=     Threads for Vivado to use\n
  -h, --help          Display this help screen\n
\n
All parameters are optional except for searchpath\n"

# Defaults
# Project name
PROJECT_NAME="Untitled"

# Part used for synthesis, whilst simulation results should be the same, 
# it's still recommended to use the same part for final product
FPGA_PART=xc7k70tfbv676-1

# Processing Jobs, set to number of CPU threads
THREADS=4

# Output name of VHDL file
OUTPUT_NAME=core

# Sourch files
# Blank sets to working dir (not recommended)
# SOURCE_DIR=


# Credit: 
# https://stackoverflow.com/questions/192249/how-do-i-parse-command-line-arguments-in-bash
for i in "$@"; do
  case $i in
    -p=*|--projname=*)
      PROJECT_NAME="${i#*=}"
      shift # past argument=value
      ;;

    -s=*|--searchpath=*)
      SOURCE_DIR="${i#*=}"
      shift
      ;;

    -p=*|--fpgapart=*)
      FPGA_PART="${i#*=}"
      shift
      ;;

    -o=*|--out=*)
      OUTPUT_NAME="${i#*=}"
      shift
      ;;

    -t=*|--threads=*)
      THREADS="${i#*=}"
      shift
      ;;      

    -h|--help)
      echo -e $HELP_STRING
      exit 0
      ;;

    -*|--*)
      echo "Unknown option $i"
      echo
      echo -e $HELP_STRING
      exit 1
      ;;
    *)
      ;;
  esac
done

if [ ! "$SOURCE_DIR" ]; then
  echo "You must specify a search path with -s="
  exit 1
fi

echo
echo "Project:    " $PROJECT_NAME
echo "Source dir: " $SOURCE_DIR
echo "FPGA part:  " $FPGA_PART
echo "Out name:   " $OUTPUT_NAME
echo "Threads:    " $THREADS
echo

read -p "Continue? (Y/N)" choice
case "$choice" in 
  y|Y ) echo "Running...";;
  * ) echo "Exiting"; exit;;
esac









# Remove any previous tasks performed
echo "Deleting old files..."
rm -f script.tcl
rm -f $PROJECT_NAME.xpr
rm -rf $PROJECT_NAME.cache
rm -rf $PROJECT_NAME.hw
rm -rf $PROJECT_NAME.ip_user_files
rm -rf $PROJECT_NAME.sim
rm -rf $PROJECT_NAME.srcs
rm -rf $PROJECT_NAME.runs
rm -f *.log
rm -f *.jou

# Find all Verilog files in this directory
SOURCE_FILES=$(find $SOURCE_DIR -type f -name "*")

# Specify any testbeds, only for debugging
#TB_FILES=$(find . -type f -name "*_tb.vhd") #add_files -norecurse { $TB_FILES }
#set_property is_global_include true [get_files $EXTRA_FILES ]

# Generate the Vivado TCL commands
echo "
create_project $PROJECT_NAME ./$PROJECT_NAME -part $FPGA_PART
add_files -norecurse { $SOURCE_FILES }
update_compile_order -fileset sources_1
launch_runs impl_1 -jobs $THREADS
wait_on_run impl_1
open_run impl_1
write_vhdl -force $OUTPUT_NAME.vhd
exit
" >> script.tcl

# Launch vivado (no gui) with new script
vivado -mode batch -source script.tcl
