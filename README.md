# Z-Push Docker-Image

ActiveSync-Gateway für das iPhone (native Mail-App mit Push) vor dem
Mailserver zogge23.de (technicalguru-Stack, Dovecot/Postfix).

- Image: `ghcr.io/amer235/z-push:<z-push-version>`
- Basis: `php:8.3-apache-bookworm`, Z-Push aus GitHub-Release
- Konfiguration (`config.php`, `backend/imap/config.php`) wird zur Laufzeit
  per Volume eingehängt – **keine Passwörter im Repo/Image**

## Updates

| Was | Wie |
|---|---|
| PHP-/Debian-Sicherheitsupdates | automatischer Rebuild jeden Montag (Workflow `build`) |
| Neue Z-Push-Version | `ZPUSH_VERSION` im Dockerfile anpassen und committen |
| GitHub-Actions-Versionen | Dependabot-PR mergen |

Nach einem neuen Build in Portainer: Stack → „Update the stack“ mit
„Re-pull image“.

## Tags

- `2.7.7` – aktuelle Z-Push-Version (wird wöchentlich neu gebaut)
- `latest` – zuletzt gebautes Image
- `sha-<commit>` – exakter Stand für Rollback

## Bekannte Grenzen

- **PHP 8.3 Sicherheitssupport endet am 31.12.2027.** Ab PHP 8.4 ist die
  IMAP-Erweiterung nicht mehr in PHP enthalten (nur noch PECL, braucht
  `libc-client`, das es nur in Debian Bookworm gibt; Bookworm-LTS bis 06/2028).
  Spätestens Ende 2027 entscheiden: PECL-Variante, Ersatzbibliothek oder
  Alternative (z. B. Grommunio).
