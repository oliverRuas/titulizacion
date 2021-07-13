export NEW_PATH=$(cd ../ && pwd)
#Funciones para el farmer client
function issueCertificatesWithAffiliation() {
	number=$1

	export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/farmer/ca/clients/admin
# export FABRIC_CA_CLIENT_TLS_CERTFILES=/home/oliver/ppa/network/fabric-ca/farmer/ca/clients/admin/msp/cacerts/localhost-8055.pem
	export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/farmer/ca/ca-cert.pem
    # register identity with CA admin
	export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/farmer/ca/clients/farmer-client-$number
	fabric-ca-client reenroll
}
function issueTLSCertificates() {
    	number=$1
 	export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/farmer/tls-ca/ca-cert.pem
	export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/farmer/tls-ca/clients/admin
	export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/farmer/tls-ca/clients/farmer-client-$number
	fabric-ca-client reenroll
}

# Originator
# # issue certificates for admin identity and for client tls
# register identity with CA admin
export CSR_NAMES_ORIGINATOR="C=SP,ST=OriginatorState,L=OriginatorLocation,O=Originator,OU=Hyperledger Fabric"
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/originator/ca/clients/admin
# export FABRIC_CA_CLIENT_TLS_CERTFILES=/home/oliver/ppa/network/fabric-ca/originator/ca/clients/admin/msp/cacerts/localhost-7055.pem
export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/originator/ca/ca-cert.pem
# enroll registered identity
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/originator/ca/clients/originator-admin
fabric-ca-client reenroll


# register identity with TLS CA admin
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/originator/tls-ca/clients/admin
# export FABRIC_CA_CLIENT_TLS_CERTFILES=/home/oliver/ppa/network/fabric-ca/originator/tls-ca/clients/admin/msp/cacerts/localhost-7054.pem
export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/originator/tls-ca/ca-cert.pem
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/originator/tls-ca/clients/originator-admin
fabric-ca-client reenroll


# # issue certificates for client identity and for client tls
# register identity with CA admin
export CSR_NAMES_ORIGINATOR="C=SP,ST=OriginatorState,L=OriginatorLocation,O=Originator,OU=Hyperledger Fabric"
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/originator/ca/clients/admin
# export FABRIC_CA_CLIENT_TLS_CERTFILES=/home/oliver/ppa/network/fabric-ca/originator/ca/clients/admin/msp/cacerts/localhost-7055.pem
export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/originator/ca/ca-cert.pem
# enroll registered identity
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/originator/ca/clients/originator-client
fabric-ca-client reenroll


# register identity with TLS CA admin
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/originator/tls-ca/clients/admin
# export FABRIC_CA_CLIENT_TLS_CERTFILES=/home/oliver/ppa/network/fabric-ca/originator/tls-ca/clients/admin/msp/cacerts/localhost-7054.pem
export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/originator/tls-ca/ca-cert.pem
# enroll registered identity
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/originator/tls-ca/clients/originator-client
fabric-ca-client reenroll

# # # issue certificates for peer node identity and for peer server tls

export CSR_NAMES_ORIGINATOR="C=SP,ST=OriginatorState,L=OriginatorLocation,O=Originator,OU=Hyperledger Fabric"
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/originator/ca/clients/admin
# export FABRIC_CA_CLIENT_TLS_CERTFILES=/home/oliver/ppa/network/fabric-ca/originator/ca/clients/admin/msp/cacerts/localhost-7055.pem
export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/originator/ca/ca-cert.pem
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/originator/ca/clients/originator-peer
fabric-ca-client reenroll


export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/originator/tls-ca/clients/admin
# export FABRIC_CA_CLIENT_TLS_CERTFILES=/home/oliver/ppa/network/fabric-ca/originator/tls-ca/clients/admin/msp/cacerts/localhost-7054.pem
export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/originator/tls-ca/ca-cert.pem
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/originator/tls-ca/clients/originator-peer
fabric-ca-client reenroll


# # # issue certificates for orderer node identity and for orderer server tls

export CSR_NAMES_ORIGINATOR="C=SP,ST=OriginatorState,L=OriginatorLocation,O=Originator,OU=Hyperledger Fabric"
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/originator/ca/clients/admin
# export FABRIC_CA_CLIENT_TLS_CERTFILES=/home/oliver/ppa/network/fabric-ca/originator/ca/clients/admin/msp/cacerts/localhost-7055.pem
export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/originator/ca/ca-cert.pem
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/originator/ca/clients/originator-orderer
fabric-ca-client reenroll


export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/originator/tls-ca/clients/admin
# export FABRIC_CA_CLIENT_TLS_CERTFILES=/home/oliver/ppa/network/fabric-ca/originator/tls-ca/clients/admin/msp/cacerts/localhost-7054.pem
export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/originator/tls-ca/ca-cert.pem
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/originator/tls-ca/clients/originator-orderer
fabric-ca-client reenroll


# # Farmer
# # issue certificates for admin identity and for admin tls
export CSR_NAMES_FARMER="C=SP,ST=FarmerState,L=FarmerLocation,O=Farmer,OU=Hyperledger Fabric"
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/farmer/ca/clients/admin
# export FABRIC_CA_CLIENT_TLS_CERTFILES=/home/oliver/ppa/network/fabric-ca/farmer/ca/clients/admin/msp/cacerts/ca-cert.pem
export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/farmer/ca/ca-cert.pem
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/farmer/ca/clients/farmer-admin
fabric-ca-client reenroll


export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/farmer/tls-ca/clients/admin
# export FABRIC_CA_CLIENT_TLS_CERTFILES=/home/oliver/ppa/network/fabric-ca/farmer/tls-ca/clients/admin/msp/cacerts/localhost-8054.pem
export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/farmer/tls-ca/ca-cert.pem
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/farmer/tls-ca/clients/farmer-admin
fabric-ca-client reenroll


export CSR_NAMES_FARMER="C=SP,ST=FarmerState,L=FarmerLocation,O=Farmer,OU=Hyperledger Fabric"
for i in {1..100}
do
	issueCertificatesWithAffiliation $i
	issueTLSCertificates $i
done



# # # issue certificates for peer node identity and for peer server tls

export CSR_NAMES_FARMER="C=SP,ST=FarmerState,L=FarmerLocation,O=Farmer,OU=Hyperledger Fabric"
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/farmer/ca/clients/admin
# export FABRIC_CA_CLIENT_TLS_CERTFILES=/home/oliver/ppa/network/fabric-ca/farmer/ca/clients/admin/msp/cacerts/localhost-8055.pem
export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/farmer/ca/ca-cert.pem
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/farmer/ca/clients/farmer-peer
fabric-ca-client reenroll


export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/farmer/tls-ca/clients/admin
# export FABRIC_CA_CLIENT_TLS_CERTFILES=/home/oliver/ppa/network/fabric-ca/farmer/tls-ca/clients/admin/msp/cacerts/localhost-8054.pem
export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/farmer/tls-ca/ca-cert.pem
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/farmer/tls-ca/clients/farmer-peer
fabric-ca-client reenroll


# # # issue certificates for orderer node identity and for orderer server tls

export CSR_NAMES_FARMER="C=SP,ST=FarmerState,L=FarmerLocation,O=Farmer,OU=Hyperledger Fabric"
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/farmer/ca/clients/admin
# export FABRIC_CA_CLIENT_TLS_CERTFILES=/home/oliver/ppa/network/fabric-ca/farmer/ca/clients/admin/msp/cacerts/localhost-8055.pem
export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/farmer/ca/ca-cert.pem
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/farmer/ca/clients/farmer-orderer
fabric-ca-client reenroll


export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/farmer/tls-ca/clients/admin
# export FABRIC_CA_CLIENT_TLS_CERTFILES=/home/oliver/ppa/network/fabric-ca/farmer/tls-ca/clients/admin//msp/cacerts/localhost-8054.pem
export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/farmer/tls-ca/ca-cert.pem
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/farmer/tls-ca/clients/farmer-orderer
fabric-ca-client reenroll


# # Aggregator
# # issue certificates for admin identity and for admin tls
export CSR_NAMES_AGGREGATOR="C=SP,ST=AggregatorState,L=AggregatorLocation,O=Aggregator,OU=Hyperledger Fabric"
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/aggregator/ca/clients/admin
# export FABRIC_CA_CLIENT_TLS_CERTFILES=/home/oliver/ppa/network/fabric-ca/aggregator/ca/clients/admin/msp/cacerts/localhost-9055.pem
export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/aggregator/ca/ca-cert.pem
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/aggregator/ca/clients/aggregator-admin
fabric-ca-client reenroll

export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/aggregator/tls-ca/clients/admin
# export FABRIC_CA_CLIENT_TLS_CERTFILES=/home/oliver/ppa/network/fabric-ca/aggregator/tls-ca/clients/admin/msp/cacerts/localhost-9054.pem
export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/aggregator/tls-ca/ca-cert.pem
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/aggregator/tls-ca/clients/aggregator-admin
fabric-ca-client reenroll

function issueCertificatesWithAffiliation() {
	number=$1
	org=$2	

	export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/$org/ca/clients/admin
	export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/$org/ca/ca-cert.pem
	export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/$org/ca/clients/$org-client-$number
	fabric-ca-client reenroll
}
function issueTLSCertificates() {
    	number=$1
	org=$2
 	export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/$org/tls-ca/ca-cert.pem
	export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/$org/tls-ca/clients/admin
	export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/$org/tls-ca/clients/$org-client-$number
	fabric-ca-client reenroll
}


for i in {1..2}
do
	issueCertificatesWithAffiliation $i aggregator
	issueTLSCertificates $i aggregator
done





# # issue certificates for client identity and for client tls
export CSR_NAMES_AGGREGATOR="C=SP,ST=AggregatorState,L=AggregatorLocation,O=Aggregator,OU=Hyperledger Fabric"
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/aggregator/ca/clients/admin
# export FABRIC_CA_CLIENT_TLS_CERTFILES=/home/oliver/ppa/network/fabric-ca/aggregator/ca/clients/admin/msp/cacerts/localhost-9055.pem
export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/aggregator/ca/ca-cert.pem
#modificada afiliacion
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/aggregator/ca/clients/aggregator-client
fabric-ca-client reenroll

export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/aggregator/tls-ca/clients/admin
export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/aggregator/tls-ca/ca-cert.pem
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/aggregator/tls-ca/clients/aggregator-client
fabric-ca-client reenroll
# # # issue certificates for peer node identity and for peer server tls

export CSR_NAMES_AGGREGATOR="C=SP,ST=AggregatorState,L=AggregatorLocation,O=Aggregator,OU=Hyperledger Fabric"
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/aggregator/ca/clients/admin
export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/aggregator/ca/ca-cert.pem
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/aggregator/ca/clients/aggregator-peer
fabric-ca-client reenroll

export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/aggregator/tls-ca/clients/admin
export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/aggregator/tls-ca/ca-cert.pem
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/aggregator/tls-ca/clients/aggregator-peer
fabric-ca-client reenroll

# # # issue certificates for orderer node identity and for orderer server tls

export CSR_NAMES_AGGREGATOR="C=SP,ST=AggregatorState,L=AggregatorLocation,O=Aggregator,OU=Hyperledger Fabric"
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/aggregator/ca/clients/admin
# export FABRIC_CA_CLIENT_TLS_CERTFILES=/home/oliver/ppa/network/fabric-ca/aggregator/ca/clients/admin//msp/cacerts/localhost-9055.pem
export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/aggregator/ca/ca-cert.pem
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/aggregator/ca/clients/aggregator-orderer
fabric-ca-client reenroll

export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/aggregator/tls-ca/clients/admin
# export FABRIC_CA_CLIENT_TLS_CERTFILES=/home/oliver/ppa/network/fabric-ca/aggregator/tls-ca/clients/admin//msp/cacerts/localhost-9054.pem
export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/aggregator/tls-ca/ca-cert.pem
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/aggregator/tls-ca/clients/aggregator-orderer
fabric-ca-client reenroll

# SPV
# # issue certificates for client identity and for client tls
export CSR_NAMES_SPV="C=SP,ST=SPVState,L=SPVLocation,O=SPV,OU=Hyperledger Fabric"
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/spv/ca/clients/admin
export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/spv/ca/ca-cert.pem
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/spv/ca/clients/spv-admin
fabric-ca-client reenroll

export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/spv/tls-ca/clients/admin
export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/spv/tls-ca/ca-cert.pem
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/spv/tls-ca/clients/spv-admin
fabric-ca-client reenroll

# # issue certificates for client identity and for client tls
export CSR_NAMES_SPV="C=SP,ST=SPVState,L=SPVLocation,O=SPV,OU=Hyperledger Fabric"
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/spv/ca/clients/admin
export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/spv/ca/ca-cert.pem
#modificada afiliacion
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/spv/ca/clients/spv-client
fabric-ca-client reenroll

export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/spv/tls-ca/clients/admin
# export FABRIC_CA_CLIENT_TLS_CERTFILES=/home/oliver/ppa/network/fabric-ca/spv/tls-ca/clients/admin/msp/cacerts/localhost-10054.pem
export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/spv/tls-ca/ca-cert.pem
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/spv/tls-ca/clients/spv-client
fabric-ca-client reenroll

# # # issue certificates for peer node identity and for peer server tls

export CSR_NAMES_SPV="C=SP,ST=SPVState,L=SPVLocation,O=SPV,OU=Hyperledger Fabric"
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/spv/ca/clients/admin
export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/spv/ca/ca-cert.pem
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/spv/ca/clients/spv-peer
fabric-ca-client reenroll

export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/spv/tls-ca/clients/admin
export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/spv/tls-ca/ca-cert.pem
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/spv/tls-ca/clients/spv-peer
fabric-ca-client reenroll

# # # issue certificates for orderer node identity and for orderer server tls

export CSR_NAMES_SPV="C=SP,ST=SPVState,L=SPVLocation,O=SPV,OU=Hyperledger Fabric"
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/spv/ca/clients/admin
export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/spv/ca/ca-cert.pem
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/spv/ca/clients/spv-orderer
fabric-ca-client reenroll

export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/spv/tls-ca/clients/admin
export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/spv/tls-ca/ca-cert.pem
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/spv/tls-ca/clients/spv-orderer
fabric-ca-client reenroll


#Underwritter
# # issue certificates for admin identity and for admin tls
export CSR_NAMES_UNDERWRITTER="C=SP,ST=UnderwritterState,L=UnderwritterLocation,O=Underwritter,OU=Hyperledger Fabric"
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/underwritter/ca/clients/admin
export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/underwritter/ca/ca-cert.pem
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/underwritter/ca/clients/underwritter-admin
fabric-ca-client reenroll

export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/underwritter/tls-ca/clients/admin
export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/underwritter/tls-ca/ca-cert.pem
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/underwritter/tls-ca/clients/underwritter-admin
fabric-ca-client reenroll

function issueCertificatesWithAffiliation() {
	number=$1
	org=$2	

	export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/$org/ca/clients/admin
	export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/$org/ca/ca-cert.pem
	export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/$org/ca/clients/$org-client-$number
	fabric-ca-client reenroll
}
function issueTLSCertificates() {
    number=$1
	org=$2
 	export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/$org/tls-ca/ca-cert.pem
	export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/$org/tls-ca/clients/admin
	export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/$org/tls-ca/clients/$org-client-$number
	fabric-ca-client reenroll
}


for i in {1..10}
do
	issueCertificatesWithAffiliation $i underwritter
	issueTLSCertificates $i underwritter
done


# # issue certificates for client identity and for client tls
export CSR_NAMES_UNDERWRITTER="C=SP,ST=UnderwritterState,L=UnderwritterLocation,O=Underwritter,OU=Hyperledger Fabric"
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/underwritter/ca/clients/admin
export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/underwritter/ca/ca-cert.pem
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/underwritter/ca/clients/underwritter-client
fabric-ca-client reenroll

export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/underwritter/tls-ca/clients/admin
export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/underwritter/tls-ca/ca-cert.pem
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/underwritter/tls-ca/clients/underwritter-client
fabric-ca-client reenroll
# # # issue certificates for peer node identity and for peer server tls

export CSR_NAMES_UNDERWRITTER="C=SP,ST=UnderwritterState,L=UnderwritterLocation,O=Underwritter,OU=Hyperledger Fabric"
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/underwritter/ca/clients/admin
export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/underwritter/ca/ca-cert.pem
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/underwritter/ca/clients/underwritter-peer
fabric-ca-client reenroll

export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/underwritter/tls-ca/clients/admin
# export FABRIC_CA_CLIENT_TLS_CERTFILES=/home/oliver/ppa/network/fabric-ca/underwritter/tls-ca/clients/admin/msp/cacerts/localhost-11054.pem
export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/underwritter/tls-ca/ca-cert.pem
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/underwritter/tls-ca/clients/underwritter-peer
fabric-ca-client reenroll

# # # issue certificates for orderer node identity and for orderer server tls

export CSR_NAMES_UNDERWRITTER="C=SP,ST=UnderwritterState,L=UnderwritterLocation,O=Underwritter,OU=Hyperledger Fabric"
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/underwritter/ca/clients/admin
# export FABRIC_CA_CLIENT_TLS_CERTFILES=/home/oliver/ppa/network/fabric-ca/underwritter/ca/clients/admin/msp/cacerts/localhost-11055.pem
export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/underwritter/ca/ca-cert.pem
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/underwritter/ca/clients/underwritter-orderer
fabric-ca-client reenroll

export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/underwritter/tls-ca/clients/admin
# export FABRIC_CA_CLIENT_TLS_CERTFILES=/home/oliver/ppa/network/fabric-ca/underwritter/tls-ca/clients/admin/msp/cacerts/localhost-11054.pem
export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/underwritter/tls-ca/ca-cert.pem
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/underwritter/tls-ca/clients/underwritter-orderer
fabric-ca-client reenroll
