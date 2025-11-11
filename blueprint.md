
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
    - **Kartu Saldo**: 
        - Menampilkan saldo akhir dengan grafik garis (`fl_chart`).
        - **Indikator Perubahan Saldo**: Menampilkan persentase kenaikan (hijau) atau penurunan (merah) saldo tepat di bawah jumlah saldo utama untuk memberikan visualisasi cepat terhadap perubahan keuangan.
    - **FAB "Speed Dial"**: Tombol Aksi Mengambang untuk navigasi cepat ke "Analisis AI" dan "Pengaturan".
- **Pencatatan Transaksi**:
    - Halaman terpisah untuk **Pemasukan** (`IncomeScreen`) dan **Pengeluaran** (`ExpenseScreen`).
    - Formulir *modal bottom sheet* untuk menambah data baru.
    - Di halaman pengeluaran, semua nominal transaksi ditampilkan dengan warna merah untuk menandakan uang keluar.
- **Halaman Tabungan (`SavingsScreen.dart`)**: Menampilkan daftar target tabungan dengan *progress bar* visual.
- **Halaman Detail Tabungan (`SavingsDetailScreen.dart`)**: Menampilkan progres detail dari sebuah target tabungan dengan *progress arc*.
- **Halaman Hutang (`DebtScreen.dart`)**: Menampilkan daftar item hutang dengan *progress bar* dan total nominal dalam Rupiah.
- **Halaman Detail Hutang (`DebtDetailScreen.dart`)**:
    - Menampilkan detail sisa cicilan, progres pembayaran, dan riwayat pembayaran.
    - Tombol "Bayar Cicilan" yang akan memunculkan *modal bottom sheet* formulir pembayaran.
- **Formulir Tambah Hutang (`add_debt_form.dart`)**:
    - Memiliki kolom untuk memasukkan "Link Pembayaran" (opsional) saat membuat hutang tipe cicilan.
- **Formulir Bayar Hutang (`pay_debt_form.dart`)**:
    - Tampil sebagai *modal bottom sheet* dari halaman detail hutang.
    - Berisi formulir untuk mencatat jumlah, sumber dana, dan tanggal pembayaran.
    - Tombol "LINK PEMBAYARAN" untuk membuka URL pembayaran yang tersimpan (menggunakan `url_launcher`).
    - Tombol "CATAT PEMBAYARAN" untuk menyimpan transaksi pembayaran.
- **Bilah Navigasi Bawah (Navbar)**: Menggunakan `curved_navigation_bar` yang terintegrasi di halaman-halaman utama.

### Halaman Sekunder
- **Analisis AI (`AiAnalysisScreen.dart`)**: Halaman placeholder.
- **Pengaturan (`SettingsScreen.dart`)**: Halaman placeholder.

## 3. Rencana Saat Ini

*   **Tugas:** Mengimplementasikan alur pembayaran cicilan hutang dengan *modal* dan tombol link pembayaran.
*   **Status:** Selesai.
*   **Langkah-langkah yang Telah Dilakukan:**
    1.  Menambahkan `url_launcher` ke `pubspec.yaml`.
    2.  Membuat file `lib/widgets/pay_debt_form.dart` untuk *modal* pembayaran.
    3.  Memastikan formulir tambah hutang (`add_debt_form.dart`) sudah memiliki input untuk link pembayaran.
    4.  Memodifikasi `lib/screens/debt/debt_detail_screen.dart` untuk menampilkan `PayDebtForm` saat tombol "BAYAR CICILAN" ditekan.
    5.  Mengimplementasikan fungsi `url_launcher` pada tombol "LINK PEMBAYARAN" di dalam `PayDebtForm`.
    6.  Menyimpan perubahan dan memperbarui `blueprint.md`.

*   **Langkah Selanjutnya:** Menunggu arahan dari pengguna.
