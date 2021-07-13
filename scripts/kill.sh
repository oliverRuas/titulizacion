docker kill $(docker ps -a -q)
docker rm $(docker ps -a -q)
./cleancerts.sh
