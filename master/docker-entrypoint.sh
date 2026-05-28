#!/bin/bash

echo "UPDATE SLURM.CONF"
sudo cp /home/etuser/slurm.conf /etc/slurm/slurm.conf
# NCPUS=$(nproc)
# Use a conservative but realistic socket count (most containers look like 1 socket with N cores)
# sudo sed -i "s/Sockets=[0-9]*/Sockets=1/" /etc/slurm/slurm.conf
# sudo sed -i "s/CPUs=[0-9]*/CPUs=$NCPUS/" /etc/slurm/slurm.conf
# Also fix the NodeName line if needed
#sed -i "s/NodeName=slurmnode\[[0-9]-*[0-9]*\]/NodeName=$(hostname)/" /etc/slurm/slurm.conf

echo "START SERVICES"
sudo service munge start
sudo service slurmctld start

echo "RELINK"
sudo bash /relink.sh
