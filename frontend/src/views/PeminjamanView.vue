<script setup>
import { onMounted, ref } from 'vue'
import { ambilPeminjaman, apiBaseUrl } from '../lib/api'
import { formatLabelPeminjaman, formatTanggal, labelStatus, ringkasStatus } from '../lib/peminjaman'

const daftar = ref([])
const ringkasan = ref({ total: 0, dipinjam: 0, dikembalikan: 0 })
const galat = ref('')
const memuat = ref(true)

onMounted(async () => {
  try {
    daftar.value = await ambilPeminjaman()
    ringkasan.value = ringkasStatus(daftar.value)
  } catch (error) {
    galat.value = error.message
  } finally {
    memuat.value = false
  }
})
</script>

<template>
  <section class="card">
    <h1>Data Peminjaman</h1>
    <p class="muted">
      Sumber data: <code>{{ apiBaseUrl }}/peminjaman</code>
    </p>

    <p v-if="memuat">Memuat data...</p>
    <p v-else-if="galat" class="galat">{{ galat }}</p>

    <template v-else>
      <p class="ringkasan">
        Total <strong>{{ ringkasan.total }}</strong> peminjaman &middot; dipinjam
        <strong>{{ ringkasan.dipinjam }}</strong> &middot; dikembalikan
        <strong>{{ ringkasan.dikembalikan }}</strong>
      </p>

      <p v-if="!daftar.length" class="muted">Belum ada data peminjaman.</p>

      <ul v-else class="daftar">
        <li v-for="item in daftar" :key="item.id">
          <span class="judul">{{ formatLabelPeminjaman(item) }}</span>
          <span class="meta">
            {{ formatTanggal(item.tanggal_pinjam) }} &rarr;
            {{ formatTanggal(item.tanggal_kembali) }}
          </span>
          <span class="badge" :class="item.status">{{ labelStatus(item.status) }}</span>
        </li>
      </ul>
    </template>
  </section>
</template>
