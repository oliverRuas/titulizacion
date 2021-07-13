#!/bin/sh
export NEW_PATH=$(cd .. && echo $PWD)
export CORE_PEER_ADDRESS=localhost:10051
export CORE_PEER_LOCALMSPID=spvMSP
export CORE_PEER_TLS_ROOTCERT_FILE=$(cd .. && echo $PWD/fabric-ca/spv/peers/spv-peer/tls/ca.crt)
export ORDERER_CA=$(cd .. && echo $PWD/fabric-ca/spv/orderers/spv-orderer/tls/ca.crt)
export ORDERER_ADDRESS=localhost:10050
t=$NEW_PATH/fabric-ca/spv/clients/spv-client/msp
export CORE_PEER_MSPCONFIGPATH=$t
while IFS=, read -r client
	do
		export KEY=$(cat new_utxo.txt)
		echo $key
		export NUMERO=\'\{\"Args\"\:\[\"DistributeCouponPrincipal\",\"\[\\\"$KEY\\\"\]\",\"$client\"\]\}\'
		echo peer chaincode invoke -o $ORDERER_ADDRESS --tls --cafile $ORDERER_CA -C $CHANNEL_NAME -n $CC_NAME -c $NUMERO --peerAddresses $CORE_PEER_ADDRESS --peerAddresses localhost:8051 --peerAddresses localhost:11051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --tlsRootCertFiles  $(cd .. && echo $PWD/fabric-ca/farmer/peers/farmer-peer/tls/ca.crt) --tlsRootCertFiles  $(cd .. && echo $PWD/fabric-ca/investor/peers/investor-peer-1/tls/ca.crt) > transfer_tokens.sh
    		chmod +x ./transfer_tokens.sh
    		./transfer_tokens.sh 2>&1 | tee utxo.json
		sleep 1
		python get_utxoID.py
		sleep 1
    	# let i=i+1
done < new_owners.txt
