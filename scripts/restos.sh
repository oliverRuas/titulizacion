peer chaincode invoke -o $ORDERER_ADDRESS --tls true --cafile $ORDERER_CA -C $CHANNEL_NAME -n $CC_NAME -c '{ "Args": ["GetHistoryOfUTXO", "747f4accaf90767ba95ef33dd1e4b46b668413c9749e87758b4788851810416d.0"] }' --peerAddresses $CORE_PEER_ADDRESS --peerAddresses localhost:7051 --peerAddresses localhost:9051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --tlsRootCertFiles  $(cd .. && echo $PWD/fabric-ca/originator/peers/originator-peer/tls/ca.crt) --tlsRootCertFiles  $(cd .. && echo $PWD/fabric-ca/aggregator/peers/aggregator-peer/tls/ca.crt)

peer chaincode invoke -o $ORDERER_ADDRESS --tls true --cafile $ORDERER_CA -C $CHANNEL_NAME -n $CC_NAME -c '{ "Args": ["BondInfo"] }' --peerAddresses $CORE_PEER_ADDRESS --peerAddresses localhost:7051 --peerAddresses localhost:9051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --tlsRootCertFiles  $(cd .. && echo $PWD/fabric-ca/originator/peers/originator-peer/tls/ca.crt) --tlsRootCertFiles  $(cd .. && echo $PWD/fabric-ca/aggregator/peers/aggregator-peer/tls/ca.crt)


peer chaincode invoke -o $ORDERER_ADDRESS --tls true --cafile $ORDERER_CA -C $CHANNEL_NAME -n $CC_NAME -c '{ "Args": ["QueryBond"] }' --peerAddresses $CORE_PEER_ADDRESS --peerAddresses localhost:7051 --peerAddresses localhost:9051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --tlsRootCertFiles  $(cd .. && echo $PWD/fabric-ca/originator/peers/originator-peer/tls/ca.crt) --tlsRootCertFiles  $(cd .. && echo $PWD/fabric-ca/aggregator/peers/aggregator-peer/tls/ca.crt)


peer chaincode invoke -o $ORDERER_ADDRESS --tls true --cafile $ORDERER_CA -C $CHANNEL_NAME -n $CC_NAME -c '{ "Args": ["QueryClientUTXOs","eDUwOTo6Q049dW5kZXJ3cml0dGVyLWNsaWVudC05LE9VPWNsaWVudCtPVT11bmRlcndyaXR0ZXIrT1U9Y2xpZW50ZSxPPUZhcm1lcixMPUZhcm1lckxvY2F0aW9uLFNUPUZhcm1lclN0YXRlLEM9U1A6OkNOPXJvb3RjYS11bmRlcndyaXR0ZXIsT1U9SHlwZXJsZWRnZXIgRmFicmljLE89dW5kZXJ3cml0dGVyLEw9VW5kZXJ3cml0dGVyTCxTVD1VbmRlcndyaXR0ZXJTVCxDPVNQ"] }' --peerAddresses $CORE_PEER_ADDRESS --peerAddresses localhost:7051 --peerAddresses localhost:9051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --tlsRootCertFiles  $(cd .. && echo $PWD/fabric-ca/originator/peers/originator-peer/tls/ca.crt) --tlsRootCertFiles  $(cd .. && echo $PWD/fabric-ca/aggregator/peers/aggregator-peer/tls/ca.crt)


6255433705703b2e0816a0a4b4a5d847f40c2173cb1c5a634c79dc3faf653b7a:1
8d51ff435ce7cc77ab5e03b815cf206b6c8d4ddda31965e370108724eca95430:1


\"6255433705703b2e0816a0a4b4a5d847f40c2173cb1c5a634c79dc3faf653b7a:0\",\"8d51ff435ce7cc77ab5e03b815cf206b6c8d4ddda31965e370108724eca95430:1\",\"2fd6dbbb8d7cd093aa425f69aaf86728acf4441c8cdeb45da2e3159b47e42cdc:1\",\"391a7c4762e7a0d34d6bd40e411ade29131fe90300ebe6b926245fd40571c974:1\"

peer chaincode invoke -o $ORDERER_ADDRESS --tls true --cafile $ORDERER_CA -C $CHANNEL_NAME -n $CC_NAME -c '{ "Args": ["PoolUTXOTokens","[\"6255433705703b2e0816a0a4b4a5d847f40c2173cb1c5a634c79dc3faf653b7a:1\",\"0ed591315698becfe477489f9403539fd6850f4185f90d292fbffe87f9054b9d:0\",\"8d51ff435ce7cc77ab5e03b815cf206b6c8d4ddda31965e370108724eca95430:1\"]"] }' --peerAddresses $CORE_PEER_ADDRESS --peerAddresses localhost:9051 --peerAddresses localhost:8051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --tlsRootCertFiles  $(cd .. && echo $PWD/fabric-ca/aggregator/peers/aggregator-peer/tls/ca.crt) --tlsRootCertFiles  $(cd .. && echo $PWD/fabric-ca/farmer/peers/farmer-peer/tls/ca.crt)

8d5e5a58fc6c10d5721aa0ada2dfc9fcc4a1c2d12731fbf824b5aec060b5932a:0



chaincode invoke -o $ORDERER_ADDRESS --tls true --cafile $ORDERER_CA -C $CHANNEL_NAME -n $CC_NAME -c '{ "Args": ["ClientID"] }' --peerAddresses $CORE_PEER_ADDRESS --peerAddresses localhost:9051 --peerAddresses localhost:8051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --tlsRootCertFiles  $(cd .. && echo $PWD/fabric-ca/aggregator/peers/aggregator-peer/tls/ca.crt) --tlsRootCertFiles  $(cd .. && echo $PWD/fabric-ca/farmer/peers/farmer-peer/tls/ca.crt)




export NEW_PATH=$(cd .. && echo $PWD)
export CORE_PEER_ADDRESS=localhost:11051
export CORE_PEER_LOCALMSPID=underwritterMSP
export CORE_PEER_TLS_ROOTCERT_FILE=$(cd .. && echo $PWD/fabric-ca/underwritter/peers/underwritter-peer/tls/ca.crt)
export ORDERER_CA=$(cd .. && echo $PWD/fabric-ca/underwritter/orderers/underwritter-orderer/tls/ca.crt)
export ORDERER_ADDRESS=localhost:11050
t=$NEW_PATH/fabric-ca/underwritter/clients/underwritter-client-6/msp
export CORE_PEER_MSPCONFIGPATH=$t

peer chaincode invoke -o $ORDERER_ADDRESS --tls --cafile $ORDERER_CA -C $CHANNEL_NAME -n $CC_NAME -c '{ "Args": ["QueryMyTokens"] }' --peerAddresses $CORE_PEER_ADDRESS --peerAddresses localhost:9051 --peerAddresses localhost:8051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --tlsRootCertFiles  $(cd .. && echo $PWD/fabric-ca/aggregator/peers/aggregator-peer/tls/ca.crt) --tlsRootCertFiles  $(cd .. && echo $PWD/fabric-ca/farmer/peers/farmer-peer/tls/ca.crt)





export NEW_PATH=$(cd .. && echo $PWD)
export CORE_PEER_ADDRESS=localhost:11051
export CORE_PEER_LOCALMSPID=investorMSP
export CORE_PEER_TLS_ROOTCERT_FILE=$(cd .. && echo $PWD/fabric-ca/investor/peers/investor-peer-1/tls/ca.crt)
export ORDERER_CA=$(cd .. && echo $PWD/fabric-ca/investor/orderers/investor-orderer/tls/ca.crt)
export ORDERER_ADDRESS=localhost:11050
t=$NEW_PATH/fabric-ca/investor/clients/investor-client-3/msp
export CORE_PEER_MSPCONFIGPATH=$t
export ACCOUNTNUMBER=$(echo -n "\"123-45678-90TszpOwQUjK?9K=Tk3z#jQQ4VV:SA=P26\"" | base64 | tr -d \\n)
export BANK=$(echo -n "\"BBVATszpOwQUjK?9K=Tk3z#jQQ4VV:SA=P26\"" | base64 | tr -d \\n)
export SALT=$(echo -n "\"TszpOwQUjK?9K=Tk3z#jQQ4VV:SA=P26\"" | base64 | tr -d \\n)
peer chaincode invoke -o $ORDERER_ADDRESS --tls --cafile $ORDERER_CA -C $CHANNEL_NAME -n $CC_NAME -c '{ "Args": ["Redeem", "7b95bc7ead1951ad7e3782c3efe27a9c354ecc57639058f10f6a6dc8dbe82559:0"] }' --peerAddresses $CORE_PEER_ADDRESS --peerAddresses localhost:10051 --peerAddresses localhost:8051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --tlsRootCertFiles  $(cd .. && echo $PWD/fabric-ca/spv/peers/spv-peer/tls/ca.crt) --tlsRootCertFiles  $(cd .. && echo $PWD/fabric-ca/farmer/peers/farmer-peer/tls/ca.crt) --transient "{\"accountNumber\":\"$ACCOUNTNUMBER\",\"bank\":\"$BANK\",\"salt\":\"$SALT\"}"






export NEW_PATH=$(cd .. && echo $PWD)
export CORE_PEER_ADDRESS=localhost:10051
export CORE_PEER_LOCALMSPID=spvMSP
export CORE_PEER_TLS_ROOTCERT_FILE=$(cd .. && echo $PWD/fabric-ca/spv/peers/spv-peer/tls/ca.crt)
export ORDERER_CA=$(cd .. && echo $PWD/fabric-ca/spv/orderers/spv-orderer/tls/ca.crt)
export ORDERER_ADDRESS=localhost:10050
t=$NEW_PATH/fabric-ca/spv/clients/spv-client/msp
export CORE_PEER_MSPCONFIGPATH=$t

peer chaincode invoke -o $ORDERER_ADDRESS --tls --cafile $ORDERER_CA -C $CHANNEL_NAME -n $CC_NAME -c '{ "Args": ["GetUTXOTokenByID","utxotoken","ec5a9b2011976523da076a9517beca4eb1a242041be656dc52286267d06525e6:0"] }' --peerAddresses $CORE_PEER_ADDRESS --peerAddresses localhost:7051 --peerAddresses localhost:8051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --tlsRootCertFiles  $(cd .. && echo $PWD/fabric-ca/servicer/peers/servicer-peer/tls/ca.crt) --tlsRootCertFiles  $(cd .. && echo $PWD/fabric-ca/farmer/peers/farmer-peer/tls/ca.crt)









export NEW_PATH=$(cd .. && echo $PWD)
export CORE_PEER_ADDRESS=localhost:11051
export CORE_PEER_LOCALMSPID=investorMSP
export CORE_PEER_TLS_ROOTCERT_FILE=$(cd .. && echo $PWD/fabric-ca/investor/peers/investor-peer-1/tls/ca.crt)
export ORDERER_CA=$(cd .. && echo $PWD/fabric-ca/investor/orderers/investor-orderer/tls/ca.crt)
export ORDERER_ADDRESS=localhost:11050
t=$NEW_PATH/fabric-ca/investor/clients/investor-client-1/msp
export CORE_PEER_MSPCONFIGPATH=$t

peer chaincode invoke -o $ORDERER_ADDRESS --tls --cafile $ORDERER_CA -C $CHANNEL_NAME -n $CC_NAME -c '{ "Args": ["QueryPaymentsAndDefaultByPeriod","1"] }' --peerAddresses $CORE_PEER_ADDRESS --peerAddresses localhost:7051 --peerAddresses localhost:8051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --tlsRootCertFiles  $(cd .. && echo $PWD/fabric-ca/servicer/peers/servicer-peer/tls/ca.crt) --tlsRootCertFiles  $(cd .. && echo $PWD/fabric-ca/farmer/peers/farmer-peer/tls/ca.crt)







export NEW_PATH=$(cd .. && echo $PWD)
export CORE_PEER_ADDRESS=localhost:11051
export CORE_PEER_LOCALMSPID=investorMSP
export CORE_PEER_TLS_ROOTCERT_FILE=$(cd .. && echo $PWD/fabric-ca/investor/peers/investor-peer-1/tls/ca.crt)
export ORDERER_CA=$(cd .. && echo $PWD/fabric-ca/investor/orderers/investor-orderer/tls/ca.crt)
export ORDERER_ADDRESS=localhost:11050
t=$NEW_PATH/fabric-ca/investor/clients/investor-client-1/msp
export CORE_PEER_MSPCONFIGPATH=$t

peer chaincode invoke -o $ORDERER_ADDRESS --tls --cafile $ORDERER_CA -C $CHANNEL_NAME -n $CC_NAME -c '{ "Args": ["QueryAssetByPeriod","1"] }' --peerAddresses $CORE_PEER_ADDRESS --peerAddresses localhost:7051 --peerAddresses localhost:8051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --tlsRootCertFiles  $(cd .. && echo $PWD/fabric-ca/servicer/peers/servicer-peer/tls/ca.crt) --tlsRootCertFiles  $(cd .. && echo $PWD/fabric-ca/farmer/peers/farmer-peer/tls/ca.crt)


[50,9900.02,"[\"7372cb8315f5e16a619b358aa895ae1084c851d1a4f0119299dfc0cb1f3cc86d.0\"]"]

export NEW_PATH=$(cd .. && echo $PWD)
export CORE_PEER_ADDRESS=localhost:10051
export CORE_PEER_LOCALMSPID=spvMSP
export CORE_PEER_TLS_ROOTCERT_FILE=$(cd .. && echo $PWD/fabric-ca/spv/peers/spv-peer/tls/ca.crt)
export ORDERER_CA=$(cd .. && echo $PWD/fabric-ca/spv/orderers/spv-orderer/tls/ca.crt)
export ORDERER_ADDRESS=localhost:10050
t=$NEW_PATH/fabric-ca/spv/clients/spv-client/msp
export CORE_PEER_MSPCONFIGPATH=$t

peer chaincode invoke -o $ORDERER_ADDRESS --tls --cafile $ORDERER_CA -C $CHANNEL_NAME -n $CC_NAME -c '{ "Args": ["WantToSell","50","9900.02","7372cb8315f5e16a619b358aa895ae1084c851d1a4f0119299dfc0cb1f3cc86d.0"] }' --peerAddresses $CORE_PEER_ADDRESS --peerAddresses localhost:7051 --peerAddresses localhost:12051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --tlsRootCertFiles  $(cd .. && echo $PWD/fabric-ca/servicer/peers/servicer-peer/tls/ca.crt) --tlsRootCertFiles  $(cd .. && echo $PWD/fabric-ca/investor/peers/investor-peer-2/tls/ca.crt)




peer chaincode invoke -o $ORDERER_ADDRESS --tls --cafile $ORDERER_CA -C $CHANNEL_NAME -n $CC_NAME -c '{ "Args": ["QueryBondsForSale"] }' --peerAddresses $CORE_PEER_ADDRESS --peerAddresses localhost:7051 --peerAddresses localhost:12051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --tlsRootCertFiles  $(cd .. && echo $PWD/fabric-ca/servicer/peers/servicer-peer/tls/ca.crt) --tlsRootCertFiles  $(cd .. && echo $PWD/fabric-ca/investor/peers/investor-peer-2/tls/ca.crt)


