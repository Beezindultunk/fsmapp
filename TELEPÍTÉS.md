# FSM App — telepítési útmutató

## 🚀 A napi teendőd (ha kézzel akarod futtatni)

```
cd /Users/torekitamasroyalcrown/Downloads/fsmapp
bash deploy.sh
```

Ennyi. A szkript magától letölti a legfrissebb kódot a GitHub-tárolóból
(https://github.com/Beezindultunk/fsmapp), majd feltölti a Firebase-re.

## 🔁 Napi automatikus feltöltés (helyi, Mac-es tartalék)

```
chmod +x deploy.sh
cp hu.fsmapp.dailydeploy.plist ~/Library/LaunchAgents/
launchctl load ~/Library/LaunchAgents/hu.fsmapp.dailydeploy.plist
```

Ellenőrzés: `launchctl list | grep fsmapp`
Napló: `cat ~/Library/Logs/fsmapp-deploy.log`

## ☁️ Felhő-alapú automatikus telepítés (GitHub Actions)

Ez a fő, megbízható automatika — a géped állapotától teljesen független.
Minden nap hajnali 2:00 UTC-kor (magyar idő 4:00), és minden alkalommal,
amikor új kód kerül a `main` ágra, magától lefut:
https://github.com/Beezindultunk/fsmapp/actions

## A saját domain (fsmapp.hu) összekötése

Ez már meg van csinálva — a DNS-rekordok be vannak állítva a Rackhostnál,
a Firebase pedig automatikusan aktiválja, amint a DNS-terjedés lezajlik.
