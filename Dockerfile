FROM ubuntu:latest

RUN apt update && apt -y upgrade && \
    apt install -y git curl wget unzip grep screen cron systemctl vim && \
    systemctl enable cron

WORKDIR /tmp

RUN git clone https://github.com/cmu-sei/Gameboard && \
    git clone https://github.com/cmu-sei/TopoMojo
    
EXPOSE 5000/udp 5001/udp 5000/tcp 5001/tcp