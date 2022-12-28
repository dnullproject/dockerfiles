FROM mongo
WORKDIR /opt/backup/
# Create app directory
WORKDIR /usr/src/configs
RUN apt update && \
    apt install awscli -y

# Install app dependencies
COPY dump.sh .
COPY restore.sh .
RUN chmod +x restore.sh dump.sh
