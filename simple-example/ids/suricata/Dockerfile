FROM ubuntu:20

RUN apt update
RUN add-apt-repository ppa:oisf/suricata-stable
RUN apt update
RUN apt install suricata

RUN apt install python3 python3-pip python3-venv

RUN pip install --upgrade suricata-update

ADD suricata.yaml /etc/suricata/suricata.yaml

