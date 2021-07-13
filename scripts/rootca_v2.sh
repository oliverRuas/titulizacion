#servicer
export NEW_PATH=$(cd ../ && pwd)
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/servicer/ca/clients/admin
export CSR_NAMES_SERVICER="C=SP,ST=ServicerState,L=ServicerLocation,O=Servicer,OU=Hyperledger Fabric"
export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/servicer/ca/tls-cert.pem
# Inscribimos la identidad de arranque de la CA
fabric-ca-client enroll -u https://rootca-servicer-admin:rootca-servicer-adminpw@localhost:7055 --tls.certfiles $FABRIC_CA_CLIENT_TLS_CERTFILES --csr.names "$CSR_NAMES_SERVICER"
# Inscribimos la identidad de arranque de la TLS CA
export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/servicer/tls-ca/tls-cert.pem
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/servicer/tls-ca/clients/admin
fabric-ca-client enroll -u https://tls-ca-servicer-admin:tls-ca-servicer-adminpw@localhost:7054 --tls.certfiles $FABRIC_CA_CLIENT_TLS_CERTFILES --csr.names "$CSR_NAMES_SERVICER"

# Farmer
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/farmer/ca/clients/admin
export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/farmer/ca/tls-cert.pem
export CSR_NAMES_FARMER="C=SP,ST=FarmerState,L=FarmerLocation,O=Farmer,OU=Hyperledger Fabric"
# Inscribimos la identidad de arranque de la CA
fabric-ca-client enroll -u https://rootca-farmer-admin:rootca-farmer-adminpw@localhost:8055 --tls.certfiles $FABRIC_CA_CLIENT_TLS_CERTFILES --csr.names "$CSR_NAMES_FARMER"
# Inscribimos la identidad de arranque de la TLS CA
export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/farmer/tls-ca/tls-cert.pem
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/farmer/tls-ca/clients/admin
fabric-ca-client enroll -u https://tls-ca-farmer-admin:tls-ca-farmer-adminpw@localhost:8054 --tls.certfiles $FABRIC_CA_CLIENT_TLS_CERTFILES --csr.names "$CSR_NAMES_FARMER"


# # Aggregator
# export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/aggregator/ca/clients/admin
# export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/aggregator/ca/tls-cert.pem
# export CSR_NAMES_AGGREGATOR="C=SP,ST=AggregatorState,L=AggregatorLocation,O=Aggregator,OU=Hyperledger Fabric"
# # Inscribimos la identidad de arranque de la CA
# fabric-ca-client enroll -u https://rootca-aggregator-admin:rootca-aggregator-adminpw@localhost:9055 --tls.certfiles $FABRIC_CA_CLIENT_TLS_CERTFILES --csr.names "$CSR_NAMES_AGGREGATOR"
# # fabric-ca-client affiliation add aggregator
# # fabric-ca-client affiliation add aggregator.client1
# # fabric-ca-client affiliation add aggregator.peer1
# # fabric-ca-client affiliation add aggregator.orderer1
# # Inscribimos la identidad de arranque de la TLS CA
# export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/aggregator/tls-ca/tls-cert.pem
# export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/aggregator/tls-ca/clients/admin
# fabric-ca-client enroll -u https://tls-ca-aggregator-admin:tls-ca-aggregator-adminpw@localhost:9054 --tls.certfiles $FABRIC_CA_CLIENT_TLS_CERTFILES --csr.names "$CSR_NAMES_AGGREGATOR"

#SPV
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/spv/ca/clients/admin
export CSR_NAMES_SPV="C=SP,ST=SPVState,L=SPVLocation,O=SPV,OU=Hyperledger Fabric"
export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/spv/ca/tls-cert.pem
# Inscribimos la identidad de arranque de la CA
fabric-ca-client enroll -u https://rootca-spv-admin:rootca-spv-adminpw@localhost:10055 --tls.certfiles $FABRIC_CA_CLIENT_TLS_CERTFILES --csr.names "$CSR_NAMES_SPV"
# Inscribimos la identidad de arranque de la TLS CA
export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/spv/tls-ca/tls-cert.pem
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/spv/tls-ca/clients/admin
fabric-ca-client enroll -u https://tls-ca-spv-admin:tls-ca-spv-adminpw@localhost:10054 --tls.certfiles $FABRIC_CA_CLIENT_TLS_CERTFILES --csr.names "$CSR_NAMES_SPV"

#Investor
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/investor/ca/clients/admin
export CSR_NAMES_INVESTOR="C=SP,ST=InvestorState,L=InvestorLocation,O=Investor,OU=Hyperledger Fabric"
export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/investor/ca/tls-cert.pem
# Inscribimos la identidad de arranque de la CA
fabric-ca-client enroll -u https://rootca-investor-admin:rootca-investor-adminpw@localhost:11055 --tls.certfiles $FABRIC_CA_CLIENT_TLS_CERTFILES --csr.names "$CSR_NAMES_INVESTOR"
# Inscribimos la identidad de arranque de la TLS CA
export FABRIC_CA_CLIENT_TLS_CERTFILES=$NEW_PATH/network/fabric-ca/investor/tls-ca/tls-cert.pem
export FABRIC_CA_CLIENT_HOME=$NEW_PATH/network/fabric-ca/investor/tls-ca/clients/admin
fabric-ca-client enroll -u https://tls-ca-investor-admin:tls-ca-investor-adminpw@localhost:11054 --tls.certfiles $FABRIC_CA_CLIENT_TLS_CERTFILES --csr.names "$CSR_NAMES_INVESTOR"



