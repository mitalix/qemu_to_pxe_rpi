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


Using the smallest image possible, I found Alpine Linux to fit the paradigm. There is a download link here ... [LINK] (https://alpinelinux.org/downloads/) here

This site was built using [GitHub Pages](https://alpinelinux.org/downloads/).

```
The background color is `#ffffff` for light mode and `#000000` for dark mode.
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



