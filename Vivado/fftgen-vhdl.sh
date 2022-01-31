echo "Building with: fftgen" $@
echo "Will Save parameters to 'FFT.txt' for later reference"
echo
rm -rf ./fft-core
rm -rf ./Verilog_FFT_core
set -e
./fftgen $@
./Veri2Unisim.sh -s=fft-core -p=Verilog_FFT_core -o="fft_VHDL"
echo $@ > FFT.txt