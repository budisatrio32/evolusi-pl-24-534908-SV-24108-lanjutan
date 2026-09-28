# syntax=docker/dockerfile:1

# Image dasar resmi, tag jelas (bukan latest), varian alpine supaya kecil.
FROM php:8.2-cli-alpine

# ---------------------------------------------------------------------------
# Layer 1 - paling jarang berubah: ekstensi PHP yang dibutuhkan Laravel.
# Paket build dihapus lagi di baris yang sama supaya tidak menambah ukuran image.
# ---------------------------------------------------------------------------
RUN apk add --no-cache --virtual .build-deps $PHPIZE_DEPS sqlite-dev \
    && docker-php-ext-install -j"$(nproc)" pdo_sqlite \
    && apk del .build-deps

# Composer diambil dari image resminya, versinya dikunci.
COPY --from=composer:2.8 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

# ---------------------------------------------------------------------------
# Layer 2 - daftar dependensi disalin dan dipasang SEBELUM kode aplikasi.
# Selama composer.json dan composer.lock tidak berubah, layer ini dipakai ulang
# dari cache sehingga Composer tidak mengunduh apa pun saat build berikutnya.
#   --no-scripts   : artisan belum ada di tahap ini
#   --no-autoloader: autoload dibuat setelah kode lengkap disalin
# ---------------------------------------------------------------------------
COPY composer.json composer.lock ./
RUN composer install --no-dev --prefer-dist --no-interaction --no-progress \
    --no-scripts --no-autoloader

# ---------------------------------------------------------------------------
# Layer 3 - paling sering berubah: kode aplikasi.
# Satu huruf berubah di sini hanya membatalkan layer ini ke bawah,
# bukan pemasangan dependensi di atasnya.
# ---------------------------------------------------------------------------
COPY . .

RUN composer dump-autoload --no-dev --optimize \
    && chmod -R ug+w storage bootstrap/cache \
    && chmod +x docker/entrypoint.sh

# Sekadar dokumentasi; yang benar-benar membuka port adalah -p saat docker run.
EXPOSE 8000

ENTRYPOINT ["/var/www/html/docker/entrypoint.sh"]
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]
