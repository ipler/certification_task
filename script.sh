#!/bin/bash
IP_PROD=$(grep -A1 '\[PROD\]' ./ansible/hosts | grep -v "\[PROD\]")
export IP_PROD
echo $IP_PROD
chmod 400 ./ansible/aws___key_pair_rsa_1_.pem
ssh ubuntu@$IP_PROD -i ./ansible/aws___key_pair_rsa_1_.pem "sudo docker pull gotofront/webapp:1.0 && sudo docker run -d -p 80:8080 gotofront/webapp:1.0"
rm ./ansible/aws___key_pair_rsa_1_.pem
