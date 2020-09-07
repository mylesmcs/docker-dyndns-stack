#!/bin/env bash

BIND="./bind/"

read -p 'Default TTL (sec): ' ttl
read -p  'DDNS Domain: ' domain

rm $BIND/*.zone

key=$(tsig-keygen -a HMAC-SHA512 $domain)

if [ $? -eq 0 ]; then
        echo -e "TSIG Key: \e[32mOK\e[0m"
else
        echo -e "TSIG Key: \e[31mFAIL\e[0m"
fi

echo "$key" > ./api/application/ddns.key

# Write zone file
cat >$BIND/$domain.zone <<EOL
\$TTL 7200       ; 2 hours
\$ORIGIN $domain.
@               IN SOA  ns1.$domain. postmaster@$domain. (
                        2002022404 ; serial
                        10800      ; refresh (3 hours)
                        3600       ; retry (1 hour)
                        432000     ; expire (5 days)
                        1200       ; minimum (20 minutes)
                        )

        IN NS						ns1.$domain.
ns1     IN A                        10.0.0.60
EOL

if [ $? -eq 0 ]; then
        echo -e "Zone File: \e[32mOK\e[0m"
else
        echo -e "Zone File: \e[31mFAIL\e[0m"
fi

# Write named.conf
cat >$BIND/named.conf << EOL
options {
        directory "/var/bind";

        pid-file "/var/run/named/named.pid";

        // Configure the IPs to listen on
        listen-on { any; };
        listen-on-v6 { none; };

        // Allow only specific hosts to use the DNS server
        //allow-query {
        //      127.0.0.1;
        //};

        // Specify a list of IPs/masks to allow zone transfers to
        allow-transfer {
                none;
        };

        // Disable recursion
        allow-recursion { none; };
        recursion no;
};

zone "$domain" IN {
      type master;
      file "/var/lib/bind/$domain.zone";
      allow-update { key "$domain"; };
      notify no;
};

$key

EOL

if [ $? -eq 0 ]; then
        echo -e "DNS Config: \e[32mOK\e[0m"
else
        echo -e "DNS Config: \e[31mFAIL\e[0m"
fi

#rename -v example.com.zone $domain.zone ./bind/example.com.zone
#sed -i "s|example.com|$domain|g" "./bind/$domain.zone"
#sed -i "s|TTL 60|TTL $ttl|g" "./bind/$domain.zone"
