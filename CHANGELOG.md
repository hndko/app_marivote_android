# 📝 Changelog

Semua perubahan penting pada proyek **MariVote - Pemilihan Calon Android** dicatat dalam dokumen ini berdasarkan prinsip [Semantic Versioning](https://semver.org) dan [Conventional Commits](https://www.conventionalcommits.org).

---

## [1.1.0] - 2026-11-19

### ✨ Added
- **Logo & Brand Identity**: Dibuat logo master MariVote (Kotak suara modern putih + centang hijau `#16834A` dalam lingkaran biru royal `#2457C5`).
- **Android Mipmaps App Icon**: Dihasilkan ikon aplikasi Android beresolusi penuh untuk seluruh kepadatan layar (`mdpi`, `hdpi`, `xhdpi`, `xxhdpi`, `xxxhdpi`).
- **Web Favicon & PWA Icons**: Dibuat `favicon.png` (32x32), `Icon-192.png`, `Icon-512.png`, serta maskable icons di folder `web/`.
- **Native Android Launch Screen**: Konfigurasi `launch_background.xml` dengan warna latar `#F5F7FB` dan `launch_image.png` terpusat.
- **Flutter In-App Animated Splash Screen**: Layar splash beranimasi halus (`SplashScreen`) dengan transisi scale & fade, menampilkan identitas MariVote sebelum berpindah ke halaman utama.
- **Pengujian Otomatis**: Ditambahkan widget test [splash_screen_test.dart](test/splash_screen_test.dart) (15/15 tests passing 100%).

---

## [1.0.0] - 2026-11-19

### ✨ Added
- **Inisialisasi Proyek**: Pengaturan aplikasi Flutter 3.41.9 / Dart 3.11.5 dengan package `com.marivote.pemilihancalon` dan target SDK Android API 26+.
- **Design Tokens & Theme**: Sistem token warna, spacing kelipatan 4 dp, tipografi Roboto, dan Material 3 theme terpusat di `lib/core/theme/`.
- **Domain Models & Randomizer**: Model `Candidate` dan `CandidateWithNumber` dengan logika pengacakan nomor urut 1 dan 2 tanpa duplikasi di `CandidateRepository`.
- **Dukungan Konfigurasi Dinamis**: Dukungan pembacaan calon lokal dari `assets/candidates.json` dengan fallback in-memory yang aman.
- **UI Pemilihan Calon**:
  - `CandidateCard` dengan foto rasio 4:5, badge nomor urut pill, dan tombol Pilih.
  - `ConfirmationDialog` untuk konfirmasi eksplisit ("Kembali" / "Ya, Pilih").
  - `HomeElectionScreen` dengan layout responsif adaptif.
- **Halaman Hasil & Ekspor Bukti**:
  - `ProofTicketWidget` template visual rasio portrait (1080x1350 px) yang hanya menampilkan calon terpilih.
  - `ProofExportService` untuk konversi widget ke PNG dengan nama `bukti-pilihan-YYYYMMDD-HHmmss.png`.
  - Simpan langsung ke Galeri/Pictures Android via modern MediaStore (`gal`) dengan tombol aksi "Buka Galeri".
  - Integrasi Android Native Share Sheet (`share_plus`).
  - Fitur "Mulai Simulasi Baru / Reset" untuk pengujian berulang.
- **Aksesibilitas (a11y)**: Label semantik `Semantics` terpasang di kartu calon, badge nomor urut, header dialog, dan bukti tiket.
- **Launcher Script**: Menu interaktif Windows `run.bat` untuk mode debug, release, build APK, clean & get, dan pengujian otomatis.
- **Automated Tests**: 14 automated unit & widget tests dengan 100% tingkat kelulusan.
- **Tata Kelola AI & Proyek**: Dokumen standar hukum `AGENTS.md` (10 pilar enterprise) dan `README.md` berstandar industri.
