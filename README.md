# evolusi-pl-24-534908-SV-24108

Aplikasi web sederhana berbasis **Laravel 12** sebagai tugas mata kuliah
**Konstruksi dan Evolusi Perangkat Lunak**.

| Keterangan  | Isi                    |
| ----------- | ---------------------- |
| Nama        | Prihastomo Budi Satrio|
| NIM         | 24/534908/SV/24108     |
| Mata Kuliah | Konstruksi dan Evolusi Perangkat Lunak |

## Kebutuhan Sistem

- PHP 8.2 atau lebih baru, dengan ekstensi `pdo_sqlite`
- Composer 2.x

Aplikasi berisi fitur CRUD **Peminjaman Buku** (satu tabel `peminjaman`) dengan
basis data SQLite. Sesi dan cache tetap disimpan pada berkas.

## Cara Menjalankan

```bash
git clone https://github.com/<username>/evolusi-pl-24-534908-SV-24108.git
cd evolusi-pl-24-534908-SV-24108

composer install
cp .env.example .env
php artisan key:generate

touch database/database.sqlite
php artisan migrate

php artisan serve
```

Aplikasi dapat diakses pada `http://127.0.0.1:8000`, dan fitur peminjaman buku
pada `http://127.0.0.1:8000/peminjaman`.

## Endpoint API

| Metode | Alamat            | Keterangan                              |
| ------ | ----------------- | --------------------------------------- |
| GET    | `/api/peminjaman` | Daftar peminjaman buku dalam bentuk JSON |

Alamat yang diizinkan memanggil API diatur pada [`config/cors.php`](config/cors.php),
secara bawaan `http://localhost:5173` dan `http://127.0.0.1:5173` (Vite dev server).

## Frontend (Vue 3)

Aplikasi frontend berada pada folder [`frontend/`](frontend/) dan dibuat dengan
`create-vue` (Vue 3 + Vue Router + Vitest + ESLint).

```bash
cd frontend
npm install
cp .env.example .env    # isi VITE_API_URL
npm run dev
```

Frontend dapat diakses pada `http://localhost:5173` dengan dua halaman ber-router,
yaitu `/` (beranda) dan `/peminjaman` (data dari API Laravel).

## Menjalankan Pengujian

```bash
php artisan test              # test backend Laravel
vendor/bin/pint --test        # memeriksa gaya penulisan kode PHP

cd frontend
npm run lint                  # oxlint + ESLint
npm run test:unit -- --run    # unit test Vitest
npm run build                 # membangun folder dist/
```

## Alur Kerja Git

Repositori ini menggunakan alur bercabang tiga tingkat:

```
main  ← branch stabil, hanya menerima merge dari dev melalui Pull Request
 └── dev  ← branch integrasi, menerima merge dari feature/* melalui Pull Request
      └── feature/*  ← branch pengerjaan fitur
```

Aturan yang diterapkan:

- Tidak ada push langsung ke `main` maupun `dev`; keduanya dilindungi *branch protection rule*.
- Setiap perubahan digabungkan melalui Pull Request.
- Pesan commit mengikuti standar [Conventional Commits](https://www.conventionalcommits.org/),
  misalnya `feat:`, `fix:`, `test:`, `docs:`, `ci:`, dan `chore:`.

## Continuous Integration

Repositori ini memiliki dua workflow GitHub Actions.

[`.github/workflows/deploy.yml`](.github/workflows/deploy.yml) — pipeline backend:

```
build → test → staging → production
```

[`.github/workflows/frontend-ci.yml`](.github/workflows/frontend-ci.yml) — pipeline frontend:

```
lint → test → build → deploy
```

Job terakhir pada kedua pipeline (`production` dan `deploy`) hanya berjalan dari
branch `main`. Push ke branch fitur dan Pull Request tetap menjalankan job-job
sebelumnya. Job `deploy` frontend tidak membangun ulang aplikasi, melainkan
mengunduh artifact hasil job `build`.
