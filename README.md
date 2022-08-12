## Sync Date OpenWrt with Domain Bug
Sync date openwrt by picking date from selected domain

Sinkronisasi waktu pada OpenWrt dengan mengambil data dari domain terpilih

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
    
- Perhatian! Jika bug/domain diganti dengan IP WebUI modem lokal, maka jam akan terlalu cepat 7 jam. Dikarenakan pengaturan ini mengikuti web/domain menggunakan acuan waktu GMT +0
- Terimakasih 

### Developer - Pengembang
- Base script from AlkhaNet by Teguh Surya Mungaran
- Added GMT+7 by Vito H.S
- Add more advancement codes by [Helmi Amirudin](https://helmiau.com)
