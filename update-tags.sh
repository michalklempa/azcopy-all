#!/bin/bash

AZCOPY_RELEASE=$(curl  -H "Accept: application/vnd.github.v3+json" https://api.github.com/repos/Azure/azure-storage-azcopy/releases/latest)
AZCOPY_VERSION=$(echo $AZCOPY_RELEASE | jq -r ".tag_name" | sed -s 's/^v//')
AZCOPY_DATE=$(date -d "$(echo $AZCOPY_RELEASE | jq -r ".published_at")" +'%Y%m%d')
AZCOPY_URL="https://azcopyvnext.azureedge.net/release${AZCOPY_DATE}/azcopy_linux_amd64_${AZCOPY_VERSION}.tar.gz"

sed -i '1c ARG UPSTREAM_URL='"${AZCOPY_URL}" Dockerfile
git config --global user.name 'Github Actions Michal'
git config --global user.email 'michal.klempa@gmail.com'
git add Dockerfile
git commit -m"Upstream version bump to ${AZCOPY_VERSION}"
git tag -f "v${AZCOPY_VERSION}"
git push --tags
git push
