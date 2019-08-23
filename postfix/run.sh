#!/bin/bash
chown -R vmail /var/vmail
chown -R www-data /var/www/html/
chown -R mysql /var/lib/mysql
chown :syslog /var/log/
chmod 775 /var/log/
mkdir -p /var/log/apache2 /var/log/mysql
if [ ! -d "/var/lib/mysql/mysql" ]; then /usr/bin/mysql_install_db;fi
/etc/init.d/mysql start;
if [ ! -d "/var/lib/mysql/mail" ]; 
then 
    PSSW=`doveadm pw -s MD5-CRYPT -p $ADMIN_PASSWD | sed 's/{MD5-CRYPT}//'`
    echo "sed -i -- 's/\$HOSTNAME/$HOSTNAME/g' /var/www/html/postfixadmin/config.inc.php"
    sed -i -- "s/\$HOSTNAME/$HOSTNAME/g" /var/www/html/postfixadmin/config.inc.php

    echo "sed -i -- 's/\$DOMAINNAME/$DOMAINNAME/g' /var/www/html/postfixadmin/config.inc.php"
    sed -i -- "s/\$DOMAINNAME/$DOMAINNAME/g" /var/www/html/postfixadmin/config.inc.php
    
    echo "sed -i -- 's/\$HOSTNAME/$HOSTNAME/g' postfixadmin.sql"
    sed -i -- "s/\$HOSTNAME/$HOSTNAME/g" postfixadmin.sql
    
    echo "sed -i -- 's/\$DOMAINNAME/$DOMAINNAME/g' postfixadmin.sql"
    sed -i -- "s/\$DOMAINNAME/$DOMAINNAME/g" postfixadmin.sql
    
    mysql < /postfixadmin.sql;mysql -e "insert into admin values('$ADMIN_USERNAME','$PSSW',1,'2016-03-02 15:23:14','2016-03-03 16:24:44',1);insert into domain_admins values('$ADMIN_USERNAME', 'ALL', NOW(), 1)" mail;
    # TODO make configuration.
    postfixadmin-cli domain add $DOMAINNAME --aliases 0 --mailboxes 0
    USERS_LIST=$(echo $USERS | tr , \\n)
    for USER in $USERS_LIST; do
        _user=$(echo $USER | awk -F':' '{print $1}')
        _pwd=$(echo $USER | awk -F':' '{print $2}')
        postfixadmin-cli mailbox add $_user@$DOMAINNAME --password $_pwd --password2 $_pwd --quota $USERS_QUOTA --name $_user
    done
fi
if [ -z "$MYHOSTNAME" ]; then
    MYHOSTNAME="$HOSTNAME.$DOMAINNAME"
fi
postconf -e myhostname=$MYHOSTNAME
postconf -e mydestination="$MYHOSTNAME, localhost"
############
# Enable TLS
############
if [[ -n "$(find /etc/postfix/certs -iname *.crt)" && -n "$(find /etc/postfix/certs -iname *.key)" ]]; then
    chmod 400 /etc/postfix/certs/*.*
    # /etc/postfix/main.cf
    postconf -e smtpd_tls_cert_file=$(find /etc/postfix/certs -iname *.crt)
    postconf -e smtpd_tls_key_file=$(find /etc/postfix/certs -iname *.key)
fi

#############
#  opendkim
#############
if [[ -z "$(find /etc/opendkim/domainkeys -iname *.private)" ]]; then
    opendkim-genkey -D /etc/opendkim/domainkeys/ -d $(hostname -d) -s $(hostname)
fi
if [[ ! -z "$(find /etc/opendkim/domainkeys -iname *.private)" ]]; then
    # /etc/postfix/main.cf
    postconf -e milter_protocol=2
    postconf -e milter_default_action=accept
    postconf -e smtpd_milters=inet:localhost:12301
    postconf -e non_smtpd_milters=inet:localhost:12301

    cat >> /etc/opendkim.conf <<EOF
AutoRestart             Yes
AutoRestartRate         10/1h
UMask                   002
Syslog                  yes
SyslogSuccess           Yes
LogWhy                  Yes

Canonicalization        relaxed/simple

ExternalIgnoreList      refile:/etc/opendkim/TrustedHosts
InternalHosts           refile:/etc/opendkim/TrustedHosts
KeyTable                refile:/etc/opendkim/KeyTable
SigningTable            /etc/opendkim/SigningTable

Mode                    sv
PidFile                 /var/run/opendkim/opendkim.pid
SignatureAlgorithm      rsa-sha256

UserID                  opendkim:opendkim

Socket                  inet:12301@localhost
EOF

    cat >> /etc/default/opendkim <<EOF
SOCKET="inet:12301@localhost"
EOF

    cat >> /etc/opendkim/TrustedHosts <<EOF
127.0.0.1
localhost
$NETWORK

*.$HOSTNAME.$DOMAINNAME
EOF

    cat >> /etc/opendkim/KeyTable <<EOF
$HOSTNAME._domainkey.$DOMAINNAME $DOMAINNAME:$HOSTNAME.$DOMAINNAME:$(find /etc/opendkim/domainkeys -iname *.private)
EOF

    cat >> /etc/opendkim/SigningTable <<EOF
$DOMAINNAME $HOSTNAME._domainkey.$DOMAINNAME
EOF

    chown opendkim:opendkim $(find /etc/opendkim/domainkeys -iname *.private)
    chmod 400 $(find /etc/opendkim/domainkeys -iname *.private)
fi

echo "sed -i -- 's/\$HOSTNAME/$HOSTNAME/g' /etc/dovecot/dovecot.conf"
sed -i -- "s/\$HOSTNAME/$HOSTNAME/g" /etc/dovecot/dovecot.conf

echo "sed -i -- 's/\$DOMAINNAME/$DOMAINNAME/g' /etc/dovecot/dovecot.conf"
sed -i -- "s/\$DOMAINNAME/$DOMAINNAME/g" /etc/dovecot/dovecot.conf

#############
#  start
#############
/etc/init.d/opendkim start;/etc/init.d/postfix start;/etc/init.d/rsyslog start;/etc/init.d/apache2 start;/usr/sbin/dovecot -F
