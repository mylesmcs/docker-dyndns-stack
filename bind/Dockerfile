FROM alpine:3.12

RUN apk --update add bind bind-dnssec-tools

COPY named.conf /etc/bind/
COPY dyn.example.com.zone /var/lib/bind/
COPY sample.com.zone /etc/bind/

RUN mkdir /var/lib/bin
RUN chown -R named:named /var/lib/bind/

EXPOSE 53
CMD ["named", "-c", "/etc/bind/named.conf", "-g", "-u", "named"]

