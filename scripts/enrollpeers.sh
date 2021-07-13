export NEW_PATH=$(cd ../ && pwd)
#Funciones para el farmer client
function issueCertificatesWithAffiliation() {
	number=$1

	export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/farmer/ca/clients/admin
# export FABRIC_CA_CLIENT_TLS_CERTFILES=/home/oliver/ppa/network/fabric-ca/farmer/ca/clients/admin/msp/cacerts/localhost-8055.pem
	export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/farmer/ca/ca-cert.pem
    # register identity with CA admin
	fabric-ca-client register --id.name farmer-client-$number --id.secret farmer-client-$number-pw --id.type client --id.affiliation farmer.cliente -u https://rootca-farmer-admin:rootca-farmer-adminpw@localhost:8055
    # enroll registered identity
	export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/farmer/ca/clients/farmer-client-$number
	fabric-ca-client enroll -u https://farmer-client-$number:farmer-client-$number-pw@localhost:8055 --csr.names "$CSR_NAMES_FARMER" --tls.certfiles $FABRIC_CA_CLIENT_TLS_CERTFILES --csr.hosts "rootca-farmer-admin,localhost"
}
function issueTLSCertificates() {
    	number=$1
 	export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/farmer/tls-ca/ca-cert.pem
	export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/farmer/tls-ca/clients/admin
	fabric-ca-client register --id.name farmer-client-$number --id.secret farmer-client-$number-pw --id.type client -u https://tls-ca-farmer-admin:tls-ca-farmer-adminpw@localhost:8054    # enroll registered identity
	export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/farmer/tls-ca/clients/farmer-client-$number
	fabric-ca-client enroll -u https://farmer-client-$number:farmer-client-$number-pw@localhost:8054 --csr.names "$CSR_NAMES_FARMER" --tls.certfiles $FABRIC_CA_CLIENT_TLS_CERTFILES --csr.hosts "farmer-client-$number,localhost" --enrollment.profile tls
}

# SERVICER
# # issue certificates for admin identity and for client tls
# register identity with CA admin
export CSR_NAMES_SERVICER="C=SP,ST=ServicerState,L=ServicerLocation,O=Servicer,OU=Hyperledger Fabric"
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/servicer/ca/clients/admin
# export FABRIC_CA_CLIENT_TLS_CERTFILES=/home/oliver/ppa/network/fabric-ca/originator/ca/clients/admin/msp/cacerts/localhost-7055.pem
export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/servicer/ca/ca-cert.pem
fabric-ca-client register --id.name servicer-admin --id.secret servicer-adminpw --id.type admin -u https://rootca-servicer-admin:rootca-servicer-adminpw@localhost:7055
# enroll registered identity
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/servicer/ca/clients/servicer-admin
fabric-ca-client enroll -u https://servicer-admin:servicer-adminpw@localhost:7055 --csr.names "$CSR_NAMES_SERVICER" --tls.certfiles $FABRIC_CA_CLIENT_TLS_CERTFILES --csr.hosts "rootca-servicer-admin,localhost"


# register identity with TLS CA admin
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/servicer/tls-ca/clients/admin
# export FABRIC_CA_CLIENT_TLS_CERTFILES=/home/oliver/ppa/network/fabric-ca/originator/tls-ca/clients/admin/msp/cacerts/localhost-7054.pem
export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/servicer/tls-ca/ca-cert.pem
fabric-ca-client register --id.name servicer-admin --id.secret servicer-adminpw --id.type admin -u https://tls-ca-servicer-admin:tls-ca-servicer-adminpw@localhost:7054
# enroll registered identity
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/servicer/tls-ca/clients/servicer-admin
fabric-ca-client enroll -u https://servicer-admin:servicer-adminpw@localhost:7054 --csr.names "$CSR_NAMES_SERVICER" --tls.certfiles $FABRIC_CA_CLIENT_TLS_CERTFILES --csr.hosts "servicer-admin,localhost" --enrollment.profile tls


# # issue certificates for client identity and for client tls
# register identity with CA admin
export CSR_NAMES_SERVICER="C=SP,ST=ServicerState,L=ServicerLocation,O=Servicer,OU=Hyperledger Fabric"
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/servicer/ca/clients/admin
# export FABRIC_CA_CLIENT_TLS_CERTFILES=/home/oliver/ppa/network/fabric-ca/originator/ca/clients/admin/msp/cacerts/localhost-7055.pem
export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/servicer/ca/ca-cert.pem
#modificada afiliacion
fabric-ca-client register --id.name servicer-client --id.secret servicer-clientpw --id.type client --id.affiliation servicer.cliente -u https://rootca-servicer-admin:rootca-servicer-adminpw@localhost:7055
# enroll registered identity
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/servicer/ca/clients/servicer-client
fabric-ca-client enroll -u https://servicer-client:servicer-clientpw@localhost:7055 --csr.names "$CSR_NAMES_SERVICER" --tls.certfiles $FABRIC_CA_CLIENT_TLS_CERTFILES --csr.hosts "rootca-servicer-admin,localhost"


# register identity with TLS CA admin
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/servicer/tls-ca/clients/admin
# export FABRIC_CA_CLIENT_TLS_CERTFILES=/home/oliver/ppa/network/fabric-ca/originator/tls-ca/clients/admin/msp/cacerts/localhost-7054.pem
export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/servicer/tls-ca/ca-cert.pem
fabric-ca-client register --id.name servicer-client --id.secret servicer-clientpw --id.type client -u https://tls-ca-servicer-admin:tls-ca-servicer-adminpw@localhost:7054
# enroll registered identity
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/servicer/tls-ca/clients/servicer-client
fabric-ca-client enroll -u https://servicer-client:servicer-clientpw@localhost:7054 --csr.names "$CSR_NAMES_SERVICER" --tls.certfiles $FABRIC_CA_CLIENT_TLS_CERTFILES --csr.hosts "servicer-client,localhost" --enrollment.profile tls

# # # issue certificates for peer node identity and for peer server tls

export CSR_NAMES_SERVICER="C=SP,ST=ServicerState,L=ServicerLocation,O=Servicer,OU=Hyperledger Fabric"
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/servicer/ca/clients/admin
# export FABRIC_CA_CLIENT_TLS_CERTFILES=/home/oliver/ppa/network/fabric-ca/originator/ca/clients/admin/msp/cacerts/localhost-7055.pem
export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/servicer/ca/ca-cert.pem
fabric-ca-client register --id.name servicer-peer --id.secret servicer-peerpw --id.type peer -u https://rootca-servicer-admin:rootca-servicer-adminpw@localhost:7055
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/servicer/ca/clients/servicer-peer
fabric-ca-client enroll -u https://servicer-peer:servicer-peerpw@localhost:7055 --csr.names "$CSR_NAMES_SERVICER"  --tls.certfiles $FABRIC_CA_CLIENT_TLS_CERTFILES --csr.hosts "rootca-servicer-admin,localhost"


export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/servicer/tls-ca/clients/admin
# export FABRIC_CA_CLIENT_TLS_CERTFILES=/home/oliver/ppa/network/fabric-ca/originator/tls-ca/clients/admin/msp/cacerts/localhost-7054.pem
export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/servicer/tls-ca/ca-cert.pem
fabric-ca-client register --id.name servicer-peer --id.secret servicer-peerpw --id.type peer -u https://tls-ca-servicer-admin:tls-ca-servicer-adminpw@localhost:7054
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/servicer/tls-ca/clients/servicer-peer
fabric-ca-client enroll -u https://servicer-peer:servicer-peerpw@localhost:7054 --csr.names "$CSR_NAMES_SERVICER" --tls.certfiles $FABRIC_CA_CLIENT_TLS_CERTFILES --csr.hosts "servicer-peer,localhost" --enrollment.profile tls


# # # issue certificates for orderer node identity and for orderer server tls

export CSR_NAMES_SERVICER="C=SP,ST=ServicerState,L=ServicerLocation,O=Servicer,OU=Hyperledger Fabric"
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/servicer/ca/clients/admin
# export FABRIC_CA_CLIENT_TLS_CERTFILES=/home/oliver/ppa/network/fabric-ca/originator/ca/clients/admin/msp/cacerts/localhost-7055.pem
export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/servicer/ca/ca-cert.pem
fabric-ca-client register --id.name servicer-orderer --id.secret servicer-ordererpw --id.type orderer -u https://rootca-servicer-admin:rootca-servicer-adminpw@localhost:7055
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/servicer/ca/clients/servicer-orderer
fabric-ca-client enroll -u https://servicer-orderer:servicer-ordererpw@localhost:7055 --csr.names "$CSR_NAMES_SERVICER"  --tls.certfiles $FABRIC_CA_CLIENT_TLS_CERTFILES --csr.hosts "rootca-servicer-admin,localhost"


export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/servicer/tls-ca/clients/admin
# export FABRIC_CA_CLIENT_TLS_CERTFILES=/home/oliver/ppa/network/fabric-ca/originator/tls-ca/clients/admin/msp/cacerts/localhost-7054.pem
export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/servicer/tls-ca/ca-cert.pem
fabric-ca-client register --id.name servicer-orderer --id.secret servicer-ordererpw --id.type orderer -u https://tls-ca-servicer-admin:tls-ca-servicer-adminpw@localhost:7054
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/servicer/tls-ca/clients/servicer-orderer
fabric-ca-client enroll -u https://servicer-orderer:servicer-ordererpw@localhost:7054 --csr.names "$CSR_NAMES_SERVICER" --tls.certfiles $FABRIC_CA_CLIENT_TLS_CERTFILES --csr.hosts "servicer-orderer,localhost" --enrollment.profile tls


# # Farmer
# # issue certificates for admin identity and for admin tls
export CSR_NAMES_FARMER="C=SP,ST=FarmerState,L=FarmerLocation,O=Farmer,OU=Hyperledger Fabric"
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/farmer/ca/clients/admin
# export FABRIC_CA_CLIENT_TLS_CERTFILES=/home/oliver/ppa/network/fabric-ca/farmer/ca/clients/admin/msp/cacerts/ca-cert.pem
export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/farmer/ca/ca-cert.pem
fabric-ca-client register --id.name farmer-admin --id.secret farmer-adminpw --id.type admin -u https://rootca-farmer-admin:rootca-farmer-adminpw@localhost:8055
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/farmer/ca/clients/farmer-admin
fabric-ca-client enroll -u https://farmer-admin:farmer-adminpw@localhost:8055 --csr.names "$CSR_NAMES_FARMER" --tls.certfiles $FABRIC_CA_CLIENT_TLS_CERTFILES --csr.hosts "rootca-farmer-admin,localhost"


export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/farmer/tls-ca/clients/admin
# export FABRIC_CA_CLIENT_TLS_CERTFILES=/home/oliver/ppa/network/fabric-ca/farmer/tls-ca/clients/admin/msp/cacerts/localhost-8054.pem
export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/farmer/tls-ca/ca-cert.pem
fabric-ca-client register --id.name farmer-admin --id.secret farmer-adminpw --id.type admin -u https://tls-ca-farmer-admin:tls-ca-farmer-adminpw@localhost:8054
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/farmer/tls-ca/clients/farmer-admin
fabric-ca-client enroll -u https://farmer-admin:farmer-adminpw@localhost:8054 --csr.names "$CSR_NAMES_FARMER" --tls.certfiles $FABRIC_CA_CLIENT_TLS_CERTFILES --csr.hosts "farmer-admin,localhost" --enrollment.profile tls


export CSR_NAMES_FARMER="C=SP,ST=FarmerState,L=FarmerLocation,O=Farmer,OU=Hyperledger Fabric"
for i in {1..5}
do
	issueCertificatesWithAffiliation $i
	issueTLSCertificates $i
done



# # # issue certificates for peer node identity and for peer server tls

export CSR_NAMES_FARMER="C=SP,ST=FarmerState,L=FarmerLocation,O=Farmer,OU=Hyperledger Fabric"
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/farmer/ca/clients/admin
# export FABRIC_CA_CLIENT_TLS_CERTFILES=/home/oliver/ppa/network/fabric-ca/farmer/ca/clients/admin/msp/cacerts/localhost-8055.pem
export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/farmer/ca/ca-cert.pem
fabric-ca-client register --id.name farmer-peer --id.secret farmer-peerpw --id.type peer -u https://rootca-farmer-admin:rootca-farmer-adminpw@localhost:8055
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/farmer/ca/clients/farmer-peer
fabric-ca-client enroll -u https://farmer-peer:farmer-peerpw@localhost:8055 --csr.names "$CSR_NAMES_FARMER" --tls.certfiles $FABRIC_CA_CLIENT_TLS_CERTFILES --csr.hosts "rootca-farmer-admin,localhost"


export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/farmer/tls-ca/clients/admin
# export FABRIC_CA_CLIENT_TLS_CERTFILES=/home/oliver/ppa/network/fabric-ca/farmer/tls-ca/clients/admin/msp/cacerts/localhost-8054.pem
export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/farmer/tls-ca/ca-cert.pem
fabric-ca-client register --id.name farmer-peer --id.secret farmer-peerpw --id.type peer -u https://tls-ca-farmer-admin:tls-ca-farmer-adminpw@localhost:8054
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/farmer/tls-ca/clients/farmer-peer
fabric-ca-client enroll -u https://farmer-peer:farmer-peerpw@localhost:8054 --csr.names "$CSR_NAMES_FARMER" --tls.certfiles $FABRIC_CA_CLIENT_TLS_CERTFILES --csr.hosts "farmer-peer,localhost" --enrollment.profile tls


# # # issue certificates for orderer node identity and for orderer server tls

export CSR_NAMES_FARMER="C=SP,ST=FarmerState,L=FarmerLocation,O=Farmer,OU=Hyperledger Fabric"
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/farmer/ca/clients/admin
# export FABRIC_CA_CLIENT_TLS_CERTFILES=/home/oliver/ppa/network/fabric-ca/farmer/ca/clients/admin/msp/cacerts/localhost-8055.pem
export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/farmer/ca/ca-cert.pem
fabric-ca-client register --id.name farmer-orderer --id.secret farmer-ordererpw --id.type orderer -u https://rootca-farmer-admin:rootca-farmer-adminpw@localhost:8055
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/farmer/ca/clients/farmer-orderer
fabric-ca-client enroll -u https://farmer-orderer:farmer-ordererpw@localhost:8055 --csr.names "$CSR_NAMES_FARMER"  --tls.certfiles $FABRIC_CA_CLIENT_TLS_CERTFILES --csr.hosts "rootca-farmer-admin,localhost"


export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/farmer/tls-ca/clients/admin
# export FABRIC_CA_CLIENT_TLS_CERTFILES=/home/oliver/ppa/network/fabric-ca/farmer/tls-ca/clients/admin//msp/cacerts/localhost-8054.pem
export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/farmer/tls-ca/ca-cert.pem
fabric-ca-client register --id.name farmer-orderer --id.secret farmer-ordererpw --id.type orderer -u https://tls-ca-farmer-admin:tls-ca-farmer-adminpw@localhost:8054
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/farmer/tls-ca/clients/farmer-orderer
fabric-ca-client enroll -u https://farmer-orderer:farmer-ordererpw@localhost:8054 --csr.names "$CSR_NAMES_FARMER" --tls.certfiles $FABRIC_CA_CLIENT_TLS_CERTFILES --csr.hosts "farmer-orderer,localhost" --enrollment.profile tls


# # # Aggregator
# # # issue certificates for admin identity and for admin tls
# export CSR_NAMES_AGGREGATOR="C=SP,ST=AggregatorState,L=AggregatorLocation,O=Aggregator,OU=Hyperledger Fabric"
# export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/aggregator/ca/clients/admin
# # export FABRIC_CA_CLIENT_TLS_CERTFILES=/home/oliver/ppa/network/fabric-ca/aggregator/ca/clients/admin/msp/cacerts/localhost-9055.pem
# export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/aggregator/ca/ca-cert.pem
# fabric-ca-client register --id.name aggregator-admin --id.secret aggregator-adminpw --id.type admin -u https://rootca-aggregator-admin:rootca-aggregator-adminpw@localhost:9055
# export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/aggregator/ca/clients/aggregator-admin
# fabric-ca-client enroll -u https://aggregator-admin:aggregator-adminpw@localhost:9055 --csr.names "$CSR_NAMES_AGGREGATOR"  --tls.certfiles $FABRIC_CA_CLIENT_TLS_CERTFILES --csr.hosts "rootca-aggregator-admin,localhost"


# export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/aggregator/tls-ca/clients/admin
# # export FABRIC_CA_CLIENT_TLS_CERTFILES=/home/oliver/ppa/network/fabric-ca/aggregator/tls-ca/clients/admin/msp/cacerts/localhost-9054.pem
# export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/aggregator/tls-ca/ca-cert.pem
# fabric-ca-client register --id.name aggregator-admin --id.secret aggregator-adminpw --id.type admin -u https://tls-ca-aggregator-admin:tls-ca-aggregator-adminpw@localhost:9054
# export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/aggregator/tls-ca/clients/aggregator-admin
# fabric-ca-client enroll -u https://aggregator-admin:aggregator-adminpw@localhost:9054 --csr.names "$CSR_NAMES_AGGREGATOR" --tls.certfiles $FABRIC_CA_CLIENT_TLS_CERTFILES --csr.hosts "aggregator-admin,localhost" --enrollment.profile tls


# function issueCertificatesWithAffiliation() {
# 	number=$1
# 	org=$2	

# 	export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/$org/ca/clients/admin
# # export FABRIC_CA_CLIENT_TLS_CERTFILES=/home/oliver/ppa/network/fabric-ca/farmer/ca/clients/admin/msp/cacerts/localhost-8055.pem
# 	export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/$org/ca/ca-cert.pem
#     # register identity with CA admin
# 	fabric-ca-client register --id.name $org-client-$number --id.secret $org-client-$number-pw --id.type client --id.affiliation $org.cliente -u https://rootca-$org-admin:rootca-$org-adminpw@localhost:9055
#     # enroll registered identity
# 	export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/$org/ca/clients/$org-client-$number
# 	fabric-ca-client enroll -u https://$org-client-$number:$org-client-$number-pw@localhost:9055 --csr.names "$CSR_NAMES_FARMER" --tls.certfiles $FABRIC_CA_CLIENT_TLS_CERTFILES --csr.hosts "rootca-aggregator-admin,localhost"
# }
# function issueTLSCertificates() {
#     	number=$1
# 	org=$2
#  	export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/$org/tls-ca/ca-cert.pem
# 	export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/$org/tls-ca/clients/admin
# 	fabric-ca-client register --id.name $org-client-$number --id.secret $org-client-$number-pw --id.type client -u https://tls-ca-$org-admin:tls-ca-$org-adminpw@localhost:9054    # enroll registered identity
# 	export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/$org/tls-ca/clients/$org-client-$number
# 	fabric-ca-client enroll -u https://$org-client-$number:$org-client-$number-pw@localhost:9054 --csr.names "$CSR_NAMES_FARMER" --tls.certfiles $FABRIC_CA_CLIENT_TLS_CERTFILES --csr.hosts "aggregator-client-$number,localhost" --enrollment.profile tls
# }


# for i in {1..2}
# do
# 	issueCertificatesWithAffiliation $i aggregator
# 	issueTLSCertificates $i aggregator
# done





# # # issue certificates for client identity and for client tls
# export CSR_NAMES_AGGREGATOR="C=SP,ST=AggregatorState,L=AggregatorLocation,O=Aggregator,OU=Hyperledger Fabric"
# export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/aggregator/ca/clients/admin
# # export FABRIC_CA_CLIENT_TLS_CERTFILES=/home/oliver/ppa/network/fabric-ca/aggregator/ca/clients/admin/msp/cacerts/localhost-9055.pem
# export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/aggregator/ca/ca-cert.pem
# #modificada afiliacion
# fabric-ca-client register --id.name aggregator-client --id.secret aggregator-clientpw --id.type client --id.affiliation aggregator.cliente -u https://rootca-aggregator-admin:rootca-aggregator-adminpw@localhost:9055
# export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/aggregator/ca/clients/aggregator-client
# fabric-ca-client enroll -u https://aggregator-client:aggregator-clientpw@localhost:9055 --csr.names "$CSR_NAMES_AGGREGATOR"  --tls.certfiles $FABRIC_CA_CLIENT_TLS_CERTFILES --csr.hosts "rootca-aggregator-admin,localhost"


# export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/aggregator/tls-ca/clients/admin
# # export FABRIC_CA_CLIENT_TLS_CERTFILES=/home/oliver/ppa/network/fabric-ca/aggregator/tls-ca/clients/admin/msp/cacerts/localhost-9054.pem
# export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/aggregator/tls-ca/ca-cert.pem
# fabric-ca-client register --id.name aggregator-client --id.secret aggregator-clientpw --id.type client -u https://tls-ca-aggregator-admin:tls-ca-aggregator-adminpw@localhost:9054
# export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/aggregator/tls-ca/clients/aggregator-client
# fabric-ca-client enroll -u https://aggregator-client:aggregator-clientpw@localhost:9054 --csr.names "$CSR_NAMES_AGGREGATOR" --tls.certfiles $FABRIC_CA_CLIENT_TLS_CERTFILES --csr.hosts "aggregator-client,localhost" --enrollment.profile tls

# # # issue certificates for peer node identity and for peer server tls

# export CSR_NAMES_AGGREGATOR="C=SP,ST=AggregatorState,L=AggregatorLocation,O=Aggregator,OU=Hyperledger Fabric"
# export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/aggregator/ca/clients/admin
# # export FABRIC_CA_CLIENT_TLS_CERTFILES=/home/oliver/ppa/network/fabric-ca/aggregator/ca/clients/admin/msp/cacerts/localhost-9055.pem
# export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/aggregator/ca/ca-cert.pem
# fabric-ca-client register --id.name aggregator-peer --id.secret aggregator-peerpw --id.type peer -u https://rootca-aggregator-admin:rootca-aggregator-adminpw@localhost:9055
# export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/aggregator/ca/clients/aggregator-peer
# fabric-ca-client enroll -u https://aggregator-peer:aggregator-peerpw@localhost:9055 --csr.names "$CSR_NAMES_AGGREGATOR"  --tls.certfiles $FABRIC_CA_CLIENT_TLS_CERTFILES --csr.hosts "rootca-aggregator-admin,localhost"


# export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/aggregator/tls-ca/clients/admin
# # export FABRIC_CA_CLIENT_TLS_CERTFILES=/home/oliver/ppa/network/fabric-ca/aggregator/tls-ca/clients/admin/msp/cacerts/localhost-9054.pem
# export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/aggregator/tls-ca/ca-cert.pem
# fabric-ca-client register --id.name aggregator-peer --id.secret aggregator-peerpw --id.type peer -u https://tls-ca-aggregator-admin:tls-ca-aggregator-adminpw@localhost:9054
# export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/aggregator/tls-ca/clients/aggregator-peer
# fabric-ca-client enroll -u https://aggregator-peer:aggregator-peerpw@localhost:9054 --csr.names "$CSR_NAMES_AGGREGATOR" --tls.certfiles $FABRIC_CA_CLIENT_TLS_CERTFILES --csr.hosts "aggregator-peer,localhost" --enrollment.profile tls


# # # # issue certificates for orderer node identity and for orderer server tls

# export CSR_NAMES_AGGREGATOR="C=SP,ST=AggregatorState,L=AggregatorLocation,O=Aggregator,OU=Hyperledger Fabric"
# export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/aggregator/ca/clients/admin
# # export FABRIC_CA_CLIENT_TLS_CERTFILES=/home/oliver/ppa/network/fabric-ca/aggregator/ca/clients/admin//msp/cacerts/localhost-9055.pem
# export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/aggregator/ca/ca-cert.pem
# fabric-ca-client register --id.name aggregator-orderer --id.secret aggregator-ordererpw --id.type orderer -u https://rootca-aggregator-admin:rootca-aggregator-adminpw@localhost:9055
# export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/aggregator/ca/clients/aggregator-orderer
# fabric-ca-client enroll -u https://aggregator-orderer:aggregator-ordererpw@localhost:9055 --csr.names "$CSR_NAMES_AGGREGATOR"  --tls.certfiles $FABRIC_CA_CLIENT_TLS_CERTFILES --csr.hosts "rootca-aggregator-admin,localhost"


# export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/aggregator/tls-ca/clients/admin
# # export FABRIC_CA_CLIENT_TLS_CERTFILES=/home/oliver/ppa/network/fabric-ca/aggregator/tls-ca/clients/admin//msp/cacerts/localhost-9054.pem
# export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/aggregator/tls-ca/ca-cert.pem
# fabric-ca-client register --id.name aggregator-orderer --id.secret aggregator-ordererpw --id.type orderer -u https://tls-ca-aggregator-admin:tls-ca-aggregator-adminpw@localhost:9054
# export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/aggregator/tls-ca/clients/aggregator-orderer
# fabric-ca-client enroll -u https://aggregator-orderer:aggregator-ordererpw@localhost:9054 --csr.names "$CSR_NAMES_AGGREGATOR" --tls.certfiles $FABRIC_CA_CLIENT_TLS_CERTFILES --csr.hosts "aggregator-orderer,localhost" --enrollment.profile tls

# SPV
# # issue certificates for client identity and for client tls
export CSR_NAMES_SPV="C=SP,ST=SPVState,L=SPVLocation,O=SPV,OU=Hyperledger Fabric"
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/spv/ca/clients/admin
# export FABRIC_CA_CLIENT_TLS_CERTFILES=/home/oliver/ppa/network/fabric-ca/spv/ca/clients/admin/msp/cacerts/localhost-10055.pem
export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/spv/ca/ca-cert.pem
fabric-ca-client register --id.name spv-admin --id.secret spv-adminpw --id.type admin -u https://rootca-spv-admin:rootca-spv-adminpw@localhost:10055
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/spv/ca/clients/spv-admin
fabric-ca-client enroll -u https://spv-admin:spv-adminpw@localhost:10055 --csr.names "$CSR_NAMES_SPV" --tls.certfiles $FABRIC_CA_CLIENT_TLS_CERTFILES --csr.hosts "rootca-spv-admin,localhost"


export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/spv/tls-ca/clients/admin
# export FABRIC_CA_CLIENT_TLS_CERTFILES=/home/oliver/ppa/network/fabric-ca/spv/tls-ca/clients/admin/msp/cacerts/localhost-10054.pem
export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/spv/tls-ca/ca-cert.pem
fabric-ca-client register --id.name spv-admin --id.secret spv-adminpw --id.type admin -u https://tls-ca-spv-admin:tls-ca-spv-adminpw@localhost:10054
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/spv/tls-ca/clients/spv-admin
fabric-ca-client enroll -u https://spv-admin:spv-adminpw@localhost:10054 --csr.names "$CSR_NAMES_SPV" --tls.certfiles $FABRIC_CA_CLIENT_TLS_CERTFILES --csr.hosts "spv-admin,localhost" --enrollment.profile tls


# # issue certificates for client identity and for client tls
export CSR_NAMES_SPV="C=SP,ST=SPVState,L=SPVLocation,O=SPV,OU=Hyperledger Fabric"
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/spv/ca/clients/admin
# export FABRIC_CA_CLIENT_TLS_CERTFILES=/home/oliver/ppa/network/fabric-ca/spv/ca/clients/admin/msp/cacerts/localhost-10055.pem
export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/spv/ca/ca-cert.pem
#modificada afiliacion
fabric-ca-client register --id.name spv-client --id.secret spv-clientpw --id.type client --id.affiliation spv.cliente -u https://rootca-spv-admin:rootca-spv-adminpw@localhost:10055
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/spv/ca/clients/spv-client
fabric-ca-client enroll -u https://spv-client:spv-clientpw@localhost:10055 --csr.names "$CSR_NAMES_SPV"  --tls.certfiles $FABRIC_CA_CLIENT_TLS_CERTFILES --csr.hosts "rootca-spv-admin,localhost"


export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/spv/tls-ca/clients/admin
# export FABRIC_CA_CLIENT_TLS_CERTFILES=/home/oliver/ppa/network/fabric-ca/spv/tls-ca/clients/admin/msp/cacerts/localhost-10054.pem
export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/spv/tls-ca/ca-cert.pem
fabric-ca-client register --id.name spv-client --id.secret spv-clientpw --id.type client -u https://tls-ca-spv-admin:tls-ca-spv-adminpw@localhost:10054
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/spv/tls-ca/clients/spv-client
fabric-ca-client enroll -u https://spv-client:spv-clientpw@localhost:10054 --csr.names "$CSR_NAMES_SPV" --tls.certfiles $FABRIC_CA_CLIENT_TLS_CERTFILES --csr.hosts "spv-client,localhost" --enrollment.profile tls

# # # issue certificates for peer node identity and for peer server tls

export CSR_NAMES_SPV="C=SP,ST=SPVState,L=SPVLocation,O=SPV,OU=Hyperledger Fabric"
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/spv/ca/clients/admin
# export FABRIC_CA_CLIENT_TLS_CERTFILES=/home/oliver/ppa/network/fabric-ca/spv/ca/clients/admin/msp/cacerts/localhost-10055.pem
export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/spv/ca/ca-cert.pem
fabric-ca-client register --id.name spv-peer --id.secret spv-peerpw --id.type peer -u https://rootca-spv-admin:rootca-spv-adminpw@localhost:10055
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/spv/ca/clients/spv-peer
fabric-ca-client enroll -u https://spv-peer:spv-peerpw@localhost:10055 --csr.names "$CSR_NAMES_SPV"  --tls.certfiles $FABRIC_CA_CLIENT_TLS_CERTFILES --csr.hosts "rootca-spv-admin,localhost"


export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/spv/tls-ca/clients/admin
# export FABRIC_CA_CLIENT_TLS_CERTFILES=/home/oliver/ppa/network/fabric-ca/spv/tls-ca/clients/admin/msp/cacerts/localhost-10054.pem
export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/spv/tls-ca/ca-cert.pem
fabric-ca-client register --id.name spv-peer --id.secret spv-peerpw --id.type peer -u https://tls-ca-spv-admin:tls-ca-spv-adminpw@localhost:10054
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/spv/tls-ca/clients/spv-peer
fabric-ca-client enroll -u https://spv-peer:spv-peerpw@localhost:10054 --csr.names "$CSR_NAMES_SPV" --tls.certfiles $FABRIC_CA_CLIENT_TLS_CERTFILES --csr.hosts "spv-peer,localhost" --enrollment.profile tls


# # # issue certificates for orderer node identity and for orderer server tls

export CSR_NAMES_SPV="C=SP,ST=SPVState,L=SPVLocation,O=SPV,OU=Hyperledger Fabric"
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/spv/ca/clients/admin
# export FABRIC_CA_CLIENT_TLS_CERTFILES=/home/oliver/ppa/network/fabric-ca/spv/ca/clients/admin/msp/cacerts/localhost-10055.pem
export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/spv/ca/ca-cert.pem
fabric-ca-client register --id.name spv-orderer --id.secret spv-ordererpw --id.type orderer -u https://rootca-spv-admin:rootca-spv-adminpw@localhost:10055
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/spv/ca/clients/spv-orderer
fabric-ca-client enroll -u https://spv-orderer:spv-ordererpw@localhost:10055 --csr.names "$CSR_NAMES_SPV"  --tls.certfiles $FABRIC_CA_CLIENT_TLS_CERTFILES --csr.hosts "rootca-spv-admin,localhost"


export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/spv/tls-ca/clients/admin
# export FABRIC_CA_CLIENT_TLS_CERTFILES=/home/oliver/ppa/network/fabric-ca/spv/tls-ca/clients/admin/msp/cacerts/localhost-10054.pem
export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/spv/tls-ca/ca-cert.pem
fabric-ca-client register --id.name spv-orderer --id.secret spv-ordererpw --id.type orderer -u https://tls-ca-spv-admin:tls-ca-spv-adminpw@localhost:10054
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/spv/tls-ca/clients/spv-orderer
fabric-ca-client enroll -u https://spv-orderer:spv-ordererpw@localhost:10054 --csr.names "$CSR_NAMES_SPV" --tls.certfiles $FABRIC_CA_CLIENT_TLS_CERTFILES --csr.hosts "spv-orderer,localhost" --enrollment.profile tls



#Underwritter
# # issue certificates for admin identity and for admin tls
export CSR_NAMES_INVESTOR="C=SP,ST=InvestorState,L=InvestorLocation,O=Investor,OU=Hyperledger Fabric"
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/investor/ca/clients/admin
# export FABRIC_CA_CLIENT_TLS_CERTFILES=/home/oliver/ppa/network/fabric-ca/underwritter/ca/clients/admin/msp/cacerts/localhost-11055.pem
export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/investor/ca/ca-cert.pem
fabric-ca-client register --id.name investor-admin --id.secret investor-adminpw --id.type admin -u https://rootca-investor-admin:rootca-investor-adminpw@localhost:11055
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/investor/ca/clients/investor-admin
fabric-ca-client enroll -u https://investor-admin:investor-adminpw@localhost:11055 --csr.names "$CSR_NAMES_INVESTOR"  --tls.certfiles $FABRIC_CA_CLIENT_TLS_CERTFILES --csr.hosts "rootca-investor-admin,localhost"


export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/investor/tls-ca/clients/admin
# export FABRIC_CA_CLIENT_TLS_CERTFILES=/home/oliver/ppa/network/fabric-ca/underwritter/tls-ca/clients/admin/msp/cacerts/localhost-11054.pem
export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/investor/tls-ca/ca-cert.pem
fabric-ca-client register --id.name investor-admin --id.secret investor-adminpw --id.type admin -u https://tls-ca-investor-admin:tls-ca-investor-adminpw@localhost:11054
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/investor/tls-ca/clients/investor-admin
fabric-ca-client enroll -u https://investor-admin:investor-adminpw@localhost:11054 --csr.names "$CSR_NAMES_INVESTOR" --tls.certfiles $FABRIC_CA_CLIENT_TLS_CERTFILES --csr.hosts "investor-admin,localhost" --enrollment.profile tls


function issueCertificatesWithAffiliation() {
	number=$1
	org=$2	

	export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/$org/ca/clients/admin
	export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/$org/ca/ca-cert.pem
    # register identity with CA admin
	fabric-ca-client register --id.name $org-client-$number --id.secret $org-client-$number-pw --id.type client --id.affiliation $org.cliente -u https://rootca-$org-admin:rootca-$org-adminpw@localhost:11055
    # enroll registered identity
	export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/$org/ca/clients/$org-client-$number
	fabric-ca-client enroll -u https://$org-client-$number:$org-client-$number-pw@localhost:11055 --csr.names "$CSR_NAMES_INVESTOR" --tls.certfiles $FABRIC_CA_CLIENT_TLS_CERTFILES --csr.hosts "rootca-investor-admin,localhost"
}
function issueTLSCertificates() {
    number=$1
	org=$2
 	export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/$org/tls-ca/ca-cert.pem
	export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/$org/tls-ca/clients/admin
	fabric-ca-client register --id.name $org-client-$number --id.secret $org-client-$number-pw --id.type client -u https://tls-ca-$org-admin:tls-ca-$org-adminpw@localhost:11054    # enroll registered identity
	export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/$org/tls-ca/clients/$org-client-$number
	fabric-ca-client enroll -u https://$org-client-$number:$org-client-$number-pw@localhost:11054 --csr.names "$CSR_NAMES_INVESTOR" --tls.certfiles $FABRIC_CA_CLIENT_TLS_CERTFILES --csr.hosts "investor-client-$number,localhost" --enrollment.profile tls
}


for i in {1..10}
do
	issueCertificatesWithAffiliation $i investor
	issueTLSCertificates $i investor
done


# # # issue certificates for peer node identity and for peer server tls



function issueCertificatesWithAffiliation() {
	number=$1
	org=$2	

	export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/$org/ca/clients/admin
	export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/$org/ca/ca-cert.pem
    # register identity with CA admin
	fabric-ca-client register --id.name $org-peer-$number --id.secret $org-peer-$number-pw --id.type peer -u https://rootca-$org-admin:rootca-$org-adminpw@localhost:11055
    # enroll registered identity
	export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/$org/ca/clients/$org-peer-$number
	fabric-ca-client enroll -u https://$org-peer-$number:$org-peer-$number-pw@localhost:11055 --csr.names "$CSR_NAMES_INVESTOR" --tls.certfiles $FABRIC_CA_CLIENT_TLS_CERTFILES --csr.hosts "rootca-investor-admin,localhost"
}
function issueTLSCertificates() {
    number=$1
	org=$2
 	export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/$org/tls-ca/ca-cert.pem
	export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/$org/tls-ca/clients/admin
	fabric-ca-client register --id.name $org-peer-$number --id.secret $org-peer-$number-pw --id.type peer -u https://tls-ca-$org-admin:tls-ca-$org-adminpw@localhost:11054    # enroll registered identity
	export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/$org/tls-ca/clients/$org-peer-$number
	fabric-ca-client enroll -u https://$org-peer-$number:$org-peer-$number-pw@localhost:11054 --csr.names "$CSR_NAMES_INVESTOR" --tls.certfiles $FABRIC_CA_CLIENT_TLS_CERTFILES --csr.hosts "investor-peer-$number,localhost" --enrollment.profile tls
}





export CSR_NAMES_INVESTOR="C=SP,ST=InvestorState,L=InvestorLocation,O=Investor,OU=Hyperledger Fabric"
# export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/investor/ca/clients/admin
# # export FABRIC_CA_CLIENT_TLS_CERTFILES=/home/oliver/ppa/network/fabric-ca/underwritter/ca/clients/admin/msp/cacerts/localhost-11055.pem
# export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/investor/ca/ca-cert.pem
# fabric-ca-client register --id.name investor-peer --id.secret investor-peerpw --id.type peer -u https://rootca-investor-admin:rootca-investor-adminpw@localhost:11055
# export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/investor/ca/clients/investor-peer
# fabric-ca-client enroll -u https://investor-peer:investor-peerpw@localhost:11055 --csr.names "$CSR_NAMES_INVESTOR"  --tls.certfiles $FABRIC_CA_CLIENT_TLS_CERTFILES --csr.hosts "rootca-investor-admin,localhost"


# export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/investor/tls-ca/clients/admin
# # export FABRIC_CA_CLIENT_TLS_CERTFILES=/home/oliver/ppa/network/fabric-ca/underwritter/tls-ca/clients/admin/msp/cacerts/localhost-11054.pem
# export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/investor/tls-ca/ca-cert.pem
# fabric-ca-client register --id.name investor-peer --id.secret investor-peerpw --id.type peer -u https://tls-ca-investor-admin:tls-ca-investor-adminpw@localhost:11054
# export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/investor/tls-ca/clients/investor-peer
# fabric-ca-client enroll -u https://investor-peer:investor-peerpw@localhost:11054 --csr.names "$CSR_NAMES_INVESTOR" --tls.certfiles $FABRIC_CA_CLIENT_TLS_CERTFILES --csr.hosts "investor-peer,localhost" --enrollment.profile tls
for i in {1..1}
do
	issueCertificatesWithAffiliation $i investor
	issueTLSCertificates $i investor
done



# # # issue certificates for orderer node identity and for orderer server tls

export CSR_NAMES_INVESTOR="C=SP,ST=InvestorState,L=InvestorLocation,O=Investor,OU=Hyperledger Fabric"
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/investor/ca/clients/admin
# export FABRIC_CA_CLIENT_TLS_CERTFILES=/home/oliver/ppa/network/fabric-ca/underwritter/ca/clients/admin/msp/cacerts/localhost-11055.pem
export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/investor/ca/ca-cert.pem
fabric-ca-client register --id.name investor-orderer --id.secret investor-ordererpw --id.type orderer -u https://rootca-investor-admin:rootca-investor-adminpw@localhost:11055
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/investor/ca/clients/investor-orderer
fabric-ca-client enroll -u https://investor-orderer:investor-ordererpw@localhost:11055 --csr.names "$CSR_NAMES_INVESTOR"  --tls.certfiles $FABRIC_CA_CLIENT_TLS_CERTFILES --csr.hosts "rootca-investor-admin,localhost"


export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/investor/tls-ca/clients/admin
# export FABRIC_CA_CLIENT_TLS_CERTFILES=/home/oliver/ppa/network/fabric-ca/underwritter/tls-ca/clients/admin/msp/cacerts/localhost-11054.pem
export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/investor/tls-ca/ca-cert.pem
fabric-ca-client register --id.name investor-orderer --id.secret investor-ordererpw --id.type orderer -u https://tls-ca-investor-admin:tls-ca-investor-adminpw@localhost:11054
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/investor/tls-ca/clients/investor-orderer
fabric-ca-client enroll -u https://investor-orderer:investor-ordererpw@localhost:11054 --csr.names "$CSR_NAMES_INVESTOR" --tls.certfiles $FABRIC_CA_CLIENT_TLS_CERTFILES --csr.hosts "investor-orderer,localhost" --enrollment.profile tls
