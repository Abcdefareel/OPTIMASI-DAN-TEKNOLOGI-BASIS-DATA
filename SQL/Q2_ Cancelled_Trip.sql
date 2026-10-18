EXPLAIN ANALYZE
SELECT id_perjalanan, id_pengemudi, tgl_perjalanan
FROM perjalanan
WHERE status = 'dibatalkan' AND tgl_perjalanan >= '2025-10-01'
ORDER BY tgl_perjalanan;

CREATE INDEX idx_perjalanan_batal
ON perjalanan (tgl_perjalanan)
WHERE status = 'dibatalkan';