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

# Originator
# # issue certificates for admin identity and for client tls
# register identity with CA admin
export CSR_NAMES_ORIGINATOR="C=SP,ST=OriginatorState,L=OriginatorLocation,O=Originator,OU=Hyperledger Fabric"
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/originator/ca/clients/admin
# export FABRIC_CA_CLIENT_TLS_CERTFILES=/home/oliver/ppa/network/fabric-ca/originator/ca/clients/admin/msp/cacerts/localhost-7055.pem
export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/originator/ca/ca-cert.pem
fabric-ca-client register --id.name originator-admin --id.secret originator-adminpw --id.type admin -u https://rootca-originator-admin:rootca-originator-adminpw@localhost:7055
# enroll registered identity
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/originator/ca/clients/originator-admin
fabric-ca-client enroll -u https://originator-admin:originator-adminpw@localhost:7055 --csr.names "$CSR_NAMES_ORIGINATOR" --tls.certfiles $FABRIC_CA_CLIENT_TLS_CERTFILES --csr.hosts "rootca-originator-admin,localhost"


# register identity with TLS CA admin
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/originator/tls-ca/clients/admin
# export FABRIC_CA_CLIENT_TLS_CERTFILES=/home/oliver/ppa/network/fabric-ca/originator/tls-ca/clients/admin/msp/cacerts/localhost-7054.pem
export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/originator/tls-ca/ca-cert.pem
fabric-ca-client register --id.name originator-admin --id.secret originator-adminpw --id.type admin -u https://tls-ca-originator-admin:tls-ca-originator-adminpw@localhost:7054
# enroll registered identity
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/originator/tls-ca/clients/originator-admin
fabric-ca-client enroll -u https://originator-admin:originator-adminpw@localhost:7054 --csr.names "$CSR_NAMES_ORIGINATOR" --tls.certfiles $FABRIC_CA_CLIENT_TLS_CERTFILES --csr.hosts "originator-admin,localhost" --enrollment.profile tls


# # issue certificates for client identity and for client tls
# register identity with CA admin
export CSR_NAMES_ORIGINATOR="C=SP,ST=OriginatorState,L=OriginatorLocation,O=Originator,OU=Hyperledger Fabric"
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/originator/ca/clients/admin
# export FABRIC_CA_CLIENT_TLS_CERTFILES=/home/oliver/ppa/network/fabric-ca/originator/ca/clients/admin/msp/cacerts/localhost-7055.pem
export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/originator/ca/ca-cert.pem
#modificada afiliacion
fabric-ca-client register --id.name originator-client --id.secret originator-clientpw --id.type client --id.affiliation originator.cliente -u https://rootca-originator-admin:rootca-originator-adminpw@localhost:7055
# fabric-ca-client affiliation add originator-client --id.name originator-client --id.secret originator-clientpw --id.type client -u https://rootca-originator-admin:rootca-originator-adminpw@localhost:7055
# enroll registered identity
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/originator/ca/clients/originator-client
fabric-ca-client enroll -u https://originator-client:originator-clientpw@localhost:7055 --csr.names "$CSR_NAMES_ORIGINATOR" --tls.certfiles $FABRIC_CA_CLIENT_TLS_CERTFILES --csr.hosts "rootca-originator-admin,localhost"


# register identity with TLS CA admin
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/originator/tls-ca/clients/admin
# export FABRIC_CA_CLIENT_TLS_CERTFILES=/home/oliver/ppa/network/fabric-ca/originator/tls-ca/clients/admin/msp/cacerts/localhost-7054.pem
export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/originator/tls-ca/ca-cert.pem
fabric-ca-client register --id.name originator-client --id.secret originator-clientpw --id.type client -u https://tls-ca-originator-admin:tls-ca-originator-adminpw@localhost:7054
# enroll registered identity
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/originator/tls-ca/clients/originator-client
fabric-ca-client enroll -u https://originator-client:originator-clientpw@localhost:7054 --csr.names "$CSR_NAMES_ORIGINATOR" --tls.certfiles $FABRIC_CA_CLIENT_TLS_CERTFILES --csr.hosts "originator-client,localhost" --enrollment.profile tls

# # # issue certificates for peer node identity and for peer server tls

export CSR_NAMES_ORIGINATOR="C=SP,ST=OriginatorState,L=OriginatorLocation,O=Originator,OU=Hyperledger Fabric"
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/originator/ca/clients/admin
# export FABRIC_CA_CLIENT_TLS_CERTFILES=/home/oliver/ppa/network/fabric-ca/originator/ca/clients/admin/msp/cacerts/localhost-7055.pem
export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/originator/ca/ca-cert.pem
fabric-ca-client register --id.name originator-peer --id.secret originator-peerpw --id.type peer -u https://rootca-originator-admin:rootca-originator-adminpw@localhost:7055
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/originator/ca/clients/originator-peer
fabric-ca-client enroll -u https://originator-peer:originator-peerpw@localhost:7055 --csr.names "$CSR_NAMES_ORIGINATOR"  --tls.certfiles $FABRIC_CA_CLIENT_TLS_CERTFILES --csr.hosts "rootca-originator-admin,localhost"


export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/originator/tls-ca/clients/admin
# export FABRIC_CA_CLIENT_TLS_CERTFILES=/home/oliver/ppa/network/fabric-ca/originator/tls-ca/clients/admin/msp/cacerts/localhost-7054.pem
export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/originator/tls-ca/ca-cert.pem
fabric-ca-client register --id.name originator-peer --id.secret originator-peerpw --id.type peer -u https://tls-ca-originator-admin:tls-ca-originator-adminpw@localhost:7054
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/originator/tls-ca/clients/originator-peer
fabric-ca-client enroll -u https://originator-peer:originator-peerpw@localhost:7054 --csr.names "$CSR_NAMES_ORIGINATOR" --tls.certfiles $FABRIC_CA_CLIENT_TLS_CERTFILES --csr.hosts "originator-peer,localhost" --enrollment.profile tls


# # # issue certificates for orderer node identity and for orderer server tls

export CSR_NAMES_ORIGINATOR="C=SP,ST=OriginatorState,L=OriginatorLocation,O=Originator,OU=Hyperledger Fabric"
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/originator/ca/clients/admin
# export FABRIC_CA_CLIENT_TLS_CERTFILES=/home/oliver/ppa/network/fabric-ca/originator/ca/clients/admin/msp/cacerts/localhost-7055.pem
export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/originator/ca/ca-cert.pem
fabric-ca-client register --id.name originator-orderer --id.secret originator-ordererpw --id.type orderer -u https://rootca-originator-admin:rootca-originator-adminpw@localhost:7055
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/originator/ca/clients/originator-orderer
fabric-ca-client enroll -u https://originator-orderer:originator-ordererpw@localhost:7055 --csr.names "$CSR_NAMES_ORIGINATOR"  --tls.certfiles $FABRIC_CA_CLIENT_TLS_CERTFILES --csr.hosts "rootca-originator-admin,localhost"


export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/originator/tls-ca/clients/admin
# export FABRIC_CA_CLIENT_TLS_CERTFILES=/home/oliver/ppa/network/fabric-ca/originator/tls-ca/clients/admin/msp/cacerts/localhost-7054.pem
export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/originator/tls-ca/ca-cert.pem
fabric-ca-client register --id.name originator-orderer --id.secret originator-ordererpw --id.type orderer -u https://tls-ca-originator-admin:tls-ca-originator-adminpw@localhost:7054
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/originator/tls-ca/clients/originator-orderer
fabric-ca-client enroll -u https://originator-orderer:originator-ordererpw@localhost:7054 --csr.names "$CSR_NAMES_ORIGINATOR" --tls.certfiles $FABRIC_CA_CLIENT_TLS_CERTFILES --csr.hosts "originator-orderer,localhost" --enrollment.profile tls


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
for i in {1..1}
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


# # Aggregator
# # issue certificates for admin identity and for admin tls
export CSR_NAMES_AGGREGATOR="C=SP,ST=AggregatorState,L=AggregatorLocation,O=Aggregator,OU=Hyperledger Fabric"
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/aggregator/ca/clients/admin
# export FABRIC_CA_CLIENT_TLS_CERTFILES=/home/oliver/ppa/network/fabric-ca/aggregator/ca/clients/admin/msp/cacerts/localhost-9055.pem
export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/aggregator/ca/ca-cert.pem
fabric-ca-client register --id.name aggregator-admin --id.secret aggregator-adminpw --id.type admin -u https://rootca-aggregator-admin:rootca-aggregator-adminpw@localhost:9055
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/aggregator/ca/clients/aggregator-admin
fabric-ca-client enroll -u https://aggregator-admin:aggregator-adminpw@localhost:9055 --csr.names "$CSR_NAMES_AGGREGATOR"  --tls.certfiles $FABRIC_CA_CLIENT_TLS_CERTFILES --csr.hosts "rootca-aggregator-admin,localhost"


export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/aggregator/tls-ca/clients/admin
# export FABRIC_CA_CLIENT_TLS_CERTFILES=/home/oliver/ppa/network/fabric-ca/aggregator/tls-ca/clients/admin/msp/cacerts/localhost-9054.pem
export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/aggregator/tls-ca/ca-cert.pem
fabric-ca-client register --id.name aggregator-admin --id.secret aggregator-adminpw --id.type admin -u https://tls-ca-aggregator-admin:tls-ca-aggregator-adminpw@localhost:9054
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/aggregator/tls-ca/clients/aggregator-admin
fabric-ca-client enroll -u https://aggregator-admin:aggregator-adminpw@localhost:9054 --csr.names "$CSR_NAMES_AGGREGATOR" --tls.certfiles $FABRIC_CA_CLIENT_TLS_CERTFILES --csr.hosts "aggregator-admin,localhost" --enrollment.profile tls


function issueCertificatesWithAffiliation() {
	number=$1
	org=$2	

	export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/$org/ca/clients/admin
# export FABRIC_CA_CLIENT_TLS_CERTFILES=/home/oliver/ppa/network/fabric-ca/farmer/ca/clients/admin/msp/cacerts/localhost-8055.pem
	export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/$org/ca/ca-cert.pem
    # register identity with CA admin
	fabric-ca-client register --id.name $org-client-$number --id.secret $org-client-$number-pw --id.type client --id.affiliation $org.cliente -u https://rootca-$org-admin:rootca-$org-adminpw@localhost:9055
    # enroll registered identity
	export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/$org/ca/clients/$org-client-$number
	fabric-ca-client enroll -u https://$org-client-$number:$org-client-$number-pw@localhost:9055 --csr.names "$CSR_NAMES_FARMER" --tls.certfiles $FABRIC_CA_CLIENT_TLS_CERTFILES --csr.hosts "rootca-aggregator-admin,localhost"
}
function issueTLSCertificates() {
    	number=$1
	org=$2
 	export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/$org/tls-ca/ca-cert.pem
	export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/$org/tls-ca/clients/admin
	fabric-ca-client register --id.name $org-client-$number --id.secret $org-client-$number-pw --id.type client -u https://tls-ca-$org-admin:tls-ca-$org-adminpw@localhost:9054    # enroll registered identity
	export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/$org/tls-ca/clients/$org-client-$number
	fabric-ca-client enroll -u https://$org-client-$number:$org-client-$number-pw@localhost:9054 --csr.names "$CSR_NAMES_FARMER" --tls.certfiles $FABRIC_CA_CLIENT_TLS_CERTFILES --csr.hosts "aggregator-client-$number,localhost" --enrollment.profile tls
}


for i in {1..1}
do
	issueCertificatesWithAffiliation $i aggregator
	issueTLSCertificates $i aggregator
done





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

export CSR_NAMES_AGGREGATOR="C=SP,ST=AggregatorState,L=AggregatorLocation,O=Aggregator,OU=Hyperledger Fabric"
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/aggregator/ca/clients/admin
# export FABRIC_CA_CLIENT_TLS_CERTFILES=/home/oliver/ppa/network/fabric-ca/aggregator/ca/clients/admin/msp/cacerts/localhost-9055.pem
export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/aggregator/ca/ca-cert.pem
fabric-ca-client register --id.name aggregator-peer --id.secret aggregator-peerpw --id.type peer -u https://rootca-aggregator-admin:rootca-aggregator-adminpw@localhost:9055
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/aggregator/ca/clients/aggregator-peer
fabric-ca-client enroll -u https://aggregator-peer:aggregator-peerpw@localhost:9055 --csr.names "$CSR_NAMES_AGGREGATOR"  --tls.certfiles $FABRIC_CA_CLIENT_TLS_CERTFILES --csr.hosts "rootca-aggregator-admin,localhost"


export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/aggregator/tls-ca/clients/admin
# export FABRIC_CA_CLIENT_TLS_CERTFILES=/home/oliver/ppa/network/fabric-ca/aggregator/tls-ca/clients/admin/msp/cacerts/localhost-9054.pem
export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/aggregator/tls-ca/ca-cert.pem
fabric-ca-client register --id.name aggregator-peer --id.secret aggregator-peerpw --id.type peer -u https://tls-ca-aggregator-admin:tls-ca-aggregator-adminpw@localhost:9054
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/aggregator/tls-ca/clients/aggregator-peer
fabric-ca-client enroll -u https://aggregator-peer:aggregator-peerpw@localhost:9054 --csr.names "$CSR_NAMES_AGGREGATOR" --tls.certfiles $FABRIC_CA_CLIENT_TLS_CERTFILES --csr.hosts "aggregator-peer,localhost" --enrollment.profile tls


# # # issue certificates for orderer node identity and for orderer server tls

export CSR_NAMES_AGGREGATOR="C=SP,ST=AggregatorState,L=AggregatorLocation,O=Aggregator,OU=Hyperledger Fabric"
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/aggregator/ca/clients/admin
# export FABRIC_CA_CLIENT_TLS_CERTFILES=/home/oliver/ppa/network/fabric-ca/aggregator/ca/clients/admin//msp/cacerts/localhost-9055.pem
export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/aggregator/ca/ca-cert.pem
fabric-ca-client register --id.name aggregator-orderer --id.secret aggregator-ordererpw --id.type orderer -u https://rootca-aggregator-admin:rootca-aggregator-adminpw@localhost:9055
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/aggregator/ca/clients/aggregator-orderer
fabric-ca-client enroll -u https://aggregator-orderer:aggregator-ordererpw@localhost:9055 --csr.names "$CSR_NAMES_AGGREGATOR"  --tls.certfiles $FABRIC_CA_CLIENT_TLS_CERTFILES --csr.hosts "rootca-aggregator-admin,localhost"


export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/aggregator/tls-ca/clients/admin
# export FABRIC_CA_CLIENT_TLS_CERTFILES=/home/oliver/ppa/network/fabric-ca/aggregator/tls-ca/clients/admin//msp/cacerts/localhost-9054.pem
export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/aggregator/tls-ca/ca-cert.pem
fabric-ca-client register --id.name aggregator-orderer --id.secret aggregator-ordererpw --id.type orderer -u https://tls-ca-aggregator-admin:tls-ca-aggregator-adminpw@localhost:9054
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/aggregator/tls-ca/clients/aggregator-orderer
fabric-ca-client enroll -u https://aggregator-orderer:aggregator-ordererpw@localhost:9054 --csr.names "$CSR_NAMES_AGGREGATOR" --tls.certfiles $FABRIC_CA_CLIENT_TLS_CERTFILES --csr.hosts "aggregator-orderer,localhost" --enrollment.profile tls

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
export CSR_NAMES_UNDERWRITTER="C=SP,ST=UnderwritterState,L=UnderwritterLocation,O=Underwritter,OU=Hyperledger Fabric"
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/underwritter/ca/clients/admin
# export FABRIC_CA_CLIENT_TLS_CERTFILES=/home/oliver/ppa/network/fabric-ca/underwritter/ca/clients/admin/msp/cacerts/localhost-11055.pem
export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/underwritter/ca/ca-cert.pem
fabric-ca-client register --id.name underwritter-admin --id.secret underwritter-adminpw --id.type admin -u https://rootca-underwritter-admin:rootca-underwritter-adminpw@localhost:11055
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/underwritter/ca/clients/underwritter-admin
fabric-ca-client enroll -u https://underwritter-admin:underwritter-adminpw@localhost:11055 --csr.names "$CSR_NAMES_UNDERWRITTER"  --tls.certfiles $FABRIC_CA_CLIENT_TLS_CERTFILES --csr.hosts "rootca-underwritter-admin,localhost"


export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/underwritter/tls-ca/clients/admin
# export FABRIC_CA_CLIENT_TLS_CERTFILES=/home/oliver/ppa/network/fabric-ca/underwritter/tls-ca/clients/admin/msp/cacerts/localhost-11054.pem
export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/underwritter/tls-ca/ca-cert.pem
fabric-ca-client register --id.name underwritter-admin --id.secret underwritter-adminpw --id.type admin -u https://tls-ca-underwritter-admin:tls-ca-underwritter-adminpw@localhost:11054
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/underwritter/tls-ca/clients/underwritter-admin
fabric-ca-client enroll -u https://underwritter-admin:underwritter-adminpw@localhost:11054 --csr.names "$CSR_NAMES_UNDERWRITTER" --tls.certfiles $FABRIC_CA_CLIENT_TLS_CERTFILES --csr.hosts "underwritter-admin,localhost" --enrollment.profile tls


function issueCertificatesWithAffiliation() {
	number=$1
	org=$2	

	export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/$org/ca/clients/admin
# export FABRIC_CA_CLIENT_TLS_CERTFILES=/home/oliver/ppa/network/fabric-ca/farmer/ca/clients/admin/msp/cacerts/localhost-8055.pem
	export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/$org/ca/ca-cert.pem
    # register identity with CA admin
	fabric-ca-client register --id.name $org-client-$number --id.secret $org-client-$number-pw --id.type client --id.affiliation $org.cliente -u https://rootca-$org-admin:rootca-$org-adminpw@localhost:11055
    # enroll registered identity
	export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/$org/ca/clients/$org-client-$number
	fabric-ca-client enroll -u https://$org-client-$number:$org-client-$number-pw@localhost:11055 --csr.names "$CSR_NAMES_FARMER" --tls.certfiles $FABRIC_CA_CLIENT_TLS_CERTFILES --csr.hosts "rootca-underwritter-admin,localhost"
}
function issueTLSCertificates() {
    number=$1
	org=$2
 	export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/$org/tls-ca/ca-cert.pem
	export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/$org/tls-ca/clients/admin
	fabric-ca-client register --id.name $org-client-$number --id.secret $org-client-$number-pw --id.type client -u https://tls-ca-$org-admin:tls-ca-$org-adminpw@localhost:11054    # enroll registered identity
	export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/$org/tls-ca/clients/$org-client-$number
	fabric-ca-client enroll -u https://$org-client-$number:$org-client-$number-pw@localhost:11054 --csr.names "$CSR_NAMES_FARMER" --tls.certfiles $FABRIC_CA_CLIENT_TLS_CERTFILES --csr.hosts "underwritter-client-$number,localhost" --enrollment.profile tls
}


for i in {1..1}
do
	issueCertificatesWithAffiliation $i underwritter
	issueTLSCertificates $i underwritter
done


# # # issue certificates for client identity and for client tls
# export CSR_NAMES_UNDERWRITTER="C=SP,ST=UnderwritterState,L=UnderwritterLocation,O=Underwritter,OU=Hyperledger Fabric"
# export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/underwritter/ca/clients/admin
# # export FABRIC_CA_CLIENT_TLS_CERTFILES=/home/oliver/ppa/network/fabric-ca/underwritter/ca/clients/admin/msp/cacerts/localhost-11055.pem
# export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/underwritter/ca/ca-cert.pem
# fabric-ca-client register --id.name underwritter-client --id.secret underwritter-clientpw --id.type client --id.affiliation underwritter.cliente -u https://rootca-underwritter-admin:rootca-underwritter-adminpw@localhost:11055
# export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/underwritter/ca/clients/underwritter-client
# fabric-ca-client enroll -u https://underwritter-client:underwritter-clientpw@localhost:11055 --csr.names "$CSR_NAMES_UNDERWRITTER"  --tls.certfiles $FABRIC_CA_CLIENT_TLS_CERTFILES --csr.hosts "rootca-underwritter-admin,localhost"


# export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/underwritter/tls-ca/clients/admin
# # export FABRIC_CA_CLIENT_TLS_CERTFILES=/home/oliver/ppa/network/fabric-ca/underwritter/tls-ca/clients/admin/msp/cacerts/localhost-11054.pem
# export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/underwritter/tls-ca/ca-cert.pem
# fabric-ca-client register --id.name underwritter-client --id.secret underwritter-clientpw --id.type client -u https://tls-ca-underwritter-admin:tls-ca-underwritter-adminpw@localhost:11054
# export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/underwritter/tls-ca/clients/underwritter-client
# fabric-ca-client enroll -u https://underwritter-client:underwritter-clientpw@localhost:11054 --csr.names "$CSR_NAMES_UNDERWRITTER" --tls.certfiles $FABRIC_CA_CLIENT_TLS_CERTFILES --csr.hosts "underwritter-client,localhost" --enrollment.profile tls

# # # issue certificates for peer node identity and for peer server tls

export CSR_NAMES_UNDERWRITTER="C=SP,ST=UnderwritterState,L=UnderwritterLocation,O=Underwritter,OU=Hyperledger Fabric"
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/underwritter/ca/clients/admin
# export FABRIC_CA_CLIENT_TLS_CERTFILES=/home/oliver/ppa/network/fabric-ca/underwritter/ca/clients/admin/msp/cacerts/localhost-11055.pem
export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/underwritter/ca/ca-cert.pem
fabric-ca-client register --id.name underwritter-peer --id.secret underwritter-peerpw --id.type peer -u https://rootca-underwritter-admin:rootca-underwritter-adminpw@localhost:11055
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/underwritter/ca/clients/underwritter-peer
fabric-ca-client enroll -u https://underwritter-peer:underwritter-peerpw@localhost:11055 --csr.names "$CSR_NAMES_UNDERWRITTER"  --tls.certfiles $FABRIC_CA_CLIENT_TLS_CERTFILES --csr.hosts "rootca-underwritter-admin,localhost"


export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/underwritter/tls-ca/clients/admin
# export FABRIC_CA_CLIENT_TLS_CERTFILES=/home/oliver/ppa/network/fabric-ca/underwritter/tls-ca/clients/admin/msp/cacerts/localhost-11054.pem
export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/underwritter/tls-ca/ca-cert.pem
fabric-ca-client register --id.name underwritter-peer --id.secret underwritter-peerpw --id.type peer -u https://tls-ca-underwritter-admin:tls-ca-underwritter-adminpw@localhost:11054
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/underwritter/tls-ca/clients/underwritter-peer
fabric-ca-client enroll -u https://underwritter-peer:underwritter-peerpw@localhost:11054 --csr.names "$CSR_NAMES_UNDERWRITTER" --tls.certfiles $FABRIC_CA_CLIENT_TLS_CERTFILES --csr.hosts "underwritter-peer,localhost" --enrollment.profile tls


# # # issue certificates for orderer node identity and for orderer server tls

export CSR_NAMES_UNDERWRITTER="C=SP,ST=UnderwritterState,L=UnderwritterLocation,O=Underwritter,OU=Hyperledger Fabric"
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/underwritter/ca/clients/admin
# export FABRIC_CA_CLIENT_TLS_CERTFILES=/home/oliver/ppa/network/fabric-ca/underwritter/ca/clients/admin/msp/cacerts/localhost-11055.pem
export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/underwritter/ca/ca-cert.pem
fabric-ca-client register --id.name underwritter-orderer --id.secret underwritter-ordererpw --id.type orderer -u https://rootca-underwritter-admin:rootca-underwritter-adminpw@localhost:11055
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/underwritter/ca/clients/underwritter-orderer
fabric-ca-client enroll -u https://underwritter-orderer:underwritter-ordererpw@localhost:11055 --csr.names "$CSR_NAMES_UNDERWRITTER"  --tls.certfiles $FABRIC_CA_CLIENT_TLS_CERTFILES --csr.hosts "rootca-underwritter-admin,localhost"


export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/underwritter/tls-ca/clients/admin
# export FABRIC_CA_CLIENT_TLS_CERTFILES=/home/oliver/ppa/network/fabric-ca/underwritter/tls-ca/clients/admin/msp/cacerts/localhost-11054.pem
export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/underwritter/tls-ca/ca-cert.pem
fabric-ca-client register --id.name underwritter-orderer --id.secret underwritter-ordererpw --id.type orderer -u https://tls-ca-underwritter-admin:tls-ca-underwritter-adminpw@localhost:11054
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/underwritter/tls-ca/clients/underwritter-orderer
fabric-ca-client enroll -u https://underwritter-orderer:underwritter-ordererpw@localhost:11054 --csr.names "$CSR_NAMES_UNDERWRITTER" --tls.certfiles $FABRIC_CA_CLIENT_TLS_CERTFILES --csr.hosts "underwritter-orderer,localhost" --enrollment.profile tls
