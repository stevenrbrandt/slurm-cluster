#!/bin/bash

set -x
echo "UPDATE SLURM.CONF"
sudo cp /home/etuser/slurm.conf /etc/slurm/slurm.conf
# NCPUS=$(nproc)
# SOCKETS=1
# Use a conservative but realistic socket count (most containers look like 1 socket with N cores)
# sudo sed -i "s/Sockets=[0-9]*/Sockets=1/" /etc/slurm/slurm.conf
# sudo sed -i "s/CPUs=[0-9]*/CPUs=$NCPUS/" /etc/slurm/slurm.conf

# Remove any existing NodeName lines for our slurm nodes so we start clean
#sudo sed -i '/^NodeName=slurmnode\[/d' /etc/slurm/slurm.conf
#sudo sed -i '/^PartitionName=slurmpar/d' /etc/slurm/slurm.conf

# Emit a clean per-node definition
#echo "NodeName=$(hostname) Sockets=$SOCKETS CPUs=$NCPUS State=UNKNOWN" | sudo tee -a /etc/slurm/slurm.conf

# Re-add a minimal partition (adjust nodes as needed)
#echo "PartitionName=slurmpar Nodes=$(hostname) Default=YES MaxTime=INFINITE State=UP" | sudo tee -a /etc/slurm/slurm.conf

echo "START SERVICES"
sudo service munge start
sudo service slurmd start #-N $(hostname)

echo "RELINK"
sudo bash /relink.sh
