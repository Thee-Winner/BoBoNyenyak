# Requirement Specification

# BoboNyenyak

| Informasi      | Detail                               |
| -------------- | ------------------------------------ |
| Nama Produk    | BoboNyenyak                          |
| Jenis Aplikasi | Mobile Application                   |
| Kelompok       | The Winner (11)                      |
| Mata Kuliah    | CPA560 – Perancangan Aplikasi Mobile |
| Institusi      | Universitas Esa Unggul               |
| Versi Dokumen  | 1.0                                  |
| Status         | Draft requirement                    |

---

## 1. Pendahuluan

### 1.1 Tujuan Dokumen

Dokumen Requirement ini mendefinisikan kebutuhan fungsional, kebutuhan nonfungsional, aturan bisnis, dan kriteria penerimaan BoboNyenyak. Dokumen digunakan sebagai acuan dalam pengembangan, pengujian, dan evaluasi aplikasi agar setiap fungsi memiliki tujuan serta hasil yang dapat diverifikasi.

### 1.2 Ruang Lingkup

BoboNyenyak merupakan aplikasi mobile untuk membantu Pengasuh Utama mencatat waktu tidur dan bangun bayi, mengelola profil bayi, melihat riwayat pencatatan, serta memahami pola tidur melalui ringkasan dan visualisasi data.

Aplikasi berfokus pada pencatatan dan penyajian informasi secara nonklinis. BoboNyenyak tidak digunakan untuk mendiagnosis gangguan tidur, menilai kondisi kesehatan bayi, atau memberikan rekomendasi medis.

### 1.3 Konvensi Requirement

Setiap kebutuhan memiliki ID unik agar dapat ditelusuri ke proses implementasi dan pengujian.

| Kode   | Keterangan                                                        |
| ------ | ----------------------------------------------------------------- |
| FR     | Functional Requirement                                            |
| NFR    | Non-Functional Requirement                                        |
| BR     | Business Rule                                                     |
| AC     | Acceptance Criteria                                               |
| High   | Kebutuhan utama yang harus dipenuhi dalam ruang lingkup inti      |
| Medium | Kebutuhan pendukung yang dapat diprioritaskan setelah fungsi inti |

### 1.4 Aktor Sistem

| Aktor                   | Deskripsi                                                                                                                                   |
| ----------------------- | ------------------------------------------------------------------------------------------------------------------------------------------- |
| Pengasuh Utama (`user`) | Ibu, ayah, atau anggota keluarga yang aktif merawat bayi dan menggunakan aplikasi untuk mengelola profil serta memantau catatan tidur bayi. |

BoboNyenyak hanya memiliki satu jenis aktor aplikasi, yaitu Pengasuh Utama. Fitur Admin Sistem, dashboard administrasi, dan hak akses administratif tidak termasuk dalam ruang lingkup requirement ini.

---

## 2. Kebutuhan Fungsional

### 2.1 Autentikasi dan Pengelolaan Akun

| ID         | Kebutuhan                                                                                                                   | Prioritas |
| ---------- | --------------------------------------------------------------------------------------------------------------------------- | --------- |
| FR-AUTH-01 | Sistem harus menyediakan fitur registrasi akun menggunakan nama, email, dan password.                                       | High      |
| FR-AUTH-02 | Sistem harus memvalidasi kelengkapan data registrasi dan format email sebelum akun dibuat.                                  | High      |
| FR-AUTH-03 | Sistem harus menyediakan fitur login menggunakan kredensial akun yang terdaftar.                                            | High      |
| FR-AUTH-04 | Sistem harus menyediakan fitur logout untuk mengakhiri sesi pengguna.                                                       | High      |
| FR-AUTH-05 | Sistem harus menampilkan pesan yang dapat dipahami ketika registrasi atau login gagal tanpa membocorkan informasi sensitif. | High      |
| FR-AUTH-06 | Sistem harus menyediakan mekanisme pemulihan password melalui layanan autentikasi apabila fitur tersebut diaktifkan.        | Medium    |
| FR-AUTH-07 | Sistem harus mengaitkan data aplikasi dengan identitas pengguna yang sedang login.                                          | High      |

### 2.2 Pengelolaan Profil Bayi

| ID         | Kebutuhan                                                                                                               | Prioritas |
| ---------- | ----------------------------------------------------------------------------------------------------------------------- | --------- |
| FR-BABY-01 | Sistem harus memungkinkan Pengasuh Utama membuat profil bayi dengan informasi minimal nama panggilan dan tanggal lahir. | High      |
| FR-BABY-02 | Sistem harus menampilkan informasi profil bayi yang sedang digunakan.                                                   | High      |
| FR-BABY-03 | Sistem harus memungkinkan Pengasuh Utama mengubah informasi profil bayi.                                                | High      |
| FR-BABY-04 | Sistem harus mengaitkan setiap catatan tidur dengan profil bayi yang sesuai.                                            | High      |
| FR-BABY-05 | Sistem harus membatasi akses profil bayi hanya kepada pemilik akun yang bersangkutan.                                   | High      |
| FR-BABY-06 | Sistem harus menyediakan konteks profil bayi aktif pada halaman utama dan proses pencatatan.                            | High      |

Catatan: ruang lingkup awal berfokus pada satu profil bayi aktif. Dukungan pengelolaan beberapa profil bayi dapat dikembangkan setelah kebutuhan inti terpenuhi.

### 2.3 Pencatatan Tidur dan Bangun

| ID          | Kebutuhan                                                                                                                               | Prioritas |
| ----------- | --------------------------------------------------------------------------------------------------------------------------------------- | --------- |
| FR-SLEEP-01 | Sistem harus menyediakan aksi **Mulai Tidur** dari halaman Home/Dashboard.                                                              | High      |
| FR-SLEEP-02 | Sistem harus mencatat waktu mulai tidur ketika Pengasuh Utama memulai sesi tidur.                                                       | High      |
| FR-SLEEP-03 | Sistem harus menyediakan aksi **Bangun** untuk mengakhiri sesi tidur yang sedang berlangsung.                                           | High      |
| FR-SLEEP-04 | Sistem harus mencatat waktu bangun ketika sesi tidur diakhiri.                                                                          | High      |
| FR-SLEEP-05 | Sistem harus menghitung durasi tidur berdasarkan waktu mulai dan waktu bangun.                                                          | High      |
| FR-SLEEP-06 | Sistem harus menyediakan input manual untuk memasukkan atau menyesuaikan waktu mulai dan waktu bangun.                                  | High      |
| FR-SLEEP-07 | Sistem harus memvalidasi kelengkapan dan kesesuaian waktu sebelum catatan disimpan.                                                     | High      |
| FR-SLEEP-08 | Sistem harus menolak catatan dengan waktu bangun yang lebih awal daripada waktu mulai tidur.                                            | High      |
| FR-SLEEP-09 | Sistem harus menyediakan kolom catatan tambahan apabila diperlukan dalam proses pencatatan.                                             | Medium    |
| FR-SLEEP-10 | Sistem harus memberikan feedback atas hasil penyimpanan catatan tidur.                                                                  | High      |
| FR-SLEEP-11 | Sistem harus mencegah pengiriman atau penyimpanan catatan yang sama secara berulang akibat pengguna menekan tombol Simpan berkali-kali. | High      |

### 2.4 Riwayat Tidur

| ID            | Kebutuhan                                                                                                     | Prioritas |
| ------------- | ------------------------------------------------------------------------------------------------------------- | --------- |
| FR-HISTORY-01 | Sistem harus menampilkan daftar catatan tidur yang telah tersimpan.                                           | High      |
| FR-HISTORY-02 | Sistem harus mengelompokkan atau menampilkan catatan berdasarkan tanggal.                                     | High      |
| FR-HISTORY-03 | Sistem harus menyediakan pemilihan atau filter tanggal untuk menemukan catatan tertentu.                      | Medium    |
| FR-HISTORY-04 | Sistem harus menampilkan waktu mulai, waktu bangun, dan durasi pada setiap catatan.                           | High      |
| FR-HISTORY-05 | Sistem harus menyediakan tampilan detail catatan tidur.                                                       | Medium    |
| FR-HISTORY-06 | Sistem harus menampilkan empty state ketika belum terdapat catatan pada periode yang dipilih.                 | High      |
| FR-HISTORY-07 | Sistem harus tetap dapat menampilkan data riwayat yang tersedia ketika perangkat tidak terhubung ke internet. | High      |
| FR-HISTORY-08 | Sistem dapat menyediakan fungsi edit dan hapus catatan dengan konfirmasi sebelum perubahan dilakukan.         | Medium    |

### 2.5 Visualisasi Pola Tidur

| ID        | Kebutuhan                                                                                                                                              | Prioritas |
| --------- | ------------------------------------------------------------------------------------------------------------------------------------------------------ | --------- |
| FR-VIS-01 | Sistem harus menampilkan visualisasi durasi tidur berdasarkan catatan yang tersimpan.                                                                  | High      |
| FR-VIS-02 | Sistem harus menyajikan informasi waktu mulai tidur dan waktu bangun dengan format yang mudah dibaca.                                                  | High      |
| FR-VIS-03 | Sistem harus menyediakan ringkasan pola atau konsistensi tidur berdasarkan data yang tersedia.                                                         | High      |
| FR-VIS-04 | Sistem harus menyediakan pemilihan periode visualisasi, seperti harian atau mingguan, apabila data mendukung.                                          | Medium    |
| FR-VIS-05 | Sistem harus menampilkan informasi ketika jumlah atau kualitas data belum mencukupi untuk menghasilkan ringkasan yang bermakna.                        | High      |
| FR-VIS-06 | Sistem harus menampilkan grafik yang menyesuaikan ukuran layar perangkat.                                                                              | High      |
| FR-VIS-07 | Sistem harus menyediakan legenda atau keterangan grafik yang dapat dipahami tanpa hanya mengandalkan perbedaan warna.                                  | Medium    |
| FR-VIS-08 | Sistem hanya boleh menyajikan hasil visualisasi sebagai informasi berdasarkan catatan pengguna dan tidak menghasilkan diagnosis atau kesimpulan medis. | High      |

### 2.6 Penyimpanan dan Sinkronisasi Data

| ID         | Kebutuhan                                                                                                                                               | Prioritas |
| ---------- | ------------------------------------------------------------------------------------------------------------------------------------------------------- | --------- |
| FR-SYNC-01 | Sistem harus memanfaatkan kemampuan penyimpanan offline Firestore agar data yang telah tersedia dapat diakses dari cache ketika koneksi tidak tersedia. | High      |
| FR-SYNC-02 | Sistem harus mendukung pencatatan perubahan data ketika perangkat sedang offline sesuai kemampuan Firestore Offline Persistence.                        | High      |
| FR-SYNC-03 | Sistem harus menyinkronkan perubahan lokal ke Cloud Firestore ketika koneksi kembali tersedia.                                                          | High      |
| FR-SYNC-04 | Sistem harus mempertahankan data yang belum berhasil tersinkronisasi dan tidak menghapusnya hanya karena kegagalan jaringan.                            | High      |
| FR-SYNC-05 | Sistem harus menampilkan informasi status koneksi atau sinkronisasi apabila status tersebut relevan bagi pengguna.                                      | Medium    |
| FR-SYNC-06 | Sistem harus menangani kegagalan akses Firebase dengan feedback yang jelas dan tidak menyebabkan aplikasi berhenti secara tiba-tiba.                    | High      |

Catatan arsitektur: requirement penyimpanan dan sinkronisasi pada dokumen ini diselaraskan dengan rancangan sistem terkini yang menggunakan Cloud Firestore dan Firestore Offline Persistence. Rancangan SRS awal yang menyebut SQLite, REST API, dan PostgreSQL merupakan rancangan sebelumnya dan tidak dijadikan dasar implementasi pada dokumen ini.

### 2.7 Pengingat dan Pengaturan

| ID            | Kebutuhan                                                                                                                | Prioritas |
| ------------- | ------------------------------------------------------------------------------------------------------------------------ | --------- |
| FR-SETTING-01 | Sistem dapat menyediakan pengaturan untuk mengaktifkan atau menonaktifkan pengingat pencatatan tidur.                    | Medium    |
| FR-SETTING-02 | Sistem harus meminta izin notifikasi melalui mekanisme sistem operasi sebelum mengirimkan notifikasi yang memerlukannya. | High      |
| FR-SETTING-03 | Sistem harus tetap menyediakan fungsi pencatatan tidur meskipun pengguna tidak memberikan izin notifikasi.               | High      |
| FR-SETTING-04 | Sistem dapat menampilkan status izin notifikasi pada halaman pengaturan.                                                 | Medium    |
| FR-SETTING-05 | Sistem dapat menyediakan pengaturan preferensi tampilan, termasuk tema gelap.                                            | Medium    |
| FR-SETTING-06 | Sistem harus menyediakan halaman Profil untuk melihat informasi akun Pengasuh Utama dan profil bayi.                     | High      |

---

## 3. Kebutuhan Nonfungsional

### 3.1 Performance

| ID          | Kebutuhan                                                                                                                         | Prioritas |
| ----------- | --------------------------------------------------------------------------------------------------------------------------------- | --------- |
| NFR-PERF-01 | Alur pencatatan satu sesi tidur ditargetkan dapat diselesaikan dalam waktu maksimal 15 detik setelah pengguna memahami alurnya.   | High      |
| NFR-PERF-02 | Halaman Home dan data riwayat yang tersedia secara lokal harus dapat ditampilkan tanpa menunggu permintaan jaringan.              | High      |
| NFR-PERF-03 | Perpindahan antarhalaman utama harus berlangsung responsif dan tidak terhambat oleh proses jaringan yang berjalan secara sinkron. | High      |
| NFR-PERF-04 | Grafik harus ditampilkan secara proporsional dan tidak terpotong pada ukuran layar perangkat yang didukung.                       | High      |
| NFR-PERF-05 | Proses sinkronisasi data harus berjalan tanpa menghambat aktivitas pencatatan pengguna.                                           | High      |

### 3.2 Usability dan Accessibility

| ID        | Kebutuhan                                                                                                                    | Prioritas |
| --------- | ---------------------------------------------------------------------------------------------------------------------------- | --------- |
| NFR-UX-01 | Antarmuka harus mudah dipahami oleh Pengasuh Utama dengan tingkat literasi digital yang beragam.                             | High      |
| NFR-UX-02 | Aksi utama pencatatan harus mudah ditemukan dan dijangkau, termasuk ketika aplikasi digunakan dengan satu tangan.            | High      |
| NFR-UX-03 | Ukuran teks, tombol, dan target sentuh harus memadai untuk digunakan pada perangkat mobile.                                  | High      |
| NFR-UX-04 | Antarmuka harus memiliki kontras dan keterbacaan yang baik untuk penggunaan pada kondisi cahaya redup.                       | High      |
| NFR-UX-05 | Informasi penting tidak boleh dibedakan hanya menggunakan warna; label atau ikon pendukung harus disediakan bila diperlukan. | Medium    |
| NFR-UX-06 | Status loading, berhasil, gagal, offline, dan empty state harus disampaikan dengan bahasa yang jelas.                        | High      |

### 3.3 Reliability dan Recoverability

| ID         | Kebutuhan                                                                                                                     | Prioritas |
| ---------- | ----------------------------------------------------------------------------------------------------------------------------- | --------- |
| NFR-REL-01 | Aplikasi tidak boleh mengalami crash hanya karena data kosong, timestamp tidak valid, atau proses sinkronisasi gagal.         | High      |
| NFR-REL-02 | Data yang telah tersimpan secara lokal harus tetap tersedia ketika koneksi internet atau layanan Firebase mengalami gangguan. | High      |
| NFR-REL-03 | Kegagalan proses penyimpanan harus memberikan informasi status yang jelas kepada pengguna.                                    | High      |
| NFR-REL-04 | Pengguna harus dapat melanjutkan proses setelah koneksi kembali tersedia tanpa kehilangan data yang belum tersinkronisasi.    | High      |
| NFR-REL-05 | Sistem harus menghindari duplikasi catatan akibat pengiriman ulang atau interaksi berulang.                                   | High      |

### 3.4 Security dan Privacy

| ID         | Kebutuhan                                                                                                                                | Prioritas |
| ---------- | ---------------------------------------------------------------------------------------------------------------------------------------- | --------- |
| NFR-SEC-01 | Pengguna harus melalui proses autentikasi sebelum mengakses data personal yang memerlukan akun.                                          | High      |
| NFR-SEC-02 | Password tidak boleh disimpan sebagai data biasa pada Cloud Firestore. Pengelolaan kredensial dilakukan melalui Firebase Authentication. | High      |
| NFR-SEC-03 | Sistem harus membatasi akses dokumen pengguna berdasarkan UID akun yang sedang terautentikasi.                                           | High      |
| NFR-SEC-04 | Akses ke profil bayi dan catatan tidur harus dibatasi pada data yang dimiliki pengguna terkait.                                          | High      |
| NFR-SEC-05 | Firestore Security Rules harus diterapkan untuk memvalidasi identitas dan hak akses terhadap dokumen.                                    | High      |
| NFR-SEC-06 | Sistem harus memvalidasi input sebelum data disimpan atau diproses.                                                                      | High      |
| NFR-SEC-07 | Proses logout harus mengakhiri sesi autentikasi pengguna melalui mekanisme Firebase Authentication.                                      | High      |
| NFR-SEC-08 | Pesan kesalahan tidak boleh menampilkan kredensial, token, atau detail internal yang sensitif.                                           | High      |
| NFR-SEC-09 | Data pengguna dan bayi tidak boleh dapat diakses oleh akun lain tanpa hak akses yang sah.                                                | High      |

### 3.5 Compatibility dan Maintainability

| ID           | Kebutuhan                                                                                                               | Prioritas |
| ------------ | ----------------------------------------------------------------------------------------------------------------------- | --------- |
| NFR-COMP-01  | Aplikasi dikembangkan menggunakan Flutter dan Dart untuk mendukung platform mobile yang ditargetkan.                    | High      |
| NFR-COMP-02  | Layout harus menyesuaikan variasi ukuran dan rasio layar perangkat yang didukung.                                       | High      |
| NFR-MAINT-01 | Kode aplikasi harus memiliki pemisahan tanggung jawab antara antarmuka, logika aplikasi, model, dan akses layanan/data. | Medium    |
| NFR-MAINT-02 | Struktur data harus konsisten agar pengembangan fitur berikutnya tidak memerlukan perubahan yang tidak terkontrol.      | Medium    |
| NFR-MAINT-03 | Komponen navigasi, tombol, tipografi, status, dan istilah harus digunakan secara konsisten di seluruh halaman.          | High      |

### 3.6 Safety dan Batasan Etis

| ID          | Kebutuhan                                                                                                                       | Prioritas |
| ----------- | ------------------------------------------------------------------------------------------------------------------------------- | --------- |
| NFR-SAFE-01 | Aplikasi tidak boleh memberikan diagnosis, rekomendasi medis, atau kesimpulan klinis berdasarkan catatan tidur.                 | High      |
| NFR-SAFE-02 | Visualisasi harus menjelaskan bahwa informasi yang ditampilkan berasal dari catatan pengguna dan bukan hasil pemeriksaan medis. | High      |
| NFR-SAFE-03 | Aplikasi harus menangani data yang tidak lengkap atau tidak valid tanpa menghasilkan informasi visual yang menyesatkan.         | High      |
| NFR-SAFE-04 | Data bayi dan pengguna yang digunakan untuk demonstrasi atau pengujian harus berupa data dummy/fiktif.                          | High      |

---

## 4. Aturan Bisnis

| ID    | Aturan                                                                                                                                                                                  |
| ----- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| BR-01 | Setiap catatan tidur harus terhubung dengan satu profil bayi.                                                                                                                           |
| BR-02 | Waktu bangun tidak boleh lebih awal daripada waktu mulai tidur.                                                                                                                         |
| BR-03 | Pengguna hanya dapat mengakses dan mengelola data yang menjadi miliknya.                                                                                                                |
| BR-04 | Catatan yang dibuat ketika offline tetap dapat disimpan selama data wajib telah memenuhi validasi.                                                                                      |
| BR-05 | Data yang belum tersinkronisasi tidak boleh dihapus otomatis akibat kegagalan jaringan.                                                                                                 |
| BR-06 | Identitas unik dokumen digunakan untuk menghindari pembuatan catatan ganda saat sinkronisasi.                                                                                           |
| BR-07 | Visualisasi hanya dihitung dari data tidur yang tersedia dan valid.                                                                                                                     |
| BR-08 | Aplikasi tidak boleh menyimpulkan diagnosis, penyakit, atau gangguan sirkadian dari data tidur.                                                                                         |
| BR-09 | Pengingat/notifikasi bukan prasyarat untuk menggunakan fitur pencatatan tidur.                                                                                                          |
| BR-10 | Prioritas fitur inti BoboNyenyak adalah pencatatan tidur, riwayat tidur, dan visualisasi pola tidur.                                                                                    |
| BR-11 | Nilai role pada profil akun, apabila tetap digunakan dalam model data, hanya menggunakan nilai `user` pada ruang lingkup aplikasi saat ini. Pengguna tidak dapat mengubah role sendiri. |

---

## 5. Kriteria Penerimaan

Kriteria penerimaan digunakan untuk memastikan bahwa kebutuhan utama dapat diamati dan diuji. Kriteria berikut merupakan target perilaku sistem, bukan pernyataan bahwa seluruh fungsi telah selesai diimplementasikan.

### 5.1 Autentikasi

| ID         | Kriteria Penerimaan                                                                                                              |
| ---------- | -------------------------------------------------------------------------------------------------------------------------------- |
| AC-AUTH-01 | Ketika pengguna mengisi data registrasi yang valid, sistem membuat akun dan mengarahkan pengguna ke alur awal aplikasi.          |
| AC-AUTH-02 | Ketika email atau password tidak memenuhi validasi, sistem menampilkan pesan koreksi dan tidak melanjutkan proses secara keliru. |
| AC-AUTH-03 | Ketika login berhasil, pengguna dapat mengakses halaman Home/Dashboard dan data yang terkait dengan UID miliknya.                |
| AC-AUTH-04 | Ketika pengguna melakukan logout, sesi autentikasi berakhir dan halaman personal tidak lagi dapat diakses tanpa login kembali.   |

### 5.2 Profil Bayi

| ID         | Kriteria Penerimaan                                                                 |
| ---------- | ----------------------------------------------------------------------------------- |
| AC-BABY-01 | Pengguna dapat membuat profil bayi dengan mengisi nama panggilan dan tanggal lahir. |
| AC-BABY-02 | Profil yang telah disimpan dapat ditampilkan kembali pada halaman Profil.           |
| AC-BABY-03 | Perubahan profil yang valid tersimpan dan ditampilkan dengan informasi terbaru.     |
| AC-BABY-04 | Akun lain tidak dapat membaca atau mengubah profil bayi milik pengguna.             |

### 5.3 Pencatatan Tidur

| ID          | Kriteria Penerimaan                                                                                                           |
| ----------- | ----------------------------------------------------------------------------------------------------------------------------- |
| AC-SLEEP-01 | Pengguna dapat memulai sesi melalui tombol Mulai Tidur dan sistem mencatat waktu mulai.                                       |
| AC-SLEEP-02 | Ketika tombol Bangun dipilih, sistem mencatat waktu akhir dan menghitung durasi sesi.                                         |
| AC-SLEEP-03 | Pengguna dapat memasukkan atau menyesuaikan waktu secara manual.                                                              |
| AC-SLEEP-04 | Jika waktu wajib belum diisi atau waktu tidak sesuai, sistem menampilkan pesan yang menjelaskan bagian yang perlu diperbaiki. |
| AC-SLEEP-05 | Setelah penyimpanan berhasil, sistem menampilkan konfirmasi dan catatan tersedia pada riwayat.                                |
| AC-SLEEP-06 | Selama proses penyimpanan berlangsung, aksi Simpan tidak dapat memicu pengiriman berulang yang menghasilkan catatan ganda.    |

### 5.4 Riwayat dan Visualisasi

| ID            | Kriteria Penerimaan                                                                                                         |
| ------------- | --------------------------------------------------------------------------------------------------------------------------- |
| AC-HISTORY-01 | Pengguna dapat melihat daftar catatan tidur beserta waktu mulai, waktu bangun, dan durasinya.                               |
| AC-HISTORY-02 | Pengguna dapat memilih tanggal/periode dan melihat catatan yang sesuai.                                                     |
| AC-HISTORY-03 | Jika tidak ada catatan pada periode yang dipilih, sistem menampilkan empty state.                                           |
| AC-VIS-01     | Grafik dan ringkasan ditampilkan berdasarkan catatan tidur yang tersedia.                                                   |
| AC-VIS-02     | Jika data belum mencukupi, sistem menampilkan informasi keterbatasan data dan tidak membuat kesimpulan yang tidak didukung. |
| AC-VIS-03     | Grafik dan keterangannya tetap dapat dibaca pada ukuran layar perangkat yang didukung.                                      |
| AC-VIS-04     | Informasi visualisasi tidak menggunakan istilah diagnosis atau rekomendasi medis.                                           |

### 5.5 Offline dan Sinkronisasi

| ID         | Kriteria Penerimaan                                                                                                                                   |
| ---------- | ----------------------------------------------------------------------------------------------------------------------------------------------------- |
| AC-SYNC-01 | Data yang tersedia pada cache dapat dibaca ketika perangkat tidak memiliki koneksi internet.                                                          |
| AC-SYNC-02 | Perubahan yang dilakukan ketika offline dipertahankan dan disinkronkan ketika koneksi tersedia kembali sesuai perilaku Firestore Offline Persistence. |
| AC-SYNC-03 | Kegagalan koneksi tidak menyebabkan data lokal yang belum tersinkronisasi dihapus.                                                                    |
| AC-SYNC-04 | Pengiriman ulang perubahan tidak menghasilkan dokumen catatan duplikat.                                                                               |
| AC-SYNC-05 | Pengguna memperoleh informasi yang jelas ketika proses penyimpanan atau sinkronisasi belum berhasil.                                                  |

### 5.6 Pengingat dan Pengaturan

| ID            | Kriteria Penerimaan                                                                                                              |
| ------------- | -------------------------------------------------------------------------------------------------------------------------------- |
| AC-SETTING-01 | Pengguna dapat mengaktifkan atau menonaktifkan pengingat apabila fitur pengingat tersedia.                                       |
| AC-SETTING-02 | Jika izin notifikasi ditolak, aplikasi tetap dapat digunakan untuk mencatat dan melihat data tidur.                              |
| AC-SETTING-03 | Preferensi yang tersedia pada halaman pengaturan ditampilkan secara konsisten setelah pengguna kembali membuka halaman tersebut. |

---

## 6. Use Case Utama

### UC-01 — Registrasi dan Login

| Elemen          | Deskripsi                                                                                                                                                                                    |
| --------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Aktor           | Pengasuh Utama                                                                                                                                                                               |
| Tujuan          | Membuat akun atau masuk ke aplikasi.                                                                                                                                                         |
| Prasyarat       | Aplikasi telah terpasang dan pengguna memiliki koneksi yang diperlukan untuk proses autentikasi.                                                                                             |
| Alur utama      | Pengguna membuka halaman autentikasi → memilih registrasi atau login → mengisi data → sistem memvalidasi → Firebase Authentication memproses autentikasi → pengguna masuk ke Home/Dashboard. |
| Alur alternatif | Data tidak valid atau autentikasi gagal → sistem menampilkan pesan kesalahan dan pengguna dapat memperbaiki input.                                                                           |
| Kondisi akhir   | Sesi autentikasi pengguna terbentuk atau pengguna tetap berada pada halaman autentikasi jika proses gagal.                                                                                   |

### UC-02 — Mengelola Profil Bayi

| Elemen          | Deskripsi                                                                                                                        |
| --------------- | -------------------------------------------------------------------------------------------------------------------------------- |
| Aktor           | Pengasuh Utama                                                                                                                   |
| Tujuan          | Membuat atau memperbarui informasi bayi yang dipantau.                                                                           |
| Prasyarat       | Pengguna telah login.                                                                                                            |
| Alur utama      | Pengguna membuka halaman Profil → memilih tambah atau ubah profil bayi → mengisi informasi → sistem memvalidasi → data disimpan. |
| Alur alternatif | Data tidak valid atau penyimpanan gagal → sistem menampilkan pesan dan mempertahankan input yang masih diperlukan.               |
| Kondisi akhir   | Informasi profil bayi tersimpan dan dapat digunakan sebagai konteks pencatatan.                                                  |

### UC-03 — Mencatat Tidur dan Bangun

| Elemen          | Deskripsi                                                                                                                                                                                                 |
| --------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Aktor           | Pengasuh Utama                                                                                                                                                                                            |
| Tujuan          | Mencatat waktu tidur dan bangun bayi.                                                                                                                                                                     |
| Prasyarat       | Pengguna telah login dan profil bayi tersedia.                                                                                                                                                            |
| Alur utama      | Pengguna membuka Home → memilih Mulai Tidur atau Catat Tidur → sistem mencatat waktu mulai → pengguna memilih Bangun atau mengisi waktu akhir → sistem memvalidasi dan menghitung durasi → data disimpan. |
| Alur alternatif | Input tidak valid → sistem meminta koreksi. Koneksi tidak tersedia → data diproses menggunakan dukungan offline Firestore sesuai status koneksi dan cache.                                                |
| Kondisi akhir   | Catatan tidur tersedia untuk ditampilkan pada riwayat dan visualisasi setelah tersimpan.                                                                                                                  |

### UC-04 — Melihat Riwayat Tidur

| Elemen          | Deskripsi                                                                                                                                       |
| --------------- | ----------------------------------------------------------------------------------------------------------------------------------------------- |
| Aktor           | Pengasuh Utama                                                                                                                                  |
| Tujuan          | Meninjau catatan tidur berdasarkan tanggal.                                                                                                     |
| Prasyarat       | Pengguna telah login.                                                                                                                           |
| Alur utama      | Pengguna membuka halaman Riwayat → memilih tanggal/periode → sistem menampilkan daftar catatan → pengguna memilih catatan untuk melihat detail. |
| Alur alternatif | Tidak terdapat catatan → sistem menampilkan empty state.                                                                                        |
| Kondisi akhir   | Pengguna memperoleh informasi catatan tidur pada tanggal/periode yang dipilih.                                                                  |

### UC-05 — Melihat Visualisasi Pola Tidur

| Elemen          | Deskripsi                                                                                                                                       |
| --------------- | ----------------------------------------------------------------------------------------------------------------------------------------------- |
| Aktor           | Pengasuh Utama                                                                                                                                  |
| Tujuan          | Memahami pola dan konsistensi berdasarkan catatan tidur.                                                                                        |
| Prasyarat       | Terdapat data tidur yang dapat diolah.                                                                                                          |
| Alur utama      | Pengguna membuka Visualisasi Pola Tidur → memilih periode jika tersedia → sistem mengolah data valid → sistem menampilkan grafik dan ringkasan. |
| Alur alternatif | Data tidak cukup atau tidak valid → sistem menampilkan keterangan keterbatasan data.                                                            |
| Kondisi akhir   | Pengguna melihat informasi pola tidur yang bersifat deskriptif dan nonklinis.                                                                   |

---

## 7. Skenario Pengujian Utama

| ID    | Skenario                                              | Hasil yang Diharapkan                                                                                 |
| ----- | ----------------------------------------------------- | ----------------------------------------------------------------------------------------------------- |
| TC-01 | Registrasi dengan data valid                          | Akun berhasil dibuat dan pengguna diarahkan ke alur awal aplikasi.                                    |
| TC-02 | Login dengan kredensial valid                         | Pengguna berhasil masuk ke Home/Dashboard.                                                            |
| TC-03 | Login dengan kredensial tidak valid                   | Sistem menampilkan pesan kegagalan tanpa membuka data personal.                                       |
| TC-04 | Membuat profil bayi                                   | Profil tersimpan dan dapat ditampilkan kembali.                                                       |
| TC-05 | Memulai dan mengakhiri sesi tidur                     | Timestamp mulai dan akhir tercatat serta durasi dihitung dengan benar.                                |
| TC-06 | Mengisi waktu bangun lebih awal dari waktu mulai      | Sistem menolak input dan meminta pengguna memperbaikinya.                                             |
| TC-07 | Menyimpan catatan tidur                               | Catatan yang berhasil disimpan muncul pada riwayat.                                                   |
| TC-08 | Membuka riwayat tanpa data                            | Sistem menampilkan empty state.                                                                       |
| TC-09 | Membuka visualisasi dengan data tersedia              | Grafik dan ringkasan sesuai dengan data yang tersimpan.                                               |
| TC-10 | Membuka visualisasi dengan data tidak mencukupi       | Sistem menampilkan keterangan bahwa data belum mencukupi.                                             |
| TC-11 | Membuka data ketika offline                           | Data yang tersedia pada cache tetap dapat ditampilkan.                                                |
| TC-12 | Koneksi terputus saat proses penyimpanan/sinkronisasi | Sistem mempertahankan data sesuai dukungan offline Firestore dan memberikan status yang tidak ambigu. |
| TC-13 | Pengguna menekan Simpan berulang kali                 | Sistem mencegah terbentuknya catatan duplikat akibat aksi berulang.                                   |
| TC-14 | Akun berbeda mencoba mengakses data pengguna lain     | Akses ditolak oleh aturan keamanan database.                                                          |
| TC-15 | Izin notifikasi ditolak                               | Fitur pencatatan dan riwayat tetap dapat digunakan.                                                   |

---

## 8. Prioritas dan Batasan Ruang Lingkup

### 8.1 Prioritas Fitur

| Prioritas   | Fitur                                                                                                                                        |
| ----------- | -------------------------------------------------------------------------------------------------------------------------------------------- |
| Must Have   | Registrasi/login, profil bayi, pencatatan tidur/bangun, perhitungan durasi, riwayat, visualisasi, serta akses data offline dan sinkronisasi. |
| Should Have | Pengingat, pengaturan notifikasi, tema gelap, dan preferensi dasar.                                                                          |
| Could Have  | Dukungan beberapa profil bayi dan personalisasi preferensi pencatatan.                                                                       |
| Not Now     | Diagnosis gangguan tidur, rekomendasi medis, integrasi wearable, GPS, kamera, mikrofon, dan sensor kesehatan.                                |

### 8.2 Batasan Sistem

1. Aplikasi hanya berfungsi sebagai sarana pencatatan dan pemantauan informasi tidur bayi secara nonklinis.
2. Akurasi informasi bergantung pada data waktu yang dimasukkan atau direkam oleh pengguna.
3. Sinkronisasi data membutuhkan koneksi internet, sedangkan akses offline mengikuti data yang tersedia pada cache dan kemampuan Firestore Offline Persistence.
4. Pengingat bergantung pada izin notifikasi dan kebijakan sistem operasi perangkat.
5. Penggunaan beberapa profil bayi dan personalisasi lanjutan tidak menjadi fokus implementasi awal.
6. Fitur administrasi sistem tidak termasuk dalam ruang lingkup aplikasi.

---

## 9. Status Implementasi dan Validasi

Requirement pada dokumen ini menjadi target perilaku sistem. Keberadaan requirement tidak otomatis berarti fitur telah selesai diimplementasikan.

| Area                              | Informasi berdasarkan artefak proyek                                                                            | Catatan                                                                                                   |
| --------------------------------- | --------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------- |
| Autentikasi                       | Integrasi Firebase Authentication dan model profil pengguna telah menjadi bagian rancangan/implementasi proyek. | Perlu pengujian alur registrasi, login, logout, dan kondisi gagal.                                        |
| Profil bayi                       | Tercantum dalam rancangan kebutuhan dan struktur data.                                                          | Perlu diverifikasi terhadap implementasi aplikasi terkini.                                                |
| Pencatatan tidur                  | Formulir dan navigasi pencatatan tersedia pada prototype.                                                       | Validasi input, proses penyimpanan, dan feedback belum sepenuhnya diterapkan pada prototype M5.           |
| Riwayat                           | Termasuk fungsi inti dan rancangan layar.                                                                       | Perlu diverifikasi terhadap data aktual yang tersimpan.                                                   |
| Visualisasi                       | Layar visualisasi termasuk prototype.                                                                           | Perlu dipastikan bahwa data grafik berasal dari catatan tersimpan, bukan hanya data dummy.                |
| Offline/sinkronisasi              | Didukung dalam rancangan melalui Firestore Offline Persistence.                                                 | Perlu pengujian pada kondisi offline dan online kembali.                                                  |
| Pengingat                         | Termasuk kebutuhan pendukung.                                                                                   | Implementasi dan izin notifikasi perlu diverifikasi.                                                      |
| Recovery dan pencegahan duplikasi | Dirancang sebagai kebutuhan validasi.                                                                           | State loading, error, offline, dan pencegahan penyimpanan berulang masih menjadi tindak lanjut prototype. |

### 9.1 Catatan Validasi Prototype

Berdasarkan artefak M5 dan M6, navigasi halaman utama seperti Home/Dashboard, Catat Tidur, Visualisasi Pola Tidur, dan Profil telah menjadi bagian dari prototype. Namun, validasi input, indikator loading, notifikasi keberhasilan, penanganan kegagalan penyimpanan, status offline, dan pencegahan duplikasi masih memerlukan pengembangan serta pengujian lebih lanjut.

### 9.2 Definition of Done

Suatu requirement dapat dinyatakan selesai apabila:

- Fungsi sesuai dengan kebutuhan dan kriteria penerimaan yang ditetapkan.
- Input tidak valid ditangani dengan pesan yang jelas.
- Status loading, berhasil, dan gagal ditampilkan sesuai kondisi proses.
- Data yang disimpan dapat dibaca kembali pada halaman yang relevan.
- Akses data dibatasi sesuai identitas pengguna.
- Kondisi offline dan kegagalan jaringan tidak menyebabkan kehilangan data yang telah tersimpan.
- Pengujian untuk skenario normal dan pengecualian telah dilakukan dan hasilnya dicatat.

---

## 10. Referensi

1. _Software Requirements Specification BoboNyenyak v1.0_, The Winner, 6 Oktober 2026.
2. _BoboNyenyak Patient Journey, Risk & Validation — Milestone 6 Final Project_, The Winner, 17 November 2026.
3. _Navigation, Interaction & Clickable Prototype — Milestone 5 Final Project_, The Winner, November 2026.
4. Dokumen _System Design BoboNyenyak_ versi 1.0.
