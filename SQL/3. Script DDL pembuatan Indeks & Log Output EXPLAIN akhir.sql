CREATE INDEX idx_penumpang_nama
    ON penumpang (nama);

CREATE INDEX idx_perjalanan_penumpang_tgl
    ON perjalanan (id_penumpang, tgl_perjalanan DESC, id_perjalanan DESC);

CREATE INDEX idx_perjalanan_pengemudi_tgl
    ON perjalanan (id_pengemudi, tgl_perjalanan)
    INCLUDE (status, tarif);

CREATE INDEX idx_pembayaran_gagal
    ON pembayaran (tgl_bayar)
    WHERE status_bayar = 'gagal';

EXPLAIN (ANALYZE, BUFFERS)
SELECT pj.id_perjalanan,
       pj.tgl_perjalanan,
       pj.status,
       pj.tarif,
       pg.nama     AS pengemudi,
       k.nama_kota AS kota_pengemudi
FROM penumpang pn
JOIN perjalanan pj ON pj.id_penumpang = pn.id_penumpang
JOIN pengemudi pg  ON pg.id_pengemudi = pj.id_pengemudi
JOIN kota k        ON k.id_kota = pg.id_kota
WHERE pn.nama = 'Fitria'
ORDER BY pj.tgl_perjalanan DESC, pj.id_perjalanan DESC
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS)
SELECT k.nama_kota,
       pg.nama       AS pengemudi,
       COUNT(*)      AS jumlah_perjalanan,
       SUM(pj.tarif) AS total_pendapatan
FROM perjalanan pj
JOIN pengemudi pg ON pg.id_pengemudi = pj.id_pengemudi
JOIN kota k       ON k.id_kota = pg.id_kota
WHERE pj.status = 'selesai'
  AND pj.tgl_perjalanan BETWEEN DATE '2026-01-01' AND DATE '2026-03-31'
  AND k.nama_kota = 'Surabaya'
GROUP BY k.nama_kota, pg.nama
ORDER BY total_pendapatan DESC
LIMIT 10;

EXPLAIN (ANALYZE, BUFFERS)
SELECT date_trunc('month', pj.tgl_perjalanan)::date AS bulan,
       pg.nama                                       AS pengemudi,
       COUNT(*)                                      AS total_perjalanan,
       COUNT(*) FILTER (WHERE pj.status = 'selesai') AS selesai,
       SUM(pj.tarif)                                 AS pendapatan
FROM pengemudi pg
JOIN perjalanan pj ON pj.id_pengemudi = pg.id_pengemudi
WHERE pg.id_pengemudi = 50
  AND pj.tgl_perjalanan >= DATE '2026-01-01'
GROUP BY date_trunc('month', pj.tgl_perjalanan), pg.nama
ORDER BY bulan;

EXPLAIN (ANALYZE, BUFFERS)
SELECT k.nama_kota,
       pb.metode,
       COUNT(*)       AS jumlah_gagal,
       SUM(pb.jumlah) AS nilai_gagal
FROM pembayaran pb
JOIN perjalanan pj ON pj.id_perjalanan = pb.id_perjalanan
JOIN pengemudi pg  ON pg.id_pengemudi  = pj.id_pengemudi
JOIN kota k        ON k.id_kota        = pg.id_kota
WHERE pb.status_bayar = 'gagal'
  AND pb.tgl_bayar >= TIMESTAMP '2026-01-01'
GROUP BY k.nama_kota, pb.metode
ORDER BY nilai_gagal DESC
LIMIT 10;