<?php

use App\Http\Controllers\Api\PeminjamanApiController;
use Illuminate\Support\Facades\Route;

Route::get('/peminjaman', [PeminjamanApiController::class, 'index'])
    ->name('api.peminjaman.index');
