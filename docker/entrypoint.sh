#!/bin/sh
set -e   # berhenti bila ada perintah gagal

cd /var/www/html

# 1 - Siapkan berkas .env. Berkas asli milik laptop sengaja tidak ikut ke image.
if [ ! -f .env ]; then
    cp .env.example .env
fi

# 2 - Buat APP_KEY bila belum ada.
if ! grep -q '^APP_KEY=base64:' .env; then
    php artisan key:generate --force
fi

# 3 - Siapkan basis data SQLite. Diisi data contoh hanya saat pertama dibuat.
#     Seeder dipanggil langsung karena DatabaseSeeder bawaan memakai factory,
#     sedangkan Faker (require-dev) tidak ikut terpasang di image ini.
if [ ! -f database/database.sqlite ]; then
    touch database/database.sqlite
    php artisan migrate --force
    php artisan db:seed --class=PeminjamanSeeder --force
else
    php artisan migrate --force
fi

# 4 - Bersihkan cache konfigurasi supaya nilai dari environment terbaca.
php artisan config:clear

# 5 - Jalankan perintah utama container (lihat CMD pada Dockerfile).
exec "$@"
