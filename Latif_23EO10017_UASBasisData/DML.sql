-- Superuser (bisa melakukan semua perintah)
CREATE ROLE superuser WITH LOGIN PASSWORD 'superuser_password';
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO superuser;

-- Admin (hanya bisa INSERT dan UPDATE di beberapa tabel)
CREATE ROLE admin WITH LOGIN PASSWORD 'admin_password';
GRANT INSERT, UPDATE ON TABLE transactions, items, transaction_items TO admin;

-- User biasa (hanya bisa SELECT semua tabel)
CREATE ROLE regular_user WITH LOGIN PASSWORD 'user_password';
GRANT SELECT ON ALL TABLES IN SCHEMA public TO regular_user;


-- Aktifkan RLS di tabel transactions
ALTER TABLE transactions ENABLE ROW LEVEL SECURITY;

-- Buat kebijakan agar regular_user hanya bisa melihat data
CREATE POLICY select_policy ON transactions
FOR SELECT
TO regular_user
USING (TRUE);

-- Buat kebijakan agar admin hanya bisa INSERT dan UPDATE
CREATE POLICY modify_policy ON transactions
FOR INSERT, UPDATE
TO admin
USING (TRUE);



-- Tabel untuk transaksi
CREATE TABLE transactions (
    transaction_id SERIAL PRIMARY KEY,
    ref_number VARCHAR(50) NOT NULL,
    cashier VARCHAR(50),
    total_items INT NOT NULL,
    total_discount NUMERIC(10, 2),
    total_amount NUMERIC(10, 2),
    cash_paid NUMERIC(10, 2),
    change_return NUMERIC(10, 2),
    tax NUMERIC(10, 2),
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabel untuk barang (items)
CREATE TABLE items (
    item_id SERIAL PRIMARY KEY,
    item_name VARCHAR(100) NOT NULL,
    unit_price NUMERIC(10, 2) NOT NULL
);

-- Tabel untuk item yang ada di transaksi (transaction_items)
CREATE TABLE transaction_items (
    id SERIAL PRIMARY KEY,
    transaction_id INT REFERENCES transactions(transaction_id) ON DELETE CASCADE,
    item_id INT REFERENCES items(item_id) ON DELETE CASCADE,
    qty INT NOT NULL,
    total_price NUMERIC(10, 2) NOT NULL
);

-- Tabel untuk keanggotaan (memberships)
CREATE TABLE memberships (
    member_id SERIAL PRIMARY KEY,
    member_name VARCHAR(50),
    total_points INT,
    points_expiry DATE
);


-- Insert data ke tabel items
INSERT INTO items (item_name, unit_price) VALUES
('LEMNREL AIR600ML', 3700),
('GLICO M CHO46ML', 3400),
('EVNGLN BV 100ML', 41700),
('KP BRANDING (M)', 200);

-- Insert data ke tabel transactions
INSERT INTO transactions (ref_number, cashier, total_items, total_discount, total_amount, cash_paid, change_return, tax)
VALUES ('I455-177-231OZ7M3', 'AYU DE', 4, 4200, 48200, 100000, 51800, 5173);

-- Insert data ke tabel transaction_items
INSERT INTO transaction_items (transaction_id, item_id, qty, total_price) VALUES
(1, 1, 1, 3700),
(1, 2, 2, 6800),
(1, 3, 1, 41700),
(1, 4, 1, 200);

-- Insert data ke tabel memberships
INSERT INTO memberships (member_name, total_points, points_expiry) VALUES
('LATIF', 1386, '2026-05-31');


-- Update harga barang
UPDATE items
SET unit_price = 3900
WHERE item_name = 'LEMNREL AIR600ML';


-- Delete data dari tabel items
DELETE FROM items
WHERE item_name = 'KP BRANDING (M)';



