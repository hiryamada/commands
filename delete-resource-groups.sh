#!/bin/bash
az group list --query '[].name' --output tsv |grep -v cloud-shell-storage |xargs -P10 -tl az group delete --no-wait --yes -g
