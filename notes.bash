
sudo ip link add name br0 type bridge    
sudo ip addr add 172.20.0.1/16 dev br0    
sudo ip link set br0 up    
sudo brctl addif virbr0 vnet0
sudo brctl addif br0 vnet0

sudo ip link set br0 down    
sudo ip link del name br0 type bridge    



qemu-system-aarch64 -M raspi3b -device usb-net,netdev=net0 -netdev user,id=net0,hostfwd=tcp::2022-:22


sudo ip link add br0 type bridge
sudo ip tuntap add dev tap0 mode tap
sudo ip link set dev tap0 master br0   # set br0 as the target bridge for tap0
sudo ip link set dev enp2s0 master br0   # set br0 as the target bridge for eth0
sudo ip link set dev br0 up
-net nic -net tap,ifname=tap0

sudo ip link set dev br0 down
sudo ip link set dev tap0 down
sudo ip link del tap0 
sudo ip link del br0


sudo ip link set dev eth0 master br0   # set br0 as the target bridge for eth0

./aarch64-softmmu/qemu-system-aarch64 
-machine virt 
-cpu cortex-a57 
-machine type=virt 
-nographic -smp 1 -m 2048 
-kernel aarch64-linux-3.15rc2-buildroot.img 
--append "console=ttyAMA0" 
-fsdev local,id=r,path=/home/alex/lsrc/qemu/rootfs/trusty-core,security_model=none 
-device virtio-9p-device,fsdev=r,mount_tag=r
