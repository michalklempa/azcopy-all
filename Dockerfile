FROM ubuntu:focal
RUN apt-get update \
  && apt-get -y --no-install-recommends install ca-certificates curl apt-transport-https lsb-release gnupg bash-completion \
  && curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null \
  && echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ focal main" | tee /etc/apt/sources.list.d/azure-cli.list \
  && apt-get update \
  && apt-get -y --no-install-recommends install azure-cli \
  && curl https://azcopyvnext.azureedge.net/release20200709/azcopy_linux_amd64_10.5.0.tar.gz -o /tmp/azcopy.tgz \
  && export BIN_LOCATION=$(tar -tzf /tmp/azcopy.tgz | grep "/azcopy") \
  && tar -xzf /tmp/azcopy.tgz --strip-components=1 -C /usr/local/bin \
  && az aks install-cli \
  && kubectl completion bash >/etc/bash_completion.d/kubectl \
  && rm -rf /var/lib/apt/lists/*
RUN curl -sL https://get.helm.sh/helm-v3.4.0-linux-amd64.tar.gz -o /tmp/helm.tar.gz \
  && tar -xzf /tmp/helm.tar.gz --strip-components=1 -C /usr/local/bin \
  && rm /tmp/helm.tar.gz
RUN curl -sL https://github.com/roboll/helmfile/releases/download/v0.132.1/helmfile_linux_amd64 -o /usr/local/bin/helmfile && chmod a+x /usr/local/bin/helmfile
CMD ["/bin/bash"]
