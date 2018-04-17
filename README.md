Releases for Crimson TNG
===

A snapshot of binaries and tools that identifies a release.

AUTOMATIC UPDATE INSTRUCTIONS
===

Unless otherwise instructed, you should follow the automatic update instructions to help ensure a smooth update process.

There are five steps to this process;

1. Clone the releases repository.

2. Copy the release package to Crimson.

3. Execute the update script and wait for it to be completed.

4. (Optionally) Regenerate the look up table.

5. Update to the corresponding UHD version.


Each step shall be reviewed in order.

CLONE RELEASE REPORTER
===

You can use git to clone the latest releases repo as follows;

$ git clone https://github.com/pervices/releases/tree/master

After cloning the releases repository, fetch all the remote tags by typing;

$ git fetch --all

In general, the latest release shall be available on the master branch, but you can see a list of previous releases using;

$ git tag -l

And you can check out to those releases by typing;

$ git checkout 1.6.7

After cloning and checking out to a specific release, enter into the release repository, to find appropriate binaries for RTM4 and RTM5 releases.

COPY RELEASE BINARY TO CRIMSON
===

You may use SCP, from within the releases repo, to copy the appropriate release to Crimson. Assuming the default Crimson IP address of 192.168.10.2, and after selecting the appropriate RTM4/5 packages;

Crimson RTM4 users:

$ scp updateCrimsonRTM4 dev0@192.168.10.2:

Crimson RTM5 users:

$ scp updateCrimsonRTM5 dev0@192.168.10.2:

You will be prompted for a password, which you were previously provided with.


EXECUTE UPDATE SCRIPT
===

DO NOT INTERUPT CRIMSON DURING THE UPDATE PROCESS.

To execute the update process, you will need to SSH into Crimson, and execute the 
update binary from within a root shell. To do this, type the following commands in 
sequence;

$ ssh dev0@192.168.10.2

$ sudo -s

Crimson RTM4 users:

$ ./updateCrimsonRTM4

Crimson RTM5 users:

$ ./updateCrimsonRTM5


The update process takes some time. It is very important NOT to interupt this process.

After the SDCard image and FPGA image have been update, and the server has come 
up again, (which can take up to 10minutes), you should see something similar to 
the the following output, but with version numbers that reflect your release;


Checking Version

RX 1f33a442

TX 1f33a442

SYNTH 1f33a442

FRIMWARE 4acd189d

FS-METAPV c64b534d25b6907292cd1bd2693b21fecbba6339

WEBPV 1aa775024abdff7481f973279959baa787b4f461 

FPGA 9a10c7830

==================

VERSION GOOD

==================


To complete the update process, reboot crimson from the shell by typing:

$ systemctl reboot now


REGENERATE LOOK UP TABLE
===

After updating to a new release, you may choose to manually regenerate the look up tables.

This is one-time process that regenerate the look up tables, which are specific to each Rx board and each radio chain.

NOTE 1: It will take approximately 45 min to fully complete this process.

NOTE 2: If you have just updated the unit, it is best to first reboot the unit to ensure that you are using the latest code, prior to regenerating the LUT.

0. SSH into the Crimson unit, using the dev0 user and the password provided by Per Vices.

1. Delete the directory /var/crimson/calibration-data/

type

sudo rm -rf /var/crimson/calibration-data/

2. Regenerate the calibration data by enabling the LUT.

You will need to generate the LUT for each radio chain. During the LUT generation processs, you will not be able to use Crimson.

echo 1 |sudo tee /var/crimson/state/{t,r}x/{a,b,c,d}/rf/freq/lut_en

This process will take approximately 30min; when the bottom LED on the crimson unit stops flashing the process will have completed. 

While logging on to the Crimson unit, you may observe the current LUT generation process status by typing;

sudo systemctl status crimson-server

The log results will indicate the radio chain, frequency and offset you will need, and are automatically used in the calibration tables.

UPDATE UHD
===

After updating all components, ensure that you are running an appropriate version of UHD. Speaking broadly, if you compiled from master,
then you should use the master UHD branch. If you compiled from another branch, you should use the corresponding branch, unless otherwise
specified.

To identify the correct version of UHD, select the branch or release that shares the same release tag as the one you selected when updating Crimson.


MANUAL UPDATE INSTRUCTIONS
===

The following section is for advanced users only. We strongly recommend using the automatic update tools instead of performing manual updates.

In order to manually update the Crimson firmware, you will have to update the mcu, fpga, website, and file system binaries.

It is important that all these elements are updated to work with the current UHD build.

To manually update the crimson device, first copy the releases repo to a machine that is hooked up to crimson. Then, create a tar ball of the appropriate release. 

COPYING BINARIES TO CRIMSON
===

1. Create a tarball of the appropriate release.

For example, for a crimson-rtm5 device, open a terminal, enter the releases directory and type;

$ tar -cf crimson-rtm5.tar ./crimson-rtm5

This will create a file called crimson-rtm5.tar, which contains the appropriate firmware for a Crimson RTM5 unit.

2. Copy this file to the crimson device.

This file then needs to be copied to crimson, which you can do using SCP. Using the default ip address of 192.168.10.2, you can type;

scp -r crimson-rtm5.tar dev0@192.168.10.2:/home/dev0

3. Uncompress the binary.

Using SSH, you can login to the crimson unit, and uncompress the tar ball. If you've followed the above instructions, this may be accomplished with:

ssh dev0@192.168.10.2

After logging into the unit, use sudo to correct the user and group permissions:

tar -xf crimson-rtm5.tar

4. Fix file permissions to root ownership, and enable read permissions;

sudo chown root:root -R crimson-rtm5/

sudo chmod a+rX -R crimson-rtm5/

You may log in and sudo using the same password you used to copy over the binaries. 
This will expand the tarball and create a directory called crimson-rtm5 which contains all the binaries you will need to update.

The remainder of these instructions assumes that you have successfully copied these files to your crimson unit, using the above instructions.

MANUAL MCU UPDATE
===

*CONFIRM THAT YOU ARE USING THE CORRECT MCU VERSION FOR YOUR DEVICE*
RTM5 BINARIES WILL NOT WORK WITH RTM4 UNITS.

IF YOU HAVE ANY QUESTIONS PLEASE CONTACT US PRIOR TO UPDATING MCU CODE.

These instructions assume that you are SSH'd onto the crimson unit, as the dev0 user, and have a release package called crimson-rtm5.

1. Replace the existing MCU binaries in /lib/mcu

The most straight forward way of ensuring a clean update is to first delete the existing MCU folder, and then replace it by moving the new MCU directory to the appropriate location.

To delete the existing directory, type;

sudo rm -rf /lib/mcu

Then, replace it with the updated MCU directory. Navigate to the location that you copied the crimson-rtm5 update directory to, and type;

sudo mv crimson-rtm5/mcu /lib/

2. Flash all the MCUs

Enter the mcu directory and use the flash tool to update all the MCUs;

cd /lib/mcu

sudo ./flash w all

Wait for this process to be completed.

When the process is completed, all the MCUs will have been updated.


MANUAL FILESYSTEM UPDATE
===

These instructions assume that you are SSH'd onto the crimson unit, as the dev0 user, and have a release package called crimson-rtm5.

1. First, stop the crimson-server process.

You can do this by typing:

sudo systemctl stop crimson-server

2. Move the upgraded binaries to /usr/bin

From within the directory the release package is in, type:

sudo mv crimson-rtm5/firmware/* /usr/bin/

3. Sync the filesystem is synchronized by typing

Simply run the following command;

sync


MANUAL FPGA RTL UPDATE
===

These instructions assume that you are SSH'd onto the crimson unit, as the dev0 user, and have a release package called crimson-rtm5.

*INCORRECTLY FOLLOWING THIS PROCESS MAY CAUSE YOUR DEVICE TO STOP WORKING.*

Please read the following instructions carefully, and contact us if you have any questions.

1. Mount the SDCard partion that has the FPGA image;

sudo mount /dev/mmcblk0p1 /mnt

2. Replace the FPGA image on the SD Card;

From the same location that you copied the release package to, type;

sudo mv crimson-rtm5/fpga/soc_system.rbf /mnt/

Note: You may safely ignore the following, specific, error:

mv: failed to preserve ownership for '/mnt/soc_system.rbf': Operation not permitted

This is because the FAT filesystem you are copying the image to does not provide for an ownership mechanism.

3. Safely unmount the SD Partition

sudo umount /mnt

This step ensures that the partition is safely unmounted.


MANUAL WEBSITE UPDATE
===

These instructions assume that you are SSH'd onto the crimson unit, as the dev0 user, and have a release package called crimson-rtm5.

1. Delete the existing website directory;

sudo rm -rf /usr/lib/node_modules/crimson-webserver

2. From the location you have the release package in, move the updated website directory to /usr/lib/node_modules;

sudo mv crimson-rtm5/crimson-webserver /usr/lib/node_modules/

3. Confirm root ownership of the crimson-webserver directory;

sudo chown root:root -R /usr/lib/node_modules/crimson-webserver

4. Confirm read permissions of the crimson-webserver directory;

sudo chmod a+rX /usr/lib/node_modules/crimson-webserver

sudo chmod u+rw /usr/lib/node_modules/crimson-webserver

5. Sync the filesystem.

sync


REBOOT UNIT
===

Sync the filesystem and then reboot the unit by typing;

sync
systemctl reboot


You will observe the unit restart itself. After it has completed the restart sequence, your unit will be ready and up to date.


