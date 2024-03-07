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

This site was built using [GitHub Pages](https://pages.github.com/).


Using the smallest image possible, I found Alpine Linux to fit the paradigm. There is a download link here ... [Alpine Downloads](https://alpinelinux.org/downloads/).

I like to keep a backup, because a little modification is needed for qemu, which requires the image size to be a multiple of four(4). Therefore, copy the image:

```
cp alpine-rpi-3.19.1-aarch64.img alpine.img
```
The image is quite small, but must be resized :
```
qemu-img resize alpine.img 128M
```
```bash
sudo mount alpine.img /nfs


```

```
test `#00ffff` test `#ff0000` test
test`#00ffff`test`#ff0000`test
```



```
`rgb(9, 105, 218)`
```

```bash
qemu-system-aarch64 \
    -smp 4 \
    -M raspi3b \
    -hda alpine.img \
    -kernel /mnt/boot/vmlinuz-rpi \
    -initrd /mnt/boot/initramfs-rpi \
    -dtb /mnt/bcm2710-rpi-3-b.dtb \
    -append "console=ttyS0,115200 console=tty1 fsck.repair=yes rootwait" \
    -usbdevice keyboard \
    -usbdevice mouse \
    -device usb-net,netdev=net0 \
    -netdev user,id=net0,hostfwd=tcp::5555-:22 
```



