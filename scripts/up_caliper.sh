docker kill $(docker ps -a -q)
docker rm $(docker ps -a -q)

cd .. && cd network && docker-compose -f docker-compose-tlsca.yaml up -d
# sudo chmod 667 -R ./fabric-ca
cd .. && cd scripts && ./rootca_v2.sh
./enrollpeers_caliper.sh
./msp_caliper.sh
./artifacts.sh
cd .. && cd network && docker-compose -f docker-compose-cli-couchdb.yaml up -d
# sudo chmod 667 -R ./fabric-ca
# sudo chmod 667 -R ./channel-artifacts
# sudo chmod 667 -R ./fabric-ca
# sudo chmod 667 -R ./chaincode
cd ..
cd scripts && ./channels.sh
# sudo chmod 667 -R ./fabric-ca
# sudo chmod 667 -R ./channel-artifacts
# sudo chmod 667 -R ./fabric-ca
# sudo chmod 667 -R ./chaincode
