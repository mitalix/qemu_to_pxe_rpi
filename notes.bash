
sudo ip link add name br0 type bridge    
sudo ip addr add 172.20.0.1/16 dev br0    
sudo ip link set br0 up    
sudo brctl addif virbr0 vnet0
sudo brctl addif br0 vnet0

sudo ip link set br0 down    
sudo ip link del name br0 type bridge    



qemu-system-aarch64 -M raspi3b -device usb-net,netdev=net0 -netdev user,id=net0,hostfwd=tcp::2022-:22


 # ip link add br0 type bridge
 # ip tuntap add dev tap0 mode tap
 # ip link set dev tap0 master br0   # set br0 as the target bridge for tap0
 # ip link set dev eth0 master br0   # set br0 as the target bridge for eth0
 # ip link set dev br0 up


