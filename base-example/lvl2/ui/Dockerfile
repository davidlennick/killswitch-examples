FROM nginx:latest

ENV API_ADDR=""
ENV API_PORT=""
ENV API_PATH=""

COPY index.html /usr/share/nginx/html/
COPY entrypoint.sh /usr/share/nginx/
COPY pinger.sh /usr/share/nginx/

CMD [ "/usr/share/nginx/entrypoint.sh" ]