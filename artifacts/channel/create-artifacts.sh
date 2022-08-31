
chmod -R 0755 ./crypto-config
# Delete existing artifacts
# rm -rf ./crypto-config
rm genesis.block echannel.tx ManageralMSPanchors.tx Institute1MSPanchors.tx Institute2MSPanchors.tx Institute3MSPanchors.tx
rm -rf ../../channel-artifacts/*

# #Generate Crypto artifactes for organizations
# cryptogen generate --config=./crypto-config.yaml --output=./crypto-config/



# System channel
SYS_CHANNEL="sys-channel"

# channel name defaults to "echannel"
CHANNEL_NAME="echannel"

echo $CHANNEL_NAME

# Generate System Genesis block
configtxgen -profile OrdererGenesis -configPath . -channelID $SYS_CHANNEL  -outputBlock ./genesis.block


# Generate channel configuration block
configtxgen -profile EChannel -configPath . -outputCreateChannelTx ./echannel.tx -channelID $CHANNEL_NAME

echo "#######    Generating anchor peer update for ManageralMSP  ##########"
configtxgen -profile EChannel -configPath . -outputAnchorPeersUpdate ./ManageralMSPanchors.tx -channelID $CHANNEL_NAME -asOrg ManageralMSP

echo "#######    Generating anchor peer update for Institute1MSP  ##########"
configtxgen -profile EChannel -configPath . -outputAnchorPeersUpdate ./Institute1MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Institute1MSP

echo "#######    Generating anchor peer update for Institute2MSP  ##########"
configtxgen -profile EChannel -configPath . -outputAnchorPeersUpdate ./Institute2MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Institute2MSP

echo "#######    Generating anchor peer update for Institute3MSP  ##########"
configtxgen -profile EChannel -configPath . -outputAnchorPeersUpdate ./Institute3MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Institute3MSP