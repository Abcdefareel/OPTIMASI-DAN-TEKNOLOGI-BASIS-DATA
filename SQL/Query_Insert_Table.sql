INSERT INTO kota VALUES
 (1,'Surabaya'),(2,'Malang'),(3,'Sidoarjo'),(4,'Gresik'),(5,'Kediri'),
 (6,'Jember'),(7,'Madiun'),(8,'Mojokerto'),(9,'Pasuruan'),(10,'Blitar');

INSERT INTO pengemudi
SELECT i, 'Pengemudi ' || i, 1 + (i % 10)
FROM generate_series(1, 500) AS i;

INSERT INTO penumpang
SELECT i, 'Penumpang ' || i
FROM generate_series(1, 10000) AS i;

INSERT INTO perjalanan
SELECT i,
       DATE '2025-01-01' + (random() * 364)::int,
       CASE WHEN random() < 0.03 THEN 'dibatalkan' ELSE 'selesai' END,
       (5 + (random() * 45)::int) * 1000,
       1 + (random() * 499)::int,
       1 + (random() * 9999)::int
FROM generate_series(1, 500000) AS i;

ALTER TABLE pengemudi  ADD FOREIGN KEY (id_kota)      REFERENCES kota (id_kota);
ALTER TABLE perjalanan ADD FOREIGN KEY (id_pengemudi) REFERENCES pengemudi (id_pengemudi);
ALTER TABLE perjalanan ADD FOREIGN KEY (id_penumpang) REFERENCES penumpang (id_penumpang);

ANALYZE;

SELECT 'kota' AS tabel, count(*) FROM kota
UNION ALL SELECT 'pengemudi', count(*) FROM pengemudi
UNION ALL SELECT 'penumpang', count(*) FROM penumpang
UNION ALL SELECT 'perjalanan', count(*) FROM perjalanan;