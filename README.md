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
- Perhatian! Pahami dan baca secara cermat instrukski dibawah ini !!!

- Ganti **``api.midtrans.com``** dengan bug/domain kesayangan anda.
- Jika menggunakan 0p0k Telkomsel silahkan tambahkan ``:443`` dibelakang bug.
    
    Contoh: **``/usr/bin/jam.sh api.midtrans.com:443``**

- Script ini menggunakan default GMT+7. jika di lokasi anda berada berbeda, maka silahkan tambahkan ```+9``` (setelah penulisan domain/bug) sesuaikan dengan zona waktu masing-masing. 
    
    Contoh: ```/usr/bin/jam.sh bug.com +9```  atau ```/usr/bin/jam.sh bug.com -7```    
- jika anda ingin menggunakan modem sebagai acuan utama untuk sinkronisasi openwrt,maka hal yang harus diperhatikan adalah :
    1. Isikan IP web UI Modem anda dengan menyertakan +0
    Contoh : **``/usr/bin/jam.sh 192.168.1.1 +0``**

     (Penjelasan : karena kebanyakan waktu yang tertera di web UI MODEM lokal default nya sudah GMT+7 ,maka kita harus memberi settingan +0 dibelakang bug agar waktu +7 tidak ditambahkan lagi kedalam settingan waktu openwrt kita)
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
