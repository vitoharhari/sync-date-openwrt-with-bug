## Sync Date OpenWrt with Domain Bug
- Sync date openwrt by picking date from selected domain.
- Sinkronisasi waktu pada OpenWrt dengan mengambil data waktu dari domain terpilih.
- Mendukung sinkronisasi waktu setelah modem/koneksi internet tersedia.
- Pemeriksa koneksi (jika menggunakan mode **``cron``**, maka script akan memeriksa koneksi, lalu merestart aplikasi VPN jika koneksi internet tidak tersedia)
- Pengaturan timezone (zona waktu) secara otomatis mengikuti pengaturan **``LuCI - System - System - Timezone``**.
- Mendukung autorestart VPN tunnels:
    - OpenClash
    - Passwall
    - ShadowsocksR
    - ShadowsocksR++
    - v2ray
    - v2rayA
    - xray
    - Libernet
    - Xderm Mini
    - Wegare STL

### Default Usage - Pemakaian Dasar
- Install **``paket yang dibutuhkan``** terlebih dahulu dengan membuka terminal/putty/dsb:

    ```
    opkg update && opkg install curl wget
    ```

- Paste command dibawah untuk memasang script ``jam.sh``
    
    Menggunakan **`wget`**
    ```
    wget --no-check-certificate "https://raw.githubusercontent.com/vitoharhari/sync-date-openwrt-with-bug/main/jam.sh" -O /usr/bin/jam.sh && chmod +x /usr/bin/jam.sh
    ```
    Menggunakan **`curl`**
    ```
    curl -sL raw.githubusercontent.com/vitoharhari/sync-date-openwrt-with-bug/main/jam.sh > /usr/bin/jam.sh && chmod +x /usr/bin/jam.sh
    ```
- Masukkan command dibawah ke **``LuCI -> System -> Startup -> Local Startup``** atau di **``rc.local``** jika di terminal

    ```
    /usr/bin/jam.sh www.site.com 
    ```

- Jika menggunakan crontab ( cek koneksi setiap 1 jam, lalu me-restart vpn jika koneksi tidak tersedia ), salin perintah dibawah ini ke **``LuCI -> System -> Schedule Tasks``** Contoh:

    ```
    0 * * * * /usr/bin/jam.sh www.site.com cron
    ```

    - Perintah diatas juga dapat dimasukkan ke file **``/etc/crontabs/root``**
    - Untuk kustomisasi waktu cron lainnya dapat dilihat di [crontab.guru](https://crontab.guru/#0_*_*_*_*)
    
### Advanced Usage - Pemakaian Lanjutan

- Ganti **``www.site.com ``** dengan **``bug/domain``** kesayangan anda. Contoh:

    ```
    /usr/bin/jam.sh m.youtu.be
    ```

- Jika menggunakan **``0p0k Telkomsel``** silahkan tambahkan **``:443``** dibelakang bug. Contoh:

    ```
    /usr/bin/jam.sh www.site.com:443
    ```

- Jika ingin melakukan **``update/pembaruan script``**, silahkan lakukan perintah dibawah ini.

    ```
    /usr/bin/jam.sh update
    ```
    Tanda update berhasil adalah seperti ini:
    ```
    jam.sh: Updating script...
    jam.sh: Downloading script update...
    jam.sh: Update done...
    jam.sh: update file cleaned up!
    Usage: add domain/bug after script!.
    jam.sh: Missing URL/Bug/Domain!. Read https://github.com/vitoharhari/sync-date-openwrt-with-bug/blob/main/README.md for details.
    ```

### How This Script Work - Cara Kerja Script Ini
- Setelah script dimasukkan ke **``Local Startup``** atau di **``rc.local``** dengan menambahkan domain/bug/URL (maupun port)
- Device OpenWrt restart, lalu script **``memeriksa koneksi internet``** terlebih dahulu.
- Jika internet belum tersedia, script akan **``mengulangi pemeriksaan koneksi sampai koneksi terhubung``**.
- Ketika koneksi sudah terhubung, script akan **``melakukan sinkronisasi waktu``**.
- Jika ada **``aplikasi VPN/Tunneling yang berjalan``**, script akan **``merestart aplikasi VPN yang digunakan``** sebelum melakukan sinkronisasi waktu.

### Developer - Pengembang
- Base script and more enhancement codes from AlkhaNet by [Teguh Surya Mungaran](https://github.com/alkhanet26)
- GMT codes and more enhancement codes by [Vito H.S](https://github.com/vitoharhari)
- opkg checker and installer, internet checker, vpn manager, gmt selection codes by [Helmi Amirudin](https://helmiau.com)
