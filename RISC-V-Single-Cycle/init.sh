# DEVICEPORT=$(cat vbuddy.cfg | head -n 1)

# stty -F "${DEVICEPORT}" 115200 speed -parenb -parodd -cmspar cs8 -hupcl -cscpub cread clocal -crtscts -ignbrk -brkint -ignpar -parmrk -inpck -istrip -inlcr -igncr -icrnl -ixon -ixoff -iuclc -ixany -imaxbel -iutf8 -opost -olcuc -ocrnl -onlcr -onocr -onlret -ofill -ofdel nl0 cr0 tab0 bs0 vt0 ff0 -isig -icanon iexten -echo echoe echok -echonl -noflsh -xcase -toscpu -echoprt echoctl echoke -flusho -extproc
# echo -ne '\r\n' > "${DEVICEPORT}"
# echo -ne 'execfile("vbuddy.py")' > "${DEVICEPORT}"
# echo -ne '\r\n' > "${DEVICEPORT}"

# cleanup
rm -rf obj_dir
rm -f *.vcd

# run Verilator to translate Verilog into C++, including C++ testbench
verilator -IRTL -Wall --cc --trace cpu.sv --exe cpu_tb.cpp

# build C++ project via make automatically generated by Verilator
make -j -C obj_dir/ -f Vcpu.mk Vcpu

# autofind USB port
ls /dev/ttyUSB* > vbuddy.cfg

# run executable simulation file
echo "\nRunning simulation"
obj_dir/Vcpu
echo "\nSimulation completed"

