for i in {1..7}
do
    export NEW_PATH=$(cd .. && echo $PWD)
    export CORE_PEER_ADDRESS=localhost:11051
    export CORE_PEER_LOCALMSPID=investorMSP
    export CORE_PEER_TLS_ROOTCERT_FILE=$(cd .. && echo $PWD/fabric-ca/investor/peers/investor-peer-1/tls/ca.crt)
    export ORDERER_CA=$(cd .. && echo $PWD/fabric-ca/investor/orderers/investor-orderer/tls/ca.crt)
    export ORDERER_ADDRESS=localhost:11050
    t=$NEW_PATH/fabric-ca/investor/clients/investor-client-$i/msp
    export CORE_PEER_MSPCONFIGPATH=$t
    peer chaincode invoke -o $ORDERER_ADDRESS --tls true --cafile $ORDERER_CA -C $CHANNEL_NAME -n $CC_NAME -c '{ "Args": ["RequestBond","500","ads"] }' --peerAddresses $CORE_PEER_ADDRESS --peerAddresses localhost:7051 --peerAddresses localhost:8051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --tlsRootCertFiles  $(cd .. && echo $PWD/fabric-ca/servicer/peers/servicer-peer/tls/ca.crt) --tlsRootCertFiles  $(cd .. && echo $PWD/fabric-ca/farmer/peers/farmer-peer/tls/ca.crt)
done
