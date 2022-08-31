

# sudo rm /artifacts/channel/create-certificate-with-ca/fabric-ca/ordererOrg/fabric-ca-server.db
# sudo rm /artifacts/channel/create-certificate-with-ca/fabric-ca/manageral/fabric-ca-server.db

# sudo rm /artifacts/channel/create-certificate-with-ca/fabric-ca/institute1/fabric-ca-server.db

# sudo rm /artifacts/channel/create-certificate-with-ca/fabric-ca/institute2/fabric-ca-server.db

# sudo rm /artifacts/channel/create-certificate-with-ca/fabric-ca/institute3/fabric-ca-server.db


cd artifacts
docker-compose down -v
cd channel/create-certificate-with-ca/
sudo rm -r fabric-ca
docker-compose down -v 
sleep 4
# sudo docker images | grep "dev" | awk '{print $1}' | xargs docker rmi -f
sleep 4
docker-compose up -d
sleep 4 
./create-certificate-with-ca.sh
sleep 5
cd ..
pwd
sudo cp -a crypto-config/ordererOrganizations/example.com/msp/keystore/. crypto-config/ordererOrganizations/example.com/ca/
sudo cp -a crypto-config/peerOrganizations/manageral.example.com/msp/keystore/. crypto-config/peerOrganizations/manageral.example.com/ca/
sudo cp -a crypto-config/peerOrganizations/institute1.example.com/msp/keystore/. crypto-config/peerOrganizations/institute1.example.com/ca/
sudo cp -a crypto-config/peerOrganizations/institute2.example.com/msp/keystore/. crypto-config/peerOrganizations/institute2.example.com/ca/
sudo cp -a crypto-config/peerOrganizations/institute3.example.com/msp/keystore/. crypto-config/peerOrganizations/institute3.example.com/ca/
sleep 2
./create-artifacts.sh
cd ..
sleep 4
docker-compose up -d 
sleep 10
cd ..
./createChannel.sh
sleep 10
./deployChaincode.sh

cd api-2.0/config/

./generate-ccp.sh

cd ..
# cd api-2.0
rm -r institute3-wallet/
rm -r institute2-wallet/
rm -r institute1-wallet/
rm -r manageral-wallet/

# forever logs 0 -f