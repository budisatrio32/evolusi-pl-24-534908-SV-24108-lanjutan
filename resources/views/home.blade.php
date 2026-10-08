@extends('layouts.app')

@section('title', 'Beranda')

@section('content')
    <div class="card">
        <h1>Aplikasi Web Sederhana.</h1>
        <p>
            Aplikasi ini dibangun dengan Laravel {{ app()->version() }} sebagai studi kasus mata kuliah
            Konstruksi dan Evolusi Perangkat Lunak.
        </p>
        <p>
            Repositori ini dikelola dengan alur kerja Git yang rapi: penamaan commit mengikuti
            Conventional Commits, pengembangan dilakukan pada branch <code>feature/*</code>,
            dan setiap perubahan digabungkan melalui Pull Request.
        </p>
    </div>
@endsection
