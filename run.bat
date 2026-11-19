@echo off
setlocal enabledelayedexpansion
title MariVote - Pemilihan Calon Android Launcher
color 0B

:MENU
cls
echo ================================================================
echo           MARIVOTE - PEMILIHAN CALON ANDROID
echo               (Prototype Statis Pemilihan)
echo ================================================================
echo.
echo   Pilih opsi yang ingin dijalankan:
echo.
echo   [1] Jalankan Aplikasi (Mode Debug)       - flutter run
echo   [2] Jalankan Aplikasi (Mode Release)     - flutter run --release
echo   [3] Build APK Release                   - flutter build apk --release
echo   [4] Build APK Debug                     - flutter build apk --debug
echo   [5] Jalankan Unit ^& Widget Test         - flutter test
echo   [6] Bersihkan Cache ^& Unduh Paket       - flutter clean ^& pub get
echo   [7] Cek Perangkat / Emulator ^& Doctor   - flutter devices ^& doctor
echo.
echo   [0] Keluar
echo.
echo ================================================================
set /p CHOICE="Masukkan pilihan Anda [0-7]: "

if "%CHOICE%"=="1" goto RUN_DEBUG
if "%CHOICE%"=="2" goto RUN_RELEASE
if "%CHOICE%"=="3" goto BUILD_RELEASE
if "%CHOICE%"=="4" goto BUILD_DEBUG
if "%CHOICE%"=="5" goto RUN_TESTS
if "%CHOICE%"=="6" goto CLEAN_GET
if "%CHOICE%"=="7" goto CHECK_DEVICES
if "%CHOICE%"=="0" goto EXIT_APP

echo.
echo [!] Pilihan tidak valid. Silakan coba lagi.
timeout /t 2 >nul
goto MENU

:RUN_DEBUG
cls
echo ================================================================
echo   Menjalankan MariVote dalam Mode Debug...
echo ================================================================
echo.
flutter run
echo.
echo Selesai. Tekan sembarang tombol untuk kembali ke menu...
pause >nul
goto MENU

:RUN_RELEASE
cls
echo ================================================================
echo   Menjalankan MariVote dalam Mode Release...
echo ================================================================
echo.
flutter run --release
echo.
echo Selesai. Tekan sembarang tombol untuk kembali ke menu...
pause >nul
goto MENU

:BUILD_RELEASE
cls
echo ================================================================
echo   Membangun APK Release...
echo   (Hasil akan berada di: build\app\outputs\flutter-apk\app-release.apk)
echo ================================================================
echo.
flutter build apk --release
echo.
echo Selesai. Tekan sembarang tombol untuk kembali ke menu...
pause >nul
goto MENU

:BUILD_DEBUG
cls
echo ================================================================
echo   Membangun APK Debug...
echo   (Hasil akan berada di: build\app\outputs\flutter-apk\app-debug.apk)
echo ================================================================
echo.
flutter build apk --debug
echo.
echo Selesai. Tekan sembarang tombol untuk kembali ke menu...
pause >nul
goto MENU

:RUN_TESTS
cls
echo ================================================================
echo   Menjalankan Seluruh Unit ^& Widget Test...
echo ================================================================
echo.
flutter test
echo.
echo Selesai. Tekan sembarang tombol untuk kembali ke menu...
pause >nul
goto MENU

:CLEAN_GET
cls
echo ================================================================
echo   Membersihkan Cache dan Mengunduh Ulang Dependensi...
echo ================================================================
echo.
flutter clean
echo.
echo Mengunduh paket...
flutter pub get
echo.
echo Selesai. Tekan sembarang tombol untuk kembali ke menu...
pause >nul
goto MENU

:CHECK_DEVICES
cls
echo ================================================================
echo   Mengecek Perangkat Terhubung dan Status Lingkungan...
echo ================================================================
echo.
echo --- Daftar Perangkat: ---
flutter devices
echo.
echo --- Daftar Emulator Tersedia: ---
flutter emulators
echo.
echo --- Status Flutter Doctor: ---
flutter doctor
echo.
echo Selesai. Tekan sembarang tombol untuk kembali ke menu...
pause >nul
goto MENU

:EXIT_APP
cls
echo Terima kasih telah menggunakan MariVote.
timeout /t 1 >nul
exit /b 0
