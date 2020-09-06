FROM alpine:3.12

RUN apk --update add bind bind-dnssec-tools

COPY named.conf /etc/bind/

RUN mkdir /var/lib/bind
RUN chown -R named:named /var/lib/bind/

COPY *.zone /var/lib/bind/

EXPOSE 53
CMD ["named", "-c", "/etc/bind/named.conf", "-g", "-u", "named"]

