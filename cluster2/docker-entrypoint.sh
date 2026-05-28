#!/bin/bash

set -x
echo "UPDATE SLURM.CONF"
sudo cp /home/etuser/slurm.conf /etc/slurm/slurm.conf


sudo service munge start
echo "START SERVICES"
if [ "$(hostname)" = "slurmmaster" ]
then
  sudo service slurmctld start
else
  sudo service slurmd start
fi

echo "RELINK"
sudo bash /relink.sh
