FROM node:latest

ENV API_PORT=8080
ENV DB_ADDR=127.0.0.1
ENV DB_PORT=8080

WORKDIR /opt/app
COPY package*.json ./
RUN npm install
COPY . .

CMD ["sh", "-c", "node server.js ${environment}"]