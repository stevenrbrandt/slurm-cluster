#FROM ubuntu:20.04
FROM et-cluster

RUN apt update -y && apt install munge -y && apt-get install mariadb-server -y

ARG DEBIAN_FRONTEND=noninteractive
RUN apt install slurm-client -y
RUN apt install curl dirmngr apt-transport-https lsb-release ca-certificates -y
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt install sudo -y && apt install python3.9 python3-pip -y && useradd -m admin -s /bin/bash -d /home/admin && echo "admin:admin" | chpasswd && adduser admin sudo && echo "admin     ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN apt update -y && apt install nodejs -y && npm install -g configurable-http-proxy && pip3 install jupyterlab==2.1.2 

COPY slurm.conf /etc/slurm-llnl/
COPY cgroup.conf /etc/slurm-llnl/
COPY notebooks/*.ipynb /etc/skel/
COPY docker-entrypoint.sh /etc/slurm-llnl/

WORKDIR /home/admin

EXPOSE 8888

#ENV USER admin
#ENV SHELL bash

# RUN apt install libopenmpi-dev -y && pip3 install jupyterlab_slurm

#ENTRYPOINT ["/etc/slurm-llnl/docker-entrypoint.sh"]
RUN pip3 install oauthenticator tornado python-oauth2 jupyterhub-dummyauthenticator mpld3

RUN pip3 install git+https://github.com/stevenrbrandt/cyolauthenticator
RUN pip3 install randpass
COPY error-cyol.html /usr/local/share/jupyterhub/templates/error.html
COPY jup-config-cyol.py /jup-config.py
COPY make_users.py /usr/local/bin/
COPY startup.sh /startup.sh
WORKDIR /
COPY mkcerts.sh /
COPY cert-info.txt /
# RUN bash ./mkcerts.sh
COPY login.html /usr/local/share/jupyterhub/templates/login.html
COPY ein.png /usr/local/share/jupyterhub/static/images/ein.png
RUN curl -L https://raw.githubusercontent.com/stevenrbrandt/workenv/master/bin/untar.py -o /usr/local/bin/untar.py
RUN chmod 755 /usr/local/bin/untar.py
CMD ["bash","/startup.sh"]
