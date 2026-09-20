/**
 * Alamat API diambil dari variabel lingkungan VITE_API_URL,
 * bukan ditulis langsung di dalam kode.
 */
export const apiBaseUrl = import.meta.env.VITE_API_URL ?? ''

export async function ambilPeminjaman() {
  if (!apiBaseUrl) {
    throw new Error('VITE_API_URL belum diatur pada berkas .env')
  }

  const response = await fetch(`${apiBaseUrl}/peminjaman`)

  if (!response.ok) {
    throw new Error(`Gagal mengambil data (HTTP ${response.status})`)
  }

  const isi = await response.json()

  return isi.data ?? []
}
