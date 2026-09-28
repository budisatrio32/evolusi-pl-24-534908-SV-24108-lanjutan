<?php

namespace Database\Seeders;

use App\Models\Peminjaman;
use Illuminate\Database\Seeder;

class PeminjamanSeeder extends Seeder
{
    /**
     * Data contoh supaya halaman dan endpoint API tidak kosong
     * saat aplikasi dijalankan dari container.
     */
    public function run(): void
    {
        $data = [
            [
                'nama_peminjam' => 'Prihastomo Budi Satrio',
                'judul_buku' => 'Clean Code',
                'tanggal_pinjam' => '2026-09-20',
                'tanggal_kembali' => null,
                'status' => 'dipinjam',
            ],
            [
                'nama_peminjam' => 'Siti Aminah',
                'judul_buku' => 'Refactoring',
                'tanggal_pinjam' => '2026-09-18',
                'tanggal_kembali' => '2026-09-25',
                'status' => 'dikembalikan',
            ],
            [
                'nama_peminjam' => 'Andi Wijaya',
                'judul_buku' => 'Continuous Delivery',
                'tanggal_pinjam' => '2026-09-22',
                'tanggal_kembali' => null,
                'status' => 'dipinjam',
            ],
        ];

        foreach ($data as $peminjaman) {
            Peminjaman::create($peminjaman);
        }
    }
}
