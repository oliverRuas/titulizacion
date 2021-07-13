export FABRIC_CFG_PATH=$(cd ../ && pwd)
export CORE_PEER_MSPCONFIGPATH=$(cd ../ && echo $PWD/fabric-ca/servicer/admins/servicer-admin/msp)
export CLIENTAUTH_CERTFILE=$(cd ../ && echo $PWD/fabric-ca/servicer/admins/servicer-admin/tls/server.crt)
export CLIENTAUTH_KEYFILE=$(cd ../ && echo $PWD/fabric-ca/servicer/admins/servicer-admin/tls/server.key)
export CORE_PEER_LOCALMSPID=servicerMSP
export ORDERER_CA=$(cd ../ && echo $PWD/fabric-ca/servicer/orderers/servicer-orderer/tls/ca.crt)

# Create the application channel
peer channel create -o localhost:7050 -c securitization -f ../network/channel-artifacts/channel.tx --outputBlock ../network/channel-artifacts/securitization.genesis.block --tls --cafile $ORDERER_CA --clientauth --certfile $CLIENTAUTH_CERTFILE --keyfile $CLIENTAUTH_KEYFILE
sleep 2

# Let the peers join the channel
#servicer-peer
export CORE_PEER_ADDRESS=localhost:7051
export CORE_PEER_LOCALMSPID=servicerMSP
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_TLS_ROOTCERT_FILE=$(cd ../ && echo $PWD/fabric-ca/servicer/peers/servicer-peer/tls/ca.crt)
export CORE_PEER_MSPCONFIGPATH=$(cd ../ && echo $PWD/fabric-ca/servicer/admins/servicer-admin/msp)
peer channel join -b ../network/channel-artifacts/securitization.genesis.block

sleep 2

#farmer-peer
export CORE_PEER_ADDRESS=localhost:8051
export CORE_PEER_LOCALMSPID=farmerMSP
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_TLS_ROOTCERT_FILE=$(cd ../ && echo $PWD/fabric-ca/farmer/peers/farmer-peer/tls/ca.crt)
export CORE_PEER_MSPCONFIGPATH=$(cd ../ && echo $PWD/fabric-ca/farmer/admins/farmer-admin/msp)
peer channel join -b ../network/channel-artifacts/securitization.genesis.block

sleep 2

# #aggregator-peer
# export CORE_PEER_ADDRESS=localhost:9051
# export CORE_PEER_LOCALMSPID=aggregatorMSP
# export CORE_PEER_TLS_ENABLED=true
# export CORE_PEER_TLS_ROOTCERT_FILE=$(cd ../ && echo $PWD/fabric-ca/aggregator/peers/aggregator-peer/tls/ca.crt)
# export CORE_PEER_MSPCONFIGPATH=$(cd ../ && echo $PWD/fabric-ca/aggregator/admins/aggregator-admin/msp)
# peer channel join -b ../network/channel-artifacts/securitization.genesis.block

# sleep 2

#spv-peer
export CORE_PEER_ADDRESS=localhost:10051
export CORE_PEER_LOCALMSPID=spvMSP
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_TLS_ROOTCERT_FILE=$(cd ../ && echo $PWD/fabric-ca/spv/peers/spv-peer/tls/ca.crt)
export CORE_PEER_MSPCONFIGPATH=$(cd ../ && echo $PWD/fabric-ca/spv/admins/spv-admin/msp)
peer channel join -b ../network/channel-artifacts/securitization.genesis.block

sleep 2

#investor-peer
export CORE_PEER_ADDRESS=localhost:11051
export CORE_PEER_LOCALMSPID=investorMSP
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_TLS_ROOTCERT_FILE=$(cd ../ && echo $PWD/fabric-ca/investor/peers/investor-peer-1/tls/ca.crt)
export CORE_PEER_MSPCONFIGPATH=$(cd ../ && echo $PWD/fabric-ca/investor/admins/investor-admin/msp)
peer channel join -b ../network/channel-artifacts/securitization.genesis.block

sleep 2


# export CORE_PEER_ADDRESS=localhost:12051
# export CORE_PEER_LOCALMSPID=investorMSP
# export CORE_PEER_TLS_ENABLED=true
# export CORE_PEER_TLS_ROOTCERT_FILE=$(cd ../ && echo $PWD/fabric-ca/investor/peers/investor-peer-2/tls/ca.crt)
# export CORE_PEER_MSPCONFIGPATH=$(cd ../ && echo $PWD/fabric-ca/investor/admins/investor-admin/msp)
# peer channel join -b ../network/channel-artifacts/securitization.genesis.block

# sleep 2

# export CORE_PEER_ADDRESS=localhost:13051
# export CORE_PEER_LOCALMSPID=investorMSP
# export CORE_PEER_TLS_ENABLED=true
# export CORE_PEER_TLS_ROOTCERT_FILE=$(cd ../ && echo $PWD/fabric-ca/investor/peers/investor-peer-3/tls/ca.crt)
# export CORE_PEER_MSPCONFIGPATH=$(cd ../ && echo $PWD/fabric-ca/investor/admins/investor-admin/msp)
# peer channel join -b ../network/channel-artifacts/securitization.genesis.block

# sleep 2

# export CORE_PEER_ADDRESS=localhost:14051
# export CORE_PEER_LOCALMSPID=investorMSP
# export CORE_PEER_TLS_ENABLED=true
# export CORE_PEER_TLS_ROOTCERT_FILE=$(cd ../ && echo $PWD/fabric-ca/investor/peers/investor-peer-4/tls/ca.crt)
# export CORE_PEER_MSPCONFIGPATH=$(cd ../ && echo $PWD/fabric-ca/investor/admins/investor-admin/msp)
# peer channel join -b ../network/channel-artifacts/securitization.genesis.block

# sleep 2


# export CORE_PEER_ADDRESS=localhost:15051
# export CORE_PEER_LOCALMSPID=investorMSP
# export CORE_PEER_TLS_ENABLED=true
# export CORE_PEER_TLS_ROOTCERT_FILE=$(cd ../ && echo $PWD/fabric-ca/investor/peers/investor-peer-5/tls/ca.crt)
# export CORE_PEER_MSPCONFIGPATH=$(cd ../ && echo $PWD/fabric-ca/investor/admins/investor-admin/msp)
# peer channel join -b ../network/channel-artifacts/securitization.genesis.block

# sleep 2


# export CORE_PEER_ADDRESS=localhost:16051
# export CORE_PEER_LOCALMSPID=investorMSP
# export CORE_PEER_TLS_ENABLED=true
# export CORE_PEER_TLS_ROOTCERT_FILE=$(cd ../ && echo $PWD/fabric-ca/investor/peers/investor-peer-6/tls/ca.crt)
# export CORE_PEER_MSPCONFIGPATH=$(cd ../ && echo $PWD/fabric-ca/investor/admins/investor-admin/msp)
# peer channel join -b ../network/channel-artifacts/securitization.genesis.block

# sleep 2


# export CORE_PEER_ADDRESS=localhost:17051
# export CORE_PEER_LOCALMSPID=investorMSP
# export CORE_PEER_TLS_ENABLED=true
# export CORE_PEER_TLS_ROOTCERT_FILE=$(cd ../ && echo $PWD/fabric-ca/investor/peers/investor-peer-7/tls/ca.crt)
# export CORE_PEER_MSPCONFIGPATH=$(cd ../ && echo $PWD/fabric-ca/investor/admins/investor-admin/msp)
# peer channel join -b ../network/channel-artifacts/securitization.genesis.block

# sleep 2



# Set the anchor peers in the network. This let the peers communicate each other

#Originator


export CORE_PEER_ADDRESS=localhost:7051
export CORE_PEER_LOCALMSPID=servicerMSP
export CORE_PEER_MSPCONFIGPATH=$(cd ../ && echo $PWD/fabric-ca/servicer/admins/servicer-admin/msp)
export ORDERER_CA=$(cd ../ && echo $PWD/fabric-ca/servicer/orderers/servicer-orderer/tls/ca.crt)

peer channel update -c securitization -f ../network/channel-artifacts/servicerMSPanchors.tx -o localhost:7050 --tls --cafile $ORDERER_CA

sleep 2

#farmer


export CORE_PEER_ADDRESS=localhost:8051
export CORE_PEER_LOCALMSPID=farmerMSP
export CORE_PEER_MSPCONFIGPATH=$(cd ../ && echo $PWD/fabric-ca/farmer/admins/farmer-admin/msp)
export ORDERER_CA=$(cd ../ && echo $PWD/fabric-ca/farmer/orderers/farmer-orderer/tls/ca.crt)

peer channel update -c securitization -f ../network/channel-artifacts/farmerMSPanchors.tx -o localhost:8050 --tls --cafile $ORDERER_CA


sleep 2


#spv


export CORE_PEER_ADDRESS=localhost:10051
export CORE_PEER_LOCALMSPID=spvMSP
export CORE_PEER_MSPCONFIGPATH=$(cd ../ && echo $PWD/fabric-ca/spv/admins/spv-admin/msp)
export ORDERER_CA=$(cd ../ && echo $PWD/fabric-ca/spv/orderers/spv-orderer/tls/ca.crt)

peer channel update -c securitization -f ../network/channel-artifacts/spvMSPanchors.tx -o localhost:10050 --tls --cafile $ORDERER_CA

sleep 2

#investor


export CORE_PEER_ADDRESS=localhost:11051
export CORE_PEER_LOCALMSPID=investorMSP
export CORE_PEER_MSPCONFIGPATH=$(cd ../ && echo $PWD/fabric-ca/investor/admins/investor-admin/msp)
export ORDERER_CA=$(cd ../ && echo $PWD/fabric-ca/investor/orderers/investor-orderer/tls/ca.crt)

peer channel update -c securitization -f ../network/channel-artifacts/investorMSPanchors.tx -o localhost:11050 --tls --cafile $ORDERER_CA




