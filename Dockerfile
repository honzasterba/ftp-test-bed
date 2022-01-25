FROM alpine:3.15

RUN apk --no-cache add vsftpd openssl

COPY conf /etc/vsftpd/conf
COPY start.sh /bin

RUN chmod +x /bin/start.sh
RUN mkdir -p /home/vsftpd/
RUN chown -R ftp:ftp /home/vsftpd/

VOLUME /home/guest

STOPSIGNAL SIGKILL

EXPOSE 20 21 21100-21199
EXPOSE 30 31 31100-31199
EXPOSE 40 41 41100-41199
EXPOSE 50 51 51100-51199
EXPOSE 60 61 61100-61199

ENTRYPOINT ["/bin/start.sh"]
