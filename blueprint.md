
# Blueprint: Finote App

## 1. Ikhtisar Aplikasi

Finote adalah aplikasi Flutter yang dirancang untuk membantu pengguna mengelola keuangan pribadi mereka. Fitur utamanya meliputi pelacakan pemasukan, pengeluaran, tabungan, dan hutang, serta menyediakan analisis keuangan berbasis AI.

## 2. Gaya, Desain, dan Fitur yang Diterapkan

### Desain & Tema Umum
- **Palet Warna**: Dominan gelap (`#1C1C1C`, `#2F2F2F`) dengan warna aksen teal (`#37C8C3`).
- **Tipografi**: Menggunakan `GoogleFonts.poppins` untuk tampilan teks yang modern dan bersih.
- **Gaya Komponen**: Komponen interaktif memiliki efek bayangan dan visual yang ditinggikan untuk nuansa premium.

### Halaman & Fitur Utama
- **Onboarding & Autentikasi**: Alur untuk perkenalan aplikasi (`Onboarding`), pendaftaran (`Sign Up`), masuk (`Login`), dan pemulihan password.
- **Halaman Utama (Home Screen)**:
    - **App Bar Kustom**: Menampilkan avatar, sapaan, ikon notifikasi, dan **menu profil**.
    - **Menu Profil (Popup)**: Menampilkan nama pengguna, email, dan opsi ke Pengaturan atau Keluar.
    - **Kartu Saldo**: Menampilkan saldo akhir dengan grafik garis (`fl_chart`).
    - **FAB "Speed Dial"**: Tombol Aksi Mengambang untuk navigasi cepat ke "Analisis AI" dan "Pengaturan".
- **Pencatatan Transaksi**:
    - Halaman terpisah untuk **Pemasukan** (`IncomeScreen`) dan **Pengeluaran** (`ExpenseScreen`).
    - Formulir *modal bottom sheet* untuk menambah data baru.
- **Halaman Tabungan (`SavingsScreen.dart`)**:
    - Menampilkan total saldo tabungan.
    - Daftar target tabungan (misal: Motor, Laptop) dengan *progress bar* visual untuk setiap target.
    - Tombol `+` untuk membuka formulir tambah tabungan baru.
- **Halaman Detail Tabungan (`SavingsDetailScreen.dart`)**:
    - Halaman yang menampilkan progres detail dari sebuah target tabungan.
    - Menggunakan `percent_indicator` untuk *progress arc*.
    - Menampilkan riwayat transaksi untuk target tabungan tersebut.
- **Formulir Tambah Tabungan (`add_saving_form.dart`)**:
    - Tampil sebagai *modal bottom sheet*.
    - Memiliki opsi untuk memilih jenis tabungan (Target/Biasa).
    - Kolom input untuk nama, jumlah, dan tanggal target.
- **Bilah Navigasi Bawah (Navbar)**:
    - Menggunakan `curved_navigation_bar` untuk efek "cekung" pada item yang aktif.
    - Terintegrasi dengan semua halaman utama termasuk halaman Tabungan.

### Halaman Sekunder
- **Analisis AI (`AiAnalysisScreen.dart`)**: Halaman placeholder.
- **Pengaturan (`SettingsScreen.dart`)**: Halaman placeholder.

## 3. Rencana Saat Ini

*   **Tugas:** Mengimplementasikan formulir tambah tabungan baru.
*   **Status:** Selesai.
*   **Langkah-langkah yang Telah Dilakukan:**
    1. Membuat file `lib/widgets/add_saving_form.dart` untuk UI formulir.
    2. Mengimplementasikan formulir tambah tabungan sebagai *modal bottom sheet*.
    3. Menghubungkan formulir ke tombol `+` di halaman Tabungan.
    4. Memperbarui `blueprint.md`.

*   **Langkah Selanjutnya:** Menunggu arahan dari pengguna.
