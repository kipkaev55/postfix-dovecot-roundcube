# Postfix+Dovecot+RoundCube MailServer
### How to use
* Install [docker-compose](https://docs.docker.com/compose/install/)
* Copy .env.example and custom it
```js
cp .env.example .env
```
* Put your certs files to ./assets/certs
* Put your dkim files to ./assets/dkim
* Run docker-composer for mailserver
```js
docker-compose build mailserver
docker-compose up -d mailserver
```
### If you need relay emails from your domain, add this in /etc/postfix/main.cf
```
...
transport_maps = hash:/etc/postfix/transport
```
Then create /etc/postfix/transport
```
# cat /etc/postfix/transport
noreply@domain.com smtp:[127.0.0.1]
domain.com relay:[mx.yandex.ru]
# postmap /etc/postfix/transport
# postfix reload
```
