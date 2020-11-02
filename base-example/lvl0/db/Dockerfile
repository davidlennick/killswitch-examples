FROM postgres:latest

ENV POSTGRES_USER docker
ENV POSTGRES_PASSWORD docker

ADD db.sql /docker-entrypoint-initdb.d/

