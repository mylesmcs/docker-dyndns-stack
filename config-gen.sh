#!/bin/bash

echo DDNS Config:
echo ====================================
echo

BIND="./bind/"

read -p 'Default TTL (sec): ' ttl
read -p  'DDNS Domain: ' domain

rm $BIND/*.zone

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
      allow-update { key "ddns-key"; };
      notify no;
};

key "ddns-key" {
        algorithm hmac-sha512;
        secret "arl7QLXhqiS3pvFUmyZ21g6gHvV6D3Par2VHtP3KtD7ZfoAhY8dAY09c8nOjQVoOwlC8keq+uMSEbAQM9F3hJw==";
};

EOL


#rename -v example.com.zone $domain.zone ./bind/example.com.zone
#sed -i "s|example.com|$domain|g" "./bind/$domain.zone"
#sed -i "s|TTL 60|TTL $ttl|g" "./bind/$domain.zone"
