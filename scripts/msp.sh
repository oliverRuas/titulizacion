#FARMER function for msp
export NEW_PATH=$(cd ../ && pwd)
function msp(){
	number=$1
	LOCAL_MSP_PATH=$NEW_PATH/fabric-ca/farmer/clients/farmer-client-$number/msp

	mkdir -p $LOCAL_MSP_PATH
	cp ./config.yaml $LOCAL_MSP_PATH
	mkdir $LOCAL_MSP_PATH/cacerts && cp ../network/fabric-ca/farmer/ca/ca-cert.pem $LOCAL_MSP_PATH/cacerts/ca-cert.pem
	mkdir $LOCAL_MSP_PATH/tlscacerts && cp ../network/fabric-ca/farmer/tls-ca/ca-cert.pem $LOCAL_MSP_PATH/tlscacerts/ca-cert.pem
	mkdir $LOCAL_MSP_PATH/signcerts && cp -r ../network/fabric-ca/farmer/ca/clients/farmer-client-$number/msp/signcerts $LOCAL_MSP_PATH/
	key=$(find ../network/fabric-ca/farmer/ca/clients/farmer-client-$number/msp/keystore -name *_sk)
	mkdir $LOCAL_MSP_PATH/keystore && cp $key $LOCAL_MSP_PATH/keystore/priv.key




	TLS_FOLDER_PATH=$NEW_PATH/fabric-ca/farmer/clients/farmer-client-$number/tls

	mkdir -p $TLS_FOLDER_PATH
	cp ../network/fabric-ca/farmer/tls-ca/ca-cert.pem $TLS_FOLDER_PATH/ca.crt
	cp ../network/fabric-ca/farmer/tls-ca/clients/farmer-client-$number/msp/signcerts/cert.pem $TLS_FOLDER_PATH/server.crt
	key=$(find ../network/fabric-ca/farmer/tls-ca/clients/farmer-client-$number/msp/keystore -name *_sk)
	cp $key $TLS_FOLDER_PATH/server.key

}

MSP_PATH=$NEW_PATH/fabric-ca/servicer/msp
mkdir -p $MSP_PATH
mkdir $MSP_PATH/cacerts && cp ../network/fabric-ca/servicer/ca/ca-cert.pem $MSP_PATH/cacerts/ca-cert.pem
mkdir $MSP_PATH/tlscacerts && cp ../network/fabric-ca/servicer/tls-ca/ca-cert.pem $MSP_PATH/tlscacerts/ca-cert.pem
cp ./config.yaml $MSP_PATH

MSP_PATH=$NEW_PATH/fabric-ca/farmer/msp
mkdir -p $MSP_PATH
mkdir $MSP_PATH/cacerts && cp ../network/fabric-ca/farmer/ca/ca-cert.pem $MSP_PATH/cacerts/ca-cert.pem
mkdir $MSP_PATH/tlscacerts && cp ../network/fabric-ca/farmer/tls-ca/ca-cert.pem $MSP_PATH/tlscacerts/ca-cert.pem
cp ./config.yaml $MSP_PATH

# MSP_PATH=$NEW_PATH/fabric-ca/aggregator/msp
# mkdir -p $MSP_PATH
# mkdir $MSP_PATH/cacerts && cp ../network/fabric-ca/aggregator/ca/ca-cert.pem $MSP_PATH/cacerts/ca-cert.pem
# mkdir $MSP_PATH/tlscacerts && cp ../network/fabric-ca/aggregator/tls-ca/ca-cert.pem $MSP_PATH/tlscacerts/ca-cert.pem
# cp ./config.yaml $MSP_PATH

MSP_PATH=$NEW_PATH/fabric-ca/spv/msp
mkdir -p $MSP_PATH
mkdir $MSP_PATH/cacerts && cp ../network/fabric-ca/spv/ca/ca-cert.pem $MSP_PATH/cacerts/ca-cert.pem
mkdir $MSP_PATH/tlscacerts && cp ../network/fabric-ca/spv/tls-ca/ca-cert.pem $MSP_PATH/tlscacerts/ca-cert.pem
cp ./config.yaml $MSP_PATH

MSP_PATH=$NEW_PATH/fabric-ca/investor/msp
mkdir -p $MSP_PATH
mkdir $MSP_PATH/cacerts && cp ../network/fabric-ca/investor/ca/ca-cert.pem $MSP_PATH/cacerts/ca-cert.pem
mkdir $MSP_PATH/tlscacerts && cp ../network/fabric-ca/investor/tls-ca/ca-cert.pem $MSP_PATH/tlscacerts/ca-cert.pem
cp ./config.yaml $MSP_PATH
#PEERS

#SERVICER
LOCAL_MSP_PATH=$NEW_PATH/fabric-ca/servicer/peers/servicer-peer/msp

mkdir -p $LOCAL_MSP_PATH
cp ./config.yaml $LOCAL_MSP_PATH
mkdir $LOCAL_MSP_PATH/cacerts && cp ../network/fabric-ca/servicer/ca/ca-cert.pem $LOCAL_MSP_PATH/cacerts/ca-cert.pem
mkdir $LOCAL_MSP_PATH/tlscacerts && cp ../network/fabric-ca/servicer/tls-ca/ca-cert.pem $LOCAL_MSP_PATH/tlscacerts/ca-cert.pem
mkdir $LOCAL_MSP_PATH/signcerts && cp -r ../network/fabric-ca/servicer/ca/clients/servicer-peer/msp/signcerts $LOCAL_MSP_PATH/
key=$(find ../network/fabric-ca/servicer/ca/clients/servicer-peer/msp/keystore -name *_sk)
mkdir $LOCAL_MSP_PATH/keystore && cp $key $LOCAL_MSP_PATH/keystore/priv.key


TLS_FOLDER_PATH=$NEW_PATH/fabric-ca/servicer/peers/servicer-peer/tls

mkdir -p $TLS_FOLDER_PATH
cp ../network/fabric-ca/servicer/tls-ca/ca-cert.pem $TLS_FOLDER_PATH/ca.crt
cp ../network/fabric-ca/servicer/tls-ca/clients/servicer-peer/msp/signcerts/cert.pem $TLS_FOLDER_PATH/server.crt
key=$(find ../network/fabric-ca/servicer/tls-ca/clients/servicer-peer/msp/keystore -name *_sk)
cp $key $TLS_FOLDER_PATH/server.key



#FARMER
LOCAL_MSP_PATH=$NEW_PATH/fabric-ca/farmer/peers/farmer-peer/msp

mkdir -p $LOCAL_MSP_PATH
cp ./config.yaml $LOCAL_MSP_PATH
mkdir $LOCAL_MSP_PATH/cacerts && cp ../network/fabric-ca/farmer/ca/ca-cert.pem $LOCAL_MSP_PATH/cacerts/ca-cert.pem
mkdir $LOCAL_MSP_PATH/tlscacerts && cp ../network/fabric-ca/farmer/tls-ca/ca-cert.pem $LOCAL_MSP_PATH/tlscacerts/ca-cert.pem
mkdir $LOCAL_MSP_PATH/signcerts && cp -r ../network/fabric-ca/farmer/ca/clients/farmer-peer/msp/signcerts $LOCAL_MSP_PATH/
key=$(find ../network/fabric-ca/farmer/ca/clients/farmer-peer/msp/keystore -name *_sk)
mkdir $LOCAL_MSP_PATH/keystore && cp $key $LOCAL_MSP_PATH/keystore/priv.key




TLS_FOLDER_PATH=$NEW_PATH/fabric-ca/farmer/peers/farmer-peer/tls

mkdir -p $TLS_FOLDER_PATH
cp ../network/fabric-ca/farmer/tls-ca/ca-cert.pem $TLS_FOLDER_PATH/ca.crt
cp ../network/fabric-ca/farmer/tls-ca/clients/farmer-peer/msp/signcerts/cert.pem $TLS_FOLDER_PATH/server.crt
key=$(find ../network/fabric-ca/farmer/tls-ca/clients/farmer-peer/msp/keystore -name *_sk)
cp $key $TLS_FOLDER_PATH/server.key



# #AGGREGATOR
# LOCAL_MSP_PATH=$NEW_PATH/fabric-ca/aggregator/peers/aggregator-peer/msp

# mkdir -p $LOCAL_MSP_PATH
# cp ./config.yaml $LOCAL_MSP_PATH
# mkdir $LOCAL_MSP_PATH/cacerts && cp ../network/fabric-ca/aggregator/ca/ca-cert.pem $LOCAL_MSP_PATH/cacerts/ca-cert.pem
# mkdir $LOCAL_MSP_PATH/tlscacerts && cp ../network/fabric-ca/aggregator/tls-ca/ca-cert.pem $LOCAL_MSP_PATH/tlscacerts/ca-cert.pem
# mkdir $LOCAL_MSP_PATH/signcerts && cp -r ../network/fabric-ca/aggregator/ca/clients/aggregator-peer/msp/signcerts $LOCAL_MSP_PATH/
# key=$(find ../network/fabric-ca/aggregator/ca/clients/aggregator-peer/msp/keystore -name *_sk)
# mkdir $LOCAL_MSP_PATH/keystore && cp $key $LOCAL_MSP_PATH/keystore/priv.key


# TLS_FOLDER_PATH=$NEW_PATH/fabric-ca/aggregator/peers/aggregator-peer/tls

# mkdir -p $TLS_FOLDER_PATH
# cp ../network/fabric-ca/aggregator/tls-ca/ca-cert.pem $TLS_FOLDER_PATH/ca.crt
# cp ../network/fabric-ca/aggregator/tls-ca/clients/aggregator-peer/msp/signcerts/cert.pem $TLS_FOLDER_PATH/server.crt
# key=$(find ../network/fabric-ca/aggregator/tls-ca/clients/aggregator-peer/msp/keystore -name *_sk)
# cp $key $TLS_FOLDER_PATH/server.key


#SPV
LOCAL_MSP_PATH=$NEW_PATH/fabric-ca/spv/peers/spv-peer/msp

mkdir -p $LOCAL_MSP_PATH
cp ./config.yaml $LOCAL_MSP_PATH
mkdir $LOCAL_MSP_PATH/cacerts && cp ../network/fabric-ca/spv/ca/ca-cert.pem $LOCAL_MSP_PATH/cacerts/ca-cert.pem
mkdir $LOCAL_MSP_PATH/tlscacerts && cp ../network/fabric-ca/spv/tls-ca/ca-cert.pem $LOCAL_MSP_PATH/tlscacerts/ca-cert.pem
mkdir $LOCAL_MSP_PATH/signcerts && cp -r ../network/fabric-ca/spv/ca/clients/spv-peer/msp/signcerts $LOCAL_MSP_PATH/
key=$(find ../network/fabric-ca/spv/ca/clients/spv-peer/msp/keystore -name *_sk)
mkdir $LOCAL_MSP_PATH/keystore && cp $key $LOCAL_MSP_PATH/keystore/priv.key




TLS_FOLDER_PATH=$NEW_PATH/fabric-ca/spv/peers/spv-peer/tls

mkdir -p $TLS_FOLDER_PATH
cp ../network/fabric-ca/spv/tls-ca/ca-cert.pem $TLS_FOLDER_PATH/ca.crt
cp ../network/fabric-ca/spv/tls-ca/clients/spv-peer/msp/signcerts/cert.pem $TLS_FOLDER_PATH/server.crt
key=$(find ../network/fabric-ca/spv/tls-ca/clients/spv-peer/msp/keystore -name *_sk)
cp $key $TLS_FOLDER_PATH/server.key


#INVESTOR



function msppeer(){

	number=$1
	LOCAL_MSP_PATH=$NEW_PATH/fabric-ca/investor/peers/investor-peer-$number/msp

	mkdir -p $LOCAL_MSP_PATH
	cp ./config.yaml $LOCAL_MSP_PATH
	mkdir $LOCAL_MSP_PATH/cacerts && cp ../network/fabric-ca/investor/ca/ca-cert.pem $LOCAL_MSP_PATH/cacerts/ca-cert.pem
	mkdir $LOCAL_MSP_PATH/tlscacerts && cp ../network/fabric-ca/investor/tls-ca/ca-cert.pem $LOCAL_MSP_PATH/tlscacerts/ca-cert.pem
	mkdir $LOCAL_MSP_PATH/signcerts && cp -r ../network/fabric-ca/investor/ca/clients/investor-peer-$number/msp/signcerts $LOCAL_MSP_PATH/
	key=$(find ../network/fabric-ca/investor/ca/clients/investor-peer-$number/msp/keystore -name *_sk)
	mkdir $LOCAL_MSP_PATH/keystore && cp $key $LOCAL_MSP_PATH/keystore/priv.key




	TLS_FOLDER_PATH=$NEW_PATH/fabric-ca/investor/peers/investor-peer-$number/tls

	mkdir -p $TLS_FOLDER_PATH
	cp ../network/fabric-ca/investor/tls-ca/ca-cert.pem $TLS_FOLDER_PATH/ca.crt
	cp ../network/fabric-ca/investor/tls-ca/clients/investor-peer-$number/msp/signcerts/cert.pem $TLS_FOLDER_PATH/server.crt
	key=$(find ../network/fabric-ca/investor/tls-ca/clients/investor-peer-$number/msp/keystore -name *_sk)
	cp $key $TLS_FOLDER_PATH/server.key


}

for i in {1..1}
do
	msppeer $i
done


#ORDERERS
#
LOCAL_MSP_PATH=$NEW_PATH/fabric-ca/servicer/orderers/servicer-orderer/msp

mkdir -p $LOCAL_MSP_PATH
cp ./config.yaml $LOCAL_MSP_PATH
mkdir $LOCAL_MSP_PATH/cacerts && cp ../network/fabric-ca/servicer/ca/ca-cert.pem $LOCAL_MSP_PATH/cacerts/ca-cert.pem
mkdir $LOCAL_MSP_PATH/tlscacerts && cp ../network/fabric-ca/servicer/tls-ca/ca-cert.pem $LOCAL_MSP_PATH/tlscacerts/ca-cert.pem
mkdir $LOCAL_MSP_PATH/signcerts && cp -r ../network/fabric-ca/servicer/ca/clients/servicer-orderer/msp/signcerts $LOCAL_MSP_PATH/
key=$(find ../network/fabric-ca/servicer/ca/clients/servicer-orderer/msp/keystore -name *_sk)
mkdir $LOCAL_MSP_PATH/keystore && cp $key $LOCAL_MSP_PATH/keystore/priv.key


TLS_FOLDER_PATH=$NEW_PATH/fabric-ca/servicer/orderers/servicer-orderer/tls

mkdir -p $TLS_FOLDER_PATH
cp ../network/fabric-ca/servicer/tls-ca/ca-cert.pem $TLS_FOLDER_PATH/ca.crt
cp ../network/fabric-ca/servicer/tls-ca/clients/servicer-orderer/msp/signcerts/cert.pem $TLS_FOLDER_PATH/server.crt
key=$(find ../network/fabric-ca/servicer/tls-ca/clients/servicer-orderer/msp/keystore -name *_sk)
cp $key $TLS_FOLDER_PATH/server.key


#FARMER
LOCAL_MSP_PATH=$NEW_PATH/fabric-ca/farmer/orderers/farmer-orderer/msp

mkdir -p $LOCAL_MSP_PATH
cp ./config.yaml $LOCAL_MSP_PATH
mkdir $LOCAL_MSP_PATH/cacerts && cp ../network/fabric-ca/farmer/ca/ca-cert.pem $LOCAL_MSP_PATH/cacerts/ca-cert.pem
mkdir $LOCAL_MSP_PATH/tlscacerts && cp ../network/fabric-ca/farmer/tls-ca/ca-cert.pem $LOCAL_MSP_PATH/tlscacerts/ca-cert.pem
mkdir $LOCAL_MSP_PATH/signcerts && cp -r ../network/fabric-ca/farmer/ca/clients/farmer-orderer/msp/signcerts $LOCAL_MSP_PATH/
key=$(find ../network/fabric-ca/farmer/ca/clients/farmer-orderer/msp/keystore -name *_sk)
mkdir $LOCAL_MSP_PATH/keystore && cp $key $LOCAL_MSP_PATH/keystore/priv.key




TLS_FOLDER_PATH=$NEW_PATH/fabric-ca/farmer/orderers/farmer-orderer/tls

mkdir -p $TLS_FOLDER_PATH
cp ../network/fabric-ca/farmer/tls-ca/ca-cert.pem $TLS_FOLDER_PATH/ca.crt
cp ../network/fabric-ca/farmer/tls-ca/clients/farmer-orderer/msp/signcerts/cert.pem $TLS_FOLDER_PATH/server.crt
key=$(find ../network/fabric-ca/farmer/tls-ca/clients/farmer-orderer/msp/keystore -name *_sk)
cp $key $TLS_FOLDER_PATH/server.key



# #AGGREGATOR
# LOCAL_MSP_PATH=$NEW_PATH/fabric-ca/aggregator/orderers/aggregator-orderer/msp

# mkdir -p $LOCAL_MSP_PATH
# cp ./config.yaml $LOCAL_MSP_PATH
# mkdir $LOCAL_MSP_PATH/cacerts && cp ../network/fabric-ca/aggregator/ca/ca-cert.pem $LOCAL_MSP_PATH/cacerts/ca-cert.pem
# mkdir $LOCAL_MSP_PATH/tlscacerts && cp ../network/fabric-ca/aggregator/tls-ca/ca-cert.pem $LOCAL_MSP_PATH/tlscacerts/ca-cert.pem
# mkdir $LOCAL_MSP_PATH/signcerts && cp -r ../network/fabric-ca/aggregator/ca/clients/aggregator-orderer/msp/signcerts $LOCAL_MSP_PATH/
# key=$(find ../network/fabric-ca/aggregator/ca/clients/aggregator-orderer/msp/keystore -name *_sk)
# mkdir $LOCAL_MSP_PATH/keystore && cp $key $LOCAL_MSP_PATH/keystore/priv.key


# TLS_FOLDER_PATH=$NEW_PATH/fabric-ca/aggregator/orderers/aggregator-orderer/tls

# mkdir -p $TLS_FOLDER_PATH
# cp ../network/fabric-ca/aggregator/tls-ca/ca-cert.pem $TLS_FOLDER_PATH/ca.crt
# cp ../network/fabric-ca/aggregator/tls-ca/clients/aggregator-orderer/msp/signcerts/cert.pem $TLS_FOLDER_PATH/server.crt
# key=$(find ../network/fabric-ca/aggregator/tls-ca/clients/aggregator-orderer/msp/keystore -name *_sk)
# cp $key $TLS_FOLDER_PATH/server.key


#SPV
LOCAL_MSP_PATH=$NEW_PATH/fabric-ca/spv/orderers/spv-orderer/msp

mkdir -p $LOCAL_MSP_PATH
cp ./config.yaml $LOCAL_MSP_PATH
mkdir $LOCAL_MSP_PATH/cacerts && cp ../network/fabric-ca/spv/ca/ca-cert.pem $LOCAL_MSP_PATH/cacerts/ca-cert.pem
mkdir $LOCAL_MSP_PATH/tlscacerts && cp ../network/fabric-ca/spv/tls-ca/ca-cert.pem $LOCAL_MSP_PATH/tlscacerts/ca-cert.pem
mkdir $LOCAL_MSP_PATH/signcerts && cp -r ../network/fabric-ca/spv/ca/clients/spv-orderer/msp/signcerts $LOCAL_MSP_PATH/
key=$(find ../network/fabric-ca/spv/ca/clients/spv-orderer/msp/keystore -name *_sk)
mkdir $LOCAL_MSP_PATH/keystore && cp $key $LOCAL_MSP_PATH/keystore/priv.key


TLS_FOLDER_PATH=$NEW_PATH/fabric-ca/spv/orderers/spv-orderer/tls

mkdir -p $TLS_FOLDER_PATH
cp ../network/fabric-ca/spv/tls-ca/ca-cert.pem $TLS_FOLDER_PATH/ca.crt
cp ../network/fabric-ca/spv/tls-ca/clients/spv-orderer/msp/signcerts/cert.pem $TLS_FOLDER_PATH/server.crt
key=$(find ../network/fabric-ca/spv/tls-ca/clients/spv-orderer/msp/keystore -name *_sk)
cp $key $TLS_FOLDER_PATH/server.key


#INVESTOR
LOCAL_MSP_PATH=$NEW_PATH/fabric-ca/investor/orderers/investor-orderer/msp

mkdir -p $LOCAL_MSP_PATH
cp ./config.yaml $LOCAL_MSP_PATH
mkdir $LOCAL_MSP_PATH/cacerts && cp ../network/fabric-ca/investor/ca/ca-cert.pem $LOCAL_MSP_PATH/cacerts/ca-cert.pem
mkdir $LOCAL_MSP_PATH/tlscacerts && cp ../network/fabric-ca/investor/tls-ca/ca-cert.pem $LOCAL_MSP_PATH/tlscacerts/ca-cert.pem
mkdir $LOCAL_MSP_PATH/signcerts && cp -r ../network/fabric-ca/investor/ca/clients/investor-orderer/msp/signcerts $LOCAL_MSP_PATH/
key=$(find ../network/fabric-ca/investor/ca/clients/investor-orderer/msp/keystore -name *_sk)
mkdir $LOCAL_MSP_PATH/keystore && cp $key $LOCAL_MSP_PATH/keystore/priv.key


TLS_FOLDER_PATH=$NEW_PATH/fabric-ca/investor/orderers/investor-orderer/tls

mkdir -p $TLS_FOLDER_PATH
cp ../network/fabric-ca/investor/tls-ca/ca-cert.pem $TLS_FOLDER_PATH/ca.crt
cp ../network/fabric-ca/investor/tls-ca/clients/investor-orderer/msp/signcerts/cert.pem $TLS_FOLDER_PATH/server.crt
key=$(find ../network/fabric-ca/investor/tls-ca/clients/investor-orderer/msp/keystore -name *_sk)
cp $key $TLS_FOLDER_PATH/server.key


#CLIENTS
#SERVICER
LOCAL_MSP_PATH=$NEW_PATH/fabric-ca/servicer/clients/servicer-client/msp

mkdir -p $LOCAL_MSP_PATH
cp ./config.yaml $LOCAL_MSP_PATH
mkdir $LOCAL_MSP_PATH/cacerts && cp ../network/fabric-ca/servicer/ca/ca-cert.pem $LOCAL_MSP_PATH/cacerts/ca-cert.pem
mkdir $LOCAL_MSP_PATH/tlscacerts && cp ../network/fabric-ca/servicer/tls-ca/ca-cert.pem $LOCAL_MSP_PATH/tlscacerts/ca-cert.pem
mkdir $LOCAL_MSP_PATH/signcerts && cp -r ../network/fabric-ca/servicer/ca/clients/servicer-client/msp/signcerts $LOCAL_MSP_PATH/
key=$(find ../network/fabric-ca/servicer/ca/clients/servicer-client/msp/keystore -name *_sk)
mkdir $LOCAL_MSP_PATH/keystore && cp $key $LOCAL_MSP_PATH/keystore/priv.key


TLS_FOLDER_PATH=$NEW_PATH/fabric-ca/servicer/clients/servicer-client/tls

mkdir -p $TLS_FOLDER_PATH
cp ../network/fabric-ca/servicer/tls-ca/ca-cert.pem $TLS_FOLDER_PATH/ca.crt
cp ../network/fabric-ca/servicer/tls-ca/clients/servicer-client/msp/signcerts/cert.pem $TLS_FOLDER_PATH/server.crt
key=$(find ../network/fabric-ca/servicer/tls-ca/clients/servicer-client/msp/keystore -name *_sk)
cp $key $TLS_FOLDER_PATH/server.key



for i in {1..5}
do
	msp $i
done



#AGGREGATOR
# LOCAL_MSP_PATH=$NEW_PATH/fabric-ca/aggregator/clients/aggregator-client/msp

# mkdir -p $LOCAL_MSP_PATH
# cp ./config.yaml $LOCAL_MSP_PATH
# mkdir $LOCAL_MSP_PATH/cacerts && cp ../network/fabric-ca/aggregator/ca/ca-cert.pem $LOCAL_MSP_PATH/cacerts/ca-cert.pem
# mkdir $LOCAL_MSP_PATH/tlscacerts && cp ../network/fabric-ca/aggregator/tls-ca/ca-cert.pem $LOCAL_MSP_PATH/tlscacerts/ca-cert.pem
# mkdir $LOCAL_MSP_PATH/signcerts && cp -r ../network/fabric-ca/aggregator/ca/clients/aggregator-client/msp/signcerts $LOCAL_MSP_PATH/
# key=$(find ../network/fabric-ca/aggregator/ca/clients/aggregator-client/msp/keystore -name *_sk)
# mkdir $LOCAL_MSP_PATH/keystore && cp $key $LOCAL_MSP_PATH/keystore/priv.key




# TLS_FOLDER_PATH=$NEW_PATH/fabric-ca/aggregator/clients/aggregator-client/tls

# mkdir -p $TLS_FOLDER_PATH
# cp ../network/fabric-ca/aggregator/tls-ca/ca-cert.pem $TLS_FOLDER_PATH/ca.crt
# cp ../network/fabric-ca/aggregator/tls-ca/clients/aggregator-client/msp/signcerts/cert.pem $TLS_FOLDER_PATH/server.crt
# key=$(find ../network/fabric-ca/aggregator/tls-ca/clients/aggregator-client/msp/keystore -name *_sk)
# cp $key $TLS_FOLDER_PATH/server.key



#SPV
LOCAL_MSP_PATH=$NEW_PATH/fabric-ca/spv/clients/spv-client/msp

mkdir -p $LOCAL_MSP_PATH
cp ./config.yaml $LOCAL_MSP_PATH
mkdir $LOCAL_MSP_PATH/cacerts && cp ../network/fabric-ca/spv/ca/ca-cert.pem $LOCAL_MSP_PATH/cacerts/ca-cert.pem
mkdir $LOCAL_MSP_PATH/tlscacerts && cp ../network/fabric-ca/spv/tls-ca/ca-cert.pem $LOCAL_MSP_PATH/tlscacerts/ca-cert.pem
mkdir $LOCAL_MSP_PATH/signcerts && cp -r ../network/fabric-ca/spv/ca/clients/spv-client/msp/signcerts $LOCAL_MSP_PATH/
key=$(find ../network/fabric-ca/spv/ca/clients/spv-client/msp/keystore -name *_sk)
mkdir $LOCAL_MSP_PATH/keystore && cp $key $LOCAL_MSP_PATH/keystore/priv.key


TLS_FOLDER_PATH=$NEW_PATH/fabric-ca/spv/clients/spv-client/tls

mkdir -p $TLS_FOLDER_PATH
cp ../network/fabric-ca/spv/tls-ca/ca-cert.pem $TLS_FOLDER_PATH/ca.crt
cp ../network/fabric-ca/spv/tls-ca/clients/spv-client/msp/signcerts/cert.pem $TLS_FOLDER_PATH/server.crt
key=$(find ../network/fabric-ca/spv/tls-ca/clients/spv-client/msp/keystore -name *_sk)
cp $key $TLS_FOLDER_PATH/server.key


# #UNDERWRITTER
# LOCAL_MSP_PATH=$NEW_PATH/fabric-ca/underwritter/clients/underwritter-client/msp

# mkdir -p $LOCAL_MSP_PATH
# cp ./config.yaml $LOCAL_MSP_PATH
# mkdir $LOCAL_MSP_PATH/cacerts && cp ../network/fabric-ca/underwritter/ca/ca-cert.pem $LOCAL_MSP_PATH/cacerts/ca-cert.pem
# mkdir $LOCAL_MSP_PATH/tlscacerts && cp ../network/fabric-ca/underwritter/tls-ca/ca-cert.pem $LOCAL_MSP_PATH/tlscacerts/ca-cert.pem
# mkdir $LOCAL_MSP_PATH/signcerts && cp -r ../network/fabric-ca/underwritter/ca/clients/underwritter-client/msp/signcerts $LOCAL_MSP_PATH/
# key=$(find ../network/fabric-ca/underwritter/ca/clients/underwritter-client/msp/keystore -name *_sk)
# mkdir $LOCAL_MSP_PATH/keystore && cp $key $LOCAL_MSP_PATH/keystore/priv.key


# TLS_FOLDER_PATH=$NEW_PATH/fabric-ca/underwritter/clients/underwritter-client/tls

# mkdir -p $TLS_FOLDER_PATH
# cp ../network/fabric-ca/underwritter/tls-ca/ca-cert.pem $TLS_FOLDER_PATH/ca.crt
# cp ../network/fabric-ca/underwritter/tls-ca/clients/underwritter-client/msp/signcerts/cert.pem $TLS_FOLDER_PATH/server.crt
# key=$(find ../network/fabric-ca/underwritter/tls-ca/clients/underwritter-client/msp/keystore -name *_sk)
# cp $key $TLS_FOLDER_PATH/server.key



#ADMINS 

#Servicer
LOCAL_MSP_PATH=$NEW_PATH/fabric-ca/servicer/admins/servicer-admin/msp

mkdir -p $LOCAL_MSP_PATH
cp ./config.yaml $LOCAL_MSP_PATH
mkdir $LOCAL_MSP_PATH/cacerts && cp ../network/fabric-ca/servicer/ca/ca-cert.pem $LOCAL_MSP_PATH/cacerts/ca-cert.pem
mkdir $LOCAL_MSP_PATH/tlscacerts && cp ../network/fabric-ca/servicer/tls-ca/ca-cert.pem $LOCAL_MSP_PATH/tlscacerts/ca-cert.pem
mkdir $LOCAL_MSP_PATH/signcerts && cp -r ../network/fabric-ca/servicer/ca/clients/servicer-admin/msp/signcerts $LOCAL_MSP_PATH/
key=$(find ../network/fabric-ca/servicer/ca/clients/servicer-admin/msp/keystore -name *_sk)
mkdir $LOCAL_MSP_PATH/keystore && cp $key $LOCAL_MSP_PATH/keystore/priv.key


TLS_FOLDER_PATH=$NEW_PATH/fabric-ca/servicer/admins/servicer-admin/tls

mkdir -p $TLS_FOLDER_PATH
cp ../network/fabric-ca/servicer/tls-ca/ca-cert.pem $TLS_FOLDER_PATH/ca.crt
cp ../network/fabric-ca/servicer/tls-ca/clients/servicer-admin/msp/signcerts/cert.pem $TLS_FOLDER_PATH/server.crt
key=$(find ../network/fabric-ca/servicer/tls-ca/clients/servicer-admin/msp/keystore -name *_sk)
cp $key $TLS_FOLDER_PATH/server.key


#FARMER
LOCAL_MSP_PATH=$NEW_PATH/fabric-ca/farmer/admins/farmer-admin/msp

mkdir -p $LOCAL_MSP_PATH
cp ./config.yaml $LOCAL_MSP_PATH
mkdir $LOCAL_MSP_PATH/cacerts && cp ../network/fabric-ca/farmer/ca/ca-cert.pem $LOCAL_MSP_PATH/cacerts/ca-cert.pem
mkdir $LOCAL_MSP_PATH/tlscacerts && cp ../network/fabric-ca/farmer/tls-ca/ca-cert.pem $LOCAL_MSP_PATH/tlscacerts/ca-cert.pem
mkdir $LOCAL_MSP_PATH/signcerts && cp -r ../network/fabric-ca/farmer/ca/clients/farmer-admin/msp/signcerts $LOCAL_MSP_PATH/
key=$(find ../network/fabric-ca/farmer/ca/clients/farmer-admin/msp/keystore -name *_sk)
mkdir $LOCAL_MSP_PATH/keystore && cp $key $LOCAL_MSP_PATH/keystore/priv.key




TLS_FOLDER_PATH=$NEW_PATH/fabric-ca/farmer/admins/farmer-admin/tls

mkdir -p $TLS_FOLDER_PATH
cp ../network/fabric-ca/farmer/tls-ca/ca-cert.pem $TLS_FOLDER_PATH/ca.crt
cp ../network/fabric-ca/farmer/tls-ca/clients/farmer-admin/msp/signcerts/cert.pem $TLS_FOLDER_PATH/server.crt
key=$(find ../network/fabric-ca/farmer/tls-ca/clients/farmer-admin/msp/keystore -name *_sk)
cp $key $TLS_FOLDER_PATH/server.key


# #AGGREGATOR
# LOCAL_MSP_PATH=$NEW_PATH/fabric-ca/aggregator/admins/aggregator-admin/msp

# mkdir -p $LOCAL_MSP_PATH
# cp ./config.yaml $LOCAL_MSP_PATH
# mkdir $LOCAL_MSP_PATH/cacerts && cp ../network/fabric-ca/aggregator/ca/ca-cert.pem $LOCAL_MSP_PATH/cacerts/ca-cert.pem
# mkdir $LOCAL_MSP_PATH/tlscacerts && cp ../network/fabric-ca/aggregator/tls-ca/ca-cert.pem $LOCAL_MSP_PATH/tlscacerts/ca-cert.pem
# mkdir $LOCAL_MSP_PATH/signcerts && cp -r ../network/fabric-ca/aggregator/ca/clients/aggregator-admin/msp/signcerts $LOCAL_MSP_PATH/
# key=$(find ../network/fabric-ca/aggregator/ca/clients/aggregator-admin/msp/keystore -name *_sk)
# mkdir $LOCAL_MSP_PATH/keystore && cp $key $LOCAL_MSP_PATH/keystore/priv.key




# TLS_FOLDER_PATH=$NEW_PATH/fabric-ca/aggregator/admins/aggregator-admin/tls

# mkdir -p $TLS_FOLDER_PATH
# cp ../network/fabric-ca/aggregator/tls-ca/ca-cert.pem $TLS_FOLDER_PATH/ca.crt
# cp ../network/fabric-ca/aggregator/tls-ca/clients/aggregator-admin/msp/signcerts/cert.pem $TLS_FOLDER_PATH/server.crt
# key=$(find ../network/fabric-ca/aggregator/tls-ca/clients/aggregator-admin/msp/keystore -name *_sk)
# cp $key $TLS_FOLDER_PATH/server.key



#SPV
LOCAL_MSP_PATH=$NEW_PATH/fabric-ca/spv/admins/spv-admin/msp

mkdir -p $LOCAL_MSP_PATH
cp ./config.yaml $LOCAL_MSP_PATH
mkdir $LOCAL_MSP_PATH/cacerts && cp ../network/fabric-ca/spv/ca/ca-cert.pem $LOCAL_MSP_PATH/cacerts/ca-cert.pem
mkdir $LOCAL_MSP_PATH/tlscacerts && cp ../network/fabric-ca/spv/tls-ca/ca-cert.pem $LOCAL_MSP_PATH/tlscacerts/ca-cert.pem
mkdir $LOCAL_MSP_PATH/signcerts && cp -r ../network/fabric-ca/spv/ca/clients/spv-admin/msp/signcerts $LOCAL_MSP_PATH/
key=$(find ../network/fabric-ca/spv/ca/clients/spv-admin/msp/keystore -name *_sk)
mkdir $LOCAL_MSP_PATH/keystore && cp $key $LOCAL_MSP_PATH/keystore/priv.key


TLS_FOLDER_PATH=$NEW_PATH/fabric-ca/spv/admins/spv-admin/tls

mkdir -p $TLS_FOLDER_PATH
cp ../network/fabric-ca/spv/tls-ca/ca-cert.pem $TLS_FOLDER_PATH/ca.crt
cp ../network/fabric-ca/spv/tls-ca/clients/spv-admin/msp/signcerts/cert.pem $TLS_FOLDER_PATH/server.crt
key=$(find ../network/fabric-ca/spv/tls-ca/clients/spv-admin/msp/keystore -name *_sk)
cp $key $TLS_FOLDER_PATH/server.key


#INVESTOR
LOCAL_MSP_PATH=$NEW_PATH/fabric-ca/investor/admins/investor-admin/msp

mkdir -p $LOCAL_MSP_PATH
cp ./config.yaml $LOCAL_MSP_PATH
mkdir $LOCAL_MSP_PATH/cacerts && cp ../network/fabric-ca/investor/ca/ca-cert.pem $LOCAL_MSP_PATH/cacerts/ca-cert.pem
mkdir $LOCAL_MSP_PATH/tlscacerts && cp ../network/fabric-ca/investor/tls-ca/ca-cert.pem $LOCAL_MSP_PATH/tlscacerts/ca-cert.pem
mkdir $LOCAL_MSP_PATH/signcerts && cp -r ../network/fabric-ca/investor/ca/clients/investor-admin/msp/signcerts $LOCAL_MSP_PATH/
key=$(find ../network/fabric-ca/investor/ca/clients/investor-admin/msp/keystore -name *_sk)
mkdir $LOCAL_MSP_PATH/keystore && cp $key $LOCAL_MSP_PATH/keystore/priv.key


TLS_FOLDER_PATH=$NEW_PATH/fabric-ca/investor/admins/investor-admin/tls

mkdir -p $TLS_FOLDER_PATH
cp ../network/fabric-ca/investor/tls-ca/ca-cert.pem $TLS_FOLDER_PATH/ca.crt
cp ../network/fabric-ca/investor/tls-ca/clients/investor-admin/msp/signcerts/cert.pem $TLS_FOLDER_PATH/server.crt
key=$(find ../network/fabric-ca/investor/tls-ca/clients/investor-admin/msp/keystore -name *_sk)
cp $key $TLS_FOLDER_PATH/server.key




#CAs

#SERVICER
LOCAL_MSP_PATH=$NEW_PATH/fabric-ca/servicer/cas/servicer-ca/msp

mkdir -p $LOCAL_MSP_PATH
cp ./config.yaml $LOCAL_MSP_PATH
mkdir $LOCAL_MSP_PATH/cacerts && cp ../network/fabric-ca/servicer/ca/ca-cert.pem $LOCAL_MSP_PATH/cacerts/ca-cert.pem
mkdir $LOCAL_MSP_PATH/tlscacerts && cp ../network/fabric-ca/servicer/tls-ca/ca-cert.pem $LOCAL_MSP_PATH/tlscacerts/ca-cert.pem
mkdir $LOCAL_MSP_PATH/signcerts && cp -r ../network/fabric-ca/servicer/ca/clients/admin/msp/signcerts $LOCAL_MSP_PATH/
key=$(find ../network/fabric-ca/servicer/ca/clients/admin/msp/keystore -name *_sk)
mkdir $LOCAL_MSP_PATH/keystore && cp $key $LOCAL_MSP_PATH/keystore/priv.key


TLS_FOLDER_PATH=$NEW_PATH/fabric-ca/servicer/tlscas/servicer-tlsca/tls

mkdir -p $TLS_FOLDER_PATH
cp ../network/fabric-ca/servicer/tls-ca/ca-cert.pem $TLS_FOLDER_PATH/ca.crt
cp ../network/fabric-ca/servicer/tls-ca/clients/admin/msp/signcerts/cert.pem $TLS_FOLDER_PATH/server.crt
key=$(find ../network/fabric-ca/servicer/tls-ca/clients/admin/msp/keystore -name *_sk)
cp $key $TLS_FOLDER_PATH/server.key


#FARMER
LOCAL_MSP_PATH=$NEW_PATH/fabric-ca/farmer/cas/farmer-ca/msp

mkdir -p $LOCAL_MSP_PATH
cp ./config.yaml $LOCAL_MSP_PATH
mkdir $LOCAL_MSP_PATH/cacerts && cp ../network/fabric-ca/farmer/ca/ca-cert.pem $LOCAL_MSP_PATH/cacerts/ca-cert.pem
mkdir $LOCAL_MSP_PATH/tlscacerts && cp ../network/fabric-ca/farmer/tls-ca/ca-cert.pem $LOCAL_MSP_PATH/tlscacerts/ca-cert.pem
mkdir $LOCAL_MSP_PATH/signcerts && cp -r ../network/fabric-ca/farmer/ca/clients/admin/msp/signcerts $LOCAL_MSP_PATH/
key=$(find ../network/fabric-ca/farmer/ca/clients/admin/msp/keystore -name *_sk)
mkdir $LOCAL_MSP_PATH/keystore && cp $key $LOCAL_MSP_PATH/keystore/priv.key




TLS_FOLDER_PATH=$NEW_PATH/fabric-ca/farmer/tlscas/farmer-tlsca/tls

mkdir -p $TLS_FOLDER_PATH
cp ../network/fabric-ca/farmer/tls-ca/ca-cert.pem $TLS_FOLDER_PATH/ca.crt
cp ../network/fabric-ca/farmer/tls-ca/clients/admin/msp/signcerts/cert.pem $TLS_FOLDER_PATH/server.crt
key=$(find ../network/fabric-ca/farmer/tls-ca/clients/admin/msp/keystore -name *_sk)
cp $key $TLS_FOLDER_PATH/server.key


# #AGGREGATOR
# LOCAL_MSP_PATH=$NEW_PATH/fabric-ca/aggregator/cas/aggregator-ca/msp

# mkdir -p $LOCAL_MSP_PATH
# cp ./config.yaml $LOCAL_MSP_PATH
# mkdir $LOCAL_MSP_PATH/cacerts && cp ../network/fabric-ca/aggregator/ca/ca-cert.pem $LOCAL_MSP_PATH/cacerts/ca-cert.pem
# mkdir $LOCAL_MSP_PATH/tlscacerts && cp ../network/fabric-ca/aggregator/tls-ca/ca-cert.pem $LOCAL_MSP_PATH/tlscacerts/ca-cert.pem
# mkdir $LOCAL_MSP_PATH/signcerts && cp -r ../network/fabric-ca/aggregator/ca/clients/admin/msp/signcerts $LOCAL_MSP_PATH/
# key=$(find ../network/fabric-ca/aggregator/ca/clients/admin/msp/keystore -name *_sk)
# mkdir $LOCAL_MSP_PATH/keystore && cp $key $LOCAL_MSP_PATH/keystore/priv.key




# TLS_FOLDER_PATH=$NEW_PATH/fabric-ca/aggregator/tlscas/aggregator-tlsca/tls

# mkdir -p $TLS_FOLDER_PATH
# cp ../network/fabric-ca/aggregator/tls-ca/ca-cert.pem $TLS_FOLDER_PATH/ca.crt
# cp ../network/fabric-ca/aggregator/tls-ca/clients/admin/msp/signcerts/cert.pem $TLS_FOLDER_PATH/server.crt
# key=$(find ../network/fabric-ca/aggregator/tls-ca/clients/admin/msp/keystore -name *_sk)
# cp $key $TLS_FOLDER_PATH/server.key



#SPV
LOCAL_MSP_PATH=$NEW_PATH/fabric-ca/spv/cas/spv-ca/msp

mkdir -p $LOCAL_MSP_PATH
cp ./config.yaml $LOCAL_MSP_PATH
mkdir $LOCAL_MSP_PATH/cacerts && cp ../network/fabric-ca/spv/ca/ca-cert.pem $LOCAL_MSP_PATH/cacerts/ca-cert.pem
mkdir $LOCAL_MSP_PATH/tlscacerts && cp ../network/fabric-ca/spv/tls-ca/ca-cert.pem $LOCAL_MSP_PATH/tlscacerts/ca-cert.pem
mkdir $LOCAL_MSP_PATH/signcerts && cp -r ../network/fabric-ca/spv/ca/clients/admin/msp/signcerts $LOCAL_MSP_PATH/
key=$(find ../network/fabric-ca/spv/ca/clients/admin/msp/keystore -name *_sk)
mkdir $LOCAL_MSP_PATH/keystore && cp $key $LOCAL_MSP_PATH/keystore/priv.key


TLS_FOLDER_PATH=$NEW_PATH/fabric-ca/spv/tlscas/spv-tlsca/tls

mkdir -p $TLS_FOLDER_PATH
cp ../network/fabric-ca/spv/tls-ca/ca-cert.pem $TLS_FOLDER_PATH/ca.crt
cp ../network/fabric-ca/spv/tls-ca/clients/admin/msp/signcerts/cert.pem $TLS_FOLDER_PATH/server.crt
key=$(find ../network/fabric-ca/spv/tls-ca/clients/admin/msp/keystore -name *_sk)
cp $key $TLS_FOLDER_PATH/server.key


#INVESTOR
LOCAL_MSP_PATH=$NEW_PATH/fabric-ca/investor/cas/investor-ca/msp

mkdir -p $LOCAL_MSP_PATH
cp ./config.yaml $LOCAL_MSP_PATH
mkdir $LOCAL_MSP_PATH/cacerts && cp ../network/fabric-ca/investor/ca/ca-cert.pem $LOCAL_MSP_PATH/cacerts/ca-cert.pem
mkdir $LOCAL_MSP_PATH/tlscacerts && cp ../network/fabric-ca/investor/tls-ca/ca-cert.pem $LOCAL_MSP_PATH/tlscacerts/ca-cert.pem
mkdir $LOCAL_MSP_PATH/signcerts && cp -r ../network/fabric-ca/investor/ca/clients/admin/msp/signcerts $LOCAL_MSP_PATH/
key=$(find ../network/fabric-ca/investor/ca/clients/admin/msp/keystore -name *_sk)
mkdir $LOCAL_MSP_PATH/keystore && cp $key $LOCAL_MSP_PATH/keystore/priv.key


TLS_FOLDER_PATH=$NEW_PATH/fabric-ca/investor/tlscas/investor-tlsca/tls

mkdir -p $TLS_FOLDER_PATH
cp ../network/fabric-ca/investor/tls-ca/ca-cert.pem $TLS_FOLDER_PATH/ca.crt
cp ../network/fabric-ca/investor/tls-ca/clients/admin/msp/signcerts/cert.pem $TLS_FOLDER_PATH/server.crt
key=$(find ../network/fabric-ca/investor/tls-ca/clients/admin/msp/keystore -name *_sk)
cp $key $TLS_FOLDER_PATH/server.key


function msp(){
	number=$1
	org=$2
	LOCAL_MSP_PATH=$NEW_PATH/fabric-ca/$org/clients/$org-client-$number/msp

	mkdir -p $LOCAL_MSP_PATH
	cp ./config.yaml $LOCAL_MSP_PATH
	mkdir $LOCAL_MSP_PATH/cacerts && cp ../network/fabric-ca/$org/ca/ca-cert.pem $LOCAL_MSP_PATH/cacerts/ca-cert.pem
	mkdir $LOCAL_MSP_PATH/tlscacerts && cp ../network/fabric-ca/$org/tls-ca/ca-cert.pem $LOCAL_MSP_PATH/tlscacerts/ca-cert.pem
	mkdir $LOCAL_MSP_PATH/signcerts && cp -r ../network/fabric-ca/$org/ca/clients/$org-client-$number/msp/signcerts $LOCAL_MSP_PATH/
	key=$(find ../network/fabric-ca/$org/ca/clients/$org-client-$number/msp/keystore -name *_sk)
	mkdir $LOCAL_MSP_PATH/keystore && cp $key $LOCAL_MSP_PATH/keystore/priv.key




	TLS_FOLDER_PATH=$NEW_PATH/fabric-ca/$org/clients/$org-client-$number/tls

	mkdir -p $TLS_FOLDER_PATH
	cp ../network/fabric-ca/$org/tls-ca/ca-cert.pem $TLS_FOLDER_PATH/ca.crt
	cp ../network/fabric-ca/$org/tls-ca/clients/$org-client-$number/msp/signcerts/cert.pem $TLS_FOLDER_PATH/server.crt
	key=$(find ../network/fabric-ca/$org/tls-ca/clients/$org-client-$number/msp/keystore -name *_sk)
	cp $key $TLS_FOLDER_PATH/server.key

}

for i in {1..10}
do
	msp $i investor
done



# for i in {1..2}
# do
# 	msp $i aggregator
# done
