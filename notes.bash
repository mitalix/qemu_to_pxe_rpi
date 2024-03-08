
sudo ip link add name br0 type bridge    
sudo ip addr add 172.20.0.1/16 dev br0    
sudo ip link set br0 up    
sudo brctl addif virbr0 vnet0
sudo brctl addif br0 vnet0

sudo ip link set br0 down    
sudo ip link del name br0 type bridge    



qemu-system-aarch64 -M raspi3b -device usb-net,netdev=net0 -netdev user,id=net0,hostfwd=tcp::2022-:22