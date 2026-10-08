# syntax=docker/dockerfile:1

# Versi dikunci sampai patch dan versi Alpine, bukan latest ataupun 8.2 saja,
# supaya hasil build hari ini sama dengan hasil build bulan depan.
ARG PHP_IMAGE=php:8.2.34-cli-alpine3.24

# ===========================================================================
# Tahap 1 - builder
# Boleh besar: ada Composer, cache unduhan, dan semua alat build.
# Tidak satu pun isi tahap ini ikut ke image akhir kecuali yang disalin
# secara eksplisit dengan COPY --from=builder.
# ===========================================================================
FROM ${PHP_IMAGE} AS builder

COPY --from=composer:2.8.12 /usr/bin/composer /usr/bin/composer

WORKDIR /app

# Dependency dipasang sebelum kode disalin, supaya layer ini tetap diambil
# dari cache selama composer.json dan composer.lock tidak berubah.
COPY composer.json composer.lock ./
RUN composer install --no-dev --prefer-dist --no-interaction --no-progress \
    --no-scripts --no-autoloader

COPY . .

RUN composer dump-autoload --no-dev --optimize \
    && chmod -R ug+w storage bootstrap/cache database \
    && chmod +x docker/entrypoint.sh

# ===========================================================================
# Tahap 2 - runtime
# Hanya berisi PHP dan hasil jadi dari builder (kode + vendor).
# Tanpa Composer, tanpa cache Composer, tanpa paket build.
# Ekstensi pdo_sqlite sudah bawaan image php resmi, jadi tidak perlu dipasang.
# ===========================================================================
FROM ${PHP_IMAGE} AS runtime

# User biasa tanpa hak root; container tidak boleh berjalan sebagai root.
RUN addgroup -S -g 1000 laravel \
    && adduser -S -D -H -u 1000 -G laravel -h /var/www/html laravel

WORKDIR /var/www/html

# --chown langsung saat menyalin, bukan RUN chown -R terpisah,
# karena chown terpisah akan menggandakan seluruh vendor ke layer baru.
COPY --from=builder --chown=laravel:laravel /app /var/www/html

USER laravel

EXPOSE 8000

# Docker memanggil endpoint /up (health route bawaan Laravel) secara berkala.
# Tiga kali gagal berturut-turut = status unhealthy.
HEALTHCHECK --interval=10s --timeout=3s --start-period=20s --retries=3 \
    CMD wget -q --spider http://127.0.0.1:8000/up || exit 1

ENTRYPOINT ["/var/www/html/docker/entrypoint.sh"]
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]
