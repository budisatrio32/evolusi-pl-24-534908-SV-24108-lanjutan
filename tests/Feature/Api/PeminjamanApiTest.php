<?php

namespace Tests\Feature\Api;

use App\Models\Peminjaman;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class PeminjamanApiTest extends TestCase
{
    use RefreshDatabase;

    public function test_endpoint_peminjaman_mengembalikan_json(): void
    {
        Peminjaman::factory()->create([
            'nama_peminjam' => 'Budi',
            'judul_buku' => 'Clean Code',
            'tanggal_pinjam' => '2026-09-01',
            'status' => 'dipinjam',
        ]);

        $this->getJson('/api/peminjaman')
            ->assertOk()
            ->assertJsonCount(1, 'data')
            ->assertJsonFragment([
                'nama_peminjam' => 'Budi',
                'judul_buku' => 'Clean Code',
                'tanggal_pinjam' => '2026-09-01',
                'tanggal_kembali' => null,
                'status' => 'dipinjam',
            ]);
    }

    public function test_endpoint_peminjaman_mengembalikan_data_kosong(): void
    {
        $this->getJson('/api/peminjaman')
            ->assertOk()
            ->assertExactJson(['data' => []]);
    }
}
