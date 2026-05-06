CREATE TABLE lesson1.flights(
   flight_id SERIAL PRIMARY KEY,
   flight_name VARCHAR(100),
   available_seats INT
);
CREATE TABLE lesson1.bookings(
	booking_id SERIAL PRIMARY KEY,
	flight_id INT REFERENCES lesson1.flights(flight_id),
	customer_name VARCHAR(100)
);

INSERT INTO lesson1.flights (flight_name, available_seats) VALUES 
('VN123',3), ('VN456',2);

BEGIN;
UPDATE lesson1.flights
SET available_seats = available_seats - 1
WHERE flight_name = 'VN123';

INSERT INTO  lesson1.bookings (flight_id, customer_name) VALUES
((SELECT flight_id FROM lesson1.flights WHERE flight_name = 'VN123'),'Nguyen Van A');

COMMIT;

SELECT * FROM lesson1.flights;
SELECT * FROM lesson1.bookings;

BEGIN;
UPDATE lesson1.flights
SET available_seats = available_seats - 1
WHERE flight_name = 'VN123';

INSERT INTO lesson1.bookings (flight_id, customer_name)
VALUES (9999, 'Nguyen Van A');

ROLLBACK;
