# 💰 Fin-Resto: Aplikasi Manajemen Keuangan (Flutter)

Aplikasi Fin-Resto (Financial-Restoran) adalah solusi manajemen keuangan pribadi yang dibangun menggunakan **Flutter**. Proyek ini didesain dengan struktur yang modular dan rapi.

Untuk mempermudah pemahaman bagi pemula, kami menggunakan analogi **Restoran Digital** untuk menjelaskan setiap bagian dari proyek ini.

---

## 🍽️ 1. Peta Lokasi Restoran: Struktur Folder Utama

Bayangkan folder utama proyek ini sebagai **Kompleks Restoran** kita. Setiap folder memiliki fungsi dan tugasnya masing-masing.

| Folder/File | Analogi Restoran | Penjelasan untuk Pemula (Kenapa Penting?) |
| :--- | :--- | :--- |
| **`android/`** | **Dapur Khusus Masakan Android 🤖** | Ini adalah tempat konfigurasi agar aplikasi bisa jalan di HP **Android** (Samsung, Xiaomi, dll.). Flutter itu pintar, dia bisa membuat satu kode untuk Android dan iPhone. Folder ini berisi **bumbu-bumbu rahasia** agar kode kita 'matang' sempurna di Android. |
| **`lib/`** | **Ruang Utama & Resep Rahasia 🧑‍🍳** | **99% kode kita ada di sini!** Di sinilah kita 'memasak' tampilan (UI/UX), mengatur logika, dan alur aplikasi. Jika Anda ingin mengubah tampilan, ini adalah tempatnya. |
| **`assets/`** | **Gudang Dekorasi ✨** | Tempat menyimpan semua **dekorasi** restoran kita: gambar-gambar (logo, ikon), jenis huruf khusus (font), atau file lain yang dipakai untuk mempercantik aplikasi. |
| **`pubspec.yaml`** | **Daftar Belanja 📝** | **File Paling Penting!** Di sini kita mencatat semua **bahan-bahan tambahan** (disebut *libraries* atau *dependencies*) yang kita butuhkan. Contoh: "Saya butuh `firebase_auth` untuk login", "Saya butuh `google_fonts` untuk tulisan bagus". Kalau tidak dicatat di sini, aplikasi tidak bisa menggunakan fitur itu. |
| **`firebase_options.dart`** | **Kunci Keamanan / Kartu Akses 🔑** | Dibuat otomatis saat kita menghubungkan aplikasi ke Google Firebase. Isinya adalah kode rahasia agar aplikasi kita **boleh** berbicara dan bertukar data dengan database online (server Firebase). |

---

## 🔪 2. Bedah Jantung Aplikasi: Isi Folder `lib/`

Folder **`lib/`** adalah **Jantung** dari seluruh aplikasi kita. Di dalamnya terdapat pembagian tugas yang sangat rapi.

### A. `main.dart`: Pintu Depan 🚪

* **Pintu Depan Restoran.**
* Ini adalah file yang **pertama kali dibuka** saat pengguna menekan ikon aplikasi.
* Tugasnya: **Menyambut** pengguna. Mengecek apakah pengguna sudah login atau belum, lalu mengarahkan mereka ke ruangan yang tepat (ke **`Login Screen`** atau langsung ke **`Home Screen`**).

### B. `core/`: Peralatan Dapur Umum 🔧

Berisi alat-alat dasar yang **bisa dipakai oleh siapa saja** di seluruh aplikasi.

* **`core/constants/` (Buku Catatan Tetap):**
    * Isinya hal-hal yang tidak pernah berubah: **warna-warna utama** aplikasi (misalnya warna biru untuk tombol), daftar nama kategori yang sudah pasti (`Gaji`, `Tagihan`), atau ukuran margin standar.
* **`core/services/` (Pelayan Khusus 🙋):**
    * Contohnya `firestore_service.dart`. Pelayan ini punya **satu tugas khusus**: bolak-balik mengambil data dari database online (**Firebase**) dan memberikannya ke tampilan aplikasi. Halaman lain **tidak perlu pusing** memikirkan cara mengambil data, cukup panggil pelayan ini.
* **`core/theme/` (Buku Dekorasi Standar):**
    * Mengatur gaya tulisan (font), warna tombol, dan tema gelap/terang secara **global** (berlaku untuk seluruh aplikasi).

### C. `features/`: Ruangan-Ruangan VIP (Berdasarkan Fitur) 🛋️

Ini adalah bagian paling rapi. Aplikasi dibagi berdasarkan **Fitur**, di mana setiap fitur memiliki ruang (folder) sendiri agar kodenya tidak campur aduk (disebut *Modular*).

| Folder Fitur | Analogi Restoran | Fungsi Utama (Apa yang Dilakukan?) |
| :--- | :--- | :--- |
| **`auth/`** | **Ruang Resepsionis** | Mengurus pendaftaran tamu. Berisi halaman **Login**, **Daftar** (Sign-up), dan **Lupa Password** (mengurus autentikasi pengguna). |
| **`home/`** | **Ruang Makan Utama** | Tampilan awal setelah login. Menampilkan ringkasan saldo, dashboard, dan menu utama yang bisa diklik. |
| **`income/` & `expense/`** | **Kasir Pemasukan & Pengeluaran** | Tempat mencatat uang masuk dan keluar. Berisi halaman **form input** untuk memasukkan angka, memilih kategori, dan menyimpan data transaksi. |
| **`ai_analysis/`** | **Ruang Konsultasi 🧠** | Fitur pintar aplikasi. Berisi halaman **laporan keuangan** (`financial_report_screen.dart`) yang nanti akan kita hubungkan dengan **AI (Gemini)** untuk memberikan saran keuangan. |
| **`settings/`** | **Ruang Manager** | Tempat mengatur profil, ganti password, atau keluar dari akun (logout). |

### D. `widgets/`: Perabotan Kecil 🖼️

* Berisi komponen-komponen tampilan kecil yang **dipakai berulang-ulang**.
* **Contoh:** Kita membuat desain "Kartu Transaksi" (`transaction_card.dart`) yang cantik **satu kali**. Daripada mengkode ulang di halaman Home, Pemasukan, dan Pengeluaran, kita cukup **memanggil** widget ini dan memasangnya di mana-mana. Ini membuat kode kita **hemat waktu dan konsisten** (tidak ada desain yang berbeda).

---

## 🚀 3. Ringkasan Alur Kerja Cepat

Ini adalah langkah-langkah yang terjadi di balik layar saat aplikasi digunakan:

1.  **Buka Aplikasi:** $\rightarrow$ File **`main.dart`** jalan.
2.  **Cek Login:** $\rightarrow$ Jika belum, diarahkan ke **`features/auth/login_screen.dart`**.
3.  **Login Berhasil:** $\rightarrow$ Masuk ke **`features/home/home_screen.dart`**.
4.  **Mau Catat Gaji?** $\rightarrow$ Klik tombol tambah $\rightarrow$ Muncul form di **`features/income/add_income_form.dart`** (yang menggunakan perabotan dari `widgets/`).
5.  **Simpan Data:** $\rightarrow$ Form memanggil **Pelayan Khusus** di **`core/services/firestore_service.dart`** $\rightarrow$ Data dikirim ke server Firebase.
6.  **Mau Lihat Laporan?** $\rightarrow$ Masuk ke **`features/ai_analysis/financial_report_screen.dart`**.

---

## 🛠️ Kesimpulan Praktis: Tips untuk Pemula

| Jika Anda Ingin... | Cari File di Folder... |
| :--- | :--- |
| **Mengubah Tampilan** (Warna, Posisi Tombol, Layout) | **`features/nama_fitur/`** (Contoh: `home/home_screen.dart`). |
| **Mengubah Logika Data** (Cara simpan ke database) | **`core/services/`** (Contoh: `firestore_service.dart`). |
| **Menambah Library/Fitur Baru** | Edit file **`pubspec.yaml`**. |
| **Mengubah Desain Komponen Kecil** (Contoh: Kartu Transaksi) | **`widgets/`**. |