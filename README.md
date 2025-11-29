# ✍️ FINOTE: Financial Note (Aplikasi Pencatat Keuangan)

Selamat datang di proyek **FINOTE**, sebuah aplikasi manajemen keuangan pribadi yang dibangun menggunakan framework **Flutter**. Aplikasi ini didesain dengan arsitektur yang bersih, modular, dan berfokus pada kemudahan pengembangan.

Untuk membantu pemula memahami struktur proyek, kami menggunakan analogi **"Restoran Digital"** yang berfungsi sebagai panduan arsitektur.

---

## 🍽️ 1. Kompleks Restoran: Struktur Folder Utama Proyek

Struktur folder utama adalah 'peta' dari seluruh proyek kita. Setiap folder adalah sebuah 'departemen' dengan fungsi spesifik.

| Folder/File | Analogi Restoran | Fungsi & Keterangan Rinci (Penting untuk Pemula) |
| :--- | :--- | :--- |
| **`android/`** | **Dapur Khusus Masakan Android 🤖** | Berisi semua konfigurasi (file Manifest, Gradles) agar kode Flutter dapat dikompilasi (diubah) menjadi file `.apk` dan berjalan sempurna di HP **Android**. Jika ada masalah izin (permissions) khusus Android, Anda akan bekerja di sini. |
| **`ios/`** | **Dapur Khusus Masakan Apple 🍎** | Sama seperti `android/`, tetapi untuk perangkat **iPhone/iPad** (iOS). Folder ini berisi konfigurasi Xcode dan izin Apple. Kita jarang menyentuhnya, kecuali saat akan *deploy* ke App Store. |
| **`lib/`** | **Ruang Utama & Resep Rahasia 🧑‍🍳 (Jantung Proyek)** | **99% dari kode aplikasi berada di sini.** Semua logika bisnis, tampilan antarmuka (UI), dan *State Management* (pengelolaan data) diatur di dalam folder ini. Inilah fokus utama kita. |
| **`assets/`** | **Gudang Dekorasi & Bahan Baku Statis ✨** | Tempat penyimpanan semua aset statis yang digunakan aplikasi, seperti: `images/` (logo, ikon, ilustrasi), `fonts/` (jenis huruf khusus), atau `files/` (data JSON lokal). **Aset tidak akan muncul jika tidak didaftarkan di `pubspec.yaml`.** |
| **`pubspec.yaml`** | **Daftar Belanja & Kontrak Proyek 📝** | **File PENTING.** Ini adalah *manifest* proyek. Di sini kita mencatat 1) **Dependencies** (library pihak ketiga seperti Firebase, penyedia font), 2) **Dev Dependencies** (alat bantu developer), dan 3) **Aset** yang didaftarkan dari folder `assets/`. |
| **`test/`** | **Ruang Uji Coba Masakan 🔬** | Berisi kode untuk pengujian (*Unit Testing* dan *Widget Testing*). Penting untuk memastikan setiap resep (fungsi kode) berjalan sesuai yang diharapkan dan tidak merusak resep lain. |

---

## 🔪 2. Membedah Ruang Utama: Isi Folder `lib/`

Folder **`lib/`** dibagi menjadi bagian-bagian yang sangat terstruktur untuk memisahkan tanggung jawab (prinsip *Separation of Concerns*).

### A. Pintu Masuk dan Kunci Utama

* **`main.dart` (Pintu Depan Restoran)**
    * **Tugas Utama:** File ini adalah titik awal eksekusi aplikasi (`void main()`).
    * **Fungsi Rinci:** Inisialisasi Firebase, menyiapkan *State Management* global (misalnya provider atau BLoC), dan menentukan rute awal (apakah pengguna diarahkan ke Login atau Home, tergantung status autentikasi).
* **`firebase_options.dart` (Kunci Keamanan)**
    * Berisi kode-kode inisialisasi yang menghubungkan aplikasi secara aman ke layanan **Google Firebase** (Firestore, Authentication, dll.).

### B. `core/`: Fondasi & Peralatan Dapur Universal 🔧

Berisi alat-alat yang berfungsi sebagai *shared resources* dan dapat diakses dari mana saja di aplikasi.

| Folder | Analogi Restoran | Fungsi Rinci dan Contoh Penggunaan |
| :--- | :--- | :--- |
| **`core/constants/`** | **Buku Catatan Tetap/Standar** | Menyimpan nilai-nilai yang tidak akan berubah: kode warna HEX utama (`AppColors`), *API Keys*, dan daftar statis seperti kategori transaksi standar (`Kategori.list`). |
| **`core/services/`** | **Pelayan Khusus/Petugas Logistik 🙋** | Berisi kelas-kelas yang menangani **interaksi eksternal**. Contoh: `firestore_service.dart` (mengirim/menerima data ke/dari database) atau `api_service.dart` (jika ada integrasi API pihak ketiga). |
| **`core/theme/`** | **Buku Dekorasi Standar** | Mendefinisikan `ThemeData` untuk aplikasi: gaya teks (`TextTheme`), warna tombol (`ButtonTheme`), dan skema warna gelap/terang. Memastikan tampilan konsisten di seluruh aplikasi. |
| **`core/utils/`** | **Alat Bantu Umum** | Fungsi-fungsi kecil yang membantu, seperti `formatCurrency()` atau `dateFormatter()`. |

### C. `features/`: Ruangan-Ruangan VIP (Fitur Modular) 🛋️

Implementasi dari prinsip modularitas. Setiap fitur memiliki ruangnya sendiri, yang biasanya dibagi lagi menjadi model, view, dan controller/logic.

| Folder Fitur | Analogi Restoran | Tanggung Jawab Utama |
| :--- | :--- | :--- |
| **`auth/`** | **Ruang Resepsionis** | Mengelola semua hal terkait pengguna: Pendaftaran, Login, Logout, Reset Password, dan penyimpanan status sesi pengguna. |
| **`home/`** | **Ruang Makan Utama (Dashboard)** | Menampilkan ringkasan data (saldo total, grafik mini), navigasi cepat, dan alur utama pengguna setelah berhasil login. |
| **`income/` & `expense/`** | **Kasir Pemasukan & Pengeluaran** | Fitur inti aplikasi. Mengelola *CRUD* (Create, Read, Update, Delete) untuk data transaksi, termasuk formulir input dan daftar riwayat transaksi. |
| **`ai_analysis/`** | **Ruang Konsultasi Keuangan 🧠** | Menangani logika analisis data. Di sinilah integrasi dengan **Gemini AI** akan ditempatkan untuk memberikan rekomendasi dan laporan keuangan yang mendalam. |
| **`settings/`** | **Ruang Manager** | Pengaturan aplikasi (tema, notifikasi, bahasa) dan manajemen akun pengguna (ubah profil/password). |

### D. `widgets/`: Perabotan Siap Pakai 🖼️

* Berisi komponen-komponen antarmuka (Widget) yang dapat digunakan **berulang kali** di berbagai fitur.
* **Tujuannya:** Menghindari pengulangan kode (*Don't Repeat Yourself / DRY*).
* **Contoh:** `CustomButton.dart`, `TransactionCard.dart`, `AppDrawer.dart`. Komponen ini hanya fokus pada tampilan dan menerima data untuk ditampilkan.

---

## 🧭 3. Alur Kerja & Ekosistem Data

Pahami bagaimana data bergerak di dalam aplikasi Anda:

1.  **Start:** Pengguna membuka aplikasi $\rightarrow$ **`main.dart`** jalan.
2.  **Tampilan:** Pengguna melihat `home_screen.dart` (di `features/home/`).
3.  **Aksi:** Pengguna menekan tombol "Tambah Pengeluaran".
4.  **Logika:** Form Pengeluaran (di `features/expense/`) mendapatkan input dari pengguna.
5.  **Penyimpanan:** Form memanggil fungsi `addData()` di **`core/services/firestore_service.dart`**.
6.  **Eksternal:** `firestore_service` mengirimkan data ke **Firebase** (database online).
7.  **Pembaharuan Tampilan:** Setelah data tersimpan, *State Management* memperbarui data yang ditampilkan di `home_screen.dart` secara otomatis.

---

## 🧑‍💻 Tips Cepat untuk Developer FINOTE

| Tugas yang Ingin Anda Lakukan | Lokasi File yang Perlu Anda Cari |
| :--- | :--- |
| **Mengubah Tampilan** (Layout, Warna Tombol) | File `_screen.dart` atau `_view.dart` di dalam folder **`features/nama_fitur/`**. |
| **Mengubah Cara Data Diambil/Disimpan** | Folder **`core/services/`** (contoh: `firestore_service.dart`). |
| **Membuat Komponen UI Baru yang Bisa Dipakai Ulang** | Folder **`widgets/`**. |
| **Menambah Pustaka/API Baru** | Edit file **`pubspec.yaml`**. |
| **Mengubah Warna/Font Global Aplikasi** | Folder **`core/theme/`**. |