FROM alpine:3.12

RUN apk --update add bind bind-dnssec-tools

COPY named.conf /etc/bind/
COPY dyn.example.com.zone /var/lib/bind/

EXPOSE 53
CMD ["named", "-c", "/etc/bind/named.conf", "-g", "-u", "named"]

