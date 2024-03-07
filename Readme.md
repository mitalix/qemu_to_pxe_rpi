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
```mermaid
graph TD;
    A-->B;
    A-->C;
    B-->D;
    C-->D;
```

```mermaid
A[Hard] -->|Text| B(Round)
B --> C{Decision}
C -->|One| D[Result 1]
C -->|Two| E[Result 2]
```



