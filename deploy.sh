#!/bin/bash
# Ez a szkript ELŐSZÖR letölti a legfrissebb kódot a GitHub-tárolóból
# (amit Claude tölt fel minden módosításnál), UTÁNA tölti fel a Firebase-re.
# Neked mostantól tényleg csak ennyi a dolgod: bash deploy.sh
# (vagy hagyod, hogy a hajnali automatika végezze el helyetted.)

cd "$(dirname "$0")"

LOGFILE="$HOME/Library/Logs/fsmapp-deploy.log"
echo "===== $(date) — automatikus feltöltés indul =====" >> "$LOGFILE"

REPO_RAW="https://raw.githubusercontent.com/Beezindultunk/fsmapp/main"

echo "1/3 — legfrissebb kód letöltése a GitHub-ról..." >> "$LOGFILE"
curl -sL "$REPO_RAW/public/index.html" -o public/index.html.new
curl -sL "$REPO_RAW/public/version.json" -o public/version.json.new
curl -sL "$REPO_RAW/firestore.rules" -o firestore.rules.new

# Csak akkor cseréljük le a fájlokat, ha a letöltés ténylegesen sikerült
# (ne írjuk felül a meglévő, működő verziót egy esetleges hálózati hibával).
if [ -s public/index.html.new ] && [ -s public/version.json.new ] && [ -s firestore.rules.new ]; then
  mv public/index.html.new public/index.html
  mv public/version.json.new public/version.json
  mv firestore.rules.new firestore.rules
  echo "   ✅ Sikeresen letöltve a legfrissebb verzió." >> "$LOGFILE"
else
  echo "   ⚠️  A letöltés nem sikerült — a jelenlegi helyi fájlokkal folytatjuk." >> "$LOGFILE"
  rm -f public/index.html.new public/version.json.new firestore.rules.new
fi

echo "2/3 — feltöltés a Firebase-re..." >> "$LOGFILE"
npx --yes firebase-tools deploy --only firestore:rules,hosting >> "$LOGFILE" 2>&1

if [ $? -eq 0 ]; then
  echo "3/3 — ✅ Sikeres feltöltés: $(date)" >> "$LOGFILE"
else
  echo "3/3 — ❌ Hiba történt a feltöltés közben: $(date) — nézd meg a fenti naplót." >> "$LOGFILE"
fi
