# Dummy Dataset
Dummy dataset adalah kumpulan data yang dibuat secara artifisial sebagai pengganti data asli secara khusus dalam kasus ini untuk mengisi data-data pada setiap tabel di database.

Beberapa hal mengapa kita perlu membuat dummy dataset adalah
- Tidak adanya data asli
- Menyalin data langsung dari production tidak dimungkinkan untuk pengujian agar menjaga kerahasiaan data atau tidak mengganggu performa di production

Dalam membuat dataset kita bisa membuat data buatan secara random, random proporsional, maupun random mengikuti beberapa distribusi data. Kita juga bisa mengotomasisasi proses pembuatan data artifisial dengan menggunakan bahasa pemrograman python. Di Python kita bisa membuat rule sendiri bagaimana kita membuat data buatan yang random secara manual, ataupun menggunakan bantuan library seperti Fake

## Detail mengenai data random di setiap tabel

### 1. Tabel `city` dan `product_detail`
- Disini datanya sudah disediakan sebelumnya. Jadi tidak perlu melakukan proses pembuatan pada kedua tabel

### 2. `seller`
Kolom:
- `seller_id` diambil totalnya 150 dan diisi datanya secara incremental dari 1 sampai 150
- `seller_name` : Data buatannya dibuat dengan menggunakan library fake dengan `method` mencari nama
- `seller_contact` : Menggenerate secara random dengan nomor hp berjumlah 12 dengan awalan `08`
- `city_id`  : Data digenerate secara random dengan proporsi random setiap `city_id` tidaklah merata melainkan proporsinya juga random

### 3. `buyer`
- `buyer_id` diambil totalnya 150 dan diisi datanya secara incremental dari 1 sampai 150
- `buyer_name` : Data buatannya dibuat dengan menggunakan library fake dengan `method` mencari nama
- `buyer_contact` : Menggenerate secara random dengan nomor hp berjumlah 12 dengan awalan `08`
- `city_id`  : Data digenerate secara random dengan proporsi tidaklah merata melainkan random setiap `city_id` 

### 4. `product`
- `product_id` diambil totalnya 1500 dan diisi datanya secara incremental dari 1 sampai 1500
- `product_detail_id` Data digenerate secara random dengan proporsi tidaklah merata melainkan random setiap `product_detail_id` 
- `buyer_name` : Data digenerate secara random dengan proporsi tidaklah merata melainkan random setiap `buyer_id`
- `seller_id` :Data digenerate secara random dengan proporsi tidaklah merata melainkan random setiap `seller_id`
- `title`  : Digenerate dengan random judul iklan yang menyesuaikan nama mobil.
- `date_post`  : Data digenerate secara random  dari tanggal 2022/02/25 sampai 2023/02/25

### 5. `bid`
- `bid_id` diambil totalnya 1500 dan diisi datanya secara incremental dari 1 sampai 1500
- `product_id` Data digenerate secara random dengan proporsi tidaklah merata melainkan random setiap `product_id` 
- `buyer_name` : Data digenerate secara random dengan proporsi tidaklah merata melainkan random setiap `buyer_id`
- `date_bid` : Digenerate dengan mengambil tanggal beberapa hari random setelah tanngal `date_post`
- `bid_price`  : Digenerate dengan menjumlahkan jumlah hari random setelah tanngal `date_post` 
- `bid_status`  : Data digenerate secara random dengan proporsi tidaklah merata melainkan random setiap `['Sent', 'Declined']`
 
