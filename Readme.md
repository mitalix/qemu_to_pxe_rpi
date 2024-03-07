### Qemu to pxe for rpi3

#### Overview


The server is a Dell laptop with Manjaro. 
dnsmasq
+ tftp 
    - /srv/tftp
    - $SERIAL_NUMBER
+ nfs
    - /nfs

mount the alpine.img image on /nfs

export the directory /nfs to the network


mount the nfs directory under /nfs to /srv/tftp/$SERIAL_NUMBER

```
sudo systemctl start dnsmasq ````
```

***
Using qemu to test and boot up an ARM rpi image. This comes in handy when you want to prepare an image for pxe-boot. Instead of trying it out on the physical server, we test out a virtual machine in qemu. It saves on constantly having to run over to the machine and unplug/plug in the device. Using the smallest image possible, I found Alpine Linux to fit the paradigm. There is a download link here ... [Alpine Downloads](https://alpinelinux.org/downloads/). The gzipped image for aarch64 works just fine. 

```4D
gunzip alpine-rpi-3.19.1-aarch64.img.gz
```

I like to keep a backup, because a little modification is needed for qemu, which requires the image size to be a multiple of four(4). Therefore, copy the image:

```4D
cp alpine-rpi-3.19.1-aarch64.img alpine.img
```
The image is quite small, but must be resized. This number can be realized when running qemu the first time and the error message recommends the size :
```4D
qemu-img resize alpine.img 128M
```


Create, if it doesn't exist, the `/nfs` directory and mount the image

```4D
[ -d /nfs ] || sudo mkdir -v /nfs

sudo mount alpine.img /nfs
```

A quick and easy way to get the current kernel, image and dtb from the image is to look in the nfs mount. It might not be the most elegent method, but it is enough to show that it works.  Some distributions of linux don't require the initrd/initramfs to load, while Alpine does require it. So, we provide qemu with the kernel, initrd, and dtb as seen below. Also, append the "cmdline.txt", i.e. console=..., etc, to get the console working. Adding the usbdevices ensures devices are available. Network is defined, but not ready yet. I'll cover that later. Machine type must be specified when using aarch64 emulation. The image alpine.img loads and root login is available without password.

```4D
qemu-system-aarch64 \
    -smp 4 \
    -M raspi3b \
    -hda alpine.img \
    -kernel /nfs/boot/vmlinuz-rpi \
    -initrd /nfs/boot/initramfs-rpi \
    -dtb /nfs/bcm2710-rpi-3-b.dtb \
    -append "console=ttyS0,115200 console=tty1 fsck.repair=yes rootwait" \
    -usbdevice keyboard \
    -usbdevice mouse \
    -device usb-net,netdev=net0 \
    -netdev user,id=net0,hostfwd=tcp::5555-:22 
```


***
Each host system is different. On a rpi raspbian system, qemu pops up a console window. On manjaro, for instance, you need to install vnc, i.e., `pacman -Ss tigervnc`. To get a console using vnc, qemu will probably give you a por number, .i.e. :5900 as parameter, type in another window: 
```
vncviewer :5900
```
There are a lot of factors that could cause this to fail, it took me months until I was able to get the keyboard and mouse working on a qemu rpi, but it maybe will be different on your system.


***
Now, assuming that the qemu image works, we'll go ahead and pxe-boot it. So, to start, just like in the previous section mount the alpine.img image on /nfs

```4D
sudo mount alpine.img /nfs
```

***
#### Configuration inside the client image

The kernel needs to point to the network image. This achieved through modifying `/nfs/cmdline.txt`

```
modules=loop,squashfs,sd-mod,usb-storage quiet console=serial0,115200 console=tty1 root=/dev/nfs nfsroot=192.168.0.108:/nfs,vers=3 rw ip=dhc
p rootwait elevator=deadline
```
***
Export the directory /nfs and probably the /srv/tftp/$SERIAL_NUMBER to the network in '/etc/exports'

```
/srv/tftp *(rw,sync,no_subtree_check,no_root_squash)
/nfs *(rw,sync,no_subtree_check,no_root_squash)
```

Export, that is, make network nfs shares available to the network.

```
sudo exportfs -a
```
Create the mountpoint if it doesn't exist alread. Mount the nfs directory under /nfs to /srv/tftp/$SERIAL_NUMBER, i.e., `SERIAL_NUMBER=76d2a334`

```
[ -d /srv/tftp/$SERIAL_NUMBER ] || sudo mkdir -v /srv/tftp/$SERIAL_NUMBER
sudo mount -vo bind /nfs /srv/tftp/$SERIAL_NUMBER
```
On manjaro, install `pacman -Ss dnsmasq`

Dnsmasq configuration is in the `/etc/dnsmasq.conf` file
```
interface=*
dhcp-range=192.168.0.10,192.168.0.50,12h
log-dhcp
enable-tftp
tftp-root=/srv/tftp
pxe-service=0,"Raspberry Pi Boot"
```
Finally start the systemd dnsmasq.service
```
sudo systemctl start dnsmasq ````
```

***
