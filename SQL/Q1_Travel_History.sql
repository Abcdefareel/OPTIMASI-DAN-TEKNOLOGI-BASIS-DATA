EXPLAIN ANALYZE
SELECT id_perjalanan, tgl_perjalanan, tarif
FROM perjalanan
WHERE id_penumpang = 4021
ORDER BY tgl_perjalanan DESC
LIMIT 10;

CREATE INDEX idx_perjalanan_penumpang_tgl
ON perjalanan (id_penumpang, tgl_perjalanan);