EXPLAIN ANALYZE
SELECT k.nama_kota, SUM(p.tarif) AS total_pendapatan
FROM perjalanan p
JOIN pengemudi d ON d.id_pengemudi = p.id_pengemudi
JOIN kota k      ON k.id_kota      = d.id_kota
WHERE p.tgl_perjalanan >= '2025-03-01'
  AND p.tgl_perjalanan <  '2025-04-01'
  AND p.status = 'selesai'
GROUP BY k.nama_kota
ORDER BY total_pendapatan DESC;

CREATE TABLE ringkasan_bulanan AS
SELECT date_trunc('month', p.tgl_perjalanan)::date AS bulan,
       k.nama_kota,
       COUNT(*)      AS jumlah_perjalanan,
       SUM(p.tarif)  AS total_pendapatan
FROM perjalanan p
JOIN pengemudi d ON d.id_pengemudi = p.id_pengemudi
JOIN kota k      ON k.id_kota      = d.id_kota
WHERE p.status = 'selesai'
GROUP BY 1, 2;

EXPLAIN ANALYZE
SELECT nama_kota, total_pendapatan
FROM ringkasan_bulanan
WHERE bulan = '2025-03-01'
ORDER BY total_pendapatan DESC;