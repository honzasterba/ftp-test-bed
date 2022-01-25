#!/bin/sh -ex

for server_name in ftps_basic ftps_implicit ftps_tls
do
    echo Generating self-signed certificate ${server_name}
    mkdir -p /etc/vsftpd/${server_name}

    openssl req -x509 -nodes -days 7300 \
        -newkey rsa:2048 -keyout /etc/vsftpd/${server_name}/vsftpd.pem -out /etc/vsftpd/${server_name}/vsftpd.pem \
        -subj "/C=FR/O=My company/CN=example.org"
    openssl pkcs12 -export -out /etc/vsftpd/${server_name}/vsftpd.pkcs12 -in /etc/vsftpd/${server_name}/vsftpd.pem -passout pass:

    chmod 755 /etc/vsftpd/${server_name}/vsftpd.pem
    chmod 755 /etc/vsftpd/${server_name}/vsftpd.pkcs12
done

&>/var/anon.log /usr/sbin/vsftpd vsftpd_anonymous.conf
&>/var/basic.log /usr/sbin/vsftpd vsftpd_basic.conf
&>/var/ftps.log /usr/sbin/vsftpd vsftpd_ftps.conf
&>/var/fpts_impl.log /usr/sbin/vsftpd vsftpd_fpts_implicit.conf
&>/var/ftps_tls.log /usr/sbin/vsftpd vsftpd_fpts_tls.conf

tail -F /var/*.log
