# BoboNyenyak

**BoboNyenyak** adalah aplikasi mobile pendamping pengasuh (_caregiver_) untuk membantu memantau, mencatat, dan memahami pola tidur bayi. Aplikasi ini dirancang untuk memudahkan orang tua dalam mencatat aktivitas tidur, melihat riwayat istirahat, serta membandingkan total durasi tidur harian dengan rekomendasi kebutuhan tidur berdasarkan kelompok usia bayi.

Proyek ini dikembangkan menggunakan **Flutter** dan **Dart**, dengan integrasi backend **Firebase Authentication** untuk autentikasi pengguna dan **Cloud Firestore** sebagai penyimpanan data secara realtime.

---

## Daftar Isi

- [Anggota Kelompok](#anggota-kelompok)
- [Fitur Aplikasi](#fitur-aplikasi)
- [Struktur Branch Pengembangan](#struktur-branch-pengembangan)
- [Status Pengembangan](#status-pengembangan)
- [Tech Stack](#tech-stack)
- [Struktur Direktori](#struktur-direktori)
- [Panduan Instalasi](#panduan-instalasi)

---

## Anggota Kelompok

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

- [x] Registrasi dan login menggunakan Firebase Authentication (Email & Password).
- [x] Splash screen dengan pemeriksaan status autentikasi pengguna.
- [x] Fitur logout dan pengelolaan sesi pengguna.
- [x] Reset kata sandi melalui email (_Forgot Password_).
- [x] Sinkronisasi informasi profil pengguna ke Cloud Firestore.
- [x] Validasi input dan penanganan pesan kesalahan autentikasi.

### 2. Manajemen Profil Bayi

- [x] Pembuatan dan pengelolaan profil bayi.
- [x] Penyimpanan informasi bayi pada koleksi `babyProfiles`.
- [x] Penggunaan profil bayi sebagai dasar pencatatan dan pemantauan tidur.

### 3. Sleep Tracker

- [x] Pelacakan aktivitas tidur secara realtime menggunakan timer.
- [x] Indikator durasi tidur berjalan (_live sleep counter_).
- [x] Circular progress untuk visualisasi pencapaian target tidur.
- [x] Pencatatan waktu mulai tidur dan konfirmasi waktu bangun.
- [x] Perhitungan durasi tidur secara otomatis.

### 4. Pencatatan Tidur Manual

- [x] Input waktu mulai tidur dan waktu bangun menggunakan _Time Picker_.
- [x] Perhitungan durasi tidur otomatis berdasarkan waktu yang dimasukkan.
- [x] Penambahan tag kondisi atau faktor selama sesi tidur, meliputi:
  - Tidur Nyenyak
  - Terganggu
  - Menyusu
  - Kolik
  - White Noise
- [x] Catatan tambahan untuk informasi terkait sesi tidur.

### 5. Sleep History

- [x] Penyajian riwayat tidur berdasarkan tanggal.
- [x] Pengelompokan catatan tidur untuk memudahkan penelusuran.
- [x] Informasi durasi dan kondisi setiap sesi tidur.
- [x] Penghapusan catatan tidur.

### 6. Daily Sleep Summary

- [x] Agregasi total durasi tidur harian.
- [x] Perhitungan persentase pencapaian target tidur.
- [x] Informasi jumlah sesi tidur.
- [x] Pemisahan ringkasan tidur malam dan tidur siang.
- [x] Penyesuaian rekomendasi kebutuhan tidur berdasarkan kelompok usia bayi.

### 7. Sleep Trends

- [ ] Visualisasi grafik durasi tidur harian, mingguan, dan bulanan.
- [ ] Analisis konsistensi pola tidur bayi.
- [ ] Perbandingan perkembangan durasi tidur berdasarkan periode waktu.

### 8. Settings and Profile

- [ ] Pengaturan preferensi aplikasi.
- [ ] Pengelolaan informasi profil pengguna dan bayi.
- [ ] Pengaturan notifikasi aplikasi.

---

## Struktur Branch Pengembangan

Pengembangan aplikasi dilakukan menggunakan pendekatan _feature-based branching_ untuk memisahkan pengerjaan fitur berdasarkan tanggung jawab masing-masing modul.

| Branch                         | Fokus Pengembangan                                               |
| ------------------------------ | ---------------------------------------------------------------- |
| `feature/auth-user-management` | Autentikasi dan manajemen pengguna                               |
| `feature/sleep-tracker`        | Pelacakan tidur, pencatatan manual, riwayat, dan ringkasan tidur |

### `feature/auth-user-management`

Berfokus pada implementasi autentikasi dan pengelolaan akun pengguna menggunakan Firebase Authentication dan Cloud Firestore.

Cakupan pengembangan:

- Registrasi dan login pengguna.
- Splash screen dan pemeriksaan sesi autentikasi.
- Reset kata sandi.
- Sinkronisasi profil pengguna ke koleksi `users/{uid}`.
- Validasi formulir dan penanganan kesalahan autentikasi.

### `feature/sleep-tracker`

Berfokus pada implementasi fitur utama pemantauan dan pencatatan pola tidur bayi.

Cakupan pengembangan:

- Realtime sleep tracking menggunakan timer.
- Pencatatan tidur manual dan konfirmasi waktu bangun.
- Perhitungan durasi tidur otomatis.
- Pengelolaan tag kondisi dan catatan tambahan.
- Riwayat tidur berdasarkan tanggal.
- Perhitungan target kebutuhan tidur berdasarkan usia bayi.
- Agregasi dan visualisasi ringkasan tidur harian.
- Implementasi struktur kode modular dan reusable widgets.

---

## Status Pengembangan

| Modul                   | Status             |
| ----------------------- | ------------------ |
| Autentikasi dan Akun    | Selesai            |
| Profil Pengguna         | Selesai            |
| Profil Bayi             | Selesai            |
| Realtime Sleep Tracker  | Selesai            |
| Pencatatan Tidur Manual | Selesai            |
| Daily Sleep Summary     | Selesai            |
| Sleep History           | Selesai            |
| Sleep Trends            | Dalam Pengembangan |
| Settings and Profile    | Direncanakan       |

---

## Tech Stack

| Kategori             | Teknologi                     |
| -------------------- | ----------------------------- |
| Framework            | Flutter                       |
| Programming Language | Dart                          |
| Authentication       | Firebase Authentication       |
| Database             | Cloud Firestore               |
| State Management     | StatefulWidget, StreamBuilder |
| Data Synchronization | Firestore Realtime Streams    |
| Architecture         | Modular Feature-First         |
| Version Control      | Git & GitHub                  |

---

## Struktur Direktori

Struktur direktori aplikasi disusun menggunakan pendekatan modular agar pemisahan tanggung jawab antarfitur lebih terorganisasi.

```text
BoBoNyenyak/
├── assets/
│   └── icons/
├── lib/
│   ├── config/
│   │   └── app_theme.dart
│   ├── models/
│   ├── screens/
│   │   ├── auth/
│   │   ├── tracker/
│   │   ├── history/
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
- Xcode untuk pengembangan iOS (macOS).
- Android Studio atau perangkat Android untuk pengembangan Android.
- Firebase project yang telah dikonfigurasi.

### 1. Clone Repository

```bash
git clone https://github.com/<owner>/BoBoNyenyak.git

cd BoBoNyenyak
```

### 2. Konfigurasi Environment

Buat file `.env` pada root project dan sesuaikan variabel konfigurasi Firebase yang digunakan oleh aplikasi.

```env
FIREBASE_API_KEY=your_api_key
FIREBASE_APP_ID=your_app_id
FIREBASE_PROJECT_ID=your_project_id
FIREBASE_MESSAGING_SENDER_ID=your_sender_id
```

Sesuaikan nama variabel dengan implementasi pada `firebase_options.dart`.

Pastikan file `.env` terdaftar sebagai asset pada `pubspec.yaml` dan tidak diunggah ke repository publik.

### 3. Konfigurasi Firebase

Pastikan aplikasi telah terhubung dengan Firebase project yang sesuai.

File konfigurasi yang diperlukan:

- `lib/firebase_options.dart`
- `firebase.json`
- `.firebaserc`
- `firestore.rules`
- `firestore.indexes.json`

Untuk melakukan deployment Firestore Rules:

```bash
firebase login

firebase deploy --only firestore:rules --project <project-id>
```

### 4. Install Dependencies

```bash
flutter pub get
```

### 5. Jalankan Aplikasi

```bash
flutter run
```

---

## Catatan Pengembangan

- BoboNyenyak merupakan aplikasi pendamping pencatatan dan pemantauan pola tidur bayi, bukan alat diagnosis medis.
- Rekomendasi durasi tidur digunakan sebagai acuan informasi berdasarkan kelompok usia bayi.
- Data pengguna dan profil bayi dikelola secara personal menggunakan Firebase Authentication dan Cloud Firestore.
- Keamanan akses data diterapkan melalui Firestore Security Rules.

---

**Developed by The Winner — Group 11**
