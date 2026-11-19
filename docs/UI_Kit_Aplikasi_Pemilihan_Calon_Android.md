# UI Kit --- Aplikasi Pemilihan Calon Android

## Static Prototype

**Versi:** 1.0\
**Tanggal:** 19 November 2026\
**Platform:** Android\
**Jenis aplikasi:** Static prototype / simulasi pemilihan\
**Bahasa:** Indonesia\
**Acuan:** PRD Aplikasi Pemilihan Calon Android (Static)

------------------------------------------------------------------------

## 1. Tujuan UI Kit

Dokumen ini menjadi panduan visual dan spesifikasi antarmuka untuk
aplikasi pemilihan dua calon. UI harus terasa sederhana, terpercaya,
netral, mudah dipahami, dan berfokus pada satu tugas utama: memilih satu
calon lalu mengunduh bukti pilihan.

Aplikasi bersifat statis dan berjalan secara lokal. Desain tidak boleh
memberi kesan bahwa pilihan dikirim ke server atau telah divalidasi oleh
penyelenggara.

## 2. Prinsip Desain

1.  **Netral:** Kedua calon mendapatkan ruang, ukuran, dan penekanan
    visual yang setara.
2.  **Jelas:** Nama, foto, dan nomor urut mudah dibaca.
3.  **Minim langkah:** Pengguna dapat menyelesaikan pemilihan dalam alur
    singkat.
4.  **Konfirmasi eksplisit:** Pilihan tidak ditetapkan sebelum pengguna
    menekan tombol konfirmasi.
5.  **Feedback langsung:** Setiap tindakan memiliki respons visual yang
    jelas.
6.  **Mobile-first:** Layout dirancang untuk layar ponsel Android,
    termasuk layar kecil.
7.  **Aksesibel:** Kontras, ukuran teks, dan area sentuh memenuhi
    praktik aksesibilitas dasar.

## 3. Arah Visual

**Konsep:** Modern, clean, civic, friendly.

-   Latar belakang abu-abu sangat muda.
-   Permukaan kartu putih dengan border tipis.
-   Warna utama biru tua/biru royal untuk tindakan utama.
-   Warna hijau hanya untuk status berhasil.
-   Warna merah tidak digunakan untuk membedakan atau mempromosikan
    calon.
-   Hindari dekorasi berlebihan, animasi panjang, atau elemen yang
    menyerupai kampanye calon.

### 3.1 Palet Warna

  Token              Hex         Penggunaan
  ------------------ ----------- -----------------------------
  `primary`          `#2457C5`   Tombol utama, fokus, tautan
  `primaryPressed`   `#19449F`   State tombol ditekan
  `primarySoft`      `#EAF0FF`   Latar badge/aksen lembut
  `background`       `#F5F7FB`   Latar halaman
  `surface`          `#FFFFFF`   Kartu, dialog, bottom sheet
  `textPrimary`      `#172033`   Judul dan teks utama
  `textSecondary`    `#667085`   Deskripsi dan metadata
  `border`           `#E4E7EC`   Garis pembatas
  `success`          `#16834A`   Status berhasil
  `successSoft`      `#EAF7EF`   Latar status berhasil
  `warning`          `#A15C07`   Peringatan
  `warningSoft`      `#FFF4DF`   Latar peringatan
  `danger`           `#C43232`   Error
  `dangerSoft`       `#FDECEC`   Latar error
  `disabled`         `#AAB2C0`   Komponen nonaktif

Pastikan teks normal memiliki kontras yang memadai terhadap latar.
Jangan menggunakan warna sebagai satu-satunya pembeda status; sertakan
label atau ikon.

### 3.2 Tipografi

Gunakan **Roboto** sebagai font utama (font bawaan Android).

  Style                Ukuran Weight     Penggunaan
  ------------------ -------- ---------- ----------------------------------
  Display               28 sp Bold       Judul hasil/hero bila diperlukan
  H1                    24 sp Bold       Judul halaman
  H2                    20 sp SemiBold   Judul bagian
  H3                    16 sp SemiBold   Nama calon/kartu
  Body                  14 sp Regular    Deskripsi dan isi
  Body Small            12 sp Regular    Catatan dan metadata
  Button                14 sp SemiBold   Label tombol
  Candidate Number      22 sp Bold       Nomor urut calon

Gunakan tinggi baris sekitar 1,3--1,5 kali ukuran font untuk teks
paragraf. Jangan mengecilkan teks penting di bawah 12 sp.

### 3.3 Spacing

Gunakan sistem kelipatan 4 dp.

  Token         Nilai
  ----------- -------
  `space1`       4 dp
  `space2`       8 dp
  `space3`      12 dp
  `space4`      16 dp
  `space5`      20 dp
  `space6`      24 dp
  `space8`      32 dp
  `space10`     40 dp
  `space12`     48 dp

Rekomendasi: - Padding horizontal halaman: 20 dp (minimum 16 dp pada
layar kecil). - Jarak antarkartu: 16 dp. - Padding dalam kartu: 16 dp. -
Jarak judul ke deskripsi: 8 dp. - Jarak antarkomponen form/tindakan:
12--16 dp.

### 3.4 Radius, Border, dan Elevation

  Token                   Nilai Penggunaan
  ------------------- --------- ---------------------
  `radiusSmall`            8 dp Badge, elemen kecil
  `radiusMedium`          12 dp Tombol, input
  `radiusLarge`           16 dp Kartu calon
  `radiusXLarge`          20 dp Dialog/lembar hasil
  `radiusFull`           999 dp Chip/pill
  `borderWidth`            1 dp Border default
  `elevationCard`       1--2 dp Kartu
  `elevationDialog`        8 dp Dialog

Gunakan shadow halus. Border harus tetap terlihat pada layar dengan
brightness rendah.

## 4. Grid dan Responsivitas

### 4.1 Layout Utama

-   Gunakan `SafeArea`.
-   Konten dapat di-scroll secara vertikal pada layar pendek.
-   Dua kartu calon disusun vertikal pada ponsel portrait.
-   Jangan memaksakan dua kolom jika lebar layar tidak cukup.
-   Pada tablet atau layar lebar, dua kartu boleh ditampilkan
    berdampingan dengan lebar yang sama.
-   Tombol utama memiliki lebar penuh di dalam kartu.

### 4.2 Ukuran Acuan

  Elemen                   Spesifikasi
  ------------------------ ----------------------------------
  Minimum target sentuh    48 × 48 dp
  Tinggi tombol utama      48--52 dp
  Tinggi tombol sekunder   44--48 dp
  Padding layar            16--20 dp
  Jarak antarkartu         16 dp
  Foto calon               Rasio 4:5 atau 1:1
  Lebar dialog             Maksimum sekitar 90% lebar layar

## 5. Komponen Reusable

### 5.1 Primary Button

**Tujuan:** Tindakan utama, seperti memilih atau mengunduh bukti.

Spesifikasi: - Tinggi: 48--52 dp. - Radius: 12 dp. - Background:
`primary`. - Teks: putih, 14 sp, SemiBold. - Lebar: penuh mengikuti
parent. - Disabled: gunakan `disabled` dan teks dengan kontras yang
masih terbaca.

Variasi: - Default: `Pilih` - Loading: `Memproses...` - Download: ikon
download + `Unduh Bukti` - Confirm: `Ya, Pilih`

### 5.2 Secondary Button

**Tujuan:** Aksi alternatif seperti membatalkan dialog.

Spesifikasi: - Tinggi: 48 dp. - Background: putih. - Border: `border`. -
Teks: `textPrimary`. - Radius: 12 dp.

Contoh label: `Kembali`, `Tutup`.

### 5.3 Candidate Card

**Struktur komponen:**

1.  Foto calon.
2.  Badge nomor urut.
3.  Nama calon.
4.  Tombol Pilih.

Spesifikasi: - Background putih. - Border 1 dp `border`. - Radius 16
dp. - Padding 16 dp. - Foto memenuhi lebar area kartu dengan rasio 4:5,
menggunakan `cover`. - Badge nomor urut memiliki latar `primarySoft` dan
teks `primary`. - Nama calon maksimal dua baris; jika lebih panjang,
teks boleh membungkus. - Tombol berada di bagian bawah kartu dan
memiliki lebar penuh.

**Penting:** Kedua kartu wajib menggunakan ukuran, tipografi, dan posisi
komponen yang sama. Jangan memberi satu calon warna, ukuran foto, atau
dekorasi yang lebih menonjol.

### 5.4 Candidate Number Badge

-   Bentuk pill atau rounded rectangle.
-   Background `primarySoft`.
-   Teks `primary`, 22 sp Bold.
-   Format nomor: `01` dan `02`.
-   Label aksesibilitas: `Nomor urut 01`.

### 5.5 Confirmation Dialog

-   Lebar maksimum sekitar 90% layar.
-   Background putih.
-   Radius 20 dp.
-   Padding 24 dp.
-   Judul 18 sp SemiBold.
-   Isi 14 sp, warna `textSecondary`.
-   Dua tombol di bagian bawah.

Urutan tombol: - `Kembali` sebagai secondary. - `Ya, Pilih` sebagai
primary.

Dialog tidak boleh tertutup otomatis ketika proses konfirmasi sedang
berjalan. Hindari menampilkan dialog konfirmasi berulang akibat double
tap.

### 5.6 Status Message / Snackbar

  -----------------------------------------------------------------------------------------
  Kondisi                             Pesan
  ----------------------------------- -----------------------------------------------------
  Bukti berhasil disimpan             `Bukti pilihan berhasil disimpan ke perangkat.`

  Gagal menyimpan                     `Bukti belum berhasil disimpan. Silakan coba lagi.`

  Foto tidak tersedia                 `Foto calon tidak dapat dimuat.`

  Pilihan sudah ditetapkan            `Pilihan pada sesi ini sudah ditetapkan.`
  -----------------------------------------------------------------------------------------

Status berhasil menggunakan ikon check dan warna `success`. Error
menggunakan ikon peringatan dan warna `danger`.

### 5.7 Loading State

-   Gunakan progress indicator kecil pada tombol.
-   Nonaktifkan tombol selama proses berjalan.
-   Jangan mengubah label calon atau nomor urut saat loading.
-   Setelah proses selesai, kembalikan tombol ke kondisi normal atau
    pindah ke halaman hasil.

### 5.8 Empty / Error Image State

Jika foto gagal dimuat: - Tampilkan placeholder netral dengan ikon
person. - Pertahankan dimensi foto agar layout tidak bergeser. -
Tampilkan nama calon tetap seperti data lokal. - Jangan mengganti foto
dengan foto calon lain.

## 6. Spesifikasi Halaman

## 6.1 Screen 01 --- Halaman Pemilihan

**Tujuan:** Pengguna melihat dua calon dan memilih salah satunya.

**App bar:** - Judul: `Pemilihan Calon` - Tidak perlu menu tambahan
untuk MVP.

**Header:** - Judul: `Pilih Calon Anda` - Deskripsi:
`Silakan perhatikan informasi calon sebelum menentukan pilihan.`

**Area kartu:** - Dua Candidate Card. - Masing-masing memuat foto, nomor
urut, nama, dan tombol `Pilih`.

**Catatan bawah:**
`Pastikan pilihan Anda sudah benar sebelum menekan tombol konfirmasi.`

**Wireframe:**

``` text
┌──────────────────────────────────┐
│  Pemilihan Calon                 │
├──────────────────────────────────┤
│                                  │
│  Pilih Calon Anda                │
│  Silakan perhatikan informasi    │
│  calon sebelum memilih.          │
│                                  │
│  ┌────────────────────────────┐  │
│  │                            │  │
│  │       FOTO CALON 01        │  │
│  │                            │  │
│  │  [ NOMOR URUT 01 ]         │  │
│  │  Nama Calon Pertama        │  │
│  │  [          PILIH         ]│  │
│  └────────────────────────────┘  │
│                                  │
│  ┌────────────────────────────┐  │
│  │                            │  │
│  │       FOTO CALON 02        │  │
│  │                            │  │
│  │  [ NOMOR URUT 02 ]         │  │
│  │  Nama Calon Kedua          │  │
│  │  [          PILIH         ]│  │
│  └────────────────────────────┘  │
│                                  │
│  Pastikan pilihan Anda benar.   │
└──────────────────────────────────┘
```

## 6.2 Screen 02 --- Dialog Konfirmasi

**Judul:** `Konfirmasi Pilihan`

**Isi:**

`Apakah Anda yakin ingin memilih [Nama Calon] dengan nomor urut [01]? Pastikan pilihan Anda sudah benar. Setelah dikonfirmasi, pilihan akan ditetapkan pada aplikasi ini.`

**Tombol:** - `Kembali` - `Ya, Pilih`

**Wireframe:**

``` text
┌──────────────────────────────────┐
│                                  │
│       (Halaman di belakang)      │
│                                  │
│     ┌──────────────────────┐     │
│     │ Konfirmasi Pilihan   │     │
│     │                      │     │
│     │ Anda akan memilih:   │     │
│     │                      │     │
│     │ Nama Calon           │     │
│     │ Nomor urut 01        │     │
│     │                      │     │
│     │ Apakah Anda yakin    │     │
│     │ dengan pilihan ini?  │     │
│     │                      │     │
│     │ [ Kembali ]          │     │
│     │ [ Ya, Pilih ]        │     │
│     └──────────────────────┘     │
└──────────────────────────────────┘
```

Dialog harus menampilkan calon yang benar-benar dipilih pengguna, bukan
data statis yang selalu sama.

## 6.3 Screen 03 --- Pilihan Berhasil

**Tujuan:** Memberi tahu bahwa pilihan sudah ditetapkan secara lokal dan
menyediakan bukti.

**Konten:** - Ikon check dalam lingkaran. - Judul:
`Pilihan Berhasil Disimpan` - Pesan:
`Terima kasih. Pilihan Anda telah berhasil dicatat pada perangkat ini.` -
Kartu ringkasan calon terpilih. - Tombol utama `Unduh Bukti`. - Tombol
sekunder `Selesai`.

**Wireframe:**

``` text
┌──────────────────────────────────┐
│                                  │
│               ✓                  │
│                                  │
│    Pilihan Berhasil Disimpan     │
│                                  │
│  Pilihan Anda telah berhasil     │
│  dicatat pada perangkat ini.     │
│                                  │
│  ┌────────────────────────────┐  │
│  │       FOTO CALON           │  │
│  │                            │  │
│  │       NOMOR URUT 01        │  │
│  │       Nama Calon           │  │
│  └────────────────────────────┘  │
│                                  │
│  [       Unduh Bukti           ] │
│  [          Selesai            ] │
│                                  │
└──────────────────────────────────┘
```

Jangan menampilkan persentase suara, jumlah suara, atau klaim bahwa
pilihan sudah masuk ke sistem pusat.

## 6.4 Screen 04 --- Status Unduh Bukti

Setelah pengguna menekan `Unduh Bukti`:

**Saat proses:** - Tombol menampilkan spinner. - Label berubah menjadi
`Menyiapkan Bukti...`. - Tombol dinonaktifkan untuk mencegah proses
ganda.

**Jika berhasil:** - Tampilkan snackbar:
`Bukti pilihan berhasil disimpan ke perangkat.` - Tombol dapat berubah
menjadi `Unduh Ulang Bukti`. - File tersedia di lokasi penyimpanan yang
ditentukan aplikasi.

**Jika gagal:** - Tampilkan pesan:
`Bukti belum berhasil disimpan. Silakan coba lagi.` - Tombol kembali
aktif. - Pilihan yang sudah ditetapkan tidak berubah.

## 7. Template Desain Bukti Gambar

Bukti gambar adalah komponen visual yang di-render menjadi PNG/JPEG dan
disimpan ke perangkat.

### 7.1 Ukuran dan Format

-   Orientasi: portrait.
-   Ukuran acuan: 1080 × 1350 px.
-   Format: PNG.
-   Background: `#F5F7FB`.
-   Konten utama berada di kartu putih dengan radius visual yang sesuai.
-   Beri ruang aman minimal 64 px dari tepi gambar.

### 7.2 Susunan Konten

``` text
┌────────────────────────────────────┐
│                                    │
│          BUKTI PILIHAN             │
│         SIMULASI PEMILIHAN         │
│                                    │
│    ┌──────────────────────────┐    │
│    │                          │    │
│    │                          │    │
│    │       FOTO CALON         │    │
│    │                          │    │
│    │                          │    │
│    └──────────────────────────┘    │
│                                    │
│           NOMOR URUT 01            │
│                                    │
│          Nama Calon Terpilih       │
│                                    │
│    Pilihan berhasil dicatat pada   │
│           perangkat ini.          │
│                                    │
│    Tanggal: 19 November 2026       │
│    Waktu: 11:30                    │
│                                    │
│    Dokumen ini merupakan bukti     │
│    simulasi dari aplikasi statis.  │
│                                    │
└────────────────────────────────────┘
```

Tanggal dan waktu harus diambil dari perangkat saat bukti dibuat. Contoh
pada wireframe hanya ilustrasi.

### 7.3 Aturan Isi Bukti

-   Hanya tampilkan foto calon terpilih.
-   Nama dan nomor urut harus sama dengan hasil pilihan.
-   Jangan tampilkan foto calon yang tidak dipilih.
-   Jangan menyertakan NIK, nomor telepon, atau informasi pribadi yang
    tidak diperlukan.
-   Jangan membuat QR code, tanda tangan digital, atau kode verifikasi
    yang memberi kesan validasi server.
-   Sertakan keterangan bahwa dokumen adalah bukti simulasi dari
    aplikasi statis.

### 7.4 Nama File

Format:

`bukti-pilihan-YYYYMMDD-HHmmss.png`

Contoh:

`bukti-pilihan-20261119-113000.png`

## 8. Ikon dan Ilustrasi

Gunakan ikon bergaya outline yang konsisten, misalnya Material Symbols
atau Material Icons.

  Kebutuhan     Ikon yang disarankan
  ------------- ------------------------
  Pemilihan     `how_to_vote`
  Pilih calon   `check_circle_outline`
  Konfirmasi    `help_outline`
  Berhasil      `check_circle`
  Unduh         `download`
  Kembali       `arrow_back`
  Error         `error_outline`
  Foto kosong   `person`

Hindari ikon yang terlalu dekoratif. Ikon harus selalu didampingi teks
untuk tindakan penting.

## 9. Navigasi dan State

Alur navigasi MVP:

``` text
Halaman Pemilihan
       |
       | Tekan "Pilih"
       v
Dialog Konfirmasi
       |
       |-- Kembali ------> Halaman Pemilihan
       |
       |-- Ya, Pilih
              |
              v
       Halaman Hasil
              |
              |-- Unduh Bukti
              |      |
              |      v
              |  Status Unduh
              |
              |-- Selesai
                     |
                     v
             Tetap pada hasil / keluar sesuai keputusan produk
```

### 9.1 State Aplikasi

  State                   Keterangan
  ----------------------- -----------------------------------
  `notSelected`           Belum ada calon dipilih.
  `confirming`            Dialog konfirmasi sedang terbuka.
  `processingSelection`   Konfirmasi sedang diproses.
  `selected`              Calon sudah ditetapkan.
  `generatingProof`       Gambar bukti sedang dibuat.
  `savingProof`           Gambar sedang disimpan.
  `proofSaved`            Bukti berhasil disimpan.
  `proofSaveFailed`       Penyimpanan bukti gagal.

### 9.2 Aturan Transisi

-   `notSelected` → `confirming` saat tombol Pilih ditekan.
-   `confirming` → `notSelected` saat pengguna memilih Kembali.
-   `confirming` → `processingSelection` saat pengguna menekan Ya,
    Pilih.
-   `processingSelection` → `selected` setelah pilihan ditetapkan.
-   `selected` → `generatingProof` saat proses bukti dimulai.
-   `generatingProof` → `savingProof` setelah gambar siap.
-   `savingProof` → `proofSaved` atau `proofSaveFailed`.
-   Dari `proofSaveFailed`, pengguna dapat mencoba menyimpan kembali.
-   Setelah `selected`, pengguna tidak dapat mengganti calon pada sesi
    yang sama.

## 10. Microcopy --- Teks Antarmuka Final

Gunakan teks berikut secara konsisten.

  -----------------------------------------------------------------------
  Lokasi                              Teks
  ----------------------------------- -----------------------------------
  App bar                             Pemilihan Calon

  Judul halaman                       Pilih Calon Anda

  Deskripsi halaman                   Silakan perhatikan informasi calon
                                      sebelum menentukan pilihan.

  Tombol kartu                        Pilih

  Judul dialog                        Konfirmasi Pilihan

  Isi dialog                          Apakah Anda yakin ingin memilih
                                      \[Nama Calon\] dengan nomor urut
                                      \[Nomor\]? Pastikan pilihan Anda
                                      sudah benar. Setelah dikonfirmasi,
                                      pilihan akan ditetapkan pada
                                      aplikasi ini.

  Tombol batal                        Kembali

  Tombol konfirmasi                   Ya, Pilih

  Judul hasil                         Pilihan Berhasil Disimpan

  Pesan hasil                         Terima kasih. Pilihan Anda telah
                                      berhasil dicatat pada perangkat
                                      ini.

  Tombol bukti                        Unduh Bukti

  Tombol selesai                      Selesai

  Unduh berhasil                      Bukti pilihan berhasil disimpan ke
                                      perangkat.

  Unduh gagal                         Bukti belum berhasil disimpan.
                                      Silakan coba lagi.

  Catatan bukti                       Dokumen ini merupakan bukti
                                      simulasi dari aplikasi statis.
  -----------------------------------------------------------------------

## 11. Motion dan Feedback

Animasi harus singkat dan tidak menghambat tugas.

-   Perpindahan halaman: fade atau slide ringan, sekitar 150--250 ms.
-   Dialog: fade + scale ringan, sekitar 150--200 ms.
-   Tombol: feedback pressed state langsung.
-   Status berhasil: ikon check muncul dengan animasi sederhana.
-   Hindari confetti atau animasi perayaan yang berlebihan.

Semua animasi harus menghormati pengaturan sistem Reduce Motion jika
tersedia.

## 12. Aksesibilitas

-   Area sentuh minimum 48 × 48 dp.
-   Kontras teks dan latar harus memadai.
-   Foto calon memiliki content description yang sesuai, misalnya
    `Foto Ahmad Pratama`.
-   Nomor urut dibacakan dengan label yang jelas.
-   Tombol memiliki label aksesibilitas, bukan ikon saja.
-   Urutan fokus mengikuti urutan visual dari atas ke bawah.
-   Informasi keberhasilan dan kegagalan tidak hanya dibedakan dengan
    warna.
-   Layout mendukung ukuran font sistem yang diperbesar.
-   Jangan memotong nama calon tanpa cara untuk membaca nama lengkap.

## 13. Asset dan Struktur Folder

Contoh struktur aset:

``` text
assets/
├── images/
│   ├── calon_a.png
│   ├── calon_b.png
│   ├── app_logo.png
│   └── placeholder_person.png
└── fonts/
    └── (opsional, jika memakai font khusus)
```

Ketentuan aset: - Foto calon memiliki kualitas cukup dan orientasi
konsisten. - Gunakan foto dengan rasio yang sama agar kartu seimbang. -
Foto tidak boleh tertukar antara ID calon. - Logo bersifat opsional. -
Jangan menggunakan foto dummy sebagai foto final tanpa persetujuan
pemilik aplikasi.

## 14. Design Tokens --- Ringkasan untuk Implementasi

``` text
COLORS
primary         #2457C5
primaryPressed  #19449F
primarySoft     #EAF0FF
background      #F5F7FB
surface         #FFFFFF
textPrimary     #172033
textSecondary   #667085
border          #E4E7EC
success         #16834A
successSoft     #EAF7EF
warning         #A15C07
warningSoft     #FFF4DF
danger          #C43232
dangerSoft      #FDECEC
disabled        #AAB2C0

TYPOGRAPHY
fontFamily      Roboto
display         28sp / Bold
h1              24sp / Bold
h2              20sp / SemiBold
h3              16sp / SemiBold
body            14sp / Regular
bodySmall       12sp / Regular
button          14sp / SemiBold
candidateNumber 22sp / Bold

SPACING
4, 8, 12, 16, 20, 24, 32, 40, 48 dp

RADIUS
small           8dp
medium          12dp
large           16dp
xLarge          20dp
full            999dp

COMPONENTS
buttonHeight    48-52dp
touchTarget     min 48x48dp
cardPadding     16dp
screenPadding   16-20dp
cardGap         16dp
```

## 15. Checklist Implementasi UI

-   [ ] Design tokens warna, tipografi, spacing, dan radius dibuat
    terpusat.
-   [ ] Komponen Primary Button dan Secondary Button reusable.
-   [ ] Candidate Card reusable untuk kedua calon.
-   [ ] Nomor urut tampil konsisten dan tidak tertukar.
-   [ ] Dialog konfirmasi menggunakan data calon yang sedang dipilih.
-   [ ] Halaman hasil menampilkan calon terpilih.
-   [ ] State loading, sukses, dan gagal tersedia.
-   [ ] Template bukti gambar sesuai design system.
-   [ ] Layout diuji pada layar kecil dan layar besar.
-   [ ] Area sentuh dan aksesibilitas diperiksa.
-   [ ] Tidak ada elemen yang menyiratkan pilihan dikirim ke server.
-   [ ] Seluruh tampilan tetap berfungsi saat perangkat offline.

## 16. Ketentuan untuk Developer / AI Agent

1.  Gunakan PRD sebagai sumber kebutuhan fungsional dan UI Kit ini
    sebagai sumber standar visual.
2.  Jangan mengubah alur pemilihan atau business rules tanpa
    persetujuan.
3.  Buat komponen reusable; hindari duplikasi UI untuk kedua calon.
4.  Sebelum mengerjakan setiap phase, tampilkan daftar file yang akan
    dibuat atau diubah.
5.  Implementasikan secara bertahap: design tokens dan komponen, halaman
    pemilihan, dialog, halaman hasil, lalu bukti gambar.
6.  Jalankan automated test dan manual test pada setiap phase sebelum
    melanjutkan.
7.  Uji tampilan pada emulator/perangkat Android dengan ukuran layar
    berbeda.
8.  Pastikan bukti gambar selalu menggunakan data calon yang benar-benar
    dipilih.
9.  Jangan menambahkan backend, autentikasi, API, atau database online.
10. Laporkan hasil pengujian dan daftar file yang berubah pada akhir
    setiap phase.

------------------------------------------------------------------------

**Akhir UI Kit --- Aplikasi Pemilihan Calon Android (Static Prototype)**
