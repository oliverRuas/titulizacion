export FABRIC_CFG_PATH=$(cd ../ && pwd)
configtxgen -profile FourOrgsOrdererGenesis -channelID system-channel -outputBlock ../network/channel-artifacts/genesis.block
configtxgen -profile FourOrgsChannel -outputCreateChannelTx ../network/channel-artifacts/channel.tx -channelID securitization

configtxgen -outputAnchorPeersUpdate ../network/channel-artifacts/servicerMSPanchors.tx -profile FourOrgsChannel -asOrg servicerMSP -channelID securitization

configtxgen -outputAnchorPeersUpdate ../network/channel-artifacts/farmerMSPanchors.tx -profile FourOrgsChannel -asOrg farmerMSP -channelID securitization

# configtxgen -outputAnchorPeersUpdate ../network/channel-artifacts/aggregatorMSPanchors.tx -profile FiveOrgsChannel -asOrg aggregatorMSP -channelID securitization

configtxgen -outputAnchorPeersUpdate ../network/channel-artifacts/spvMSPanchors.tx -profile FourOrgsChannel -asOrg spvMSP -channelID securitization

configtxgen -outputAnchorPeersUpdate ../network/channel-artifacts/investorMSPanchors.tx -profile FourOrgsChannel -asOrg investorMSP -channelID securitization