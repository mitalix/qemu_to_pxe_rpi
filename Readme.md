Qemu to pxe for rpi3



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

Using the smallest image possible, I found Alpine Linux to fit the paradigm. There is a download link here ... [Alpine Downloads](https://alpinelinux.org/downloads/). The gzipped image for aarch64 works just fine. 

```bash
gunzip alpine-rpi-3.19.1-aarch64.img.gz
```

I like to keep a backup, because a little modification is needed for qemu, which requires the image size to be a multiple of four(4). Therefore, copy the image:

```bash
cp alpine-rpi-3.19.1-aarch64.img alpine.img
```
The image is quite small, but must be resized. This number can be realized when running qemu the first time and the error message recommends the size :
```bash
qemu-img resize alpine.img 128M
```


Now mount the image

```bash
sudo mount alpine.img /nfs
```

A quick and easy way to get the current kernel, image and dtb from the image is to look in the nfs mount. It might not be the most elegent method, but it is enough to show that it works.  Some distributions of linux don't require the initrd/initramfs to load, while Alpine does require it. So, we provide qemu with the kernel, initrd, and dtb as seen below. Also, append the "cmdline.txt" to get the console working. Adding the usbdevices ensures devices are available. Network is defined, but not ready yet. I'll cover that later. MAchine type must be specified when using aarch64 emulation.

```4D
qemu-system-aarch64 \
    -smp 4 \
    -M raspi3b \
    -hda alpine.img \
    -kernel /nfs/boot/vmlinuz-rpi \
    -initrd nfs/boot/initramfs-rpi \
    -dtb /nfs/bcm2710-rpi-3-b.dtb \
    -append "console=ttyS0,115200 console=tty1 fsck.repair=yes rootwait" \
    -usbdevice keyboard \
    -usbdevice mouse \
    -device usb-net,netdev=net0 \
    -netdev user,id=net0,hostfwd=tcp::5555-:22 
```



