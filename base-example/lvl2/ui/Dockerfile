FROM nginx:latest

ENV API_ADDR=""
ENV API_PORT=""
ENV API_PATH=""

COPY index.html /usr/share/nginx/html
COPY entrypoint.sh /usr/share/nginx
COPY pinger.sh /usr/share/nginx
RUN chmod +x /usr/share/nginx/entrypoint.sh

CMD [ "/usr/share/nginx/entrypoint.sh" ]