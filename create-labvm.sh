#!/bin/bash
# az vm image list --output table --publisher microsoftwindowsserver --all |grep vnext
name=labvm$RANDOM

# https://zenn.dev/skksky_tech/scraps/088d576009c091
myip=$(curl https://checkip.amazonaws.com/)
username=azureuser
password=Pass_0$(date |md5sum |head -c12)

az group create -n $name -l japaneast

publicIpAddress=$(az vm create -n $name -g $name -l japaneast \
--image MicrosoftWindowsServer:microsoftserveroperatingsystems-previews:windows-server-vnext-azure-edition:25075.1000.220314 \
--size Standard_D2s_v5 \
--public-ip-sku Standard \
--admin-username $username \
--admin-password $password \
--nsg-rule None \
--query publicIpAddress --output tsv)

az network nsg rule create -g $name -n allowrdp --nsg-name $name"NSG" --priority 1000 --source-address-prefixes $myip --destination-port-ranges 3389 --protocol Tcp

encodedPassword=$(pwsh -Command "(echo $password | ConvertTo-SecureString -AsPlainText -Force) | ConvertFrom-SecureString")

rdpfile="labvm.rdp"
cp rdptemplate.txt $rdpfile
echo >> $rdpfile # add new line
echo full address:s:$publicIpAddress >> $rdpfile
echo username:s:$username >> $rdpfile
echo password 51:b:$encodedPassword >> $rdpfile
