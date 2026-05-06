CREATE TABLE lesson2.accounts(
	account_id SERIal PRIMARY KEY,
	owner_name VARCHAR(100),
	balance NUMERIC(10,2)
);
INSERT INTO lesson2.accounts(owner_name, balance) VALUES
('A', 500.00), ('B', 300.00);

BEGIN;
UPDATE lesson2.accounts
SET balance = balance - 100.00
WHERE owner_name = 'A';
UPDATE lesson2.accounts
SET balance = balance + 100.00
WHERE owner_name = 'B';
COMMIT;

SELECT * FROM lesson2.accounts;

BEGIN;
UPDATE lesson2.accounts
SET balance = balance - 100.00
WHERE owner_name = 'A';
UPDATE lesson2.accounts
SET balance = balance + 100.00
WHERE account_id = 9999;

ROLLBACK;