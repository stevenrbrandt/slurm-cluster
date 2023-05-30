set -ex
(cd cluster && docker-compose build)
docker-compose build
docker-compose down
sleep 1
docker volume rm slurm-cluster_shared-vol
docker system prune -f
sleep 1
docker-compose up -d
sleep 60
echo "READY"
