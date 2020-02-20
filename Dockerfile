FROM spothero/baseline:latest

RUN wget -O /usr/bin/aviator https://github.com/JulzDiverse/aviator/releases/download/v1.6.0/aviator-linux-amd64 && \
    wget -O /usr/bin/ytt https://github.com/k14s/ytt/releases/download/v0.23.0/ytt-linux-amd64 && \
    chmod +x /usr/bin/aviator /usr/bin/ytt

ADD pipeline-generator /usr/local/bin
WORKDIR /workdir
