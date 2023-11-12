#!/bin/bash
IP_PROD=$(grep -A1 '\[PROD\]' ./ansible/hosts | grep -v "\[PROD\]")
export IP_PROD
echo $IP_PROD
chmod 400 ./aws___key_pair_rsa_1_.pem
#ssh-keyscan $IP_PROD >> ~/.ssh/known_hosts
ssh -o 'StrictHostKeyChecking no' ubuntu@$IP_PROD -i ./aws___key_pair_rsa_1_.pem "sudo docker pull gotofront/webapp:1.0 && sudo docker run -d -p 80:8080 gotofront/webapp:1.0"
rm ./aws___key_pair_rsa_1_.pem
