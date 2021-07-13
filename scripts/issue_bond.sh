export NEW_PATH=$(cd .. && echo $PWD)
export CORE_PEER_ADDRESS=localhost:10051
export CORE_PEER_LOCALMSPID=spvMSP
export CORE_PEER_TLS_ROOTCERT_FILE=$(cd .. && echo $PWD/fabric-ca/spv/peers/spv-peer/tls/ca.crt)
export ORDERER_CA=$(cd .. && echo $PWD/fabric-ca/spv/orderers/spv-orderer/tls/ca.crt)
export ORDERER_ADDRESS=localhost:10050
t=$NEW_PATH/fabric-ca/spv/clients/spv-client/msp
export CORE_PEER_MSPCONFIGPATH=$t
peer chaincode invoke -o $ORDERER_ADDRESS --tls true --cafile $ORDERER_CA -C $CHANNEL_NAME -n $CC_NAME -c '{ "Args": ["IssueBond"] }' --peerAddresses $CORE_PEER_ADDRESS --peerAddresses localhost:7051 --peerAddresses localhost:11051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --tlsRootCertFiles  $(cd .. && echo $PWD/fabric-ca/servicer/peers/servicer-peer/tls/ca.crt) --tlsRootCertFiles  $(cd .. && echo $PWD/fabric-ca/investor/peers/investor-peer-1/tls/ca.crt)




# export NEW_PATH=$(cd .. && echo $PWD)
# export CORE_PEER_ADDRESS=localhost:11051
# export CORE_PEER_LOCALMSPID=spvMSP
# export CORE_PEER_TLS_ROOTCERT_FILE=$(cd .. && echo $PWD/fabric-ca/investor/peers/investor-peer-1/tls/ca.crt)
# export ORDERER_CA=$(cd .. && echo $PWD/fabric-ca/investor/orderers/investor-orderer/tls/ca.crt)
# export ORDERER_ADDRESS=localhost:11050
# t=$NEW_PATH/fabric-ca/investor/clients/investor-client-1/msp
# export CORE_PEER_MSPCONFIGPATH=$t
# peer chaincode invoke -o $ORDERER_ADDRESS --tls true --cafile $ORDERER_CA -C $CHANNEL_NAME -n $CC_NAME -c '{ "Args": ["QueryIdentityHistory","eDUwOTo6Q049ZmFybWVyLWNsaWVudC00LE9VPWNsaWVudCtPVT1mYXJtZXIrT1U9Y2xpZW50ZSxPPUZhcm1lcixMPUZhcm1lckxvY2F0aW9uLFNUPUZhcm1lclN0YXRlLEM9U1A6OkNOPXJvb3RjYS1mYXJtZXIsT1U9SHlwZXJsZWRnZXIgRmFicmljLE89RmFybWVyLEw9RmFybWVyTCxTVD1GYXJtZXJTVCxDPVNQ"] }' --peerAddresses $CORE_PEER_ADDRESS --peerAddresses localhost:7051 --peerAddresses localhost:9051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --tlsRootCertFiles  $(cd .. && echo $PWD/fabric-ca/servicer/peers/servicer-peer/tls/ca.crt) --tlsRootCertFiles  $(cd .. && echo $PWD/fabric-ca/spv/peers/spv-peer/tls/ca.crt)


# export NEW_PATH=$(cd .. && echo $PWD)
# export CORE_PEER_ADDRESS=localhost:11051
# export CORE_PEER_LOCALMSPID=investorMSP
# export CORE_PEER_TLS_ROOTCERT_FILE=$(cd .. && echo $PWD/fabric-ca/investor/peers/investor-peer-1/tls/ca.crt)
# export ORDERER_CA=$(cd .. && echo $PWD/fabric-ca/investor/orderers/investor-orderer/tls/ca.crt)
# export ORDERER_ADDRESS=localhost:11050
# t=$NEW_PATH/fabric-ca/investor/clients/investor-client-1/msp
# export CORE_PEER_MSPCONFIGPATH=$t




# export NEW_PATH=$(cd .. && echo $PWD)
# export CORE_PEER_ADDRESS=localhost:10051
# export CORE_PEER_LOCALMSPID=spvMSP
# export CORE_PEER_TLS_ROOTCERT_FILE=$(cd .. && echo $PWD/fabric-ca/spv/peers/spv-peer/tls/ca.crt)
# export ORDERER_CA=$(cd .. && echo $PWD/fabric-ca/spv/orderers/spv-orderer/tls/ca.crt)
# export ORDERER_ADDRESS=localhost:10050
# t=$NEW_PATH/fabric-ca/spv/clients/spv-client/msp
# export CORE_PEER_MSPCONFIGPATH=$t
# peer chaincode invoke -o $ORDERER_ADDRESS --tls true --cafile $ORDERER_CA -C $CHANNEL_NAME -n $CC_NAME -c '{ "Args": ["QueryIdentityHistory","eDUwOTo6Q049ZmFybWVyLWNsaWVudC00LE9VPWNsaWVudCtPVT1mYXJtZXIrT1U9Y2xpZW50ZSxPPUZhcm1lcixMPUZhcm1lckxvY2F0aW9uLFNUPUZhcm1lclN0YXRlLEM9U1A6OkNOPXJvb3RjYS1mYXJtZXIsT1U9SHlwZXJsZWRnZXIgRmFicmljLE89RmFybWVyLEw9RmFybWVyTCxTVD1GYXJtZXJTVCxDPVNQ"] }' --peerAddresses $CORE_PEER_ADDRESS --peerAddresses localhost:7051 --peerAddresses localhost:8051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --tlsRootCertFiles  $(cd .. && echo $PWD/fabric-ca/servicer/peers/servicer-peer/tls/ca.crt) --tlsRootCertFiles  $(cd .. && echo $PWD/fabric-ca/farmer/peers/farmer-peer/tls/ca.crt)
