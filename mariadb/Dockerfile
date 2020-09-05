FROM mariadb:latest
LABEL maintainer "Myles McSweeney <info@mylesmcsweeney.com>"

ENV MYSQL_ROOT_PASSWORD=testpassword

COPY ./sql-scripts/ /docker-entrypoint-initdb.d/
