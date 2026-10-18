CREATE TABLE kota (
    id_kota   INT PRIMARY KEY,
    nama_kota TEXT NOT NULL
);

CREATE TABLE pengemudi (
    id_pengemudi INT PRIMARY KEY,
    nama         TEXT NOT NULL,
    id_kota      INT  NOT NULL
);

CREATE TABLE penumpang (
    id_penumpang INT PRIMARY KEY,
    nama         TEXT NOT NULL
);

CREATE TABLE perjalanan (
    id_perjalanan  INT PRIMARY KEY,
    tgl_perjalanan DATE NOT NULL,
    status         TEXT NOT NULL,
    tarif          INT  NOT NULL,
    id_pengemudi   INT  NOT NULL,
    id_penumpang   INT  NOT NULL
);