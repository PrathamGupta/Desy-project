createCertificatesForManageral() {
  echo
  echo "Enroll the CA admin"
  echo
  mkdir -p ../crypto-config/peerOrganizations/manageral.example.com/
  export FABRIC_CA_CLIENT_HOME=${PWD}/../crypto-config/peerOrganizations/manageral.example.com/

  fabric-ca-client enroll -u https://admin:adminpw@localhost:7054 --caname ca.manageral.example.com --tls.certfiles ${PWD}/fabric-ca/manageral/tls-cert.pem

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-manageral-example-com.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-manageral-example-com.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-manageral-example-com.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-manageral-example-com.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/../crypto-config/peerOrganizations/manageral.example.com/msp/config.yaml

  echo
  echo "Register peer0"
  echo
  fabric-ca-client register --caname ca.manageral.example.com --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/manageral/tls-cert.pem

  
  echo
  echo "Register user"
  echo
  fabric-ca-client register --caname ca.manageral.example.com --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/fabric-ca/manageral/tls-cert.pem

  echo
  echo "Register the org admin"
  echo
  fabric-ca-client register --caname ca.manageral.example.com --id.name manageraladmin --id.secret manageraladminpw --id.type admin --tls.certfiles ${PWD}/fabric-ca/manageral/tls-cert.pem

  mkdir -p ../crypto-config/peerOrganizations/manageral.example.com/peers

  # -----------------------------------------------------------------------------------
  #  Peer 0
  mkdir -p ../crypto-config/peerOrganizations/manageral.example.com/peers/peer0.manageral.example.com
  mkdir -p ../crypto-config/peerOrganizations/manageral.example.com/peers/peer1.manageral.example.com

  echo
  echo "## Generate the peer0 msp"
  echo
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca.manageral.example.com -M ${PWD}/../crypto-config/peerOrganizations/manageral.example.com/peers/peer0.manageral.example.com/msp --csr.hosts peer0.manageral.example.com --tls.certfiles ${PWD}/fabric-ca/manageral/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/manageral.example.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/manageral.example.com/peers/peer0.manageral.example.com/msp/config.yaml

  echo
  echo "## Generate the peer0-tls certificates"
  echo
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca.manageral.example.com -M ${PWD}/../crypto-config/peerOrganizations/manageral.example.com/peers/peer0.manageral.example.com/tls --enrollment.profile tls --csr.hosts peer0.manageral.example.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/manageral/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/manageral.example.com/peers/peer0.manageral.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/manageral.example.com/peers/peer0.manageral.example.com/tls/ca.crt
  cp ${PWD}/../crypto-config/peerOrganizations/manageral.example.com/peers/peer0.manageral.example.com/tls/signcerts/* ${PWD}/../crypto-config/peerOrganizations/manageral.example.com/peers/peer0.manageral.example.com/tls/server.crt
  cp ${PWD}/../crypto-config/peerOrganizations/manageral.example.com/peers/peer0.manageral.example.com/tls/keystore/* ${PWD}/../crypto-config/peerOrganizations/manageral.example.com/peers/peer0.manageral.example.com/tls/server.key

  mkdir ${PWD}/../crypto-config/peerOrganizations/manageral.example.com/msp/tlscacerts
  cp ${PWD}/../crypto-config/peerOrganizations/manageral.example.com/peers/peer0.manageral.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/manageral.example.com/msp/tlscacerts/ca.crt

  mkdir ${PWD}/../crypto-config/peerOrganizations/manageral.example.com/tlsca
  cp ${PWD}/../crypto-config/peerOrganizations/manageral.example.com/peers/peer0.manageral.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/manageral.example.com/tlsca/tlsca.manageral.example.com-cert.pem

  mkdir ${PWD}/../crypto-config/peerOrganizations/manageral.example.com/ca
  cp ${PWD}/../crypto-config/peerOrganizations/manageral.example.com/peers/peer0.manageral.example.com/msp/cacerts/* ${PWD}/../crypto-config/peerOrganizations/manageral.example.com/ca/ca.manageral.example.com-cert.pem

  
  # --------------------------------------------------------------------------------------------------

  mkdir -p ../crypto-config/peerOrganizations/manageral.example.com/users
  mkdir -p ../crypto-config/peerOrganizations/manageral.example.com/users/User1@manageral.example.com

  echo
  echo "## Generate the user msp"
  echo
  fabric-ca-client enroll -u https://user1:user1pw@localhost:7054 --caname ca.manageral.example.com -M ${PWD}/../crypto-config/peerOrganizations/manageral.example.com/users/User1@manageral.example.com/msp --tls.certfiles ${PWD}/fabric-ca/manageral/tls-cert.pem

  mkdir -p ../crypto-config/peerOrganizations/manageral.example.com/users/Admin@manageral.example.com

  echo
  echo "## Generate the org admin msp"
  echo
  fabric-ca-client enroll -u https://manageraladmin:manageraladminpw@localhost:7054 --caname ca.manageral.example.com -M ${PWD}/../crypto-config/peerOrganizations/manageral.example.com/users/Admin@manageral.example.com/msp --tls.certfiles ${PWD}/fabric-ca/manageral/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/manageral.example.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/manageral.example.com/users/Admin@manageral.example.com/msp/config.yaml

}

# createcertificatesForManageral



createCertificatesForInstitute1() {
  echo
  echo "Enroll the CA admin"
  echo
  mkdir -p ../crypto-config/peerOrganizations/institute1.example.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/../crypto-config/peerOrganizations/institute1.example.com/

  fabric-ca-client enroll -u https://admin:adminpw@localhost:8054 --caname ca.institute1.example.com --tls.certfiles ${PWD}/fabric-ca/institute1/tls-cert.pem

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-institute1-example-com.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-institute1-example-com.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-institute1-example-com.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-institute1-example-com.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/../crypto-config/peerOrganizations/institute1.example.com/msp/config.yaml

  echo
  echo "Register peer0"
  echo

  fabric-ca-client register --caname ca.institute1.example.com --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/institute1/tls-cert.pem

  echo
  echo "Register peer1"
  echo
  fabric-ca-client register --caname ca.institute1.example.com --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/institute1/tls-cert.pem

  echo
  echo "Register user"
  echo

  fabric-ca-client register --caname ca.institute1.example.com --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/fabric-ca/institute1/tls-cert.pem

  echo
  echo "Register the org admin"
  echo

  fabric-ca-client register --caname ca.institute1.example.com --id.name institute1admin --id.secret institute1adminpw --id.type admin --tls.certfiles ${PWD}/fabric-ca/institute1/tls-cert.pem

  mkdir -p ../crypto-config/peerOrganizations/institute1.example.com/peers

  # --------------------------------------------------------------
  # Peer 0
  mkdir -p ../crypto-config/peerOrganizations/institute1.example.com/peers/peer0.institute1.example.com

  echo
  echo "## Generate the peer0 msp"
  echo

  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca.institute1.example.com -M ${PWD}/../crypto-config/peerOrganizations/institute1.example.com/peers/peer0.institute1.example.com/msp --csr.hosts peer0.institute1.example.com --tls.certfiles ${PWD}/fabric-ca/institute1/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/institute1.example.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/institute1.example.com/peers/peer0.institute1.example.com/msp/config.yaml

  echo
  echo "## Generate the peer0-tls certificates"
  echo

  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca.institute1.example.com -M ${PWD}/../crypto-config/peerOrganizations/institute1.example.com/peers/peer0.institute1.example.com/tls --enrollment.profile tls --csr.hosts peer0.institute1.example.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/institute1/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/institute1.example.com/peers/peer0.institute1.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/institute1.example.com/peers/peer0.institute1.example.com/tls/ca.crt
  cp ${PWD}/../crypto-config/peerOrganizations/institute1.example.com/peers/peer0.institute1.example.com/tls/signcerts/* ${PWD}/../crypto-config/peerOrganizations/institute1.example.com/peers/peer0.institute1.example.com/tls/server.crt
  cp ${PWD}/../crypto-config/peerOrganizations/institute1.example.com/peers/peer0.institute1.example.com/tls/keystore/* ${PWD}/../crypto-config/peerOrganizations/institute1.example.com/peers/peer0.institute1.example.com/tls/server.key

  mkdir ${PWD}/../crypto-config/peerOrganizations/institute1.example.com/msp/tlscacerts
  cp ${PWD}/../crypto-config/peerOrganizations/institute1.example.com/peers/peer0.institute1.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/institute1.example.com/msp/tlscacerts/ca.crt

  mkdir ${PWD}/../crypto-config/peerOrganizations/institute1.example.com/tlsca
  cp ${PWD}/../crypto-config/peerOrganizations/institute1.example.com/peers/peer0.institute1.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/institute1.example.com/tlsca/tlsca.institute1.example.com-cert.pem

  mkdir ${PWD}/../crypto-config/peerOrganizations/institute1.example.com/ca
  cp ${PWD}/../crypto-config/peerOrganizations/institute1.example.com/peers/peer0.institute1.example.com/msp/cacerts/* ${PWD}/../crypto-config/peerOrganizations/institute1.example.com/ca/ca.institute1.example.com-cert.pem

  # -----------------------------------------------------------------------------------
  #  Peer 1

  mkdir -p ../crypto-config/peerOrganizations/institute1.example.com/peers/peer1.institute1.example.com

  echo
  echo "## Generate the peer1 msp"
  echo

  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:8054 --caname ca.institute1.example.com -M ${PWD}/../crypto-config/peerOrganizations/institute1.example.com/peers/peer1.institute1.example.com/msp --csr.hosts peer1.institute1.example.com --tls.certfiles ${PWD}/fabric-ca/institute1/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/institute1.example.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/institute1.example.com/peers/peer1.institute1.example.com/msp/config.yaml

  echo
  echo "## Generate the peer1-tls certificates"
  echo

  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:8054 --caname ca.institute1.example.com -M ${PWD}/../crypto-config/peerOrganizations/institute1.example.com/peers/peer1.institute1.example.com/tls --enrollment.profile tls --csr.hosts peer1.institute1.example.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/institute1/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/institute1.example.com/peers/peer1.institute1.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/institute1.example.com/peers/peer1.institute1.example.com/tls/ca.crt
  cp ${PWD}/../crypto-config/peerOrganizations/institute1.example.com/peers/peer1.institute1.example.com/tls/signcerts/* ${PWD}/../crypto-config/peerOrganizations/institute1.example.com/peers/peer1.institute1.example.com/tls/server.crt
  cp ${PWD}/../crypto-config/peerOrganizations/institute1.example.com/peers/peer1.institute1.example.com/tls/keystore/* ${PWD}/../crypto-config/peerOrganizations/institute1.example.com/peers/peer1.institute1.example.com/tls/server.key

  # --------------------------------------------------------------------------------

  mkdir -p ../crypto-config/peerOrganizations/institute1.example.com/users
  mkdir -p ../crypto-config/peerOrganizations/institute1.example.com/users/User1@institute1.example.com

  echo
  echo "## Generate the user msp"
  echo

  fabric-ca-client enroll -u https://user1:user1pw@localhost:8054 --caname ca.institute1.example.com -M ${PWD}/../crypto-config/peerOrganizations/institute1.example.com/users/User1@institute1.example.com/msp --tls.certfiles ${PWD}/fabric-ca/institute1/tls-cert.pem

  mkdir -p ../crypto-config/peerOrganizations/institute1.example.com/users/Admin@institute1.example.com

  echo
  echo "## Generate the org admin msp"
  echo

  fabric-ca-client enroll -u https://institute1admin:institute1adminpw@localhost:8054 --caname ca.institute1.example.com -M ${PWD}/../crypto-config/peerOrganizations/institute1.example.com/users/Admin@institute1.example.com/msp --tls.certfiles ${PWD}/fabric-ca/institute1/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/institute1.example.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/institute1.example.com/users/Admin@institute1.example.com/msp/config.yaml

}

# createCertificateForInstitute1

createCertificatesForInstitute2() {
  echo
  echo "Enroll the CA admin"
  echo
  mkdir -p ../crypto-config/peerOrganizations/institute2.example.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/../crypto-config/peerOrganizations/institute2.example.com/

  fabric-ca-client enroll -u https://admin:adminpw@localhost:9054 --caname ca.institute2.example.com --tls.certfiles ${PWD}/fabric-ca/institute2/tls-cert.pem

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-institute2-example-com.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-institute2-example-com.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-institute2-example-com.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-institute2-example-com.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/../crypto-config/peerOrganizations/institute2.example.com/msp/config.yaml

  echo
  echo "Register peer0"
  echo

  fabric-ca-client register --caname ca.institute2.example.com --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/institute2/tls-cert.pem

  echo
  echo "Register peer1"
  echo
  fabric-ca-client register --caname ca.institute2.example.com --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/institute2/tls-cert.pem

  echo
  echo "Register user"
  echo

  fabric-ca-client register --caname ca.institute2.example.com --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/fabric-ca/institute2/tls-cert.pem

  echo
  echo "Register the org admin"
  echo

  fabric-ca-client register --caname ca.institute2.example.com --id.name institute2admin --id.secret institute2adminpw --id.type admin --tls.certfiles ${PWD}/fabric-ca/institute2/tls-cert.pem

  mkdir -p ../crypto-config/peerOrganizations/institute2.example.com/peers

  # --------------------------------------------------------------
  # Peer 0

  mkdir -p ../crypto-config/peerOrganizations/institute2.example.com/peers/peer0.institute2.example.com

  echo
  echo "## Generate the peer0 msp"
  echo

  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:9054 --caname ca.institute2.example.com -M ${PWD}/../crypto-config/peerOrganizations/institute2.example.com/peers/peer0.institute2.example.com/msp --csr.hosts peer0.institute2.example.com --tls.certfiles ${PWD}/fabric-ca/institute2/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/institute2.example.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/institute2.example.com/peers/peer0.institute2.example.com/msp/config.yaml

  echo
  echo "## Generate the peer0-tls certificates"
  echo

  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:9054 --caname ca.institute2.example.com -M ${PWD}/../crypto-config/peerOrganizations/institute2.example.com/peers/peer0.institute2.example.com/tls --enrollment.profile tls --csr.hosts peer0.institute2.example.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/institute2/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/institute2.example.com/peers/peer0.institute2.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/institute2.example.com/peers/peer0.institute2.example.com/tls/ca.crt
  cp ${PWD}/../crypto-config/peerOrganizations/institute2.example.com/peers/peer0.institute2.example.com/tls/signcerts/* ${PWD}/../crypto-config/peerOrganizations/institute2.example.com/peers/peer0.institute2.example.com/tls/server.crt
  cp ${PWD}/../crypto-config/peerOrganizations/institute2.example.com/peers/peer0.institute2.example.com/tls/keystore/* ${PWD}/../crypto-config/peerOrganizations/institute2.example.com/peers/peer0.institute2.example.com/tls/server.key

  mkdir ${PWD}/../crypto-config/peerOrganizations/institute2.example.com/msp/tlscacerts
  cp ${PWD}/../crypto-config/peerOrganizations/institute2.example.com/peers/peer0.institute2.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/institute2.example.com/msp/tlscacerts/ca.crt

  mkdir ${PWD}/../crypto-config/peerOrganizations/institute2.example.com/tlsca
  cp ${PWD}/../crypto-config/peerOrganizations/institute2.example.com/peers/peer0.institute2.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/institute2.example.com/tlsca/tlsca.institute2.example.com-cert.pem

  mkdir ${PWD}/../crypto-config/peerOrganizations/institute2.example.com/ca
  cp ${PWD}/../crypto-config/peerOrganizations/institute2.example.com/peers/peer0.institute2.example.com/msp/cacerts/* ${PWD}/../crypto-config/peerOrganizations/institute2.example.com/ca/ca.institute2.example.com-cert.pem

  # -----------------------------------------------------------------------------------
  #  Peer 1

  mkdir -p ../crypto-config/peerOrganizations/institute2.example.com/peers/peer0.institute2.example.com

  echo
  echo "## Generate the peer1 msp"
  echo

  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:9054 --caname ca.institute2.example.com -M ${PWD}/../crypto-config/peerOrganizations/institute2.example.com/peers/peer1.institute2.example.com/msp --csr.hosts peer1.institute2.example.com --tls.certfiles ${PWD}/fabric-ca/institute2/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/institute2.example.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/institute2.example.com/peers/peer1.institute2.example.com/msp/config.yaml

  echo
  echo "## Generate the peer1-tls certificates"
  echo

  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:9054 --caname ca.institute2.example.com -M ${PWD}/../crypto-config/peerOrganizations/institute2.example.com/peers/peer1.institute2.example.com/tls --enrollment.profile tls --csr.hosts peer1.institute2.example.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/institute2/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/institute2.example.com/peers/peer1.institute2.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/institute2.example.com/peers/peer1.institute2.example.com/tls/ca.crt
  cp ${PWD}/../crypto-config/peerOrganizations/institute2.example.com/peers/peer1.institute2.example.com/tls/signcerts/* ${PWD}/../crypto-config/peerOrganizations/institute2.example.com/peers/peer1.institute2.example.com/tls/server.crt
  cp ${PWD}/../crypto-config/peerOrganizations/institute2.example.com/peers/peer1.institute2.example.com/tls/keystore/* ${PWD}/../crypto-config/peerOrganizations/institute2.example.com/peers/peer1.institute2.example.com/tls/server.key

  # --------------------------------------------------------------------------------

  mkdir -p ../crypto-config/peerOrganizations/institute2.example.com/users
  mkdir -p ../crypto-config/peerOrganizations/institute2.example.com/users/User1@institute2.example.com

  echo
  echo "## Generate the user msp"
  echo

  fabric-ca-client enroll -u https://user1:user1pw@localhost:9054 --caname ca.institute2.example.com -M ${PWD}/../crypto-config/peerOrganizations/institute2.example.com/users/User1@institute2.example.com/msp --tls.certfiles ${PWD}/fabric-ca/institute2/tls-cert.pem

  mkdir -p ../crypto-config/peerOrganizations/institute2.example.com/users/Admin@institute2.example.com

  echo
  echo "## Generate the org admin msp"
  echo

  fabric-ca-client enroll -u https://institute2admin:institute2adminpw@localhost:9054 --caname ca.institute2.example.com -M ${PWD}/../crypto-config/peerOrganizations/institute2.example.com/users/Admin@institute2.example.com/msp --tls.certfiles ${PWD}/fabric-ca/institute2/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/institute2.example.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/institute2.example.com/users/Admin@institute2.example.com/msp/config.yaml

}

# createCertificatesForInstitute2

createCertificatesForInstitute3() {
  echo
  echo "Enroll the CA admin"
  echo
  mkdir -p ../crypto-config/peerOrganizations/institute3.example.com/
  export FABRIC_CA_CLIENT_HOME=${PWD}/../crypto-config/peerOrganizations/institute3.example.com/

  fabric-ca-client enroll -u https://admin:adminpw@localhost:10054 --caname ca.institute3.example.com --tls.certfiles ${PWD}/fabric-ca/institute3/tls-cert.pem

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-institute3-example-com.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-institute3-example-com.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-institute3-example-com.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-institute3-example-com.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/../crypto-config/peerOrganizations/institute3.example.com/msp/config.yaml

  echo
  echo "Register peer0"
  echo
  fabric-ca-client register --caname ca.institute3.example.com --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/institute3/tls-cert.pem

  echo
  echo "Register peer1"
  echo
  fabric-ca-client register --caname ca.institute3.example.com --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/institute3/tls-cert.pem

  echo
  echo "Register user"
  echo
  fabric-ca-client register --caname ca.institute3.example.com --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/fabric-ca/institute3/tls-cert.pem

  echo
  echo "Register the org admin"
  echo
  fabric-ca-client register --caname ca.institute3.example.com --id.name institute3admin --id.secret institute3adminpw --id.type admin --tls.certfiles ${PWD}/fabric-ca/institute3/tls-cert.pem

  mkdir -p ../crypto-config/peerOrganizations/institute3.example.com/peers

  # -----------------------------------------------------------------------------------
  #  Peer 0
  mkdir -p ../crypto-config/peerOrganizations/institute3.example.com/peers/peer0.institute3.example.com

  echo
  echo "## Generate the peer0 msp"
  echo
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:10054 --caname ca.institute3.example.com -M ${PWD}/../crypto-config/peerOrganizations/institute3.example.com/peers/peer0.institute3.example.com/msp --csr.hosts peer0.institute3.example.com --tls.certfiles ${PWD}/fabric-ca/institute3/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/institute3.example.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/institute3.example.com/peers/peer0.institute3.example.com/msp/config.yaml

  echo
  echo "## Generate the peer0-tls certificates"
  echo
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:10054 --caname ca.institute3.example.com -M ${PWD}/../crypto-config/peerOrganizations/institute3.example.com/peers/peer0.institute3.example.com/tls --enrollment.profile tls --csr.hosts peer0.institute3.example.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/institute3/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/institute3.example.com/peers/peer0.institute3.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/institute3.example.com/peers/peer0.institute3.example.com/tls/ca.crt
  cp ${PWD}/../crypto-config/peerOrganizations/institute3.example.com/peers/peer0.institute3.example.com/tls/signcerts/* ${PWD}/../crypto-config/peerOrganizations/institute3.example.com/peers/peer0.institute3.example.com/tls/server.crt
  cp ${PWD}/../crypto-config/peerOrganizations/institute3.example.com/peers/peer0.institute3.example.com/tls/keystore/* ${PWD}/../crypto-config/peerOrganizations/institute3.example.com/peers/peer0.institute3.example.com/tls/server.key

  mkdir ${PWD}/../crypto-config/peerOrganizations/institute3.example.com/msp/tlscacerts
  cp ${PWD}/../crypto-config/peerOrganizations/institute3.example.com/peers/peer0.institute3.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/institute3.example.com/msp/tlscacerts/ca.crt

  mkdir ${PWD}/../crypto-config/peerOrganizations/institute3.example.com/tlsca
  cp ${PWD}/../crypto-config/peerOrganizations/institute3.example.com/peers/peer0.institute3.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/institute3.example.com/tlsca/tlsca.institute3.example.com-cert.pem

  mkdir ${PWD}/../crypto-config/peerOrganizations/institute3.example.com/ca
  cp ${PWD}/../crypto-config/peerOrganizations/institute3.example.com/peers/peer0.institute3.example.com/msp/cacerts/* ${PWD}/../crypto-config/peerOrganizations/institute3.example.com/ca/ca.institute3.example.com-cert.pem

  # -----------------------------------------------------------------------------------
  #  Peer 1

  mkdir -p ../crypto-config/peerOrganizations/institute3.example.com/peers/peer1.institute3.example.com
  echo
  echo "## Generate the peer1 msp"
  echo
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:10054 --caname ca.institute3.example.com -M ${PWD}/../crypto-config/peerOrganizations/institute3.example.com/peers/peer1.institute3.example.com/msp --csr.hosts peer1.institute3.example.com --tls.certfiles ${PWD}/fabric-ca/institute3/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/institute3.example.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/institute3.example.com/peers/peer1.institute3.example.com/msp/config.yaml

  echo
  echo "## Generate the peer1-tls certificates"
  echo
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:10054 --caname ca.institute3.example.com -M ${PWD}/../crypto-config/peerOrganizations/institute3.example.com/peers/peer1.institute3.example.com/tls --enrollment.profile tls --csr.hosts peer1.institute3.example.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/institute3/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/institute3.example.com/peers/peer1.institute3.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/institute3.example.com/peers/peer1.institute3.example.com/tls/ca.crt
  cp ${PWD}/../crypto-config/peerOrganizations/institute3.example.com/peers/peer1.institute3.example.com/tls/signcerts/* ${PWD}/../crypto-config/peerOrganizations/institute3.example.com/peers/peer1.institute3.example.com/tls/server.crt
  cp ${PWD}/../crypto-config/peerOrganizations/institute3.example.com/peers/peer1.institute3.example.com/tls/keystore/* ${PWD}/../crypto-config/peerOrganizations/institute3.example.com/peers/peer1.institute3.example.com/tls/server.key

  # --------------------------------------------------------------------------------------------------

  mkdir -p ../crypto-config/peerOrganizations/institute3.example.com/users
  mkdir -p ../crypto-config/peerOrganizations/institute3.example.com/users/User1@institute3.example.com

  echo
  echo "## Generate the user msp"
  echo
  fabric-ca-client enroll -u https://user1:user1pw@localhost:10054 --caname ca.institute3.example.com -M ${PWD}/../crypto-config/peerOrganizations/institute3.example.com/users/User1@institute3.example.com/msp --tls.certfiles ${PWD}/fabric-ca/institute3/tls-cert.pem

  mkdir -p ../crypto-config/peerOrganizations/institute3.example.com/users/Admin@institute3.example.com

  echo
  echo "## Generate the org admin msp"
  echo
  fabric-ca-client enroll -u https://institute3admin:institute3adminpw@localhost:10054 --caname ca.institute3.example.com -M ${PWD}/../crypto-config/peerOrganizations/institute3.example.com/users/Admin@institute3.example.com/msp --tls.certfiles ${PWD}/fabric-ca/institute3/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/institute3.example.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/institute3.example.com/users/Admin@institute3.example.com/msp/config.yaml

}

# createCertificatesForInstitute3

createCertificatesForOrderer() {
  echo
  echo "Enroll the CA admin"
  echo
  mkdir -p ../crypto-config/ordererOrganizations/example.com

  export FABRIC_CA_CLIENT_HOME=${PWD}/../crypto-config/ordererOrganizations/example.com

  fabric-ca-client enroll -u https://admin:adminpw@localhost:11054 --caname ca-orderer --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-orderer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-orderer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-orderer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-orderer.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/../crypto-config/ordererOrganizations/example.com/msp/config.yaml

  echo
  echo "Register orderer"
  echo

  fabric-ca-client register --caname ca-orderer --id.name orderer --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem

  
  echo
  echo "Register the orderer admin"
  echo

  fabric-ca-client register --caname ca-orderer --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem

  mkdir -p ../crypto-config/ordererOrganizations/example.com/orderers
  # mkdir -p ../crypto-config/ordererOrganizations/example.com/orderers/example.com

  # ---------------------------------------------------------------------------
  #  Orderer

  mkdir -p ../crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com

  echo
  echo "## Generate the orderer msp"
  echo

  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:11054 --caname ca-orderer -M ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp --csr.hosts orderer.example.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem

  cp ${PWD}/../crypto-config/ordererOrganizations/example.com/msp/config.yaml ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/config.yaml

  echo
  echo "## Generate the orderer-tls certificates"
  echo

  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:11054 --caname ca-orderer -M ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls --enrollment.profile tls --csr.hosts orderer.example.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem

  cp ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls/ca.crt
  cp ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls/signcerts/* ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.crt
  cp ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls/keystore/* ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.key

  mkdir ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts
  cp ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

  mkdir ${PWD}/../crypto-config/ordererOrganizations/example.com/msp/tlscacerts
  cp ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/example.com/msp/tlscacerts/tlsca.example.com-cert.pem

  
  # ---------------------------------------------------------------------------

  mkdir -p ../crypto-config/ordererOrganizations/example.com/users
  mkdir -p ../crypto-config/ordererOrganizations/example.com/users/Admin@example.com

  echo
  echo "## Generate the admin msp"
  echo

  fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@localhost:11054 --caname ca-orderer -M ${PWD}/../crypto-config/ordererOrganizations/example.com/users/Admin@example.com/msp --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem

  cp ${PWD}/../crypto-config/ordererOrganizations/example.com/msp/config.yaml ${PWD}/../crypto-config/ordererOrganizations/example.com/users/Admin@example.com/msp/config.yaml

}

# createCretificateForOrderer

sudo rm -rf ../crypto-config/*
# sudo rm -rf fabric-ca/*
createCertificatesForManageral
createCertificatesForInstitute1
createCertificatesForInstitute2
createCertificatesForInstitute3

createCertificatesForOrderer
