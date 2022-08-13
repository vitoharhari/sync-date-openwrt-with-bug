## Sync Date OpenWrt with Domain Bug
- Sync date openwrt by picking date from selected domain.
- Sinkronisasi waktu pada OpenWrt dengan mengambil data waktu dari domain terpilih.
- Support sinkronisasi setelah modem siap atau koneksi internet tersedia.
- Support autorestart VPN tunnels:
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
    /usr/bin/jam.sh api.midtrans.com
    ```
- Ganti **``api.midtrans.com``** dengan bug/domain kesayangan anda.
- Jika menggunakan 0p0k Telkomsel silahkan tambahkan ``:443`` dibelakang bug.
    
    Contoh: **``/usr/bin/jam.sh api.midtrans.com:443``**
    
- Perhatian! Jika **``bug/domain``** diganti dengan **``IP WebUI modem lokal``**, maka jam akan terlalu cepat 7 jam. Dikarenakan pengaturan ini mengikuti **``web/domain``** menggunakan acuan waktu **``GMT +0``**
- jika lokasi anda bukan **``GMT +7``** maka silahkan edit file **``jam.sh``** nya dengan mengganti di bagian **``var2=ganti disini``* contoh : **``var2=08``**
- Terimakasih 

### How This Script Work - Cara Kerja Script Ini
- Setelah script dimasukkan ke **``Local Startup``** atau di **``rc.local``** dengan menambahkan domain/bug/URL (maupun port)
- Device OpenWrt restart, lalu script memeriksa koneksi internet terlebih dahulu.
- Jika internet belum tersedia, script akan melakukan pengulangan pemeriksaan koneksi sampai koneksi terhubung.
- Setelah koneksi terhubung, script akan melakukan sinkronisasi waktu terlebih dahulu, lalu merestart aplikasi VPN yang digunakan.

### Developer - Pengembang
- Base script from AlkhaNet by Teguh Surya Mungaran
- Added GMT+7 by Vito H.S
- Add more advancement codes by [Helmi Amirudin](https://helmiau.com)
