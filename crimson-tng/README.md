Per Vices Release v1.0
==========================

## ARM
The code here pertains to the Linux file system running on the SoC. Copy
the contents of this folder into the root directory of the file system.
```
scp -r arm/* root@192.168.10.2:/
```

## FPGA
The code here is the FPGA binary. Copy it into the boot partition of the
SD Card.

## SD Card
The files here are used to generate the SD Card image. This includes uboot,
preloader, and file system partitions. A single important binary is _missing_.
Please visit the [PV servers]() for pervices-base-image-socfpga_arria5.tar.gz
as that is a larger file. Execute the following to build.
```
mkdir rootfs
sudo tar -xzf pervices-base-image-socfpga_arria5.tar.gz -C rootfs
sudo ./make_sdimage.py -f -P preloader-mkpimage.bin,u-boot-socfpga_arria5.img,num=3,format=raw,size=50M,type=A2 -P rootfs/*,num=2,format=ext3,size=2000M -P zImage,u-boot.scr,soc_system.rbf,socfpga.dtb,num=1,format=vfat,size=500M -s 4G -n sdcard.img
```