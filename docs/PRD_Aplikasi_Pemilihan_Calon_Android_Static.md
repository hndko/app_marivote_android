# Product Requirements Document (PRD)

## Aplikasi Pemilihan Calon -- Android (Static Prototype)

**Versi:** 1.0\
**Tanggal:** 19 November 2026\
**Platform:** Android\
**Jenis aplikasi:** Static prototype / simulasi pemilihan\
**Bahasa antarmuka:** Bahasa Indonesia

------------------------------------------------------------------------

## 1. Ringkasan Produk

Aplikasi Android sederhana untuk menampilkan dua calon dalam satu
halaman dan memungkinkan pengguna memilih salah satu calon. Setiap calon
ditampilkan menggunakan foto, nama, dan nomor urut. Nomor urut dibuat
secara acak dari data lokal untuk kebutuhan simulasi.

Saat pengguna menekan tombol **Pilih**, aplikasi menampilkan dialog
konfirmasi. Jika pengguna memilih **Ya, Pilih**, aplikasi menampilkan
konfirmasi pilihan dan menyediakan bukti pilihan dalam bentuk gambar
yang dapat diunduh/disimpan ke perangkat.

Aplikasi dibuat **secara statis**: tidak membutuhkan backend, API,
database server, autentikasi, atau proses pengiriman suara ke server.
Seluruh data calon dan proses simulasi berjalan di perangkat.

## 2. Tujuan

1.  Menyediakan tampilan pemilihan dua calon yang sederhana dan mudah
    digunakan.
2.  Memungkinkan pengguna memilih satu calon.
3.  Memastikan pilihan dikonfirmasi sebelum diproses.
4.  Menghasilkan bukti pilihan berupa gambar yang menampilkan calon
    terpilih.
5.  Menyediakan opsi untuk menyimpan/mengunduh bukti tersebut ke
    perangkat Android.

## 3. Batasan dan Asumsi

### 3.1 Termasuk dalam MVP

-   Satu halaman utama berisi dua kartu calon.
-   Foto, nama, dan nomor urut untuk masing-masing calon.
-   Nomor urut acak dari dua nomor unik, yaitu 1 dan 2.
-   Tombol **Pilih** pada masing-masing calon.
-   Dialog konfirmasi sebelum pilihan ditetapkan.
-   Halaman/dialog hasil pilihan.
-   Pembuatan bukti pilihan dalam format gambar.
-   Tombol **Unduh Bukti** dan opsi **Bagikan Bukti** (opsional).
-   Penanganan izin dan penyimpanan file Android sesuai versi OS.

### 3.2 Tidak termasuk dalam MVP

-   Backend, REST API, dan database online.
-   Login, registrasi, atau verifikasi identitas.
-   Penghitungan suara dan dashboard hasil.
-   Sinkronisasi antarperangkat.
-   Pencegahan pemilihan ganda secara terpusat.
-   Enkripsi atau tanda tangan digital bukti.
-   Klaim bahwa bukti gambar merupakan bukti pemungutan suara yang sah
    atau tervalidasi.

> **Catatan penting:** Karena aplikasi ini statis dan seluruh proses
> berjalan di perangkat, aplikasi hanya cocok untuk demo, simulasi, atau
> prototype UI. Aplikasi tidak boleh diposisikan sebagai sistem
> pemilihan resmi yang membutuhkan integritas, kerahasiaan, audit, dan
> verifikasi suara.

## 4. Target Pengguna

-   Pengguna Android yang akan mencoba simulasi pemilihan.
-   Tim/pemilik produk yang membutuhkan prototype alur pemilihan dua
    calon.
-   Penguji aplikasi untuk memvalidasi tampilan dan pengalaman pengguna.

## 5. Alur Penggunaan Utama

1.  Pengguna membuka aplikasi.
2.  Aplikasi menampilkan dua calon dalam urutan nomor yang diacak.
3.  Pengguna melihat foto, nama, dan nomor urut kedua calon.
4.  Pengguna menekan tombol **Pilih** pada salah satu calon.
5.  Aplikasi menampilkan dialog konfirmasi.
6.  Jika pengguna memilih **Kembali**, dialog ditutup dan belum ada
    pilihan yang disimpan.
7.  Jika pengguna memilih **Ya, Pilih**, aplikasi menetapkan calon
    tersebut sebagai pilihan pada sesi/perangkat.
8.  Aplikasi menampilkan status berhasil dan ringkasan calon terpilih.
9.  Aplikasi menyiapkan bukti pilihan dalam bentuk gambar.
10. Pengguna menekan **Unduh Bukti** untuk menyimpan gambar ke
    perangkat.

## 6. Rancangan Konten Antarmuka

### 6.1 Halaman Utama

**Judul halaman:**\
`Pemilihan Calon`

**Subjudul/instruksi:**\
`Silakan pilih satu calon dengan menekan tombol Pilih.`

Setiap kartu calon memuat:

-   Foto calon (rasio disarankan 1:1 atau 4:5).
-   Nomor urut, misalnya `01` atau `02`.
-   Nama calon.
-   Tombol `Pilih`.

Contoh data dummy:

  Data         Calon A                       Calon B
  ------------ ----------------------------- -----------------------------
  Nama         Ahmad Pratama                 Siti Rahmawati
  Nomor urut   Diacak menjadi 01/02          Diacak menjadi 01/02
  Foto         `assets/images/calon_a.png`   `assets/images/calon_b.png`

Nama dan foto di atas hanya contoh. Data final harus dapat diganti
melalui konfigurasi/data lokal aplikasi.

### 6.2 Dialog Konfirmasi

**Judul:**\
`Konfirmasi Pilihan`

**Isi pesan:**\
`Apakah Anda yakin ingin memilih [Nama Calon] dengan nomor urut [Nomor Urut]? Pastikan pilihan Anda sudah benar. Setelah dikonfirmasi, pilihan akan ditetapkan pada aplikasi ini.`

**Tombol:** - `Kembali` --- menutup dialog tanpa menetapkan pilihan. -
`Ya, Pilih` --- menetapkan pilihan dan melanjutkan ke halaman hasil.

### 6.3 Tampilan Berhasil

**Judul:**\
`Pilihan Berhasil Disimpan`

**Pesan:**\
`Terima kasih. Pilihan Anda telah berhasil dicatat pada perangkat ini.`

Tampilkan: - Foto calon terpilih. - Nama calon. - Nomor urut. - Tombol
`Unduh Bukti`. - Tombol `Selesai` atau `Kembali ke Beranda` (sesuai
desain).

**Catatan:** Gunakan istilah "dicatat pada perangkat ini", bukan
"terkirim" atau "terdaftar di server", karena tidak ada backend.

### 6.4 Desain Bukti Pilihan

Bukti dibuat sebagai file gambar PNG atau JPEG dengan ukuran yang nyaman
dibaca dan dibagikan.

Konten minimal gambar bukti:

-   Judul: `BUKTI PILIHAN`
-   Keterangan: `Simulasi Pemilihan`
-   Foto calon yang dipilih.
-   Nama calon.
-   Nomor urut.
-   Teks: `Pilihan berhasil dicatat pada perangkat ini.`
-   Tanggal dan waktu perangkat saat bukti dibuat.
-   Catatan kecil:
    `Dokumen ini merupakan bukti simulasi dari aplikasi statis.`

Bukti hanya menampilkan calon yang dipilih, bukan kedua calon. Jangan
menambahkan data pribadi pengguna yang tidak diperlukan.

## 7. Kebutuhan Fungsional

  -----------------------------------------------------------------------
  ID                      Kebutuhan               Prioritas
  ----------------------- ----------------------- -----------------------
  FR-01                   Aplikasi menampilkan    Must
                          tepat dua calon pada    
                          halaman utama.          

  FR-02                   Setiap calon            Must
                          menampilkan foto, nama, 
                          nomor urut, dan tombol  
                          Pilih.                  

  FR-03                   Nomor urut calon diacak Must
                          menggunakan data lokal  
                          dan tidak boleh         
                          duplikat.               

  FR-04                   Urutan nomor calon      Must
                          konsisten selama satu   
                          sesi pemilihan.         

  FR-05                   Menekan tombol Pilih    Must
                          membuka dialog          
                          konfirmasi calon yang   
                          sesuai.                 

  FR-06                   Tombol Kembali menutup  Must
                          dialog tanpa menyimpan  
                          pilihan.                

  FR-07                   Tombol Ya, Pilih        Must
                          menetapkan calon        
                          sebagai pilihan.        

  FR-08                   Setelah pilihan         Must
                          ditetapkan, aplikasi    
                          menampilkan ringkasan   
                          calon terpilih.         

  FR-09                   Aplikasi menghasilkan   Must
                          gambar bukti yang hanya 
                          memuat calon terpilih.  

  FR-10                   Tombol Unduh Bukti      Must
                          menyimpan gambar ke     
                          penyimpanan perangkat.  

  FR-11                   Aplikasi menampilkan    Must
                          notifikasi              
                          berhasil/gagal saat     
                          menyimpan bukti.        

  FR-12                   Aplikasi mencegah       Should
                          perubahan pilihan       
                          setelah pilihan         
                          ditetapkan dalam sesi   
                          tersebut.               

  FR-13                   Pengguna dapat          Could
                          membagikan gambar bukti 
                          melalui fitur share     
                          Android.                
  -----------------------------------------------------------------------

## 8. Aturan Bisnis

1.  Hanya tersedia dua calon.
2.  Setiap calon harus memiliki ID lokal, nama, dan file foto yang
    valid.
3.  Nomor urut hanya menggunakan angka 1 dan 2; masing-masing diberikan
    satu kali.
4.  Pengacakan dilakukan saat sesi pemilihan dimulai. Nomor tidak
    berubah ketika pengguna membuka dialog atau kembali dari dialog.
5.  Pengguna hanya dapat menetapkan satu pilihan dalam satu sesi.
6.  Pilihan baru dianggap ditetapkan setelah pengguna menekan
    `Ya, Pilih`.
7.  Menekan `Kembali` atau menutup dialog tidak boleh mengubah status
    pilihan.
8.  Bukti dibuat berdasarkan data calon yang benar-benar dipilih.
9.  Jika proses pembuatan atau penyimpanan gambar gagal, pilihan tidak
    boleh berubah menjadi calon lain. Pengguna dapat mencoba mengunduh
    kembali.
10. Karena tidak ada backend, status pilihan hanya berlaku secara lokal
    dan tidak dapat diverifikasi oleh penyelenggara.

## 9. Kebutuhan Non-Fungsional

-   **Kompatibilitas:** Mendukung Android API 26 (Android 8.0) atau
    lebih baru, kecuali ada keputusan target minimum lain.
-   **Performa:** Halaman utama tampil cepat dan interaksi tombol/dialog
    terasa responsif.
-   **Offline:** Seluruh fitur utama berjalan tanpa koneksi internet.
-   **Privasi:** Tidak meminta nama, NIK, nomor telepon, lokasi, atau
    data pribadi lain.
-   **Penyimpanan:** File bukti disimpan menggunakan mekanisme
    penyimpanan Android yang sesuai versi OS (misalnya MediaStore pada
    Android modern).
-   **Usability:** Tombol mudah disentuh, teks terbaca, dan dialog tidak
    membingungkan.
-   **Stabilitas:** Aplikasi menangani foto yang tidak ditemukan dan
    kegagalan penyimpanan tanpa crash.
-   **Aksesibilitas:** Komponen interaktif memiliki label yang jelas dan
    kontras teks memadai.

## 10. Spesifikasi Teknis

### 10.1 Arsitektur

-   Aplikasi Android native atau Flutter (pilih salah satu sebelum
    implementasi).
-   Data calon disimpan sebagai aset lokal/konfigurasi statis.
-   Tidak ada server, API, atau database eksternal.
-   Pengacakan nomor urut dilakukan di sisi aplikasi.
-   Bukti dibuat dari template lokal menggunakan mekanisme render
    widget/view menjadi bitmap.
-   Penyimpanan bukti memakai API penyimpanan Android yang sesuai versi
    OS.

### 10.2 Contoh Struktur Data Lokal

``` json
[
  {
    "id": "candidate_a",
    "name": "Ahmad Pratama",
    "image": "assets/images/calon_a.png"
  },
  {
    "id": "candidate_b",
    "name": "Siti Rahmawati",
    "image": "assets/images/calon_b.png"
  }
]
```

Nomor urut tidak perlu ditulis permanen pada data calon. Aplikasi
mengacak pemetaan nomor 1 dan 2 saat sesi dimulai.

### 10.3 Format File Bukti

-   Format utama: PNG.
-   Nama file: `bukti-pilihan-YYYYMMDD-HHmmss.png`.
-   Isi gambar: identitas calon terpilih dan informasi simulasi.
-   Lokasi simpan: galeri/folder Pictures aplikasi melalui mekanisme
    Android yang sesuai.
-   Aplikasi harus memberi umpan balik jika penyimpanan berhasil atau
    gagal.

## 11. Struktur Halaman

  -----------------------------------------------------------------------
  Halaman/Komponen                    Fungsi
  ----------------------------------- -----------------------------------
  Splash Screen (opsional)            Identitas aplikasi saat dibuka.

  Halaman Pemilihan                   Menampilkan dua calon dan tombol
                                      Pilih.

  Dialog Konfirmasi                   Memastikan pengguna benar-benar
                                      memilih calon tersebut.

  Halaman Hasil                       Menampilkan calon terpilih dan opsi
                                      unduh bukti.

  Template Bukti                      Tampilan gambar yang akan disimpan
                                      ke perangkat.
  -----------------------------------------------------------------------

## 12. Acceptance Criteria

Implementasi dinyatakan memenuhi kebutuhan apabila:

-   [ ] Halaman utama menampilkan tepat dua calon.
-   [ ] Foto dan nama masing-masing calon tampil dengan benar.
-   [ ] Nomor urut 1 dan 2 diberikan secara acak tanpa duplikasi.
-   [ ] Nomor urut tidak berubah ketika dialog dibuka dan ditutup.
-   [ ] Tombol Pilih pada calon pertama menampilkan nama/nomor calon
    pertama di dialog.
-   [ ] Tombol Pilih pada calon kedua menampilkan nama/nomor calon kedua
    di dialog.
-   [ ] Menekan Kembali tidak menetapkan pilihan.
-   [ ] Menekan Ya, Pilih menetapkan calon yang benar.
-   [ ] Halaman hasil menampilkan calon yang telah dipilih.
-   [ ] Gambar bukti menampilkan foto, nama, dan nomor urut calon
    terpilih.
-   [ ] Gambar bukti tidak menampilkan calon yang tidak dipilih.
-   [ ] Tombol Unduh Bukti menghasilkan file gambar yang dapat dibuka
    dari perangkat.
-   [ ] Pesan keberhasilan atau kegagalan penyimpanan tampil dengan
    benar.
-   [ ] Seluruh alur utama dapat digunakan tanpa koneksi internet.
-   [ ] Aplikasi tidak crash saat aset foto tidak ditemukan atau
    penyimpanan gagal.

## 13. Skenario Pengujian

  -----------------------------------------------------------------------
  ID                      Skenario                Hasil yang Diharapkan
  ----------------------- ----------------------- -----------------------
  TC-01                   Membuka aplikasi        Dua kartu calon tampil.

  TC-02                   Memulai sesi beberapa   Nomor urut dapat
                          kali                    berubah secara acak
                                                  antar sesi, tetapi
                                                  selalu unik dalam satu
                                                  sesi.

  TC-03                   Menekan Pilih pada      Dialog menampilkan data
                          calon A                 calon A.

  TC-04                   Menekan Kembali         Dialog tertutup dan
                                                  belum ada pilihan.

  TC-05                   Menekan Ya, Pilih       Calon A ditetapkan dan
                                                  halaman hasil tampil.

  TC-06                   Mengunduh bukti         File gambar calon A
                                                  tersimpan dan dapat
                                                  dibuka.

  TC-07                   Memilih calon B         Seluruh informasi hasil
                                                  dan bukti mengacu pada
                                                  calon B.

  TC-08                   Penyimpanan             Pesan gagal tampil dan
                          ditolak/gagal           pengguna dapat mencoba
                                                  lagi.

  TC-09                   Mode pesawat            Alur pemilihan dan
                                                  pembuatan bukti tetap
                                                  berjalan.

  TC-10                   Mencoba memilih lagi    Pilihan tidak berubah
                          setelah pilihan         dalam sesi tersebut.
                          ditetapkan              
  -----------------------------------------------------------------------

## 14. Rencana Pengerjaan

### Phase 1 --- Persiapan dan Data Lokal

-   Menyiapkan project Android.
-   Menyiapkan aset foto dan data dua calon.
-   Membuat mekanisme pengacakan nomor urut.
-   Memastikan nomor urut stabil selama sesi.

**Gate:** Data calon dan pengacakan lolos pengujian.

### Phase 2 --- UI Pemilihan

-   Membuat halaman utama.
-   Membuat kartu calon.
-   Membuat tombol Pilih.
-   Membuat dialog konfirmasi.

**Gate:** Tampilan dan alur batal/konfirmasi lolos pengujian manual.

### Phase 3 --- Hasil dan Bukti

-   Membuat tampilan hasil pilihan.
-   Membuat template bukti gambar.
-   Menghasilkan file PNG.
-   Mengimplementasikan tombol Unduh Bukti.

**Gate:** File bukti sesuai calon yang dipilih dan dapat dibuka.

### Phase 4 --- Pengujian dan Build

-   Automated test untuk pengacakan, pemilihan, dan pembuatan bukti.
-   Manual test pada perangkat/emulator Android.
-   Uji penyimpanan pada versi Android target.
-   Build APK release dan pemeriksaan akhir.

**Gate:** Semua acceptance criteria wajib terpenuhi sebelum aplikasi
dinyatakan selesai.

## 15. Ketentuan untuk Developer / AI Agent

1.  PRD ini menjadi acuan utama implementasi.
2.  Jangan menambahkan backend, login, API, database online, atau fitur
    di luar ruang lingkup tanpa persetujuan.
3.  Sebelum memulai setiap phase, tampilkan daftar file yang akan dibuat
    atau diubah.
4.  Kerjakan phase secara berurutan dan jangan lanjut sebelum gate phase
    sebelumnya lolos.
5.  Setiap phase wajib menjalankan automated test dan manual test yang
    relevan.
6.  Laporkan hasil pengujian, error, dan perubahan file sebelum meminta
    persetujuan melanjutkan.
7.  Gunakan data dummy lokal yang mudah diganti.
8.  Pastikan tidak ada klaim bahwa pilihan telah dikirim ke server atau
    tercatat secara resmi.
9.  Buat UI modern, sederhana, responsif, dan fokus pada proses
    pemilihan.
10. Jangan mengubah kebutuhan atau aturan bisnis dalam PRD tanpa
    persetujuan.

## 16. Informasi yang Perlu Disiapkan Sebelum Implementasi

-   Nama aplikasi.
-   Nama resmi kedua calon.
-   Foto calon A dan calon B.
-   Logo/identitas penyelenggara (jika diperlukan).
-   Pilihan teknologi: Flutter atau Android Native.
-   Apakah pilihan perlu dikunci hanya selama aplikasi berjalan atau
    tetap terkunci setelah aplikasi ditutup dan dibuka kembali.

------------------------------------------------------------------------

**Akhir PRD --- Aplikasi Pemilihan Calon Android (Static Prototype)**
