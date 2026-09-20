import { describe, it, expect } from 'vitest'
import { formatLabelPeminjaman, formatTanggal, labelStatus, ringkasStatus } from '../peminjaman'

describe('formatLabelPeminjaman', () => {
  it('menggabungkan nama peminjam dan judul buku', () => {
    const label = formatLabelPeminjaman({ nama_peminjam: 'Budi', judul_buku: 'Clean Code' })

    expect(label).toBe('Budi - Clean Code')
  })

  it('memberi tahu saat data tidak lengkap', () => {
    expect(formatLabelPeminjaman({ nama_peminjam: 'Budi', judul_buku: '' })).toBe(
      'Data tidak lengkap',
    )
    expect(formatLabelPeminjaman(null)).toBe('Data tidak lengkap')
  })
})

describe('formatTanggal', () => {
  it('mengubah tanggal ISO menjadi format Indonesia', () => {
    expect(formatTanggal('2026-09-01')).toBe('01-09-2026')
  })

  it('menampilkan strip saat tanggal kosong', () => {
    expect(formatTanggal(null)).toBe('-')
  })
})

describe('labelStatus', () => {
  it('menerjemahkan kode status yang dikenal', () => {
    expect(labelStatus('dipinjam')).toBe('Dipinjam')
    expect(labelStatus('dikembalikan')).toBe('Dikembalikan')
  })

  it('mengembalikan teks cadangan untuk status asing', () => {
    expect(labelStatus('hilang')).toBe('Tidak diketahui')
  })
})

describe('ringkasStatus', () => {
  it('menghitung jumlah peminjaman per status', () => {
    const ringkasan = ringkasStatus([
      { status: 'dipinjam' },
      { status: 'dikembalikan' },
      { status: 'dipinjam' },
    ])

    expect(ringkasan).toEqual({ total: 3, dipinjam: 2, dikembalikan: 1 })
  })

  it('mengembalikan nol untuk daftar kosong', () => {
    expect(ringkasStatus()).toEqual({ total: 0, dipinjam: 0, dikembalikan: 0 })
  })
})
