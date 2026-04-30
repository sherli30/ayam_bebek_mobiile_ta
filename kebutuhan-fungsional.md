
DOKUMEN KEBUTUHAN FUNGSIONAL
Sistem Manajemen Pemesanan, Penjualan & Tracking Pengiriman
Proyek Tugas Akhir (TA)

Versi 3.0  —  Revisi Struktur Navigasi Menu & Kebutuhan Fungsional
Platform: Web (Admin) & Mobile (Customer)  |  Role: Admin & Customer

1. PENDAHULUAN
1.1 Tujuan Dokumen
Dokumen ini mendeskripsikan seluruh kebutuhan fungsional sistem pemesanan, penjualan, dan tracking pengiriman berbasis web (Admin) dan mobile (Customer). Versi 3.0 ini merupakan revisi dari versi 2.0 dengan penambahan utama: definisi eksplisit struktur navigasi menu aplikasi agar antarmuka terasa intuitif, terorganisir, dan konsisten — mengacu pada pola desain Seller Center seperti Shopee dan Tokopedia/TikTok Shop yang sudah familiar bagi pengguna e-commerce Indonesia.

1.2 Aktor Sistem
Aktor	Platform	Deskripsi
Customer	Mobile App (Android/iOS)	Pelanggan yang melakukan pemesanan, pembayaran, scan barcode, dan memantau tracking paket.
Admin	Web App (Browser)	Satu-satunya role admin yang mengelola seluruh operasional: pesanan, transaksi, tracking, scan barcode, laporan, dan data customer.

1.3 Ruang Lingkup
•	Aplikasi Mobile (Customer): pemesanan, pembayaran, scan barcode untuk tracking, notifikasi.
•	Aplikasi Web (Admin): manajemen pesanan, penjualan, tracking & scan barcode, laporan, dan manajemen data customer.
•	3 (tiga) toko dengan inventori dan laporan penjualan yang terpisah.
•	Mekanisme pengiriman otomatis: reguler untuk pesanan kecil, cargo untuk pesanan besar/banyak.

 
2. STRUKTUR NAVIGASI MENU
Bagian ini mendefinisikan struktur menu navigasi aplikasi secara eksplisit, terinspirasi dari pola desain Seller Center (Shopee, Tokopedia) agar alur kerja admin dan customer terasa intuitif. Setiap menu dipetakan langsung ke kebutuhan fungsional pada bagian 3 dan 4.

2.1 Navigasi Aplikasi Web (Admin)
Admin menggunakan sidebar navigasi tetap di sisi kiri layar, dengan konten utama di sisi kanan. Pola ini identik dengan Shopee Seller Center dan Tokopedia Seller Dashboard.

#	Menu Utama (Sidebar)	Sub-Menu	Fungsi / Referensi Kebutuhan Fungsional
1	🏠  Dashboard	—	Ringkasan harian pesanan, pendapatan, alert paket. (KF 3.2)
2	📦  Pesanan	Semua Pesanan	Daftar seluruh pesanan dari 3 toko. (KF 3.3)
		Perlu Dikonfirmasi	Filter pesanan berstatus menunggu konfirmasi. (KF 3.3)
		Dalam Pengemasan	Pesanan yang sedang dikemas. (KF 3.3, 3.6)
		Dalam Pengiriman	Pesanan yang sudah dikirim. (KF 3.3, 3.6)
		Selesai	Pesanan yang sudah tiba/selesai. (KF 3.3)
		Dibatalkan	Pesanan yang dibatalkan beserta alasan. (KF 3.3)
3	💳  Transaksi	Semua Transaksi	Daftar seluruh transaksi pembayaran. (KF 3.4)
4	🛒  Produk & Toko	Toko 1 — Daftar Produk	Kelola produk Toko 1. (KF 3.5)
		Toko 2 — Daftar Produk	Kelola produk Toko 2. (KF 3.5)
		Toko 3 — Daftar Produk	Kelola produk Toko 3. (KF 3.5)
5	🚚  Pengiriman & Tracking	Update Status	Perbarui status tracking tiap paket. (KF 3.6)
		Scan Barcode	Scan barcode via webcam/USB scanner. (KF 3.6)
		Cetak Label	Generate & cetak label pengiriman. (KF 3.7)
		Riwayat Tracking	Cari & filter riwayat perjalanan paket. (KF 3.8)
6	📈  Laporan	Laporan Per Toko	Laporan penjualan masing-masing toko. (KF 3.9)
		Laporan Konsolidasi	Gabungan laporan 3 toko. (KF 3.9)
		Ekspor Data	Ekspor laporan ke PDF / Excel. (KF 3.9)
7	👥  Pelanggan	Daftar Customer	Lihat, cari, filter, hapus akun customer. (KF 4.1–4.3)
8	⚙️  Pengaturan	Profil Admin	Edit profil & ganti kata sandi. (KF 4A)
		Pengaturan Pengiriman	Atur threshold berat/volume. (KF 5.2)

2.1.1 Konvensi Visual Sidebar Admin
•	Setiap menu utama memiliki ikon dan label teks.
•	Sub-menu muncul saat menu utama diklik (accordion/expand).
•	Menu aktif ditandai dengan highlight warna biru.
•	Badge notifikasi angka muncul pada menu Pesanan jika ada pesanan baru yang belum dikonfirmasi.
•	Header sidebar menampilkan nama dan foto profil admin.
•	Tombol Logout tersedia di bagian bawah sidebar.

2.2 Navigasi Aplikasi Mobile (Customer)
Aplikasi mobile menggunakan Bottom Navigation Bar (tab bar bawah) dengan 4–5 tab utama, mengikuti pola standar aplikasi mobile e-commerce.

Tab / Menu Utama	Fungsi	Ref. KF
🏠  Beranda	Tampilan utama: banner promo, daftar 3 toko, produk rekomendasi.	KF 2.2
🛒  Katalog / Toko	Pilih toko, jelajah produk, cari berdasarkan nama/kategori.	KF 2.2
📦  Pesanan Saya	Riwayat pesanan, status real-time, filter status & tanggal.	KF 2.6, 2.7
📷  Scan Barcode	Kamera aktif untuk scan barcode paket — tracking & konfirmasi terima.	KF 2.5
👤  Profil	Info akun, riwayat transaksi, pengaturan, logout.	KF 2.1, 2.4

2.2.1 Sub-Menu dalam Tab “Pesanan Saya”
Tab Pesanan Saya memiliki sub-tab horizontal (chip/filter) yang mencerminkan tahap status pesanan:
•	Semua — seluruh pesanan tanpa filter.
•	Menunggu Konfirmasi — pesanan yang baru dibuat.
•	Dikemas — pesanan dalam proses pengemasan.
•	Dikirim — pesanan dalam perjalanan.
•	Selesai — pesanan yang sudah diterima.
•	Dibatalkan — pesanan yang dibatalkan.

2.2.2 Alur Keranjang & Checkout
•	Ikon keranjang belanja tersedia di pojok kanan atas halaman Katalog/Toko.
•	Badge angka pada ikon keranjang menunjukkan jumlah item.
•	Halaman Checkout mencakup: ringkasan produk, form alamat, info pengiriman (reguler/cargo otomatis), dan total biaya.
•	Konfirmasi pesanan membawa customer ke halaman Pembayaran.

 
3. KEBUTUHAN FUNGSIONAL — APLIKASI MOBILE (CUSTOMER)
Seluruh fitur di bagian ini dapat diakses melalui Bottom Navigation Bar yang didefinisikan pada Bagian 2.2.

3.1 Autentikasi
•	Registrasi akun menggunakan nama lengkap, email, nomor telepon, dan kata sandi.
•	Login menggunakan email dan kata sandi.
•	Logout dari aplikasi.
•	Reset kata sandi via email.

3.2 Katalog & Toko  —  Tab “Katalog / Toko”
•	Customer dapat melihat daftar 3 toko yang tersedia.
•	Customer dapat memilih toko dan melihat produk yang dijual oleh toko tersebut.
•	Customer dapat melihat detail produk: nama, deskripsi, harga, stok, dan foto.
•	Customer dapat mencari produk berdasarkan nama atau kategori.

3.3 Pemesanan & Checkout
•	Customer dapat menambahkan produk ke keranjang belanja (ikon keranjang pojok kanan atas).
•	Customer dapat mengubah jumlah atau menghapus item dari keranjang.
•	Customer mengisi alamat pengiriman saat checkout.
•	Sistem menentukan jenis pengiriman secara otomatis berdasarkan volume/berat pesanan:
◦	Pesanan kecil (di bawah threshold): pengiriman reguler dengan biaya tambahan kecil.
◦	Pesanan besar/banyak (melebihi threshold): pengiriman cargo dengan biaya tambahan cargo.
•	Customer melihat rincian biaya sebelum konfirmasi: subtotal produk, biaya pengiriman, dan total keseluruhan.
•	Customer mengkonfirmasi pesanan dan melanjutkan ke pembayaran.

3.4 Pembayaran
•	Customer memilih metode pembayaran yang tersedia (transfer bank, dompet digital, dll.).
•	Customer menerima notifikasi konfirmasi pembayaran berhasil atau gagal.
•	Customer dapat melihat riwayat transaksi dengan status: menunggu, lunas, atau dibatalkan.

3.5 Scan Barcode untuk Tracking  —  Tab “Scan Barcode”
Fitur ini memungkinkan customer melakukan scan barcode pada paket fisik atau label pengiriman untuk memantau dan mengkonfirmasi status paket secara langsung dari aplikasi mobile.

•	Customer membuka tab Scan Barcode di navigation bar bawah.
•	Kamera smartphone diaktifkan untuk melakukan scan barcode pada paket.
•	Sistem membaca barcode, mencocokkan dengan data pesanan milik customer, dan menampilkan:
◦	Status tracking terkini paket.
◦	Riwayat perjalanan paket (pengemasan, pengiriman, tiba).
◦	Tanggal dan waktu setiap tahap status.
•	Jika barcode dikenali sebagai paket milik customer: informasi tracking ditampilkan.
•	Jika barcode tidak dikenali atau bukan milik customer: sistem menampilkan pesan error.
•	Customer dapat menggunakan scan barcode sebagai cara konfirmasi bahwa paket telah diterima (Scan = Konfirmasi Terima).

3.6 Tracking Pesanan (Tanpa Scan)  —  Tab “Pesanan Saya”
•	Customer dapat memantau status pesanan secara real-time tanpa perlu scan, langsung dari tab Pesanan Saya.
•	Status yang ditampilkan:
◦	Pesanan Diterima — admin telah mengkonfirmasi pesanan.
◦	Dalam Pengemasan — paket sedang dikemas di toko.
◦	Dalam Pengiriman — paket dalam perjalanan ke customer.
◦	Paket Tiba — paket sudah diterima, disertai tanggal dan jam tiba.
•	Customer melihat riwayat lengkap perubahan status beserta timestamp setiap tahap.
•	Customer menerima notifikasi push setiap ada perubahan status.

3.7 Riwayat Pesanan  —  Tab “Pesanan Saya”
•	Customer dapat melihat semua pesanan yang pernah dibuat.
•	Customer dapat melihat detail pesanan: produk, biaya, status, dan informasi pengiriman.
•	Customer dapat memfilter pesanan berdasarkan status (sub-tab) atau rentang tanggal.

3.8 Notifikasi Push
•	Pesanan berhasil dikonfirmasi admin.
•	Pembayaran berhasil atau gagal.
•	Status paket berubah (pengemasan, pengiriman, tiba).
•	Paket telah tiba.

 
4. KEBUTUHAN FUNGSIONAL — APLIKASI WEB (ADMIN)
Satu role Admin mengelola seluruh operasional sistem melalui satu aplikasi web terintegrasi. Seluruh fitur berikut dapat diakses melalui sidebar navigasi yang didefinisikan pada Bagian 2.1.

4.1 Autentikasi Admin
•	Login menggunakan username/email dan kata sandi.
•	Logout dari sistem (tombol Logout di bagian bawah sidebar).
•	Reset kata sandi oleh admin sendiri.

4.2 Dashboard  —  Menu: 🏠 Dashboard
•	Ringkasan harian: jumlah pesanan masuk, diproses, dan selesai.
•	Total pendapatan harian, mingguan, dan bulanan per toko.
•	Grafik penjualan per toko (3 toko ditampilkan terpisah).
•	Ringkasan status tracking: jumlah paket dalam pengemasan, pengiriman, dan sudah terkirim.
•	Daftar pesanan terbaru yang memerlukan tindakan.
•	Alert paket yang belum diupdate statusnya dalam waktu tertentu.

4.3 Manajemen Pesanan  —  Menu: 📦 Pesanan
Sub-menu sidebar: Semua Pesanan | Perlu Dikonfirmasi | Dalam Pengemasan | Dalam Pengiriman | Selesai | Dibatalkan

•	Admin melihat daftar semua pesanan masuk dari ketiga toko.
•	Admin memfilter pesanan berdasarkan: toko, status, tanggal, dan jenis pengiriman.
•	Admin melihat detail pesanan: data customer, produk dipesan, alamat, dan total biaya.
•	Admin mengkonfirmasi pesanan yang masuk.
•	Admin membatalkan pesanan dengan alasan yang wajib dicatat.
•	Admin menentukan atau mengubah jenis pengiriman (reguler / cargo) jika diperlukan.

4.4 Manajemen Transaksi  —  Menu: 💳 Transaksi
Sub-menu sidebar: Semua Transaksi

•	Admin melihat daftar semua transaksi pembayaran.
•	Admin melihat status pembayaran: menunggu, lunas, gagal, atau refund.
•	Admin mencari transaksi berdasarkan ID pesanan, nama customer, atau tanggal.

4.5 Manajemen Produk & Toko  —  Menu: 🛒 Produk & Toko
Sub-menu sidebar: Toko 1 — Daftar Produk | Toko 2 — Daftar Produk | Toko 3 — Daftar Produk

•	Sistem mendukung 3 toko yang beroperasi secara independen, masing-masing memiliki sub-menu sendiri.
•	Admin dapat menambah, mengubah, dan menghapus produk pada setiap toko.
•	Admin mengatur harga, stok, deskripsi, dan foto produk.
•	Setiap toko memiliki katalog dan laporan penjualan yang terpisah.

4.6 Tracking & Scan Barcode  —  Menu: 🚚 Pengiriman & Tracking
Sub-menu sidebar: Update Status | Scan Barcode | Cetak Label | Riwayat Tracking

Admin memiliki kemampuan scan barcode melalui web menggunakan kamera web (webcam) atau scanner USB untuk memperbarui status tracking paket.

•	Admin melihat daftar semua pesanan yang perlu diupdate status trackingnya (sub-menu Update Status).
•	Admin mengupdate status tracking setiap pesanan:
◦	Pesanan Diterima — otomatis saat admin konfirmasi pesanan.
◦	Dalam Pengemasan — admin mengupdate saat proses kemas dimulai.
◦	Dalam Pengiriman — admin scan barcode paket atau input nomor resi, disertai nama kurir/vendor cargo.
◦	Paket Tiba — admin scan barcode atau konfirmasi manual, disertai tanggal dan jam tiba.
•	Alur scan barcode di web admin (sub-menu Scan Barcode):
◦	Admin memilih status yang akan diupdate.
◦	Admin mengaktifkan kamera web atau menghubungkan scanner USB.
◦	Admin menscan barcode pada paket.
◦	Sistem mencocokkan barcode dengan data pesanan dan memperbarui status secara otomatis.
◦	Sistem menampilkan konfirmasi berhasil atau pesan error jika barcode tidak dikenali.
•	Admin dapat memasukkan nomor resi secara manual sebagai alternatif scan.
•	Setiap perubahan status tercatat beserta timestamp dan nama admin yang mengupdate.
•	Admin dapat menambahkan catatan pada setiap perubahan status (misal: delay, kendala pengiriman).

4.7 Cetak Label & Barcode  —  Sub-menu: Cetak Label
•	Admin dapat mencetak label pengiriman yang memuat barcode unik, nama customer, alamat tujuan, nama toko, dan nomor pesanan.
•	Barcode digenerate otomatis oleh sistem saat pesanan dikonfirmasi.
•	Label kompatibel dengan printer thermal maupun printer biasa.

4.8 Riwayat & Pencarian Tracking  —  Sub-menu: Riwayat Tracking
•	Admin melihat riwayat lengkap perubahan status setiap pesanan beserta waktu dan nama admin yang mengupdate.
•	Admin mencari paket berdasarkan nomor resi, ID pesanan, atau nama customer.
•	Admin memfilter tracking berdasarkan status, tanggal, dan toko asal.

4.9 Laporan Penjualan  —  Menu: 📈 Laporan
Sub-menu sidebar: Laporan Per Toko | Laporan Konsolidasi | Ekspor Data

•	Admin melihat laporan penjualan per toko dalam rentang tanggal tertentu (sub-menu Laporan Per Toko).
•	Laporan mencakup: total pesanan, total pendapatan, produk terlaris, dan metode pembayaran.
•	Admin melihat laporan konsolidasi ketiga toko dalam satu tampilan (sub-menu Laporan Konsolidasi).
•	Laporan dapat diekspor dalam format PDF atau Excel (sub-menu Ekspor Data).

 
5. KEBUTUHAN FUNGSIONAL — MANAJEMEN DATA CUSTOMER
Dapat diakses melalui sidebar: Menu 👥 Pelanggan > Daftar Customer

5.1 Hak Akses Admin terhadap Data Customer
Aksi	Diizinkan?	Keterangan	Ref.
Lihat (View) Data Customer	Ya	Admin dapat melihat seluruh data customer yang terdaftar.	KF 5.2, 5.3
Cari (Search) Customer	Ya	Pencarian berdasarkan nama, email, atau nomor telepon.	KF 5.2
Filter Data Customer	Ya	Filter berdasarkan tanggal registrasi, status akun, atau toko.	KF 5.2
Hapus (Delete) Customer	Ya	Admin dapat menghapus akun customer.	KF 5.1
Tambah (Create) Customer	TIDAK	Pembuatan akun hanya dapat dilakukan oleh customer sendiri.	—
Edit (Update) Data Customer	TIDAK	Admin tidak diperbolehkan mengubah data pribadi customer.	—

5.2 Fitur Pencarian & Filter Customer
•	Pencarian berdasarkan nama lengkap, email, atau nomor telepon.
•	Filter berdasarkan:
◦	Status akun: aktif atau dinonaktifkan.
◦	Tanggal registrasi: rentang awal dan akhir.
◦	Toko yang pernah melakukan pemesanan.
•	Hasil menampilkan: nama, email, nomor telepon, tanggal registrasi, jumlah pesanan, dan status akun.

5.3 Detail Data Customer
•	Informasi profil: nama, email, nomor telepon, alamat.
•	Riwayat pesanan: daftar semua pesanan yang pernah dibuat.
•	Status akun: aktif atau dinonaktifkan.

6. KEBUTUHAN FUNGSIONAL — MANAJEMEN DATA ADMIN
Dapat diakses melalui sidebar: Menu ⚙️ Pengaturan > Profil Admin

6.1 Hak Akses Admin terhadap Data Admin
Aksi	Diizinkan?	Keterangan
Lihat (View) Profil Sendiri	Ya	Admin dapat melihat data profilnya sendiri.
Edit (Update) Profil Sendiri	Ya	Admin dapat mengubah nama, email, dan nomor telepon miliknya sendiri.
Ganti Kata Sandi	Ya	Admin dapat mengganti kata sandinya sendiri melalui pengaturan profil.
Hapus (Delete) Akun Admin	TIDAK	Admin tidak dapat menghapus akunnya sendiri maupun akun admin lain.
Tambah (Create) Akun Admin	TIDAK	Pembuatan akun admin dilakukan di luar sistem (langsung di database/server).

6.2 Fitur Edit Profil Admin
•	Admin dapat melihat informasi profil saat ini: nama lengkap, email, dan nomor telepon.
•	Admin dapat mengubah nama lengkap, email, dan nomor telepon miliknya sendiri.
•	Admin dapat mengganti kata sandi dengan memasukkan kata sandi lama dan kata sandi baru.
•	Sistem menampilkan konfirmasi setelah perubahan profil berhasil disimpan.
•	Admin tidak dapat mengubah data profil admin lain.

6.3 Detail Data Profil Admin
•	Informasi akun: nama lengkap, username/email, dan nomor telepon.
•	Status akun: aktif.
•	Tanggal akun dibuat (read-only, tidak dapat diubah).

 
7. MEKANISME PENGIRIMAN
Pengaturan threshold dapat diakses melalui: Menu ⚙️ Pengaturan > Pengaturan Pengiriman

7.1 Jenis Pengiriman
Jenis	Kondisi	Biaya Tambahan	Keterangan
Reguler	Pesanan kecil (di bawah threshold berat/volume)	Ada, nominal kecil	Tanpa cargo, cocok untuk pesanan sedikit/ringan.
Cargo	Pesanan besar (melebihi threshold berat/volume)	Ada, nominal lebih besar	Menggunakan vendor cargo untuk volume/berat besar.

7.2 Aturan Penentuan Pengiriman
•	Admin mengatur nilai threshold berat/volume di panel Pengaturan Pengiriman (sidebar Menu Pengaturan).
•	Sistem otomatis merekomendasikan jenis pengiriman saat customer checkout.
•	Admin dapat mengubah jenis pengiriman secara manual jika diperlukan (dari menu Pesanan).
•	Biaya pengiriman ditampilkan transparan kepada customer sebelum konfirmasi pesanan.

8. MULTI-TOKO

8.1 Ketentuan
•	Sistem mengelola 3 toko yang beroperasi secara independen.
•	Setiap toko memiliki katalog produk, stok, harga, dan laporan penjualan yang terpisah.
•	Customer dapat memesan dari lebih dari satu toko; setiap toko menghasilkan pesanan dan tracking terpisah.
•	Di sidebar admin, setiap toko memiliki sub-menu tersendiri di bawah menu Produk & Toko.

8.2 Laporan Per Toko
•	Admin dapat melihat laporan spesifik per toko maupun laporan konsolidasi ketiga toko (menu Laporan).

8.3 Struktur Relasi: Toko → Kategori → Produk
Bagian ini mendefinisikan hierarki relasional inti antara entitas Toko, Kategori Produk, dan Produk. Struktur ini menjadi fondasi data seluruh fitur manajemen produk, katalog, dan laporan penjualan dalam sistem.

8.3.1 Diagram Relasi (Teks)

  TOKO (Store)
    │
    │  1 : N  (satu toko memiliki banyak kategori)
    │
    ▼
  KATEGORI PRODUK (ProductCategory)
    │
    │  1 : N  (satu kategori memiliki banyak produk)
    │
    ▼
  PRODUK (Product)

Keterangan notasi:
  •  1 : N  =  One-to-Many (satu ke banyak)
  •  Setiap level hanya memiliki satu induk — tidak ada kategori atau produk yang dapat berasal dari lebih dari satu toko/kategori.

8.3.2 Detail Setiap Relasi

[A] Toko → Kategori Produk  (One-to-Many)
•	Satu toko dapat memiliki banyak kategori produk (misal: Toko 1 memiliki kategori "Makanan", "Minuman", "Snack").
•	Setiap kategori produk hanya milik satu toko — kategori tidak dapat dibagikan ke toko lain.
•	Jika sebuah toko dihapus, seluruh kategori yang dimiliki toko tersebut ikut dihapus (cascade delete).
•	Kategori diidentifikasi unik dalam lingkup toko yang sama (slug unik per toko).

[B] Kategori Produk → Produk  (One-to-Many)
•	Satu kategori dapat memiliki banyak produk (misal: kategori "Minuman" memuat produk "Es Teh", "Jus Jeruk", "Air Mineral").
•	Setiap produk hanya dapat masuk ke dalam satu kategori — produk tidak dapat dikategorikan ganda.
•	Jika sebuah kategori dihapus, produk yang berada di dalamnya tidak akan otomatis terhapus; admin harus memvalidasi atau memindahkan produk tersebut terlebih dahulu.
•	Pengelompokan produk ke dalam kategori memudahkan pencarian dan filter produk oleh customer di aplikasi mobile.

[C] Toko → Produk  (Relasi Tak Langsung, melalui Kategori)
•	Seorang customer melihat produk berdasarkan toko yang dipilih, kemudian dapat memfilter lebih lanjut berdasarkan kategori di dalam toko tersebut.
•	Setiap produk secara implisit terikat pada toko melalui kategorinya — produk dari Toko 1 tidak pernah muncul di katalog Toko 2 maupun Toko 3.
•	Stok, harga, dan laporan penjualan setiap produk dihitung dalam ruang lingkup toko masing-masing.

8.3.3 Aturan Bisnis Relasi

No	Aturan	Keterangan
1	Kategori wajib terikat ke toko	Tidak boleh ada kategori tanpa toko induk (store_id NOT NULL).
2	Produk wajib terikat ke kategori	Setiap produk harus memiliki kategori yang valid sebelum dapat dipublikasikan.
3	Kategori lintas toko dilarang	Admin tidak dapat memindahkan kategori dari Toko A ke Toko B.
4	Produk lintas kategori dilarang	Satu produk hanya masuk ke satu kategori; perubahan kategori harus dilakukan secara eksplisit oleh admin.
5	Isolasi data per toko terjaga	Laporan, stok, dan katalog produk selalu di-scope ke toko asal melalui rantai Toko → Kategori → Produk.

8.3.4 Implikasi pada Antarmuka Admin
•	Saat admin membuka sub-menu Toko N — Daftar Produk, tampilan difilter berdasarkan toko yang dipilih.
•	Di dalam halaman daftar produk per toko, admin dapat menyaring produk lebih lanjut berdasarkan kategori toko tersebut.
•	Form tambah/edit produk mengharuskan admin memilih kategori; daftar kategori yang muncul hanya berasal dari toko yang sedang aktif agar tidak terjadi kesalahan relasi lintas toko.
•	Form tambah/edit kategori mengharuskan admin memilih toko; setelah tersimpan, kategori tersebut eksklusif milik toko yang dipilih dan tidak dapat diubah toko-nya.

9. ALUR TRACKING LENGKAP

9.1 Tahapan Status
No	Status	Siapa Update	Cara Update	Terlihat Oleh
1	Pesanan Diterima	Admin (Web — Menu Pesanan)	Konfirmasi pesanan di web	Customer & Admin
2	Dalam Pengemasan	Admin (Web — Menu Pengiriman & Tracking)	Update manual / scan barcode via web	Customer & Admin
3	Dalam Pengiriman	Admin (Web — Menu Pengiriman & Tracking)	Scan barcode / input resi via web	Customer & Admin
4	Paket Tiba	Admin (Web) atau Customer (Mobile — Tab Scan Barcode)	Scan barcode via web/mobile	Customer & Admin

9.2 Informasi yang Ditampilkan pada Tracking
•	Nomor pesanan dan nomor resi/barcode unik.
•	Nama toko asal.
•	Status terkini beserta tanggal dan waktu update.
•	Riwayat lengkap semua status yang telah dilalui.
•	Tanggal estimasi atau tanggal aktual paket tiba.
•	Nama kurir atau vendor cargo yang digunakan.

 
10. RINGKASAN FITUR PER AKTOR

Fitur / Modul	Customer (Mobile)	Admin (Web)
Registrasi & Login	Ya (daftar sendiri)	Ya (login admin)
Lihat Katalog & Produk	Ya — Tab Katalog/Toko	Ya (kelola) — Menu Produk & Toko
Pemesanan & Checkout	Ya — Keranjang & Checkout	—
Pembayaran	Ya	Konfirmasi pembayaran — Menu Transaksi
Scan Barcode	Ya — Tab Scan Barcode	Ya — Menu Pengiriman & Tracking > Scan Barcode
Tracking Status Pesanan	Lihat + Scan — Tab Pesanan Saya	Lihat + Update + Scan — Menu Pengiriman & Tracking
Notifikasi	Push notification	Notifikasi web (badge menu Pesanan)
Laporan Penjualan	—	Ya — Menu Laporan (per toko & konsolidasi)
Manajemen Produk & Toko	—	Ya (CRUD, 3 toko) — Menu Produk & Toko
Manajemen Data Customer	Lihat & Edit profil sendiri	Lihat, Hapus, Cari, Filter — Menu Pelanggan
Manajemen Data Admin	—	Lihat & Edit profil sendiri — Menu Pengaturan
Cetak Label & Barcode	—	Ya — Menu Pengiriman & Tracking > Cetak Label
Dashboard	Ringkasan pesanan & tracking (Tab Beranda)	Penjualan, Tracking, Pesanan — Menu Dashboard
Manajemen Pengiriman	Pilih otomatis saat checkout	Override & atur threshold — Menu Pengaturan


Dokumen Kebutuhan Fungsional v3.0  —  Revisi Struktur Navigasi Menu  |  Tugas Akhir
