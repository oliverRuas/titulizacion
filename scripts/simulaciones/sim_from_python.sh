#!/usr/bin/env bash
let i=1
while IFS=, read -r payments
    do 
    # for i in {1..100}
        # do
    export NEW_PATH=$(cd .. && cd .. && echo $PWD)        
    export NUMERO=\'\{\"Args\"\:\[\"SimulatePayments\",$payments\]\}\'
    #echo $NUMERO
    export CORE_PEER_ADDRESS=localhost:8051
    export CORE_PEER_LOCALMSPID=farmerMSP
    export CORE_PEER_TLS_ROOTCERT_FILE=$(cd .. && cd .. && echo $PWD/fabric-ca/farmer/peers/farmer-peer/tls/ca.crt)
    export ORDERER_CA=$(cd .. && cd .. && echo $PWD/fabric-ca/farmer/orderers/farmer-orderer/tls/ca.crt)
    export ORDERER_ADDRESS=localhost:8050
    t=$NEW_PATH/fabric-ca/farmer/clients/farmer-client-$i/msp
    export CORE_PEER_MSPCONFIGPATH=$t
    export DATA=$(echo -n "{\"depositReference\":\"asdasdad\",\"bank\":\"Banco\"}" | base64 | tr -d \\n)
    export DATOS=\"\{\\\"farmerPrivateData\\\"\:\\\"$DATA\\\"\}\"
    echo peer chaincode invoke -o $ORDERER_ADDRESS --tls true --cafile $ORDERER_CA -C $CHANNEL_NAME -n $CC_NAME -c $NUMERO --peerAddresses $CORE_PEER_ADDRESS --peerAddresses localhost:7051 --peerAddresses localhost:10051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --tlsRootCertFiles  $(cd .. && cd .. && echo $PWD/fabric-ca/servicer/peers/servicer-peer/tls/ca.crt) --tlsRootCertFiles  $(cd .. && cd .. && echo $PWD/fabric-ca/spv/peers/spv-peer/tls/ca.crt) --transient $DATOS> simul.sh
    chmod +x ./simul.sh
    export CORE_PEER_ADDRESS=localhost:8051
    export CORE_PEER_LOCALMSPID=farmerMSP
    export CORE_PEER_TLS_ROOTCERT_FILE=$(cd .. && cd .. && echo $PWD/fabric-ca/farmer/peers/farmer-peer/tls/ca.crt)
    export ORDERER_CA=$(cd .. && cd .. && echo $PWD/fabric-ca/farmer/orderers/farmer-orderer/tls/ca.crt)
    export ORDERER_ADDRESS=localhost:8050
    t=$NEW_PATH/fabric-ca/farmer/clients/farmer-client-$i/msp
    export CORE_PEER_MSPCONFIGPATH=$t
    echo $CORE_PEER_MSPCONFIGPATH
    ./simul.sh
    let i=i+1
done < $1
