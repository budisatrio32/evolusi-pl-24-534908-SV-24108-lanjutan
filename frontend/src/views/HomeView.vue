<script setup>
import { apiBaseUrl } from '../lib/api'
</script>

<template>
  <section class="card">
    <h1>Peminjaman Buku</h1>
    <p>
      Aplikasi Vue 3 ini adalah antarmuka untuk API Laravel pada repositori
      <code>evolusi-pl-24-534908-SV-24108</code>.
    </p>

    <dl>
      <dt>Nama</dt>
      <dd>Prihastomo Budi Satrio</dd>
      <dt>NIM</dt>
      <dd>24/534908/SV/24108</dd>
      <dt>Alamat API</dt>
      <dd>
        <code>{{ apiBaseUrl || 'VITE_API_URL belum diatur' }}</code>
      </dd>
    </dl>

    <RouterLink class="btn" to="/peminjaman">Lihat data peminjaman</RouterLink>
  </section>
</template>
