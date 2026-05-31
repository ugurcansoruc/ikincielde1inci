#!/bin/zsh
export PATH="/usr/local/bin:/usr/bin:/bin:$PATH"
cd "$(dirname "$0")/.."
mkdir -p assets/vehicles

crop() {
  local path="$1" slug="$2"
  .venv/bin/python3 <<PY
from PIL import Image
img = Image.open("$path")
if img.mode == "RGBA":
    img = img.convert("RGB")
w, h = img.size
c = img.crop((int(w * 0.02), int(h * 0.12), int(w * 0.62), int(h * 0.72)))
c.save("assets/vehicles/$slug.jpg", "JPEG", quality=90)
print("OK assets/vehicles/$slug.jpg")
PY
}

go() {
  local url="$1" expect="$2" slug="$3"
  printf '%s' "$url" | orca computer set-value --app com.brave.Browser --element-index 10 --value-stdin --restore-window --json >/dev/null
  sleep 0.8
  orca computer press-key --app com.brave.Browser --key Return --restore-window --json >/dev/null
  for i in {1..12}; do
    sleep 2
    title=$(orca computer get-app-state --app com.brave.Browser --json 2>/dev/null | python3 -c "import json,sys; t=json.load(sys.stdin)['result']['snapshot']['treeText']; print([l for l in t.split(chr(10)) if l.startswith('Window:')][0])" 2>/dev/null)
    echo "  [$slug] try $i: ${title:0:80}"
    if echo "$title" | grep -qi "$expect"; then
      path=$(orca computer get-app-state --app com.brave.Browser --json | python3 -c "import json,sys; print(json.load(sys.stdin)['result']['screenshot']['path'])")
      crop "$path" "$slug"
      return 0
    fi
  done
  echo "FAIL $slug"
  return 1
}

go "https://www.sahibinden.com/ilan/vasita-otomobil-mercedes-benz-inci-den-2024-c200-amg-4-matic-9g-tronic-boyasiz-hatasiz-1317108703/detay" "C200" "mercedes-c200"
go "https://www.sahibinden.com/ilan/vasita-otomobil-bmw-inci-den-2018-bmw-740d-xdrive-long-m-excellence-114.000-km-de-1316952669/detay" "740" "bmw-740d"
go "https://www.sahibinden.com/ilan/vasita-otomobil-bmw-inci-den-2015-bmw-525d-xdrive-executive-m-sport-ici-taba-bakimli-1318354871/detay" "525" "bmw-525d"
go "https://www.sahibinden.com/ilan/vasita-arazi-suv-pickup-porsche-inci-den-2013-cayenne-3.0d-platinium-boyasiz-vergi-barisli-1315225864/detay" "Cayenne" "porsche-cayenne"

/usr/bin/ls -la assets/vehicles/
