FROM ubuntu:14.04
LABEL maintainer="Valerii Kipkaev <kipkaev@kipkaev.name>"

ENV DEBIAN_FRONTEND noninteractive
ENV USERS_QUOTA 50

RUN apt-get update && \
    apt-get install -y wget postfix-mysql \
    dovecot-mysql dovecot-imapd dovecot-pop3d dovecot-lmtpd \
    php5-imap postfixadmin roundcube \
    mc telnet nano ca-certificates \
    mailutils dnsutils systemd htop mc \
    sasl2-bin opendkim opendkim-tools && \
    adduser vmail -q --home /var/vmail --uid 1150 --disabled-password --gecos "" && \
    wget -q http://downloads.sourceforge.net/project/postfixadmin/postfixadmin/postfixadmin-2.93/postfixadmin-2.93.tar.gz && \
    tar -C /var/www/html/ -xf postfixadmin-2.93.tar.gz  && \
    ln -s /var/www/html/postfixadmin-2.93/ /var/www/html/postfixadmin && \
    wget -q https://github.com/roundcube/roundcubemail/releases/download/1.1.4/roundcubemail-1.1.4.tar.gz && \
    tar -C /var/www/html/ -xf roundcubemail-1.1.4.tar.gz && \
    ln -s /var/www/html/roundcubemail-1.1.4 /var/www/html/roundcubemail && \
    chown :syslog /var/log/ && \
    chmod 775 /var/log/ && \
    chmod +x /var/www/html/postfixadmin/scripts/postfixadmin-cli && \
    ln -s /var/www/html/postfixadmin/scripts/postfixadmin-cli /usr/bin/postfixadmin-cli

COPY postfixadmin.sql /

COPY run.sh /run.sh
RUN chmod +x /run.sh
COPY dovecot /etc/dovecot
COPY postfix /etc/postfix
COPY postfixadmin /var/www/html/postfixadmin
COPY roundcubemail/config /var/www/html/roundcubemail/config

VOLUME [ "/var/log/", "/var/vmail/", "/var/lib/mysql" ]

EXPOSE 25 80 110 143 465 993 995

ENTRYPOINT /run.sh
