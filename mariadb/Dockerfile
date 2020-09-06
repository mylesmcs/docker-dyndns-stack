FROM mariadb:latest
LABEL maintainer "Myles McSweeney <info@mylesmcsweeney.com>"

# to be change to env var
ENV MYSQL_ROOT_PASSWORD=rTBSgdfGwQ5G

COPY ./sql-scripts/ /docker-entrypoint-initdb.d/
