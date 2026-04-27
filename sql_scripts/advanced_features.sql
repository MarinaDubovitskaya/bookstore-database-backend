CREATE TABLE IF NOT EXISTS price_log (
    book_id INT,
    old_price NUMERIC,
    new_price NUMERIC,
    change_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE OR REPLACE FUNCTION log_price_changes()
RETURNS TRIGGER AS $$
BEGIN
    IF OLD.price <> NEW.price THEN
        INSERT INTO price_log(book_id, old_price, new_price)
        VALUES (OLD.book_id, OLD.price, NEW.price);
    END IF;
    RETURN NEW;
END; $$ LANGUAGE plpgsql;

CREATE TRIGGER trg_price_update AFTER UPDATE ON books FOR EACH ROW EXECUTE FUNCTION log_price_changes();

CREATE OR REPLACE PROCEDURE adjust_stock_bulk(p_ratio NUMERIC) AS $$
DECLARE
    rec_book RECORD;
    cur_books CURSOR FOR SELECT book_id, stock_count FROM books WHERE stock_count < 10;
BEGIN
    OPEN cur_books;
    LOOP
        FETCH cur_books INTO rec_book;
        EXIT WHEN NOT FOUND;
        UPDATE books SET stock_count = stock_count + floor(stock_count * p_ratio) WHERE book_id = rec_book.book_id;
    END LOOP;
    CLOSE cur_books;
END; $$ LANGUAGE plpgsql;

DO $$ BEGIN
    IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'shop_admin') THEN CREATE ROLE shop_admin; END IF;
END $$;

GRANT USAGE ON SCHEMA bookstore TO shop_admin;
GRANT SELECT, INSERT, UPDATE ON ALL TABLES IN SCHEMA bookstore TO shop_admin;
