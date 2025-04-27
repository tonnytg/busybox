FROM ubuntu:22.04

WORKDIR /app

# Variáveis para não travar o processo
ENV DEBIAN_FRONTEND=noninteractive
ENV NVM_DIR=/root/.nvm

# pacotes básicos
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    neovim \
    mtr \
    python3 \
    python3-pip \
    screen \
    tmux \
    htop \
    tcpdump \
    netcat \
    gnupg \
    lsb-release \
    unzip \
    wget \
    ca-certificates \
    software-properties-common \
    && rm -rf /var/lib/apt/lists/*

# gcloud e gsutil
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg && \
    apt-get update && apt-get install -y google-cloud-sdk && \
    rm -rf /var/lib/apt/lists/*

# NVM e Node.js
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash && \
    . "$NVM_DIR/nvm.sh" && \
    nvm install --lts && \
    nvm use --lts && \
    nvm alias default node

# Terraform, Terrascan, TFLint, Terracost
RUN wget -O terraform.zip https://releases.hashicorp.com/terraform/1.8.4/terraform_1.8.4_linux_amd64.zip && \
    unzip terraform.zip && mv terraform /usr/local/bin/ && rm terraform.zip

# Terrascan
RUN curl -LO https://github.com/tenable/terrascan/releases/download/v1.18.4/terrascan_1.18.4_Linux_x86_64.tar.gz && \
    tar -xzf terrascan_1.18.4_Linux_x86_64.tar.gz terrascan && \
    mv terrascan /usr/local/bin/ && \
    rm terrascan_1.18.4_Linux_x86_64.tar.gz

RUN curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash;

RUN curl -LO https://github.com/infracost/infracost/releases/latest/download/infracost-linux-amd64.tar.gz && \
    tar -xzf infracost-linux-amd64.tar.gz && \
    mv infracost-linux-amd64 /usr/local/bin/infracost && \
    rm infracost-linux-amd64.tar.gz

# Go
RUN wget https://go.dev/dl/go1.22.3.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go1.22.3.linux-amd64.tar.gz && \
    rm go1.22.3.linux-amd64.tar.gz

# PostgreSQL Client 16
RUN curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor -o /etc/apt/trusted.gpg.d/postgresql.gpg && \
    echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list && \
    apt-get update && \
    apt-get install -y postgresql-client-16 && \
    rm -rf /var/lib/apt/lists/*

# Kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -sL https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
    rm kubectl

ENV PATH=$PATH:/usr/local/go/bin

CMD [ "bash" ]
