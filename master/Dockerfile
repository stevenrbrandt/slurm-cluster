#FROM ubuntu:20.04
FROM et-cluster

ARG DEBIAN_FRONTEND=noninteractive
RUN apt install slurmd slurm-client slurmctld -y

# RUN apt update -y && apt install libopenmpi-dev -y && pip3 install mpi4py

COPY slurm.conf /etc/slurm-llnl/
COPY cgroup.conf /etc/slurm-llnl/
COPY docker-entrypoint.sh /etc/slurm-llnl/
COPY relink.sh /

EXPOSE 6817 6818 6819 3306 

WORKDIR /home/admin

ENTRYPOINT ["/etc/slurm-llnl/docker-entrypoint.sh"]
