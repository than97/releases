echo "Updating Website"
systemctl stop crimson-website; 
systemctl stop crimson-server; 
systemctl mask crimson-website; 
systemctl mask crimson-server; 
#Ramdisk on boot
rm -rf /var/crimson/state
cp fstab/fstab /etc/
#Ram disk for now
mount -t tmpfs -o size=50m tmpfs /var/crimson/state
systemctl unmask crimson-server; 
systemctl unmask crimson-website; 
systemctl start crimson-server; 
systemctl start crimson-website; 
