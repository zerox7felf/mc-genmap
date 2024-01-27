FROM docker.io/jitesoft/lighttpd

WORKDIR /var/www/html
COPY *.html /var/www/html/
COPY *.css /var/www/html/
COPY *.png /var/www/html/

ENTRYPOINT [ "entrypoint" ]
CMD [ "-D" ]
