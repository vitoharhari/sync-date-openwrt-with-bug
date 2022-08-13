## Sync Date OpenWrt with Domain Bug
- Sync date openwrt by picking date from selected domain.
- Sinkronisasi waktu pada OpenWrt dengan mengambil data waktu dari domain terpilih.
- Mendukung sinkronisasi waktu setelah modem/koneksi internet tersedia.
- Mendukung pemilihan GMT secara manual.
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

### Usage - Pemakaian
- Paste command dibawah untuk memasang script ``jam.sh``

    ```
    wget --no-check-certificate "https://raw.githubusercontent.com/vitoharhari/sync-date-openwrt-with-bug/main/jam.sh" -O /usr/bin/jam.sh && chmod +x /usr/bin/jam.sh
    ```
- Masukkan command dibawah ke **``LuCI -> System -> Startup -> Local Startup``** atau di **``rc.local``** jika di terminal

    ```
    /usr/bin/jam.sh www.site.com 
    ```

### Perhatian! Pahami dan baca secara cermat instrukski dibawah ini !!!

- Ganti **``www.site.com ``** dengan bug/domain kesayangan anda. Contoh:

    ```
    /usr/bin/jam.sh m.youtu.be
    ```
- Jika menggunakan 0p0k Telkomsel silahkan tambahkan ``:443`` dibelakang bug. Contoh:

    ```
    /usr/bin/jam.sh www.site.com:443
    ```
    
- Script ini menggunakan GMT+7 sebagai setelan bawaan. Jika lokasi anda berbeda, tambahkan ```+9``` (setelah penulisan domain/bug) dengan menyesuaikan zona waktu tempat anda. Contoh:
    
    ```
    /usr/bin/jam.sh www.site.com +8
    ```
    Anda juga bisa menggabungkan fungsi port seperti pada contoh 0p0k telkomsel. Contoh:
    ```
    /usr/bin/jam.sh www.site.com:443 +8
    ```

- Jika ingin melakukan update/pembaruan script, silahkan lakukan perintah dibawah ini.

    ```
    /usr/bin/jam.sh update
    ```

- Jika anda menggunakan modem sebagai acuan sinkronisasi waktu, lakukan langkah berikut:
    
    Isikan IP WebUI modem, contoh menggunakan ``192.168.8.1`` dengan menyertakan ```+0```. Contoh:
    ```
    /usr/bin/jam.sh 192.168.8.1 +0
    ```
    Penjelasan: Rata-rata setelan waktu bawaan modem menggunakan GMT+7, maka kita harus menambahkan ```+0``` dibelakang bug/domain agar waktu +7 tidak ditambahkan ke pengaturan waktu OpenWrt.

### How This Script Work - Cara Kerja Script Ini
- Setelah script dimasukkan ke **``Local Startup``** atau di **``rc.local``** dengan menambahkan domain/bug/URL (maupun port)
- Device OpenWrt restart, lalu script memeriksa koneksi internet terlebih dahulu.
- Jika internet belum tersedia, script akan melakukan pengulangan pemeriksaan koneksi sampai koneksi terhubung.
- Setelah koneksi terhubung, script akan melakukan sinkronisasi waktu terlebih dahulu, lalu merestart aplikasi VPN yang digunakan.

### Developer - Pengembang
- Base script from AlkhaNet by Teguh Surya Mungaran
- Added GMT+7 by Vito H.S
- Add more advancement codes by [Helmi Amirudin](https://helmiau.com)
