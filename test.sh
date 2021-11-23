#!/bin/bash
#CHAVESSH="~/.ssh/grupo-one.pem"
CHAVESSH="/var/lib/jenkins/.ssh/grupo-one.pem"


cd ./terraform

DNS="$(terraform output | grep public_dns | awk '{print $2;exit}')" | sed -e "s/\",//g"

echo $DNS

ssh -i ${CHAVESSH} $DNS 'exit'

if [[ $? -eq 0 ]]
then 
    echo "::::: server está no ar :::::"
    exit 0
else
    echo "::::: server não está no ar :::::"
    exit 1
fi