#FROM ubuntu:20.04
FROM et-cluster

#ARG DEBIAN_FRONTEND=noninteractive
#RUN apt install slurmd slurm-client -y
#RUN apt install -y libpmix-bin libpmix-dev libpmix2

#COPY slurm.conf /etc/slurm/
#COPY cgroup.conf /etc/slurm/
COPY docker-entrypoint.sh /etc/slurm/
#COPY relink.sh /

EXPOSE 6817 6818 6819  

# RUN apt update -y && apt install libopenmpi-dev -y && pip3 install mpi4py

#COPY --chown=munge munge.key /etc/munge/munge.key
#RUN chmod 400  /etc/munge/munge.key

#ENTRYPOINT ["/etc/slurm-llnl/docker-entrypoint.sh"]
ENTRYPOINT ["/etc/slurm/docker-entrypoint.sh"]
