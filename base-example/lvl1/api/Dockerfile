FROM node:latest

ENV API_PORT=8080
ENV DB_ADDR=127.0.0.1
ENV DB_PORT=8080

WORKDIR /opt/app
COPY package*.json ./
COPY entrypoint.sh ./
RUN npm install
COPY . .


#ENTRYPOINT [ "/opt/app/entrypoint.sh" ]
#CMD ["sh", "-c", "node server.js"]
CMD ["sh", "-c", "/opt/app/entrypoint.sh"]
