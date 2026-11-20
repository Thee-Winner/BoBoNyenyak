# Product Requirements Document (PRD)

# BoboNyenyak

| Informasi         | Detail                                                                    |
| ----------------- | ------------------------------------------------------------------------- |
| Nama Produk       | BoboNyenyak                                                               |
| Deskripsi Singkat | Aplikasi mobile pendamping pencatatan dan pemantauan rutinitas tidur bayi |
| Kategori          | M-Information                                                             |
| Kelompok          | The Winner (11)                                                           |
| Mata Kuliah       | CPA560 – Perancangan Aplikasi Mobile                                      |
| Institusi         | Universitas Esa Unggul                                                    |
| Versi Dokumen     | 1.0                                                                       |
| Status            | Draft dokumentasi produk                                                  |

---

## 1. Ringkasan Produk

BoboNyenyak merupakan aplikasi mobile yang dirancang untuk membantu orang tua atau pengasuh utama bayi mencatat waktu mulai tidur dan waktu bangun, menyimpan riwayat tidur, serta memahami pola dan konsistensi tidur bayi melalui informasi yang disajikan secara sederhana.

Aplikasi ini berfokus pada penyediaan informasi rutinitas tidur bayi agar pengasuh dapat meninjau catatan berdasarkan tanggal dan melihat rangkuman pola tidur dari data yang telah dicatat. BoboNyenyak juga dirancang untuk mendukung pencatatan ketika koneksi internet tidak tersedia, sehingga aktivitas pencatatan tidak sepenuhnya bergantung pada koneksi jaringan.

BoboNyenyak merupakan aplikasi pendamping nonklinis. Informasi yang ditampilkan bertujuan membantu pengasuh memantau kebiasaan tidur bayi dan tidak dimaksudkan untuk menggantikan konsultasi dengan dokter atau tenaga kesehatan profesional.

## 2. Latar Belakang dan Permasalahan

Pemantauan rutinitas tidur bayi membutuhkan pencatatan waktu tidur dan waktu bangun secara berulang. Dalam praktiknya, orang tua atau pengasuh dapat mengandalkan ingatan atau pencatatan sederhana pada perangkat pribadi. Cara tersebut dapat menyulitkan pengasuh ketika ingin melihat kembali riwayat, mengetahui durasi tidur, atau memahami pola tidur berdasarkan catatan dari beberapa hari.

Hasil survei awal terhadap empat pengasuh utama bayi menunjukkan beberapa kondisi berikut:

- Tiga dari empat responden mengandalkan ingatan untuk memantau rutinitas tidur bayi, sedangkan satu responden menggunakan Notes atau perangkat ponsel.
- Frekuensi pencatatan berbeda-beda; tidak semua responden mencatat setiap aktivitas tidur dan bangun.
- Tiga dari empat responden menyebut rasa mengantuk sebagai salah satu hambatan ketika melakukan pencatatan pada malam atau dini hari.
- Informasi yang ingin dilihat kembali meliputi durasi tidur, waktu mulai tidur dan bangun, pola harian, serta perbandingan antarhari.
- Visualisasi pola tidur menjadi salah satu fitur yang dianggap dibutuhkan oleh responden.

Temuan tersebut digunakan sebagai dasar awal dalam merumuskan kebutuhan dan arah desain BoboNyenyak. Karena jumlah responden terbatas, hasil survei tidak digunakan untuk menyimpulkan kondisi seluruh orang tua atau pengasuh bayi.

## 3. Tujuan Produk

BoboNyenyak dikembangkan dengan tujuan:

1. Membantu pengasuh mencatat waktu mulai tidur dan waktu bangun bayi secara lebih terstruktur.
2. Menyediakan riwayat tidur yang dapat ditinjau kembali berdasarkan tanggal.
3. Menyajikan informasi pola dan konsistensi tidur berdasarkan catatan yang tersedia.
4. Mengurangi ketergantungan pada ingatan atau catatan manual yang tersebar.
5. Mendukung pencatatan dan peninjauan data inti ketika koneksi internet tidak tersedia.
6. Memberikan pengalaman penggunaan yang sederhana dan sesuai dengan kebutuhan pengasuh dalam aktivitas sehari-hari.

## 4. Target Pengguna

### 4.1 Pengguna Utama — Pengasuh Utama

Pengguna utama BoboNyenyak adalah ibu, ayah, atau anggota keluarga yang aktif merawat dan memantau rutinitas tidur bayi.

Karakteristik dan kebutuhan:

- Memerlukan cara praktis untuk mencatat waktu tidur dan bangun bayi.
- Membutuhkan riwayat pencatatan yang mudah ditemukan kembali.
- Ingin melihat durasi dan pola tidur berdasarkan data yang telah dicatat.
- Dapat melakukan pencatatan pada malam atau dini hari, termasuk ketika sedang mengantuk atau terburu-buru.
- Memiliki tingkat literasi digital yang beragam.

## 5. Nilai dan Manfaat Produk

BoboNyenyak menawarkan nilai utama berupa pencatatan rutinitas tidur bayi yang terstruktur dan penyajian informasi yang mudah ditinjau kembali.

Manfaat yang dituju:

- **Pencatatan lebih terstruktur:** waktu mulai tidur dan bangun disimpan sebagai catatan yang dapat ditinjau kembali.
- **Riwayat lebih mudah diakses:** pengasuh dapat melihat catatan tidur berdasarkan tanggal.
- **Pemahaman pola melalui informasi:** data yang telah dicatat disajikan dalam bentuk visualisasi dan ringkasan.
- **Dukungan saat offline:** pencatatan inti dirancang tetap dapat dilakukan tanpa koneksi internet, kemudian disinkronkan ketika koneksi tersedia.
- **Penggunaan yang praktis:** alur pencatatan dan navigasi dirancang agar mudah dipahami serta tidak menambah langkah yang tidak diperlukan.

## 6. Ruang Lingkup Produk

### 6.1 Fitur Utama — Must Have

Fitur berikut merupakan bagian utama dari ruang lingkup produk:

| Fitur                                | Deskripsi                                                                                                                    |
| ------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------- |
| Registrasi dan Login                 | Memungkinkan pengasuh membuat akun dan masuk ke aplikasi.                                                                    |
| Pengelolaan Profil Bayi              | Memungkinkan pengasuh membuat dan memperbarui profil bayi yang dipantau.                                                     |
| Pencatatan Tidur                     | Memungkinkan pengasuh mencatat waktu mulai tidur dan waktu bangun, baik melalui aksi mulai/akhiri maupun input waktu manual. |
| Perhitungan Durasi                   | Menghitung durasi tidur berdasarkan waktu mulai dan waktu selesai.                                                           |
| Riwayat Tidur                        | Menampilkan daftar catatan tidur berdasarkan tanggal beserta waktu dan durasinya.                                            |
| Visualisasi Pola Tidur               | Menampilkan grafik atau ringkasan pola dan konsistensi berdasarkan data tidur yang tersedia.                                 |
| Penyimpanan Offline dan Sinkronisasi | Memungkinkan pencatatan lokal ketika offline dan mengirimkan perubahan ke server ketika koneksi tersedia.                    |

### 6.2 Fitur Pendukung — Should Have

Fitur pendukung yang meningkatkan kenyamanan penggunaan:

- Pengingat pencatatan tidur yang dapat diatur pengguna.
- Pengaturan notifikasi.
- Tema gelap dan preferensi dasar aplikasi.

### 6.3 Pengembangan Lanjutan — Could Have

Fitur yang dapat dipertimbangkan setelah kebutuhan inti terpenuhi:

- Dukungan pengelolaan lebih dari satu profil bayi.
- Personalisasi preferensi pencatatan.

### 6.4 Di Luar Ruang Lingkup — Not Now

BoboNyenyak tidak mencakup:

- Diagnosis gangguan tidur atau gangguan kesehatan bayi.
- Rekomendasi atau keputusan medis.
- Penilaian kondisi kesehatan bayi secara klinis.
- Integrasi wearable atau sensor kesehatan.
- Penggunaan GPS, kamera, atau mikrofon sebagai kebutuhan inti.
- Transaksi jual-beli atau pembayaran.
- Media broadcast publik satu arah.

## 7. Gambaran Pengalaman Pengguna

Alur penggunaan utama BoboNyenyak berpusat pada aktivitas pengasuh dalam mencatat dan meninjau rutinitas tidur bayi.

1. **Mengenali kebutuhan:** pengasuh ingin memantau waktu tidur dan bangun bayi secara lebih teratur.
2. **Memulai pencatatan:** pengasuh membuka halaman Catat Tidur dari Dashboard.
3. **Mengisi dan menyimpan data:** pengasuh mencatat waktu mulai tidur, waktu bangun, serta catatan tambahan jika diperlukan.
4. **Memahami pola tidur:** pengasuh membuka halaman Visualisasi Pola Tidur untuk melihat informasi berdasarkan catatan yang tersimpan.
5. **Mengelola informasi:** pengasuh memeriksa atau memperbarui informasi akun dan profil bayi melalui halaman Profil.

Halaman utama yang menjadi bagian dari rancangan prototype meliputi:

- Home / Dashboard
- Catat Tidur
- Visualisasi Pola Tidur
- Profil

## 8. Prinsip Produk dan Pengalaman Pengguna

Pengembangan BoboNyenyak mengikuti prinsip berikut:

- **Praktis:** aksi pencatatan utama harus mudah ditemukan dan dilakukan dengan langkah minimal.
- **Mudah dipahami:** istilah, navigasi, tombol, dan informasi harus dapat dipahami oleh pengguna dengan tingkat literasi digital yang beragam.
- **Nyaman digunakan:** antarmuka memperhatikan penggunaan satu tangan dan kondisi cahaya redup, termasuk ketersediaan dark mode.
- **Informatif:** riwayat dan visualisasi menyampaikan informasi berdasarkan data yang benar-benar tersedia.
- **Transparan:** aplikasi memberikan feedback yang jelas mengenai proses, keberhasilan, kegagalan, dan status penyimpanan.
- **Aman dan privat:** informasi pengguna dan bayi hanya dapat diakses sesuai hak akses.
- **Tidak menghakimi atau mendiagnosis:** visualisasi tidak memberikan label penyakit maupun kesimpulan medis.

## 9. Indikator Keberhasilan Produk

Indikator berikut digunakan sebagai sasaran awal untuk mengevaluasi produk dan pengalaman pengguna. Indikator ini bukan klaim bahwa seluruh target telah tercapai.

| Area                 | Indikator                                                                                                                |
| -------------------- | ------------------------------------------------------------------------------------------------------------------------ |
| Pencatatan           | Pengasuh dapat menyelesaikan alur pencatatan waktu tidur dan bangun dengan benar.                                        |
| Kecepatan penggunaan | Rancangan pencatatan ditargetkan dapat diuji untuk diselesaikan dalam waktu maksimal 15 detik pada skenario yang sesuai. |
| Riwayat              | Pengasuh dapat menemukan kembali catatan berdasarkan tanggal.                                                            |
| Visualisasi          | Pengguna dapat memahami informasi durasi dan pola dari data yang tersedia tanpa menafsirkannya sebagai diagnosis.        |
| Keandalan data       | Status penyimpanan ditampilkan dengan jelas dan kegagalan tidak menyebabkan catatan hilang atau tersimpan ganda.         |
| Offline              | Catatan dapat disimpan secara lokal ketika koneksi tidak tersedia dan diproses untuk sinkronisasi setelah koneksi pulih. |
| Usability            | Navigasi, formulir, dan informasi utama dapat digunakan tanpa bantuan langsung dari pengembang.                          |

## 10. Batasan, Asumsi, dan Ketergantungan

### 10.1 Batasan

- BoboNyenyak merupakan aplikasi pendamping nonklinis.
- Informasi pola tidur hanya dihitung dari data yang tersedia dan valid.
- Aplikasi tidak memberikan diagnosis, saran medis, atau penilaian kesehatan bayi.
- Data bayi dan pengguna untuk prototype, demonstrasi, serta pengujian menggunakan data fiktif atau dummy.
- Akses terhadap data dibatasi berdasarkan autentikasi dan kewenangan pengguna.

### 10.2 Asumsi

- Pengguna utama memiliki smartphone yang dapat menjalankan aplikasi.
- Pengasuh memasukkan atau mengakhiri pencatatan sesuai aktivitas tidur bayi.
- Ketepatan informasi yang ditampilkan bergantung pada kelengkapan dan ketepatan data yang dicatat pengguna.

### 10.3 Ketergantungan

- Fitur sinkronisasi membutuhkan koneksi internet dan layanan backend yang tersedia.
- Pengingat bergantung pada izin notifikasi serta kebijakan sistem operasi perangkat.
- Penggunaan fitur akun membutuhkan mekanisme autentikasi.

## 11. Status Pengembangan Saat Ini

Berdasarkan dokumentasi milestone hingga M6:

- BoboNyenyak telah memiliki rancangan aplikasi mobile dan clickable prototype yang melanjutkan hasil milestone sebelumnya.
- Prototype mencakup navigasi menuju Dashboard, Catat Tidur, Visualisasi Pola Tidur, dan Profil.
- Alur autentikasi dan pengelolaan profil termasuk dalam rancangan produk.
- Evaluasi prototype mengidentifikasi kebutuhan pengembangan validasi input, feedback proses penyimpanan, penanganan kondisi offline, dan pencegahan pencatatan ganda.
- Pengujian pada M6 menunjukkan navigasi dan tampilan formulir dapat diakses, tetapi proses validasi serta penyimpanan belum dapat diuji secara menyeluruh.

Status tersebut menggambarkan hasil yang tercatat dalam dokumen milestone, bukan pernyataan bahwa seluruh fitur telah selesai diimplementasikan.

## 12. Risiko Produk

| Risiko                   | Dampak Potensial                                            | Arah Mitigasi                                                   |
| ------------------------ | ----------------------------------------------------------- | --------------------------------------------------------------- |
| Akses data tanpa izin    | Privasi pengguna dan bayi terganggu.                        | Autentikasi dan pembatasan akses berdasarkan hak pengguna.      |
| Kesalahan input waktu    | Riwayat dan visualisasi menjadi tidak akurat.               | Validasi waktu dan kelengkapan data sebelum penyimpanan.        |
| Kegagalan jaringan       | Pengguna tidak mengetahui apakah catatan berhasil disimpan. | Status penyimpanan yang jelas dan mekanisme pemulihan.          |
| Pencatatan ganda         | Data riwayat menjadi tidak konsisten.                       | Mencegah pengiriman berulang dan memeriksa status penyimpanan.  |
| Salah tafsir visualisasi | Pengguna menganggap informasi sebagai penilaian medis.      | Label dan penjelasan nonklinis serta pembatasan klaim aplikasi. |

## 13. Referensi Dokumen

PRD ini disusun dengan mengacu pada artefak proyek BoboNyenyak berikut:

1. **Software Requirements Specification (SRS) BoboNyenyak**, The Winner, versi 1.0, 6 Oktober 2026.
2. **BoboNyenyak Patient Journey, Risk & Validation**, Milestone 6 Final Project – Healthcare Mobile Application, The Winner, versi 1.0, 17 November 2026.
3. **Milestone 5 – Navigation, Interaction & Clickable Prototype**, sebagai dasar rancangan navigasi dan interaksi prototype.
4. Hasil survei awal pengasuh utama bayi yang dirangkum dalam SRS.

---

## Catatan Pemeliharaan Dokumen

PRD menjelaskan tujuan, ruang lingkup, pengguna, dan nilai produk. Detail kebutuhan fungsional/nonfungsional beserta acceptance criteria dijabarkan lebih lanjut dalam `REQUIREMENT.md`. Detail arsitektur, teknologi, integrasi, dan struktur data dijabarkan dalam `SYSTEM-DESIGN.md`, sedangkan spesifikasi antarmuka dan pengalaman pengguna dijabarkan dalam `DESIGN.md`.

Perubahan pada ruang lingkup atau prioritas produk perlu diperbarui pada dokumen ini agar tetap konsisten dengan dokumen requirement, desain, dan implementasi.
