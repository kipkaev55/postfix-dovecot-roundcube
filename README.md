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

### Scheme of working

```mermaid
sequenceDiagram
    autonumber
    participant C as EMailSMTPClient (Monolith)
    participant M as MailServer (Postfix+Dovecot)
    participant S as SMTP (Postfix)
    participant D as MAILER-DAEMON
    participant P as POP/IMAP (Dovecot)
    participant Y as Relay Yandex
    participant NS as NS-server
    participant MX as MX-server

    C->>+M: { to: user@domain.name, from: noreply@mydomain.ltd, bcc: masha@mydomain.ltd }
    M->>+S: { to: user@domain.name, from: noreply@mydomain.ltd, bcc: masha@mydomain.ltd }
    S->>-M: received
    M->>-C: received
    alt if to === noreply@mydomain.ltd
      S->>+P: { to: user@domain.name, from: noreply@mydomain.ltd, bcc: masha@mydomain.ltd }
      P-->>-S: status=sent (delivered via dovecot service)
    else if to === *@mydomain.ltd
      S->>+Y: *@mydomain.ltd relay:[mx.yandex.ru]
      alt success
          Y-->>-S: status=sent (250 OK)
      else fail
          Y--xM: status=deferred (450 4.2.1 The recipient has exceeded message rate limit)
          M->>D: { to: noreply@mydomain.ltd, from: MAILER-DAEMON@smtp }
          D->>P: { to: noreply@mydomain.ltd, from: MAILER-DAEMON@smtp }
      end
    else
      S->>+NS: mx for domain.name
      NS-->>-S: mx.domain.name
      S->>+MX: *@domain.name relay:[mx.domain.name]
      alt success
          MX-->>-S: status=sent (250 OK)
      else fail
          MX--xM: status=deferred (450 4.2.1 The recipient has exceeded message rate limit)
          M->>D: { to: noreply@mydomain.ltd, from: MAILER-DAEMON@smtp }
          D->>P: { to: noreply@mydomain.ltd, from: MAILER-DAEMON@smtp }
      end
    end

```
