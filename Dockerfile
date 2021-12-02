ARG UPSTREAM_URL=https://azcopyvnext.azureedge.net/release20211027/azcopy_linux_amd64_10.13.0.tar.gz

FROM ubuntu:focal
ARG UPSTREAM_URL
RUN apt-get update \
  && apt-get -y --no-install-recommends install ca-certificates curl apt-transport-https lsb-release gnupg bash-completion jq \
  && curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null \
  && echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ focal main" | tee /etc/apt/sources.list.d/azure-cli.list \
  && apt-get update \
  && apt-get -y --no-install-recommends install azure-cli \
  && curl ${UPSTREAM_URL} -o /tmp/azcopy.tgz \
  && export BIN_LOCATION=$(tar -tzf /tmp/azcopy.tgz | grep "/azcopy") \
  && tar -xzf /tmp/azcopy.tgz --strip-components=1 -C /usr/local/bin \
  && az aks install-cli \
  && kubectl completion bash >/etc/bash_completion.d/kubectl \
  && rm -rf /var/lib/apt/lists/*
RUN HELM_VERSION=$(curl  -H "Accept: application/vnd.github.v3+json" https://api.github.com/repos/helm/helm/releases/latest | jq -r ".tag_name") \
  && echo "Helm Version: ${HELM_VERSION}" \
  && curl -sL https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz -o /tmp/helm.tar.gz \
  && tar -xzf /tmp/helm.tar.gz --strip-components=1 -C /usr/local/bin \
  && rm /tmp/helm.tar.gz
RUN HELMFILE_VERSION=$(curl  -H "Accept: application/vnd.github.v3+json" https://api.github.com/repos/roboll/helmfile/releases/latest | jq -r ".tag_name") \
  && curl -sL https://github.com/roboll/helmfile/releases/download/${HELMFILE_VERSION}/helmfile_linux_amd64 -o /usr/local/bin/helmfile \
  && chmod a+x /usr/local/bin/helmfile
RUN printf '%s\n' \
          "if ! shopt -oq posix; then" \
          "  if [ -f /usr/share/bash-completion/bash_completion ]; then" \
          "    . /usr/share/bash-completion/bash_completion" \
          "  elif [ -f /etc/bash_completion ]; then" \
          "    . /etc/bash_completion" \
          "  fi" \
          "fi" >> /etc/bash.bashrc
CMD ["/bin/bash"]
