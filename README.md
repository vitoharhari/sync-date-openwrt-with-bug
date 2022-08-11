# sync-date-openwrt-with-bug
Sync date openwrt with pick date from bug or domain

- script AlkhaNet by Teguh Surya Mungaran
- modded GMT+7 By Vito H.S
- ganti http://api.midtrans.com dengan bug anda masing2
- jika menggunakan opok Telkomsel silahkan tambahkan :443 dibelakang bug
- (contoh :     # Sync Jam otomatis berdasarkan bug isp by AlkhaNET
    curl -i http://api.midtrans.com:443 | grep Date > /root/date )
- pastekan command dibawah untuk menginstall script ini

wget --no-check-certificate "https://raw.githubusercontent.com/vitoharhari/sync-date-openwrt-with-bug/main/jam.sh" -O /usr/bin/jam.sh && chmod +x /usr/bin/jam.sh

- masukkan command dibawah ke Luci, di system>startup>local startup,atau di rc.local jika di terminal

/usr/bin/jam.sh

- perhatian! Jika bug/domain diganti dengan IP web ui modem lokal maka jam akan terlalu cepat 7 jam dikarenakan settingan ini mengikuti web domain menggunakan acuan waktu GMT +0
- terimakasih 
