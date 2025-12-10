#!/bin/bash

echo "UPDATE SLURM.CONF"
#sudo perl -p -i -e "s/\bCPUs=\d+/CPUs=$(nproc)/g" /etc/slurm/slurm.conf
#sudo perl -p -i -e "s/\bSockets=\d+/Sockets=$(nproc)/g" /etc/slurm/slurm.conf
sudo cp /home/etuser/slurm.conf /etc/slurm/slurm.conf

echo "START SERVICES"
sudo service munge start
sudo service slurmctld start

echo "RELINK"
sudo bash /relink.sh
