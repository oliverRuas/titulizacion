#Programa para registrar las identidades de los farmers
for i in {1..500}
do
    export NEW_PATH=$(cd .. && echo $PWD)
    export CORE_PEER_ADDRESS=localhost:8051
    export CORE_PEER_LOCALMSPID=farmerMSP
    export CORE_PEER_TLS_ROOTCERT_FILE=$(cd .. && echo $PWD/fabric-ca/farmer/peers/farmer-peer/tls/ca.crt)
    export ORDERER_CA=$(cd .. && echo $PWD/fabric-ca/farmer/orderers/farmer-orderer/tls/ca.crt)
    export ORDERER_ADDRESS=localhost:8050
    t=$NEW_PATH/fabric-ca/farmer/clients/farmer-client-$i/msp
    export CORE_PEER_MSPCONFIGPATH=$t
    peer chaincode invoke -o $ORDERER_ADDRESS --tls --cafile $ORDERER_CA -C $CHANNEL_NAME -n $CC_NAME -c '{ "Args": ["RegisteringFarmers"] }' --peerAddresses $CORE_PEER_ADDRESS --peerAddresses localhost:11051 --peerAddresses localhost:10051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --tlsRootCertFiles  $(cd .. && echo $PWD/fabric-ca/investor/peers/investor-peer-1/tls/ca.crt) --tlsRootCertFiles  $(cd .. && echo $PWD/fabric-ca/spv/peers/spv-peer/tls/ca.crt)
done
