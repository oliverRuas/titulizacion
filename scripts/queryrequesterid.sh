export NEW_PATH=$(cd .. && echo $PWD)
export CORE_PEER_ADDRESS=localhost:10051
export CORE_PEER_LOCALMSPID=spvMSP
export CORE_PEER_TLS_ROOTCERT_FILE=$(cd .. && echo $PWD/fabric-ca/spv/peers/spv-peer/tls/ca.crt)
export ORDERER_CA=$(cd .. && echo $PWD/fabric-ca/spv/orderers/spv-orderer/tls/ca.crt)
export ORDERER_ADDRESS=localhost:10050
t=$NEW_PATH/fabric-ca/spv/clients/spv-client/msp
export CORE_PEER_MSPCONFIGPATH=$t
peer chaincode invoke -o $ORDERER_ADDRESS --tls true --cafile $ORDERER_CA -C $CHANNEL_NAME -n $CC_NAME -c '{ "Args": ["QueryRequesterID"] }' --peerAddresses $CORE_PEER_ADDRESS --peerAddresses localhost:7051 --peerAddresses localhost:8051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --tlsRootCertFiles  $(cd .. && echo $PWD/fabric-ca/servicer/peers/servicer-peer/tls/ca.crt) --tlsRootCertFiles  $(cd .. && echo $PWD/fabric-ca/farmer/peers/farmer-peer/tls/ca.crt) 2>&1 | tee requester.json
