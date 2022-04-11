#!/bin/bash
# delete all resource groups, except cloud-shell's
az group list --query '[].name' --output tsv |grep -v cloud-shell-storage |xargs -P10 -r -tl az group delete --no-wait --yes -g
