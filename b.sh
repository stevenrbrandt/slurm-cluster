set -ex
(cd cluster && ~/.local/bin/docker-compose build)
~/.local/bin/docker-compose -f docker-compose-jupyter.yml build
~/.local/bin/docker-compose -f docker-compose-jupyter.yml down
sleep 1
docker volume rm slurm-cluster_shared-vol
docker system prune -f
sleep 1
~/.local/bin/docker-compose -f docker-compose-jupyter.yml up -d
sleep 60
echo "READY"
ch -u http://localhost:8888
