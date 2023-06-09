# slurm-cluster
Docker local slurm cluster

Original image Created by: Rodrigo Ancavil del Pino

https://medium.com/analytics-vidhya/slurm-cluster-with-docker-9f242deee601

Forked and updated by Steven R. Brandt

To build the image, first go to the cluster directory and run

     $ docker-compose build

This will generate the base image used by all the containers.
Next, go to the root directory and build the images for all
the nodes at once in the same way, i.e.

     $ docker-compose build

To run slurm cluster environment you must execute:

     $ docker-compose up -d

To stop it, you must:

     $ docker-compose stop

To check logs:

     $ docker-compose logs -f

     (stop logs with CTRL-c")

To check running containers:

     $ docker-compose ps
