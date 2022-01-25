#!/bin/sh -ex

CONF_ROOT=/etc/vsftpd/conf

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

/usr/sbin/vsftpd $CONF_ROOT/vsftpd_anonymous.conf
/usr/sbin/vsftpd $CONF_ROOT/vsftpd_basic.conf
/usr/sbin/vsftpd $CONF_ROOT/vsftpd_ftps.conf
/usr/sbin/vsftpd $CONF_ROOT/vsftpd_fpts_implicit.conf
/usr/sbin/vsftpd $CONF_ROOT/vsftpd_fpts_tls.conf

tail -F /var/*.log
