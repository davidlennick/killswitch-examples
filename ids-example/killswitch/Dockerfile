FROM ubuntu:latest

WORKDIR /app
RUN apt update
RUN apt install -y python3 python3-pip

COPY killswitch.py ./
COPY killswitch-service.py ./
COPY rules.json ./
COPY entrypoint.sh ./
RUN python3 -m pip install docker

ENTRYPOINT [ "/app/entrypoint.sh" ]