# 🤖 AGENTS.md — Panduan & Aturan Utama Pengembangan Proyek MariVote Android

Dokumen ini adalah **sumber acuan hukum dan aturan rekayasa perangkat lunak tertinggi (*Single Source of Truth*)** bagi seluruh AI Coding Assistant dan pengembang manusia yang bekerja pada repositori **MariVote - Pemilihan Calon Android**. Seluruh instruksi dalam dokumen ini bersifat mengikat dan wajib dipatuhi tanpa pengecualian.

Jika terjadi kontradiksi aturan, urutan prioritas hukum tertinggi adalah:
1. **Keamanan, Privasi & Integritas Data**
2. **Instruksi Pengguna Aktif Saat Ini**
3. **Dokumen ini (`AGENTS.md`)**
4. **Spesifikasi PRD & UI Kit (`docs/`)**
5. **Pola Kode Lama / Legacy Code**

---

## 📌 Metadata Proyek

- **Nama Aplikasi**: **MariVote - Pemilihan Calon Android** (Static Prototype)
- **Versi Saat Ini**: `v1.1.1`
- **Platform & Runtime**: Flutter 3.41.9 / Dart 3.11.5 / Android SDK (Min API 26, Target API 34+)
- **Package ID / Namespace**: `com.marivote.pemilihancalon`
- **Tipe Arsitektur**: Layered MVVM + Repository Pattern (Presentation, Controller/ViewModel, Data, Services)
- **Dokumentasi Proyek**: [PRD Aplikasi](docs/PRD_Aplikasi_Pemilihan_Calon_Android_Static.md) & [UI Kit Spesifikasi](docs/UI_Kit_Aplikasi_Pemilihan_Calon_Android.md)
- **Histori Rilis**: `CHANGELOG.md` & `README.md`
- **Sumber Versi Runtime**: `pubspec.yaml` (`version: 1.1.1+3`)

---

## 📋 Daftar Isi

1. [🏛️ 10 Pilar Aturan Wajib AI Assistant & Pengembang](#-10-pilar-aturan-wajib-ai-assistant--pengembang)
   - [🎯 1. Peran & Prinsip Kerja Utama (Role & Prime Directives)](#-1-peran--prinsip-kerja-utama-role--prime-directives)
   - [🏗️ 2. Arsitektur MVVM & Pemisahan Tanggung Jawab](#-2-arsitektur-mvvm--pemisahan-tanggung-jawab)
   - [📄 3. Widget Murni Presentasional & Bebas Akses Storage Langsung](#-3-widget-murni-presentasional--bebas-akses-storage-langsung)
   - [🏢 4. Data Scoping & Offline-First Persistence](#-4-data-scoping--offline-first-persistence)
   - [🎨 5. Standar UI/UX, Tema Terang & Zero External CDN](#-5-standar-uiux-tema-terang--zero-external-cdn)
   - [📊 6. Standardisasi Interaktivitas, Anti-Double Submit & Layout](#-6-standardisasi-interaktivitas-anti-double-submit--layout)
   - [🔒 7. Standar Keamanan OWASP, Scoped Storage & Privasi](#-7-standar-keamanan-owasp-scoped-storage--privasi)
   - [🧪 8. Standar Pengujian Mutu (Quality Gates) & Definition of Done](#-8-standar-pengujian-mutu-quality-gates--definition-of-done)
   - [📦 9. Aturan Git Commit & Push Otomatis & SemVer](#-9-aturan-git-commit--push-otomatis--semver)
   - [🔄 10. Kewajiban Pengkinian Dokumen (Mandatory Sync)](#-10-kewajiban-pengkinian-dokumen-mandatory-sync)
2. [📁 Konsep Tata Letak Direktori (Folder-Foldering Hierarchy)](#-konsep-tata-letak-direktori-folder-foldering-hierarchy)
   - [🌳 Diagram Pohon Direktori](#-diagram-pohon-direktori)
   - [🧩 Penjelasan Modul Direktori](#-penjelasan-modul-direktori)
3. [🛡️ Standar Wajib Audit Kualitas & Kesiapan Produksi (Quality Gate)](#-standar-wajib-audit-kualitas--kesiapan-produksi-quality-gate)

---

## 🏛️ 10 Pilar Aturan Wajib AI Assistant & Pengembang

```text
┌──────────────────────────────────────────────────────────────────────────────────┐
│                   10 PILAR ATURAN WAJIB PENGEMBANGAN MARIVOTE                    │
├───────────────────┬───────────────────┬───────────────────┬──────────────────────┤
│ 1. Prime Directive│ 2. Clean MVVM Arch│ 3. Dumb UI Widgets│ 4. Offline Storage   │
│ 5. Zero-CDN Assets│ 6. Anti-DoubleTap │ 7. Scoped Security│ 8. Strict Quality    │
│ 9. SemVer AutoPush│ 10. Mandatory Sync│                   │                      │
└───────────────────┴───────────────────┴───────────────────┴──────────────────────┘
```

---

### 🎯 1. Peran & Prinsip Kerja Utama (Role & Prime Directives)
1. **Senior Flutter Engineer Mindset**: Bertindak sebagai Senior Flutter & Android Architect, Security Auditor, dan QA Lead. Prioritaskan kestabilan lifecycle, pemisahan layer bersih, dan performa UI 60 FPS bebas jank.
2. **Nol Asumsi & Non-Halusinasi**: Selalu baca berkas langsung di sistem file (`read_file`) sebelum melakukan perubahan kode. Dilarang berasumsi nama parameter, method plugin, atau aset gambar ada tanpa verifikasi nyata.
3. **Preservasi Invarian Domain**:
   - Tepat dua calon pada sesi pemilihan (PRD FR-01).
   - Nomor urut selalu dialokasikan acak 1 dan 2 tanpa duplikasi (PRD FR-03).
   - Urutan nomor calon konsisten selama satu sesi berlangsung (PRD FR-04).
   - Pilihan hanya ditetapkan setelah konfirmasi eksplisit (PRD FR-07).
   - Pengguna dicegah mengganti calon dalam sesi yang sama setelah menetapkan pilihan (PRD FR-12).
   - Bukti pilihan hanya memuat calon terpilih dan menyertakan disclaimer simulasi statis (PRD FR-09).

---

### 🏗️ 2. Arsitektur MVVM & Pemisahan Tanggung Jawab
1. **Pemisahan 4 Layer Terstruktur**:
   - **Presentation Layer (`lib/presentation/screens/`, `lib/presentation/widgets/`)**: Hanya bertanggung jawab me-render UI dan menangkap interaksi pengguna.
   - **Controller / State Management (`lib/presentation/controllers/`)**: Mengelola state aplikasi (`ElectionController` yang meng-extend `ChangeNotifier`), mengorkestrasi alur pemilihan, dan mengekspos state secara reaktif.
   - **Data Layer (`lib/data/repositories/`, `lib/data/models/`)**: Menyediakan Single Source of Truth untuk model data domain (`Candidate`, `CandidateWithNumber`) dan repositori penyimpanan lokal (`CandidateRepository`, `SessionRepository`).
   - **Service Layer (`lib/services/`)**: Layanan stateless eksternal/platform seperti rendering gambar bitmap dan ekspor galeri Android (`ProofExportService`).
2. **Larangan Logic Bleeding**: Dilarang meletakkan logika persistensi, randomizer nomor urut, atau render bitmap langsung di dalam widget view.

---

### 📄 3. Widget Murni Presentasional & Bebas Akses Storage Langsung
1. **Zero Raw Storage di Widget**: Dilarang memanggil `SharedPreferences` atau I/O file langsung di dalam method `build()` widget. Seluruh akses data wajib melalui `ElectionController` atau `SessionRepository`.
2. **Reusable UI Components**:
   - Tombol utama dan sekunder wajib menggunakan [AppButton](lib/presentation/widgets/app_button.dart).
   - Kartu calon wajib menggunakan [CandidateCard](lib/presentation/widgets/candidate_card.dart) yang setara dan netral untuk kedua calon.
   - Dialog konfirmasi wajib menggunakan [ConfirmationDialog](lib/presentation/widgets/confirmation_dialog.dart).
3. **Stateless over Stateful**: Utamakan `StatelessWidget`. Gunakan `StatefulWidget` hanya untuk pengelolaan controller lifecycle (`initState`, `dispose`), animasi lokal, atau GlobalKey boundaries.

---

### 🏢 4. Data Scoping & Offline-First Persistence
1. **100% Offline by Design**: Seluruh fitur pemilihan, pengacakan, persistensi, dan pembuatan bukti wajib berfungsi penuh tanpa koneksi internet (Airplane mode safe - PRD TC-09).
2. **Dual Data Fallback**:
   - Konfigurasi calon dibaca dinamis dari `assets/candidates.json`.
   - Jika file tidak ada atau rusak, repositori otomatis menggunakan in-memory fallback yang aman tanpa menimbulkan crash.
3. **Session Reset Safety**: Fitur "Mulai Simulasi Baru / Reset" wajib membersihkan data lokal secara tervalidasi dan menghasilkan nomor urut acak baru untuk sesi berikutnya.

---

### 🎨 5. Standar UI/UX, Tema Terang & Zero External CDN
1. **Tema Terang Bersih (*Light Mode Primary*)**:
   - Menggunakan palet token terpusat [AppColors](lib/core/theme/app_colors.dart) (`primary: #2457C5`, `background: #F5F7FB`, `surface: #FFFFFF`, `border: #E4E7EC`).
   - Kontras warna teks memenuhi standar WCAG AA (rasio kontras minimal 4.5:1 terhadap latar).
2. **Zero External CDN & Network Assets**:
   - Seluruh gambar, ikon, dan font tersimpan 100% secara lokal di repositori (`assets/images/`).
   - Dilarang keras menggunakan `Image.network` ke URL publik yang rentan offline atau privacy leak.
3. **Ikon & Tipografi Standar**:
   - Menggunakan Material Icons bawaan Flutter (Roboto font) tanpa dependensi web font eksternal.
4. **Komponen Aksesibilitas (a11y)**:
   - Touch target tombol minimal 48x48 dp.
   - Label semantik eksplisit (`Semantics`) pada kartu calon, badge nomor urut, judul modal dialog, dan tiket bukti untuk kompatibilitas screen reader (TalkBack).

---

### 📊 6. Standardisasi Interaktivitas, Anti-Double Submit & Layout
1. **Pencegahan Double-Tap / Double-Submit**:
   - Tombol aksi utama (Pilih, Ya Pilih, Unduh Bukti, Bagikan Bukti) wajib dinonaktifkan (`disabled`) dan menampilkan loading spinner saat proses asinkron berlangsung.
2. **Layout Responsif & Scroll-Safe**:
   - Menggunakan `SafeArea` dan `SingleChildScrollView` untuk mencegah RenderFlex overflow pada ponsel berlayar pendek atau saat orientasi layar berubah.
   - Menggunakan `LayoutBuilder` untuk tata letak adaptif (vertikal di layar mobile, grid berdampingan di layar tablet/desktop).
   - Penggunaan `Wrap` pada baris informasi metadata untuk menjamin tidak ada teks yang terpotong.
3. **Larangan Dialog Bawaan Platform**:
   - Dilarang menggunakan dialog mentah tanpa styling. Seluruh dialog wajib berdasar pada [AppSpacing.roundedXLarge] (20 dp) dengan layout tombol terstandarisasi ("Kembali" di kiri, "Ya, Pilih" di kanan).

---

### 🔒 7. Standar Keamanan OWASP, Scoped Storage & Privasi
1. **Zero Secret Hardcoding**: Dilarang menyimpan credential atau kunci privat di dalam kode sumber.
2. **Proteksi Privasi Pemilih**:
   - Tidak meminta data pribadi (nama, NIK, alamat, nomor telepon).
   - Gambar bukti hanya memuat nama calon, nomor urut, waktu perangkat, dan disclaimer simulasi statis. Dilarang menyertakan barcode palsu atau stempel server palsu.
3. **Modern MediaStore Scoped Storage**:
   - Penyimpanan gambar ke galeri Android menggunakan scoped storage API modern (plugin `gal`) tanpa meminta permission berbahaya (`MANAGE_EXTERNAL_STORAGE`).
   - Fallback `WRITE_EXTERNAL_STORAGE` hanya aktif pada Android API <= 29.

---

### 🧪 8. Standar Pengujian Mutu (Quality Gates) & Definition of Done
Setiap penambahan fitur atau perbaikan kode dinyatakan selesai (*Definition of Done*) jika dan hanya jika:
1. **Zero Lint Issues**: `flutter analyze` menghasilkan output `No issues found!`.
2. **Automated Tests 100% Passing**: `flutter test` lulus seluruh test suite (Unit, Widget, Logic).
3. **Build APK Android Berhasil**: `flutter build apk --debug` lolos tanpa error Gradle.
4. **Dokumentasi & Versi Ter-update**: `README.md`, `CHANGELOG.md`, dan `AGENTS.md` tersinkronisasi.

**Perintah Verifikasi Wajib**:
```bash
# Analisis Statis Dart
flutter analyze

# Rangkaian Pengujian Otomatis
flutter test

# Uji Kompilasi APK Android
flutter build apk --debug
```

---

### 📦 9. Aturan Git Commit & Push Otomatis & SemVer
1. **Format Conventional Commits**:
   ```text
   <type>(<scope>): <subject>
   ```
   - `feat`: Menambahkan fitur baru.
   - `fix`: Memperbaiki bug atau cacat logika.
   - `docs`: Dokumentasi proyek (`README.md`, `AGENTS.md`, `docs/`).
   - `style`: Penyesuaian tampilan/formatting tanpa mengubah logika.
   - `refactor`: Restrukturisasi kode tanpa mengubah fungsionalitas.
   - `test`: Menambah atau memperbarui unit/widget tests.
   - `chore`: Perawatan dependensi atau file build.
   - *Aturan*: Kata kerja imperatif (`add`, `fix`, `update`), subjek maksimal 100 karakter, tanpa tanda titik di akhir.
2. **Kewajiban Semantic Versioning (SemVer)**:
   - `MAJOR (X.0.0)`: Perubahan arsitektur besar / breaking change.
   - `MINOR (1.X.0)`: Penambahan fitur baru yang kompatibel ke belakang.
   - `PATCH (1.0.X)`: Bugfix, refactor, atau pembaruan kecil.
   - Versi wajib sinkron serempak di: `pubspec.yaml`, `README.md`, `CHANGELOG.md`, dan `AGENTS.md`.

---

### 🔄 10. Kewajiban Pengkinian Dokumen (Mandatory Sync)
1. **Zero Stale Documentation**: Setiap kali ada penambahan fitur, perubahan UI Kit, atau perbaikan bug, dokumentasi `README.md`, `CHANGELOG.md`, dan `AGENTS.md` wajib langsung dimutakhirkan dalam commit yang sama.
2. **Sinkronisasi Dokumen Teknis**: Jika terdapat perubahan alur operasional calon atau format bukti gambar, perbarui dokumen terkait di `docs/`.

---

## 📁 Konsep Tata Letak Direktori (Folder-Foldering Hierarchy)

### 🌳 Diagram Pohon Direktori

```text
app_marivote_android/
├── android/                        # Konfigurasi Gradle Android & AndroidManifest
│   └── app/
│       ├── build.gradle.kts        # Namespace: com.marivote.pemilihancalon, minSdk 26
│       └── src/main/
│           ├── AndroidManifest.xml # Label: MariVote - Pemilihan Calon
│           └── kotlin/com/marivote/pemilihancalon/MainActivity.kt
├── assets/                         # Aset statis lokal (100% offline)
│   ├── candidates.json             # Konfigurasi data calon dinamis
│   └── images/                     # Potret calon 4:5, placeholder & logo
│       ├── app_logo.png
│       ├── calon_a.png
│       ├── calon_b.png
│       └── placeholder_person.png
├── docs/                           # Blueprint spesifikasi & kebutuhan
│   ├── PRD_Aplikasi_Pemilihan_Calon_Android_Static.md
│   └── UI_Kit_Aplikasi_Pemilihan_Calon_Android.md
├── lib/                            # Kode sumber aplikasi Flutter
│   ├── main.dart                   # Entry point aplikasi & inisialisasi controller
│   ├── core/                       # Design system & shared theme
│   │   └── theme/
│   │       ├── app_colors.dart     # Token warna standar UI Kit
│   │       ├── app_spacing.dart    # Token spacing kelipatan 4 dp & radius
│   │       ├── app_typography.dart # Token tipografi Roboto Android
│   │       └── app_theme.dart      # Konfigurasi ThemeData Material 3
│   ├── data/                       # Data layer & model domain
│   │   ├── models/
│   │   │   └── candidate.dart      # Candidate & CandidateWithNumber domain models
│   │   └── repositories/
│   │       ├── candidate_repository.dart # Repositori calon & pengacakan nomor urut
│   │       └── session_repository.dart   # Persistensi sesi SharedPreferences
│   ├── presentation/               # UI presentation layer (MVVM)
│   │   ├── controllers/
│   │   │   └── election_controller.dart  # State machine & notifier pemilihan
│   │   ├── screens/
│   │   │   ├── home_election_screen.dart   # Halaman pemilihan 2 calon
│   │   │   └── election_result_screen.dart # Halaman hasil & opsi unduh bukti
│   │   └── widgets/
│   │       ├── app_button.dart             # Tombol primary/secondary anti-double-submit
│   │       ├── candidate_card.dart         # Kartu calon dengan badge nomor urut
│   │       ├── confirmation_dialog.dart    # Dialog konfirmasi eksplisit
│   │       └── proof_ticket_widget.dart    # Template visual bukti gambar PNG
│   └── services/                   # Service layer platform
│       └── proof_export_service.dart       # Capture RepaintBoundary, Galeri & Share
├── test/                           # Automated test suites
│   ├── candidate_randomizer_test.dart      # Unit test pengacakan & domain
│   ├── proof_service_test.dart             # Test template bukti & format nama file
│   └── selection_flow_widget_test.dart     # Widget test alur pemilihan & dialog
├── run.bat                         # Interactive Windows launcher script
├── pubspec.yaml                    # Dependensi, aset, dan versi aplikasi
├── CHANGELOG.md                    # Catatan histori rilis SemVer
├── README.md                       # Dokumentasi publik & panduan pengguna
└── AGENTS.md                       # Acuan hukum standar AI Coding Agent
```

---

### 🧩 Penjelasan Modul Direktori

1. **`lib/core/theme/`**: Tempat terpusat seluruh nilai desain visual (warna, ukuran font, padding, border radius). Dilarang keras melakukan hardcode warna hex atau ukuran font acak di file UI; seluruhnya harus merujuk pada token di folder ini.
2. **`lib/data/`**: Mengelola struktur data dan persistensi lokal. `CandidateRepository` mengelola calon dan algoritma pengacakan nomor urut, sedangkan `SessionRepository` mengelola penyimpanan status ke `SharedPreferences`.
3. **`lib/presentation/controllers/`**: Mengatur state aplikasi melalui `ElectionController` (`ChangeNotifier`). Mengontrol navigasi reaktif antara pemilihan dan hasil pilihan, mencegah race conditions, dan menangani reset simulasi.
4. **`lib/presentation/widgets/`**: Komponen modular reusable yang murni presentasional dan mudah diuji secara independen.
5. **`lib/presentation/screens/`**: Halaman layar utama aplikasi yang mengombinasikan widget dengan layout responsif.
6. **`lib/services/`**: Menangani interaksi dengan plugin platform Android (konversi widget ke bitmap PNG, simpan ke galeri Android via `gal`, dan native share sheet via `share_plus`).

---

## 🛡️ Standar Wajib Audit Kualitas & Kesiapan Produksi (Quality Gate)

Sebelum kode dinyatakan siap rilis (*production-ready*) atau di-merge ke branch utama, AI Assistant dan pengembang wajib memverifikasi 9 pilar audit berikut:

| No | Pilar Kualitas | Aspek yang Wajib Diverifikasi | Standar Wajib MariVote Android | Status |
|:--:|---|---|---|:--:|
| **1** | **Concurrency & State Safety** | Pergantian state saat dialog konfirmasi atau render bukti berlangsung | Status `processingSelection` & `savingProof` mengunci interaksi ganda | ✅ Terpenuhi |
| **2** | **UX & Usability Bottleneck** | Double submit tombol Pilih, feedback unduh galeri, mobile responsive | Tombol loading spinner `disabled`, SnackBar aksi "Buka Galeri", layout responsif | ✅ Terpenuhi |
| **3** | **OWASP & Mobile Security** | Zero secret hardcoding, data privasi pemilih, scoped storage | Tidak ada data pribadi yang diminta, scoped storage MediaStore Android tanpa izin berbahaya | ✅ Terpenuhi |
| **4** | **Scalability & Resource** | Memory footprint saat render bitmap bukti gambar beresolusi tinggi | Resolusi pixelRatio 2.0 terkontrol pada `RepaintBoundary`, pembersihan buffer | ✅ Terpenuhi |
| **5** | **Offline-First Resilience** | Aplikasi dibuka dalam mode pesawat atau tanpa koneksi data | 100% aset lokal (`assets/images/`), SharedPreferences lokal, zero network call | ✅ Terpenuhi |
| **6** | **Memory Leaks & Lifecycle** | Listener cleanup pada controller saat widget di-unmount | `removeListener` terdaftar di `dispose()`, safe post-frame callback | ✅ Terpenuhi |
| **7** | **Graceful Fallback** | File gambar gagal dimuat, file JSON konfigurasi tidak ditemukan | Fallback placeholder person netral, fallback in-memory candidates aman | ✅ Terpenuhi |
| **8** | **Observability & Error Feedback** | Penanganan galeri gagal simpan atau izin ditolak pengguna | Feedback SnackBar ramah dengan pesan kegagalan spesifik tanpa aplikasi crash | ✅ Terpenuhi |
| **9** | **Accessibility (a11y)** | Kompatibilitas screen reader TalkBack, rasio kontras teks WCAG AA | `Semantics` terpasang di kartu calon, badge nomor urut, header dialog, dan bukti tiket | ✅ Terpenuhi |
