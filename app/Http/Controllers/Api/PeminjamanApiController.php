<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Peminjaman;
use Illuminate\Http\JsonResponse;

class PeminjamanApiController extends Controller
{
    /**
     * Daftar peminjaman buku dalam bentuk JSON untuk aplikasi Vue.
     */
    public function index(): JsonResponse
    {
        $peminjaman = Peminjaman::latest()->get()->map(fn (Peminjaman $item) => [
            'id' => $item->id,
            'nama_peminjam' => $item->nama_peminjam,
            'judul_buku' => $item->judul_buku,
            'tanggal_pinjam' => $item->tanggal_pinjam->toDateString(),
            'tanggal_kembali' => $item->tanggal_kembali?->toDateString(),
            'status' => $item->status,
        ]);

        return response()->json(['data' => $peminjaman]);
    }
}
