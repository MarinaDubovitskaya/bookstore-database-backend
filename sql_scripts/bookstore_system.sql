CREATE SCHEMA bookstore;
SET search_path TO bookstore;

CREATE TABLE authors (
    author_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL
);

CREATE TABLE books (
    book_id SERIAL PRIMARY KEY,
    title TEXT NOT NULL,
    author_id INTEGER REFERENCES authors(author_id),
    price NUMERIC(10, 2),
    stock_count INTEGER DEFAULT 0
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount NUMERIC(10, 2)
);

CREATE OR REPLACE FUNCTION apply_custom_discount(p_price NUMERIC, p_rating INT)
RETURNS NUMERIC AS $$
BEGIN
    IF p_rating >= 300 THEN
        RETURN p_price * 0.90;
    ELSE
        RETURN p_price;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE update_stock(p_book_id INT, p_quantity INT)
AS $$
BEGIN
    UPDATE books SET stock_count = stock_count - p_quantity WHERE book_id = p_book_id;
END;
$$ LANGUAGE plpgsql;
