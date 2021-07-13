docker kill $(docker ps -a -q)
docker rm $(docker ps -a -q)

cd .. && cd network && docker-compose -f docker-compose-tlsca.yaml up -d
cd .. && cd scripts && ./rootca_v2.sh
./enrollpeers.sh
./msp.sh
./artifacts.sh
cd .. && cd network && docker-compose -f docker-compose-cli-couchdb.yaml up -d
cd ..
cd scripts && ./channels.sh

