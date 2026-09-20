/**
 * Logika murni seputar data peminjaman buku.
 * Fungsi di berkas ini tidak memanggil jaringan, sehingga bisa diuji
 * dengan Vitest tanpa perlu menjalankan Laravel.
 */

const LABEL_STATUS = {
  dipinjam: 'Dipinjam',
  dikembalikan: 'Dikembalikan',
}

/**
 * Membuat label ringkas untuk satu baris peminjaman.
 * Contoh: formatLabelPeminjaman({ nama_peminjam: 'Budi', judul_buku: 'Clean Code' })
 *         menghasilkan "Budi - Clean Code".
 */
export function formatLabelPeminjaman(peminjaman) {
  const nama = peminjaman?.nama_peminjam?.trim()
  const judul = peminjaman?.judul_buku?.trim()

  if (!nama || !judul) {
    return 'Data tidak lengkap'
  }

  return `${nama} - ${judul}`
}

/**
 * Mengubah tanggal ISO (2026-09-01) menjadi format Indonesia (01-09-2026).
 * Nilai kosong ditampilkan sebagai tanda strip.
 */
export function formatTanggal(tanggal) {
  if (!tanggal) {
    return '-'
  }

  const [tahun, bulan, hari] = tanggal.split('-')

  return `${hari}-${bulan}-${tahun}`
}

/**
 * Mengubah kode status menjadi teks yang enak dibaca.
 */
export function labelStatus(status) {
  return LABEL_STATUS[status] ?? 'Tidak diketahui'
}

/**
 * Menghitung ringkasan jumlah peminjaman berdasarkan status.
 */
export function ringkasStatus(daftar = []) {
  return daftar.reduce(
    (ringkasan, item) => {
      ringkasan.total += 1

      if (item.status === 'dikembalikan') {
        ringkasan.dikembalikan += 1
      } else {
        ringkasan.dipinjam += 1
      }

      return ringkasan
    },
    { total: 0, dipinjam: 0, dikembalikan: 0 },
  )
}
