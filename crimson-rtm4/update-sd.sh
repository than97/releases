sh update-mcu.sh; sh update-server.sh ; sh update-fpga-sd.sh ; echo "Waiting 2mins for server to come up"; sleep 120; sh checkVersion.sh; sleep 10; echo "Restarting"; mem rw sys0 0;