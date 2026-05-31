#!/bin/zsh
export PATH="/usr/bin:/bin"
DIR="/Users/ugurcansoruc/Desktop/ikincielde1inci/assets/instagram"
mkdir -p "$DIR"

fetch_one() {
  num="$1"
  id="$2"
  html=$(/usr/bin/curl -sL -A "Mozilla/5.0" "https://www.instagram.com/p/${id}/embed/captioned/" --max-time 25)
  # Prefer post/reel cover (71878 or large 82787-15), skip profile (82787-19) and tiny thumbs
  url=$(echo "$html" | /usr/bin/grep -oE 'https://[^"<> ]+cdninstagram\.com/v/t51\.[0-9]+-[0-9]+/[0-9]+_[0-9]+_[0-9]+_n\.jpg[^"<> ]*' | /usr/bin/grep -v '82787-19' | /usr/bin/grep -v 's150x150' | /usr/bin/grep -v 's240x240' | /usr/bin/head -1)
  if [ -z "$url" ]; then
    url=$(echo "$html" | /usr/bin/grep -oE 'https://[^"<> ]+cdninstagram\.com/v/t51\.[0-9]+-[0-9]+/[0-9]+_[0-9]+_[0-9]+_n\.jpg' | /usr/bin/grep -v '82787-19' | /usr/bin/head -1)
  fi
  url=$(echo "$url" | sed 's/&amp;/\&/g')
  echo "post-$num $id"
  echo "  $url"
  if [ -n "$url" ]; then
    /usr/bin/curl -sL -A "Mozilla/5.0" -o "$DIR/post-$num.jpg" "$url"
    file "$DIR/post-$num.jpg"
  fi
}

fetch_one 1 DXpBVMHiPmW
fetch_one 2 DPqTwApCMBf
fetch_one 3 DOS-XIGiPrt
fetch_one 4 DZAKAIGoX1z
fetch_one 5 DY-CRxLofmb
fetch_one 6 DY7Vor4oTTu
