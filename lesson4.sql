CREATE TABLE lesson4.accounts (
    account_id SERIAL PRIMARY KEY,
    customer_name VARCHAR(100),
    balance NUMERIC(12,2)
);

CREATE TABLE lesson4.transactions (
    trans_id SERIAL PRIMARY KEY,
    account_id INT REFERENCES lesson4.accounts(account_id),
    amount NUMERIC(12,2),
    trans_type VARCHAR(10),
    created_at TIMESTAMP DEFAULT NOW()
);

INSERT INTO lesson4.accounts(customer_name, balance)
VALUES ('A', 1000.00), ('B', 500.00);

BEGIN;

DO $$
BEGIN
    IF (SELECT balance FROM lesson4.accounts WHERE account_id = 1) < 300 THEN
        RAISE EXCEPTION 'Không đủ tiền';
    END IF;
END $$;

UPDATE lesson4.accounts
SET balance = balance - 300
WHERE account_id = 1;

INSERT INTO lesson4.transactions(account_id, amount, trans_type)
VALUES (1, 300, 'WITHDRAW');

COMMIT;

SELECT * FROM lesson4.accounts;
SELECT * FROM lesson4.transactions;

BEGIN;

UPDATE lesson4.accounts
SET balance = balance - 200
WHERE account_id = 1;

INSERT INTO lesson4.transactions(account_id, amount, trans_type)
VALUES (9999, 200, 'WITHDRAW');

ROLLBACK;

SELECT * FROM lesson4.accounts;
SELECT * FROM lesson4.transactions;