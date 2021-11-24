#!/bin/bash
#CHAVESSH="~/.ssh/grupo-one.pem"
CHAVESSH="/var/lib/jenkins/.ssh/grupo-one.pem"

cd terraform
terraform init
terraform fmt
terraform apply -auto-approve

echo "Aguardando criação de maquinas ..."
# sleep 10 # 10 segundos


ID_M1=$(terraform output | grep 'mysql_prod' | awk '{print $4}')
ID_M1_DNS=$(terraform)

ID_M2=$(terraform output | grep 'mysql_dev' | awk '{print $4}')
ID_M2_DNS=$(terraform output | grep 'mysql_dev' | awk '{print $9}' | cut -b 8-)

ID_M3=$(terraform output | grep 'mysql_stage' | awk '{print $4}')
ID_M3_DNS=$(terraform output | grep 'mysql_stage' | awk '{print $9}' | cut -b 8-)

echo "
[mysql_prod]
$ID_M1_DNS
[mysql_dev]
$ID_M2_DNS
[mysql_stage]
$ID_M3_DNS
" > ../ansible/hosts


echo "
[mysql_prod]
$ID_M1_DNS
[mysql_dev]
$ID_M2_DNS
[mysql_stage]
$ID_M3_DNS"


#sleep 10 # 20 segundos


cd ../ansible

echo "Executando ansible ::::: [ ansible-playbook -i hosts provisionar.yml -u ubuntu --private-key ${CHAVESSH} ]"
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i hosts provisionar.yml -u ubuntu --private-key ${CHAVESSH}
