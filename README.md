# BoboNyenyak

**BoboNyenyak** merupakan aplikasi mobile yang dirancang untuk membantu orang tua dan pengasuh dalam memantau, mencatat, serta memahami pola tidur bayi. Aplikasi ini menyediakan fitur pelacakan tidur, riwayat tidur, ringkasan harian, dan visualisasi tren tidur untuk mendukung pemantauan rutinitas tidur bayi.

Dikembangkan menggunakan **Flutter** dan **Dart**, BoboNyenyak mengintegrasikan **Firebase Authentication** untuk autentikasi pengguna dan **Cloud Firestore** sebagai basis data untuk penyimpanan serta sinkronisasi data secara real-time.

---

## Daftar Isi

- [Gambaran Umum Proyek](#gambaran-umum-proyek)
- [Anggota Tim](#anggota-tim)
- [Fitur Aplikasi](#fitur-aplikasi)
- [Teknologi yang Digunakan](#teknologi-yang-digunakan)
- [Struktur Branch Pengembangan](#struktur-branch-pengembangan)
- [Struktur Direktori](#struktur-direktori)
- [Panduan Instalasi](#panduan-instalasi)
- [Status Pengembangan](#status-pengembangan)
- [Roadmap Penyempurnaan UI](#roadmap-penyempurnaan-ui)
- [Catatan Pengembangan](#catatan-pengembangan)

---

## Gambaran Umum Proyek

BoboNyenyak dikembangkan sebagai aplikasi pendamping bagi orang tua dan pengasuh untuk mencatat serta memantau aktivitas tidur bayi.

Pengembangan aplikasi berfokus pada tiga aspek utama:

- **Pelacakan Tidur:** Mencatat sesi tidur bayi secara real-time maupun manual.
- **Pemantauan Tidur:** Menampilkan riwayat tidur dan ringkasan durasi tidur harian.
- **Analisis Pola Tidur:** Menyajikan visualisasi tren tidur serta perbandingan durasi tidur dengan rekomendasi berdasarkan kelompok usia bayi.

Aplikasi ini ditujukan untuk keperluan pencatatan dan pemantauan, bukan sebagai alat diagnosis medis.

---

## Anggota Tim

**Kelompok 11 — The Winner**

| Nama                     | Peran              | GitHub                                                         |
| ------------------------ | ------------------ | -------------------------------------------------------------- |
| Abid Zhorif Adi Winata   | Project Manager    | [@Joripcast](https://github.com/Joripcast)                     |
| Rayyan Aulia Rifai Putra | UI/UX Designer     | [@auliarayyan3-create](https://github.com/auliarayyan3-create) |
| Muhammad Chairul Sholeh  | Frontend Developer | [@chrulls85](https://github.com/chrulls85)                     |
| Kevin Yulian Pamungkas   | Backend Developer  | [@kvinn-dev](https://github.com/kvinn-dev)                     |

---

## Fitur Aplikasi

### 1. Autentikasi dan Manajemen Pengguna

- Registrasi dan login menggunakan Firebase Authentication.
- Splash screen dan pemeriksaan status autentikasi.
- Pengelolaan sesi pengguna.
- Pemulihan kata sandi melalui email.
- Sinkronisasi profil pengguna dengan Cloud Firestore.
- Validasi formulir dan penanganan kesalahan autentikasi.

### 2. Manajemen Profil Bayi

- Membuat dan mengelola profil bayi.
- Menyimpan informasi bayi pada koleksi `babyProfiles`.
- Mengubah nama dan tanggal lahir bayi.
- Menggunakan profil bayi aktif untuk fitur pelacakan dan pemantauan tidur.

### 3. Pelacakan Tidur Real-Time

- Melacak sesi tidur menggunakan timer interaktif.
- Menampilkan durasi tidur secara langsung.
- Memvisualisasikan progres pencapaian target tidur harian.
- Mencatat waktu mulai tidur dan waktu bangun.
- Menghitung durasi tidur secara otomatis.

### 4. Pencatatan Tidur Manual

- Menambahkan catatan tidur secara manual.
- Memilih waktu mulai dan selesai tidur menggunakan Time Picker.
- Menghitung durasi tidur secara otomatis.
- Menambahkan tag kondisi tidur:
  - Deep Sleep
  - Disturbed
  - Breastfeeding
  - Colic
  - White Noise
- Menambahkan catatan tambahan pada setiap sesi tidur.

### 5. Riwayat Tidur

- Menampilkan sesi tidur berdasarkan tanggal.
- Mengelompokkan catatan tidur untuk memudahkan navigasi.
- Melihat durasi dan detail setiap sesi tidur.
- Menghapus catatan tidur yang tersimpan.

### 6. Ringkasan Tidur Harian

- Menghitung total durasi tidur harian.
- Menampilkan persentase pencapaian target tidur.
- Menampilkan jumlah sesi tidur.
- Memisahkan ringkasan tidur siang dan malam.
- Menyesuaikan rekomendasi kebutuhan tidur berdasarkan kelompok usia bayi.

### 7. Tren Tidur

- Menampilkan grafik durasi tidur selama tujuh hari.
- Memvisualisasikan jendela tidur dan timeline sirkadian.
- Menyajikan analisis stabilitas pola tidur.
- Menampilkan disclaimer nonmedis pada halaman tren tidur.

### 8. Pengaturan dan Profil

- Melihat dan mengubah profil pengasuh.
- Mengelola profil bayi aktif.
- Mengatur pengingat pencatatan tidur.
- Melihat dan mengelola pengaturan izin notifikasi.
- Mengubah tema aplikasi antara Light Mode dan Dark Mode.
- Melihat status sinkronisasi serta jumlah catatan tidur pada cache lokal.
- Melakukan sinkronisasi data secara manual.
- Mengakses informasi batasan medis dan kebijakan privasi.
- Keluar dari akun dengan konfirmasi.

### 9. Light Mode dan Dark Mode

- Pengelolaan tema global secara reaktif menggunakan `AppThemeMode` dan `ChangeNotifier`.
- Pemetaan warna dinamis melalui `BoboColors.of(context)`.
- Penyediaan palet warna terpisah untuk Light Mode dan Dark Mode.
- Penerapan konfigurasi tema pada seluruh halaman dan komponen aplikasi.

**Palet Light Mode**

| Elemen       | Warna     |
| ------------ | --------- |
| Background   | `#F6F8FC` |
| Card         | `#FFFFFF` |
| Border       | `#E2E8F0` |
| Primary Text | `#1B2A4A` |

**Palet Dark Mode**

| Elemen       | Warna     |
| ------------ | --------- |
| Background   | `#0F1528` |
| Card         | `#182238` |
| Border       | `#1E2846` |
| Primary Text | `#FFFFFF` |

---

## Teknologi yang Digunakan

| Kategori           | Teknologi                                     |
| ------------------ | --------------------------------------------- |
| Framework          | Flutter                                       |
| Bahasa Pemrograman | Dart                                          |
| Autentikasi        | Firebase Authentication                       |
| Basis Data         | Cloud Firestore                               |
| State Management   | StatefulWidget, StreamBuilder, ChangeNotifier |
| Theming            | ThemeData, AppThemeMode, BoboColors           |
| Sinkronisasi Data  | Firestore Real-time Streams                   |
| Arsitektur         | Modular Feature-First                         |
| Version Control    | Git dan GitHub                                |

---

## Struktur Branch Pengembangan

Pengembangan aplikasi menggunakan pendekatan _feature-based branching_ untuk memisahkan pengerjaan fitur berdasarkan tanggung jawab masing-masing modul.

| Branch                            | Fokus Pengembangan                                               |
| --------------------------------- | ---------------------------------------------------------------- |
| `feature/auth-user-management`    | Autentikasi dan manajemen pengguna                               |
| `feature/sleep-tracker`           | Pelacakan tidur, pencatatan manual, riwayat, dan ringkasan tidur |
| `feature/sleep-trends`            | Visualisasi grafik, analisis stabilitas, dan timeline sirkadian  |
| `feature/settings-and-theme-mode` | Pengaturan, manajemen profil, serta sistem Light/Dark Mode       |

### `feature/auth-user-management`

Berfokus pada implementasi autentikasi dan pengelolaan akun pengguna.

- Registrasi dan login pengguna.
- Splash screen dan pemeriksaan status autentikasi.
- Pemulihan kata sandi.
- Sinkronisasi profil pengguna ke `users/{uid}`.
- Validasi formulir dan penanganan kesalahan autentikasi.

### `feature/sleep-tracker`

Berfokus pada implementasi fitur utama pencatatan dan pemantauan tidur bayi.

- Pelacakan tidur secara real-time.
- Pencatatan tidur secara manual.
- Perhitungan durasi tidur otomatis.
- Pengelolaan tag kondisi dan catatan tambahan.
- Pengelolaan riwayat tidur.
- Perhitungan target kebutuhan tidur berdasarkan usia bayi.
- Agregasi dan visualisasi ringkasan tidur harian.

### `feature/sleep-trends`

Berfokus pada visualisasi dan analisis pola tidur bayi.

- Grafik durasi tidur selama tujuh hari.
- Visualisasi jendela tidur.
- Timeline sirkadian.
- Analisis stabilitas pola tidur.
- Disclaimer nonmedis.

### `feature/settings-and-theme-mode`

Berfokus pada halaman pengaturan dan penerapan sistem tema ganda.

- Pengelolaan profil pengasuh dan bayi.
- Pengaturan pengingat dan sinkronisasi.
- Pengelolaan state tema global menggunakan `AppThemeMode`.
- Utilitas warna dinamis menggunakan `BoboColors`.
- Konfigurasi `ThemeData` untuk Light Mode dan Dark Mode.
- Penerapan tema pada seluruh halaman dan komponen aplikasi.

---

## Struktur Direktori

Struktur direktori aplikasi disusun secara modular untuk memisahkan tanggung jawab antara halaman, layanan, model, konfigurasi, dan komponen yang dapat digunakan kembali.

```text
BoBoNyenyak/
├── assets/
│   └── icons/
├── lib/
│   ├── config/
│   │   ├── app_theme.dart
│   │   └── bobo_colors.dart
│   ├── models/
│   ├── screens/
│   │   ├── auth/
│   │   ├── tracker/
│   │   ├── history/
│   │   ├── trends/
│   │   ├── settings/
│   │   └── splash/
│   ├── services/
│   ├── widgets/
│   ├── firebase_options.dart
│   └── main.dart
├── android/
├── ios/
├── firebase.json
├── firestore.rules
├── firestore.indexes.json
├── pubspec.yaml
└── README.md
```

---

## Panduan Instalasi

### Prasyarat

Pastikan perangkat pengembangan telah memiliki:

- Flutter SDK.
- Dart SDK.
- Android Studio atau perangkat Android.
- Xcode untuk pengembangan iOS pada macOS.
- Firebase CLI.
- Firebase project yang telah dikonfigurasi.

### 1. Clone Repository

```bash
git clone https://github.com/Thee-Winner/BoBoNyenyak.git

cd BoBoNyenyak
```

### 2. Install Dependencies

Jalankan perintah berikut untuk mengunduh seluruh dependensi proyek:

```bash
flutter pub get
```

### 3. Konfigurasi Firebase

Pastikan aplikasi terhubung dengan Firebase project yang sesuai.

File konfigurasi Firebase yang digunakan meliputi:

- `lib/firebase_options.dart`
- `firebase.json`
- `.firebaserc`
- `firestore.rules`
- `firestore.indexes.json`

Untuk menghubungkan proyek dengan Firebase pada lingkungan lokal baru, gunakan FlutterFire CLI:

```bash
dart pub global activate flutterfire_cli

flutterfire configure
```

Pastikan konfigurasi yang dihasilkan sesuai dengan Firebase project yang digunakan aplikasi.

### 4. Deploy Firestore Rules

Apabila diperlukan, jalankan perintah berikut untuk melakukan deployment Firestore Security Rules:

```bash
firebase login

firebase deploy --only firestore:rules --project <project-id>
```

Ganti `<project-id>` dengan ID Firebase project yang digunakan.

### 5. Jalankan Aplikasi

Setelah seluruh konfigurasi selesai, jalankan aplikasi menggunakan:

```bash
flutter run
```

---

## Status Pengembangan

| Modul                              | Status Fungsional | Status UI/UX  |
| ---------------------------------- | ----------------- | ------------- |
| Autentikasi dan Manajemen Pengguna | Selesai           | Selesai       |
| Profil Pengasuh                    | Selesai           | Selesai       |
| Profil Bayi                        | Selesai           | Selesai       |
| Real-time Sleep Tracker            | Selesai           | Selesai       |
| Pencatatan Tidur Manual            | Selesai           | Selesai       |
| Ringkasan Tidur Harian             | Selesai           | Selesai       |
| Riwayat Tidur                      | Selesai           | Selesai       |
| Tren Tidur                         | Selesai           | Penyempurnaan |
| Pengaturan dan Profil              | Selesai           | Penyempurnaan |
| Light Mode dan Dark Mode           | Diimplementasikan | Penyempurnaan |

Fitur utama aplikasi telah diimplementasikan. Fokus pengembangan selanjutnya mencakup integrasi backend, pengambilan data, sinkronisasi real-time, serta penyempurnaan tampilan dan pengalaman pengguna.

---

## Roadmap Penyempurnaan UI

Meskipun fitur utama telah diimplementasikan, masih terdapat beberapa aspek tampilan dan pengalaman pengguna yang direncanakan untuk disempurnakan.

- [ ] **Konsistensi Spacing dan Padding:** Menyeragamkan jarak antar-elemen menggunakan token spacing.
- [ ] **Tipografi:** Meninjau ukuran, ketebalan, dan hierarki teks pada seluruh halaman.
- [ ] **Animasi Mikro:** Menambahkan transisi yang lebih halus pada tombol, kartu, switch, dan navigasi.
- [ ] **Ikonografi:** Menyeragamkan gaya dan ukuran ikon.
- [ ] **Aksesibilitas Warna:** Memastikan kontras teks dan latar belakang pada Light Mode maupun Dark Mode.
- [ ] **Empty State dan Loading State:** Menyempurnakan tampilan ketika data kosong atau sedang dimuat.
- [ ] **Responsivitas:** Menyesuaikan tata letak untuk berbagai ukuran layar.
- [ ] **Microcopy:** Meninjau ulang teks pada dialog, SnackBar, dan label aplikasi.
- [ ] **Penyempurnaan Dark Mode:** Meninjau penggunaan shadow, border, dan elevation.
- [ ] **Visual Quality Assurance:** Melakukan pengujian tampilan pada perangkat fisik iOS dan Android.

Roadmap ini merupakan dokumen yang akan terus diperbarui seiring berjalannya proses penyempurnaan aplikasi.

---

## Catatan Pengembangan

- BoboNyenyak merupakan aplikasi pendamping untuk pencatatan dan pemantauan pola tidur bayi, bukan alat diagnosis medis.
- Rekomendasi durasi tidur digunakan sebagai referensi informasi berdasarkan kelompok usia bayi.
- Data pengguna dan profil bayi dikelola melalui Firebase Authentication dan Cloud Firestore.
- Keamanan akses data diterapkan menggunakan Firestore Security Rules.
- Sistem tema ganda menggunakan `AppThemeMode` dan `BoboColors` untuk mengelola perubahan warna aplikasi secara dinamis.

---

**Dikembangkan oleh The Winner — Kelompok 11**
