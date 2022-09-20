FROM ubuntu
WORKDIR /app

RUN apt update && \
    apt install -y \
    git \
    wget

RUN wget https://github.com/mikefarah/yq/releases/download/v4.27.5/yq_linux_amd64 -O /bin/yq && \
      chmod +x /bin/yq

COPY deploy.sh .
