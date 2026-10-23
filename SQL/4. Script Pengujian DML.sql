-- PENGUJIAN DENGAN INDEKS
BEGIN;
EXPLAIN (ANALYZE, BUFFERS)
INSERT INTO perjalanan (id_perjalanan, tgl_perjalanan, status, tarif, id_pengemudi, id_penumpang)
SELECT s.i,
       DATE '2025-01-01' + floor(s.r_tgl * 660)::int,
       CASE WHEN s.r_status < 0.88 THEN 'selesai' ELSE 'dibatalkan' END,
       CASE WHEN s.r_status < 0.88
            THEN (floor(power(s.r_tarif, 1.5) * 135)::int + 16) * 500
            ELSE 0 END,
       floor(s.r_pengemudi * 400)::int + 1,
       floor(s.r_penumpang * 1700)::int + 1
FROM (SELECT i, random() AS r_tgl, random() AS r_status, random() AS r_tarif,
             random() AS r_pengemudi, random() AS r_penumpang
      FROM generate_series(500001, 510000) AS i) s;
ROLLBACK;

BEGIN;
EXPLAIN (ANALYZE, BUFFERS)
INSERT INTO pembayaran (id_perjalanan, metode, status_bayar, jumlah, tgl_bayar)
SELECT p.id_perjalanan,
       (ARRAY['tunai','e-wallet','transfer'])[floor(random()*3)+1],
       CASE WHEN p.x < 0.97 THEN 'berhasil'
            WHEN p.x < 0.99 THEN 'pending'
            ELSE 'gagal' END,
       ROUND((p.tarif * (0.8 + random() * 0.2) + 2000)::numeric, 2),
       p.tgl_perjalanan + (random() * 30) * INTERVAL '1 minute'
FROM (SELECT id_perjalanan, tarif, tgl_perjalanan, random() AS x
      FROM perjalanan WHERE status = 'selesai' LIMIT 10000) p;
ROLLBACK;

BEGIN;
EXPLAIN (ANALYZE, BUFFERS)
UPDATE perjalanan SET tarif = tarif + 500
WHERE status = 'selesai' AND tgl_perjalanan >= DATE '2026-07-01';
ROLLBACK;

BEGIN;
EXPLAIN (ANALYZE, BUFFERS)
UPDATE perjalanan SET tgl_perjalanan = tgl_perjalanan + 1
WHERE id_pengemudi <= 40;
ROLLBACK;

BEGIN;
EXPLAIN (ANALYZE, BUFFERS)
UPDATE pembayaran SET jumlah = jumlah + 1000
WHERE tgl_bayar >= TIMESTAMP '2026-07-01';
ROLLBACK;

BEGIN;
EXPLAIN (ANALYZE, BUFFERS)
DELETE FROM pembayaran WHERE tgl_bayar < TIMESTAMP '2025-07-01';
ROLLBACK;




-- PENGUJIAN TANPA INDEKS 
DROP INDEX IF EXISTS idx_penumpang_nama;
DROP INDEX IF EXISTS idx_perjalanan_penumpang_tgl;
DROP INDEX IF EXISTS idx_perjalanan_pengemudi_tgl;
DROP INDEX IF EXISTS idx_pembayaran_gagal;
VACUUM (ANALYZE) perjalanan;
VACUUM (ANALYZE) pembayaran;

BEGIN;
EXPLAIN (ANALYZE, BUFFERS)
INSERT INTO perjalanan (id_perjalanan, tgl_perjalanan, status, tarif, id_pengemudi, id_penumpang)
SELECT s.i,
       DATE '2025-01-01' + floor(s.r_tgl * 660)::int,
       CASE WHEN s.r_status < 0.88 THEN 'selesai' ELSE 'dibatalkan' END,
       CASE WHEN s.r_status < 0.88
            THEN (floor(power(s.r_tarif, 1.5) * 135)::int + 16) * 500
            ELSE 0 END,
       floor(s.r_pengemudi * 400)::int + 1,
       floor(s.r_penumpang * 1700)::int + 1
FROM (SELECT i, random() AS r_tgl, random() AS r_status, random() AS r_tarif,
             random() AS r_pengemudi, random() AS r_penumpang
      FROM generate_series(500001, 510000) AS i) s;
ROLLBACK;

BEGIN;
EXPLAIN (ANALYZE, BUFFERS)
INSERT INTO pembayaran (id_perjalanan, metode, status_bayar, jumlah, tgl_bayar)
SELECT p.id_perjalanan,
       (ARRAY['tunai','e-wallet','transfer'])[floor(random()*3)+1],
       CASE WHEN p.x < 0.97 THEN 'berhasil'
            WHEN p.x < 0.99 THEN 'pending'
            ELSE 'gagal' END,
       ROUND((p.tarif * (0.8 + random() * 0.2) + 2000)::numeric, 2),
       p.tgl_perjalanan + (random() * 30) * INTERVAL '1 minute'
FROM (SELECT id_perjalanan, tarif, tgl_perjalanan, random() AS x
      FROM perjalanan WHERE status = 'selesai' LIMIT 10000) p;
ROLLBACK;

BEGIN;
EXPLAIN (ANALYZE, BUFFERS)
UPDATE perjalanan SET tarif = tarif + 500
WHERE status = 'selesai' AND tgl_perjalanan >= DATE '2026-07-01';
ROLLBACK;

BEGIN;
EXPLAIN (ANALYZE, BUFFERS)
UPDATE perjalanan SET tgl_perjalanan = tgl_perjalanan + 1
WHERE id_pengemudi <= 40;
ROLLBACK;

BEGIN;
EXPLAIN (ANALYZE, BUFFERS)
UPDATE pembayaran SET jumlah = jumlah + 1000
WHERE tgl_bayar >= TIMESTAMP '2026-07-01';
ROLLBACK;

BEGIN;
EXPLAIN (ANALYZE, BUFFERS)
DELETE FROM pembayaran WHERE tgl_bayar < TIMESTAMP '2025-07-01';
ROLLBACK;

