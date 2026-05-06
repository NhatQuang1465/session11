CREATE TABLE lesson3.products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    stock INT,
    price NUMERIC(10,2)
);

CREATE TABLE lesson3.orders (
    order_id SERIAL PRIMARY KEY,
    customer_name VARCHAR(100),
    total_amount NUMERIC(10,2),
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE lesson3.order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES lesson3.orders(order_id),
    product_id INT REFERENCES lesson3.products(product_id),
    quantity INT,
    subtotal NUMERIC(10,2)
);

INSERT INTO lesson3.products (product_name, stock, price) VALUES
('Product 1', 10, 50.00),
('Product 2', 10, 30.00);

BEGIN;

DO $$
BEGIN
    IF (SELECT stock FROM lesson3.products WHERE product_id = 1) < 2 THEN
        RAISE EXCEPTION 'Không đủ hàng product 1';
    END IF;

    IF (SELECT stock FROM lesson3.products WHERE product_id = 2) < 1 THEN
        RAISE EXCEPTION 'Không đủ hàng product 2';
    END IF;
END $$;

UPDATE lesson3.products
SET stock = stock - 2
WHERE product_id = 1;

UPDATE lesson3.products
SET stock = stock - 1
WHERE product_id = 2;

INSERT INTO lesson3.orders(customer_name, total_amount)
VALUES ('Nguyen Van A', 0)
RETURNING order_id;

INSERT INTO lesson3.order_items(order_id, product_id, quantity, subtotal)
VALUES
(1, 1, 2, (SELECT price FROM lesson3.products WHERE product_id = 1) * 2),
(1, 2, 1, (SELECT price FROM lesson3.products WHERE product_id = 2) * 1);

UPDATE lesson3.orders
SET total_amount = (
    SELECT SUM(subtotal)
    FROM lesson3.order_items
    WHERE order_id = 1
)
WHERE order_id = 1;

COMMIT;

BEGIN;

UPDATE lesson3.products SET stock = 0 WHERE product_id = 1;

DO $$
BEGIN
    IF (SELECT stock FROM lesson3.products WHERE product_id = 1) < 2 THEN
        RAISE EXCEPTION 'Không đủ hàng product 1';
    END IF;
END $$;

UPDATE lesson3.products SET stock = stock - 2 WHERE product_id = 1;

UPDATE lesson3.products SET stock = stock - 1 WHERE product_id = 2;

INSERT INTO lesson3.orders(customer_name, total_amount)
VALUES ('Nguyen Van A', 0);

COMMIT;

ROLLBACK;