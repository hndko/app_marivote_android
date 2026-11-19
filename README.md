# 🗳️ MariVote — Aplikasi Pemilihan Calon Android

> Prototype aplikasi simulasi pemilihan dua calon berbasis Android (Flutter) yang sederhana, netral, 100% offline, dengan pengacakan nomor urut lokal, dialog konfirmasi eksplisit, dan ekspor bukti gambar PNG ke galeri perangkat.

[![Flutter Version](https://img.shields.io/badge/Flutter-3.41.9-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart Version](https://img.shields.io/badge/Dart-3.11.5-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Android Min SDK](https://img.shields.io/badge/Android%20Min%20SDK-API%2026%20(8.0+)-3DDC84?style=for-the-badge&logo=android&logoColor=white)](https://developer.android.com)
[![Tests Passing](https://img.shields.io/badge/Tests-15%2F15%20Passed%20(100%25)-success?style=for-the-badge&logo=githubactions&logoColor=white)](#-pengujian-otomatis)
[![Version](https://img.shields.io/badge/Version-1.1.1-blue?style=for-the-badge)](CHANGELOG.md)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](LICENSE)

---

## 📑 Daftar Isi

- [📖 Tentang Proyek](#-tentang-proyek)
- [🛠️ Teknologi & Library](#️-teknologi--library)
- [🗄️ Struktur Data & Konfigurasi Calon](#️-struktur-data--konfigurasi-calon)
- [👥 Hak Akses & Role Pengguna](#-hak-akses--role-pengguna)
- [✨ Fitur Utama](#-fitur-utama)
- [📋 Prasyarat Sistem](#-prasyarat-sistem)
- [🚀 Panduan Instalasi](#-panduan-instalasi)
- [💻 Panduan Penggunaan](#-panduan-penggunaan)
- [🧪 Panduan Pengujian Otomatis](#-panduan-pengujian-otomatis)
- [🔐 Kredensial Default](#-kredensial-default)
- [🤝 Panduan Kontribusi & Aturan AI](#-panduan-kontribusi--aturan-ai)
- [📄 Lisensi](#-lisensi)

---

## 📖 Tentang Proyek

**MariVote** adalah aplikasi prototype Android yang dirancang untuk memvalidasi alur dan pengalaman pengguna (UX) pada pemilihan dua calon secara statis dan netral. Aplikasi berjalan **sepenuhnya di perangkat pengguna (100% offline-first)** tanpa memerlukan server, koneksi internet, akun login, database terpusat, maupun REST API.

Aplikasi ini berfokus pada:
1. Memberikan representasi visual yang setara, seimbang, dan adil antara kedua calon tanpa bias kampanye.
2. Mengacak nomor urut `01` dan `02` secara unik pada setiap sesi baru agar tidak ada posisi calon yang diuntungkan.
3. Mencegah kesalahan ketukan tidak sengaja melalui dialog konfirmasi eksplisit ("Kembali" atau "Ya, Pilih").
4. Menghasilkan bukti pilihan dalam bentuk gambar PNG beresolusi tinggi (acuan 1080 x 1350 px) yang dapat langsung diunduh ke galeri perangkat Android atau dibagikan melalui Android Native Share Sheet.
5. Menyediakan mekanisme reset simulasi lokal untuk memfasilitasi pengujian berulang kali tanpa perlu menghapus data aplikasi secara manual.

> **Catatan Penting (PRD Section 3.2):** Aplikasi ini berstatus **Static Prototype**. Seluruh proses pencatatan hanya bersifat lokal pada perangkat dan bukan merupakan sistem pemungutan suara resmi yang terverifikasi server.

---

## 🛠️ Teknologi & Library

- **Bahasa Pemrograman**: [Dart 3.11.5](https://dart.dev)
- **Framework Utama**: [Flutter 3.41.9 (Stable Channel)](https://flutter.dev)
- **Platform Sasaran**: Android (Minimum SDK API 26 / Android 8.0 Oreo, Target SDK API 34+)
- **Design System**: Material 3 dengan token tema kustom sesuai [UI Kit](docs/UI_Kit_Aplikasi_Pemilihan_Calon_Android.md)
- **Arsitektur**: Layered MVVM + Repository Pattern (`Presentation`, `Controller/ViewModel`, `Data`, `Services`)
- **Library / Plugin Pendukung**:
  - `shared_preferences` (^2.5.6): Persistensi status sesi pemilihan lokal secara persisten.
  - `gal` (^3.0.1): Penyimpanan gambar bukti ke Galeri / Pictures Android via modern MediaStore scoped storage API.
  - `share_plus` (^13.3.1): Membuka Android Native Share Sheet untuk membagikan file PNG bukti.
  - `path_provider` (^2.1.6): Akses direktori sementara perangkat untuk penulisan file bukti sebelum dibagikan.
  - `intl` (^0.20.3): Standardisasi format tanggal dan waktu lokal.
  - `flutter_lints` (^6.0.0): Penegakan aturan kebersihan dan kualitas kode resmi Dart.

---

## 🗄️ Struktur Data & Konfigurasi Calon

### 1. File Konfigurasi Dinamis (`assets/candidates.json`)
Calon dapat diubah secara dinamis tanpa perlu menyentuh atau mengompilasi ulang kode sumber Dart melalui file `assets/candidates.json`:

```json
[
  {
    "id": "candidate_a",
    "name": "Ahmad Pratama",
    "image": "assets/images/calon_a.png",
    "description": "Calon Pertama"
  },
  {
    "id": "candidate_b",
    "name": "Siti Rahmawati",
    "image": "assets/images/calon_b.png",
    "description": "Calon Kedua"
  }
]
```

### 2. Model Entitas Domain (`lib/data/models/candidate.dart`)
- `Candidate`: Menyimpan `id`, `name`, `image`, dan `description`.
- `CandidateWithNumber`: Memetakan calon dengan nomor urut hasil pengacakan (`number`: 1 atau 2), format dua digit (`formattedNumber`: `"01"` atau `"02"`), serta label aksesibilitas (`accessibilityLabel`).

### 3. Persistensi Sesi Lokal (`lib/data/repositories/session_repository.dart`)
Status pemilihan disimpan di `SharedPreferences` menggunakan kunci:
- `marivote_session_candidates`: JSON array calon beserta nomor urut sesi aktif.
- `marivote_selected_candidate`: JSON calon yang telah dikonfirmasi pemilih.
- `marivote_voted_at`: Timestamp ISO 8601 saat konfirmasi dilakukan.

---

## 👥 Hak Akses & Role Pengguna

Karena aplikasi merupakan prototype simulasi statis lokal, tidak diperlukan sistem autentikasi bertingkat:

| Role | Deskripsi Hak Akses / Tanggung Jawab |
| :--- | :--- |
| **Pemilih (Voter / User)** | Melihat kedua calon, memilih 1 calon, mengonfirmasi pilihan, mengunduh bukti ke galeri, membagikan bukti, serta memulai simulasi baru. |
| **Penguji (Tester / Admin)** | Menguji konsistensi pengacakan nomor urut antar sesi, memverifikasi tidak adanya perubahan pilihan setelah ditetapkan, dan menguji ekspor file PNG di perangkat Android. |

---

## ✨ Fitur Utama

- 🔹 **Dua Calon Netral & Seimbang**: Kedua calon ditampilkan berdampingan/vertikal dengan ukuran foto, tipografi, dan ruang kartu yang setara tanpa unsur kampanye.
- 🔹 **Pengacakan Nomor Urut Lokal (PRD FR-03)**: Nomor urut 1 dan 2 dialokasikan secara acak saat sesi pemilihan dimulai dan dijamin bebas duplikasi.
- 🔹 **Konsistensi Sesi (PRD FR-04 & FR-12)**: Nomor urut calon tidak berubah saat membuka/menutup dialog dan terkunci permanen begitu pilihan dikonfirmasi.
- 🔹 **Dialog Konfirmasi Eksplisit (PRD FR-05 & FR-06)**: Menampilkan nama dan nomor urut calon yang dipilih dengan tombol "Kembali" (batal) dan "Ya, Pilih" (konfirmasi).
- 🔹 **Template Bukti Gambar PNG Beresolusi Tinggi (PRD FR-09)**: Merender tiket visual portrait (1080 x 1350 px) yang memuat calon terpilih, nomor urut, waktu perangkat, dan disclaimer simulasi statis.
- 🔹 **Unduh Bukti ke Galeri Android (PRD FR-10)**: Menyimpan gambar dengan nama file format `bukti-pilihan-YYYYMMDD-HHmmss.png` ke folder Galeri/Pictures, dilengkapi tombol aksi cepat *"Buka Galeri"*.
- 🔹 **Bagikan Bukti (PRD FR-13)**: Mengirimkan gambar bukti ke WhatsApp, Telegram, atau aplikasi lain melalui Android Native Share Sheet.
- 🔹 **Mulai Simulasi Baru / Reset**: Mengosongkan status pilihan lokal dan mengacak ulang nomor urut calon untuk simulasi berikutnya.
- 🔹 **Ramah Aksesibilitas (WCAG AA & TalkBack)**: Seluruh kartu calon, tombol, judul dialog, dan tiket bukti dilengkapi label `Semantics` serta memenuhi area sentuh minimal 48 x 48 dp.

---

## 📋 Prasyarat Sistem

- **Sistem Operasi**: Windows 10/11, macOS, atau Linux
- **Flutter SDK**: Versi `3.41.x` atau lebih baru
- **Dart SDK**: Versi `3.11.x` atau lebih baru
- **Android SDK**: Android API 26 (Android 8.0 Oreo) hingga Android API 34+
- **Java Development Kit (JDK)**: OpenJDK 17

---

## 🚀 Panduan Instalasi

1. **Clone Repositori**:
   ```bash
   git clone https://github.com/marivote/app_marivote_android.git
   cd app_marivote_android
   ```

2. **Unduh Dependensi Proyek**:
   ```bash
   flutter pub get
   ```

3. **Verifikasi Lingkungan**:
   ```bash
   flutter doctor
   ```

---

## 💻 Panduan Penggunaan

### 1. Menjalankan via Interactive Launcher (`run.bat`)
Untuk pengguna Windows, tersedia script launcher interaktif serbaguna:
```cmd
.\run.bat
```

Tampilan Menu Interaktif:
```text
================================================================
          MARIVOTE - PEMILIHAN CALON ANDROID
              (Prototype Statis Pemilihan)
================================================================

  [1] Jalankan Aplikasi (Mode Debug)       - flutter run
  [2] Jalankan Aplikasi (Mode Release)     - flutter run --release
  [3] Build APK Release                   - flutter build apk --release
  [4] Build APK Debug                     - flutter build apk --debug
  [5] Jalankan Unit & Widget Test         - flutter test
  [6] Bersihkan Cache & Unduh Paket       - flutter clean & pub get
  [7] Cek Perangkat / Emulator & Doctor   - flutter devices & doctor

  [0] Keluar
================================================================
```

### 2. Menjalankan via Perintah Flutter CLI
- **Mode Debug (Development)**:
  ```bash
  flutter run
  ```
- **Mode Release (Performa Penuh)**:
  ```bash
  flutter run --release
  ```
- **Kompilasi APK Debug**:
  ```bash
  flutter build apk --debug
  # Output: build/app/outputs/flutter-apk/app-debug.apk
  ```
- **Kompilasi APK Release**:
  ```bash
  flutter build apk --release
  # Output: build/app/outputs/flutter-apk/app-release.apk
  ```

---

## 🧪 Panduan Pengujian Otomatis

Seluruh logika bisnis, pengacakan nomor urut, alur dialog konfirmasi, dan pembuatan bukti telah diverifikasi dengan automated test suite:

```bash
flutter test
```

### Rincian Rangkaian Uji (15/15 Tests Passing):
1. **`test/splash_screen_test.dart`** (1 test):
   - Verifikasi tampilan identitas brand, judul MariVote, dan navigasi transisi ke halaman utama.
2. **`test/candidate_randomizer_test.dart`** (7 tests):
   - Serialisasi & deserialisasi model JSON.
   - Format nomor urut dua digit (`01`, `02`) dan label aksesibilitas.
   - Integritas data calon default (tepat 2 calon).
   - Pengacakan nomor urut unik 1 & 2 tanpa duplikasi (PRD FR-01, FR-03).
   - Verifikasi sifat acak deterministik dan peluang 50% bagi kedua calon (PRD TC-02).
   - Pembacaan konfigurasi dinamis `assets/candidates.json` dengan fallback aman.
2. **`test/selection_flow_widget_test.dart`** (4 tests):
   - TC-01: Verifikasi dua kartu calon tampil di halaman utama.
   - TC-03 & TC-04: Menekan tombol Pilih menampilkan dialog konfirmasi, menekan Kembali membatalkan pilihan tanpa perubahan state.
   - TC-05: Menekan "Ya, Pilih" mengunci calon dan beralih ke halaman hasil.
   - TC-07: Memilih calon kedua menetapkan data calon kedua secara konsisten.
3. **`test/proof_service_test.dart`** (3 tests):
   - Penamaan file otomatis format `bukti-pilihan-YYYYMMDD-HHmmss.png` (PRD Section 10.3).
   - Format tanggal Indonesia ("19 November 2026") dan format waktu ("11:30").
   - Template bukti hanya memuat calon terpilih dan tidak menyertakan calon lain (PRD FR-09).

---

## 🔐 Kredensial Default

Aplikasi ini **100% offline dan tidak memerlukan login atau server backend**. Tidak ada username, kata sandi, maupun API key yang perlu dikonfigurasi.

---

## 🤝 Panduan Kontribusi & Aturan AI

Seluruh pengembang dan AI Coding Assistant yang bekerja pada repositori ini **WAJIB** mematuhi pedoman hukum rekayasa perangkat lunak di [AGENTS.md](AGENTS.md):

1. **Conventional Commits**: Format commit wajib mengikuti `<type>(<scope>): <description>` (contoh: `feat(proof): add gallery shortcut to snackbar`).
2. **Strict Multi-File Version Sync**: Nomor versi SemVer wajib sinkron serempak di `pubspec.yaml`, `README.md`, `CHANGELOG.md`, dan `AGENTS.md`.
3. **Quality Gates**: Kode hanya boleh di-merge jika `flutter analyze` menghasilkan 0 issues dan seluruh `flutter test` lulus 100%.

---

## 📄 Lisensi

Hak Cipta © 2026 Proyek MariVote.  
Didistribusikan di bawah lisensi [MIT License](LICENSE).
