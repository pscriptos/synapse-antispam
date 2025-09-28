# Synapse Docker Image mit integriertem HTTP Antispam Modul

> 📝 Diese Dokumentation ergänzt den Blogbeitrag  
> [🔐 Matrix absichern mit Draupnir Antispam Modul (Blog)](https://www.cleveradmin.de/blog/2025/05/matrix-absichern-mit-draupnir-antispam-modul/)  
> und bietet eine praktische Umsetzung in Form eines vorgefertigten Docker-Images mit integriertem Antispam-Modul für Synapse.

Dieses Repository stellt ein angepasstes Docker-Image für den Matrix Synapse Server bereit, welches das Modul [synapse-http-antispam](https://github.com/maunium/synapse-http-antispam) bereits enthält. Es richtet sich an Administratoren, die Draupnir als externen Spamfilter für ihre Synapse-Instanz nutzen möchten – besonders in Docker-Umgebungen.

## 📦 Docker Image

Das Image basiert auf `matrixdotorg/synapse:latest` und wird automatisch um das HTTP Antispam Modul erweitert. Es kann direkt genutzt oder als Basis für ein eigenes Compose-Setup verwendet werden.

### Verfügbare Tags

- `git.techniverse.net/scriptos/synapse:latest-antispam` – immer die aktuellste Version
- `git.techniverse.net/scriptos/synapse:v1.138.0-antispam` – spezifische Synapse-Version mit Modul

👉 **Hinweis:** Die Images werden nur für offizielle Hauptversionen von Synapse gebaut, nicht für Pre-Releases oder Release Candidates.  
Eine Übersicht aller verfügbaren Versionen findest du hier:  
[Synapse with HTTPAntiSpam: Tags](https://git.techniverse.net/scriptos/-/packages/container/synapse)

### Beispiel: docker-compose.yml

```yaml
services:
  synapse-antispam:
    build:
      context: .
      dockerfile: ./Dockerfile
    image: custom-synapse:latest-antispam
```

Alternativ kannst du direkt ein vorgefertigtes Image mit Tag verwenden, z. B.:

```yaml
image: git.techniverse.net/scriptos/synapse:v1.138.0-antispam
```

## 🔧 Konfiguration in homeserver.yaml

Damit das Modul korrekt funktioniert, muss folgende Konfiguration in `homeserver.yaml` ergänzt werden:

```yaml
modules:
  - module: synapse_http_antispam.HTTPAntispam
    config:
      base_url: http://matrix-draupnir:8082/api/1/spam_check
      authorization: '8EEGpJGVsR2yHmXaA9r74SwcmijLpQmraRm6HuivhG8in5KJ8H'
      enabled_callbacks:
        - check_event_for_spam
        - user_may_invite
        - user_may_join_room
      fail_open:
        check_event_for_spam: true
        user_may_invite: false
        user_may_join_room: false
      async:
        check_event_for_spam: true
```

## 🧩 Funktionsweise des Moduls

Das Modul leitet bestimmte Ereignisse an einen externen HTTP-Dienst weiter – in diesem Fall Draupnir – um dort zu prüfen, ob eine Aktion als Spam gewertet werden soll. Es kann Nachrichten, Einladungen und Raumbeitritte blockieren, bevor sie überhaupt ausgeführt werden.

**Verfügbare Prüfungen (Callbacks):**
- `check_event_for_spam` – prüft Nachrichten und Aktionen
- `user_may_invite` – prüft Einladungserlaubnis
- `user_may_join_room` – prüft Beitrittsberechtigung

**Weitere Optionen:**
- `fail_open` – legt fest, ob bei Ausfall von Draupnir Aktionen erlaubt bleiben
- `async` – aktiviert die asynchrone Prüfung für bessere Performance

## 🔗 Weiterführende Links

- [🔐 Matrix absichern mit Draupnir Antispam Modul (Blog)](https://www.cleveradmin.de/blog/2025/05/matrix-absichern-mit-draupnir-antispam-modul/)
- [📚 Draupnir-Dokumentation](https://the-draupnir-project.github.io/draupnir-documentation/)
- [🧰 synapse-http-antispam (GitHub)](https://github.com/maunium/synapse-http-antispam)

---

> Hinweis: Dieses Repository enthält keine Quelltexte des Moduls selbst, sondern dokumentiert nur die Verwendung des vorkonfigurierten Docker-Images.

## 💬 Support & Community

Du hast Fragen, brauchst Unterstützung bei der Einrichtung oder möchtest dich einfach mit anderen austauschen, die ähnliche Projekte betreiben? Dann schau gerne in unserer Techniverse Community vorbei:

👉 **Matrix-Raum:** [#community:techniverse.net](https://matrix.to/#/#community:techniverse.net)  
Wir freuen uns auf deinen Besuch und helfen dir gerne weiter!

<p align="center">
  <img src="https://assets.techniverse.net/f1/git/graphics/gray0-catonline.svg" alt="">
</p>

<p align="center">
<img src="https://assets.techniverse.net/f1/logos/small/license.png" alt="License" width="15" height="15"> <a href="./synapse-antispam/src/branch/main/LICENSE">License</a> | <img src="https://assets.techniverse.net/f1/logos/small/matrix2.svg" alt="Matrix" width="15" height="15"> <a href="https://matrix.to/#/#community:techniverse.net">Matrix</a> | <img src="https://assets.techniverse.net/f1/logos/small/mastodon2.svg" alt="Matrix" width="15" height="15"> <a href="https://social.techniverse.net/@donnerwolke">Mastodon</a>
</p>