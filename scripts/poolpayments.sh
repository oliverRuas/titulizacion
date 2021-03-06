export NEW_PATH=$(cd .. && echo $PWD)
export CORE_PEER_ADDRESS=localhost:7051
export CORE_PEER_LOCALMSPID=servicerMSP
export CORE_PEER_TLS_ROOTCERT_FILE=$(cd .. && echo $PWD/fabric-ca/servicer/peers/servicer-peer/tls/ca.crt)
export ORDERER_CA=$(cd .. && echo $PWD/fabric-ca/servicer/orderers/servicer-orderer/tls/ca.crt)
export ORDERER_ADDRESS=localhost:7050
t=$NEW_PATH/fabric-ca/servicer/clients/servicer-client/msp
export CORE_PEER_MSPCONFIGPATH=$t
peer chaincode invoke -o $ORDERER_ADDRESS --tls true --cafile $ORDERER_CA -C $CHANNEL_NAME -n $CC_NAME -c '{ "Args": ["PoolPaymentsServicer"] }' --peerAddresses $CORE_PEER_ADDRESS --peerAddresses localhost:11051 --peerAddresses localhost:8051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --tlsRootCertFiles  $(cd .. && echo $PWD/fabric-ca/investor/peers/investor-peer-1/tls/ca.crt) --tlsRootCertFiles  $(cd .. && echo $PWD/fabric-ca/farmer/peers/farmer-peer/tls/ca.crt)

