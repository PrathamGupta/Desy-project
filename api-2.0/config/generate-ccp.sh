#!/bin/bash

function one_line_pem {
    echo "`awk 'NF {sub(/\\n/, ""); printf "%s\\\\\\\n",$0;}' $1`"
}

function json_ccp {
    local PP=$(one_line_pem $5)
    local PP1=$(one_line_pem $6)
    local CP=$(one_line_pem $7)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${P1PORT}/$3/" \
        -e "s/\${CAPORT}/$4/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${PEER1PEM}#$PP1#" \
        -e "s#\${CAPEM}#$CP#" \
        ./ccp-template.json
}

function json_ccp_manageral {
    local PP=$(one_line_pem $3)
    local CP=$(one_line_pem $4)
    sed -e "s/\${P0PORT}/$1/" \
        -e "s/\${CAPORT}/$2/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        ./ccp-template-manageral.json
}

ORG=1
P0PORT=7051
CAPORT=7054
PEERPEM=../../artifacts/channel/crypto-config/peerOrganizations/manageral.example.com/peers/peer0.manageral.example.com/tls/tlscacerts/tls-localhost-7054-ca-manageral-example-com.pem
CAPEM=../../artifacts/channel/crypto-config/peerOrganizations/manageral.example.com/msp/tlscacerts/ca.crt


echo "$(json_ccp_manageral $P0PORT $CAPORT $PEERPEM $CAPEM)" > connection-manageral.json


ORG=1
P0PORT=8051
P1PORT=9051
CAPORT=8054
PEERPEM=../../artifacts/channel/crypto-config/peerOrganizations/institute1.example.com/peers/peer0.institute1.example.com/tls/tlscacerts/tls-localhost-8054-ca-institute1-example-com.pem
PEER1PEM=../../artifacts/channel/crypto-config/peerOrganizations/institute1.example.com/peers/peer1.institute1.example.com/tls/tlscacerts/tls-localhost-8054-ca-institute1-example-com.pem
CAPEM=../../artifacts/channel/crypto-config/peerOrganizations/institute1.example.com/msp/tlscacerts/ca.crt

echo "$(json_ccp $ORG $P0PORT $P1PORT $CAPORT $PEERPEM $PEER1PEM $CAPEM )" > connection-institute1.json

ORG=2
P0PORT=10051
P1PORT=11051
CAPORT=9054
PEERPEM=../../artifacts/channel/crypto-config/peerOrganizations/institute2.example.com/peers/peer0.institute2.example.com/tls/tlscacerts/tls-localhost-9054-ca-institute2-example-com.pem
PEER1PEM=../../artifacts/channel/crypto-config/peerOrganizations/institute2.example.com/peers/peer1.institute2.example.com/tls/tlscacerts/tls-localhost-9054-ca-institute2-example-com.pem
CAPEM=../../artifacts/channel/crypto-config/peerOrganizations/institute2.example.com/msp/tlscacerts/ca.crt


echo "$(json_ccp $ORG $P0PORT $P1PORT $CAPORT $PEERPEM $PEER1PEM $CAPEM )" > connection-institute2.json

ORG=3
P0PORT=12051
P1PORT=13051
CAPORT=10054
PEERPEM=../../artifacts/channel/crypto-config/peerOrganizations/institute3.example.com/peers/peer0.institute3.example.com/tls/tlscacerts/tls-localhost-10054-ca-institute3-example-com.pem
PEER1PEM=../../artifacts/channel/crypto-config/peerOrganizations/institute3.example.com/peers/peer1.institute3.example.com/tls/tlscacerts/tls-localhost-10054-ca-institute3-example-com.pem
CAPEM=../../artifacts/channel/crypto-config/peerOrganizations/institute3.example.com/msp/tlscacerts/ca.crt



echo "$(json_ccp $ORG $P0PORT $P1PORT $CAPORT $PEERPEM $PEER1PEM $CAPEM )" > connection-institute3.json
