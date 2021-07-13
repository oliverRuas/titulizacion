peer chaincode invoke -o localhost:10050 --tls --cafile /media/oliver/ssd/securitization/fabric-ca/spv/orderers/spv-orderer/tls/ca.crt -C securitization -n securitizationcode -c '{"Args":["Transfer","[\"048918285b08dd97308ce4497250dc043560dd3e4116e3f15a70bc24fe7e37f5.0\"]","500","eDUwOTo6Q049aW52ZXN0b3ItY2xpZW50LTEsT1U9Y2xpZW50K09VPWludmVzdG9yK09VPWNsaWVudGUsTz1JbnZlc3RvcixMPUludmVzdG9yTG9jYXRpb24sU1Q9SW52ZXN0b3JTdGF0ZSxDPVNQOjpDTj1yb290Y2EtaW52ZXN0b3IsT1U9SHlwZXJsZWRnZXIgRmFicmljLE89SW52ZXN0b3IsTD1JbnZlc3RvckwsU1Q9SW52ZXN0b3JTVCxDPVNQ"]}' --peerAddresses localhost:10051 --peerAddresses localhost:8051 --peerAddresses localhost:11051 --tlsRootCertFiles /media/oliver/ssd/securitization/fabric-ca/spv/peers/spv-peer/tls/ca.crt --tlsRootCertFiles /media/oliver/ssd/securitization/fabric-ca/farmer/peers/farmer-peer/tls/ca.crt --tlsRootCertFiles /media/oliver/ssd/securitization/fabric-ca/investor/peers/investor-peer-1/tls/ca.crt
