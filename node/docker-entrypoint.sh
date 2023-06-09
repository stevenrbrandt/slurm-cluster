#!/bin/bash

echo "UPDATE SLURM.CONF"
sudo sed -i "s/REPLACE_IT/CPUs=$(nproc)/g" /etc/slurm-llnl/slurm.conf

echo "START SERVICES"
sudo service munge start
sudo service slurmd start #-N $(hostname)

echo "RELINK"
sudo bash /relink.sh
