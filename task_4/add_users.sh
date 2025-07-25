#!/bin/bash
echo create user \"sesurity\"
useradd sesurity && cd /home/sesurity
openssl genrsa -out sesurity.key 2048

openssl req -new -key sesurity.key \
-out sesurity.csr \
-subj "/CN=sesurity"

openssl x509 -req -in sesurity.csr \
-CA /etc/kubernetes/pki/ca.crt \
-CAkey /etc/kubernetes/pki/ca.key \
-CAcreateserial \
-out sesurity.crt -days 500

mkdir .certs && mv sesurity.crt sesurity.key .certs

kubectl config set-credentials sesurity \
--client-certificate=/home/sesurity/.certs/sesurity.crt \
--client-key=/home/sesurity/.certs/sesurity.key

kubectl config set-context sesurity-context \
--cluster=kubernetes --user=sesurity

mkdir .kube && vi .kube/config

chown -R sesurity: /home/sesurity/
echo user \"sesurity\" created!

userdel -r sesurity

#echo;
#echo \>\>\>init shard1-1;
#docker compose exec -T shard1-1 mongosh --port 27018 <<EOF
#rs.initiate(
#    {
#      _id : "rs0",
#      members: [
#        { _id : 0, host : "shard1-1:27018" },
#        { _id : 1, host : "shard1-2:27019" },
#        { _id : 2, host : "shard1-3:27020" }
#      ]
#    }
#);
#exit();
#EOF