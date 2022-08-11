# sync-date-openwrt-with-bug
Sync date openwrt with pick date from bug or domain

- script AlkhaNet by Teguh Surya Mungaran
- ganti http://whatsapp.com dengan bug anda masing2
- pastekan command dibawah untuk menginstall script ini

wget --no-check-certificate "https://raw.githubusercontent.com/vitoharhari/sync-date-openwrt-with-bug/main/jam.sh" -O /usr/bin/jam.sh && chmod +x /usr/bin/jam.sh

- masukkan command dibawah ke Luci, di system>startup>local startup,atau di rc.local jika di terminal

/usr/bin/jam.sh

- terimakasih 
