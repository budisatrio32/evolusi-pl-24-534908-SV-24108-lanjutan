<script setup>
import { RouterLink, RouterView } from 'vue-router'
</script>

<template>
  <header>
    <nav>
      <span class="brand">Evolusi PL</span>
      <RouterLink to="/">Beranda</RouterLink>
      <RouterLink to="/peminjaman">Peminjaman</RouterLink>
    </nav>
  </header>

  <main>
    <RouterView />
  </main>

  <footer>Konstruksi dan Evolusi Perangkat Lunak &middot; Frontend Vue 3</footer>
</template>
