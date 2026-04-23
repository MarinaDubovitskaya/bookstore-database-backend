CREATE OR REPLACE FUNCTION shorten_text(
    p_text text, 
    p_max_len int DEFAULT 45
)
RETURNS text
LANGUAGE plpgsql
IMMUTABLE
AS $$
DECLARE
    v_truncated text;
BEGIN
    IF length(p_text) <= p_max_len THEN
        RETURN p_text;
    END IF;

    v_truncated := left(p_text, p_max_len - 3);

    IF position(' ' in v_truncated) > 0 THEN
       v_truncated := substring(v_truncated from '^(.+)\s');
    END IF;

    RETURN v_truncated || '...';
END;
$$;

CREATE OR REPLACE FUNCTION book_name(
    p_book_id integer,
    p_title text
)
RETURNS text
LANGUAGE plpgsql
STABLE
AS $$
DECLARE
    v_authors text;
    v_full_name text;
BEGIN
    SELECT string_agg(
               author_name(a.last_name, a.first_name, a.middle_name),
               ', ' ORDER BY au.seq_num
           )
    INTO v_authors
    FROM authorship au
    JOIN authors a ON a.author_id = au.author_id
    WHERE au.book_id = p_book_id;

    v_full_name := p_title || '. ' || COALESCE(v_authors, '');

    RETURN shorten_text(v_full_name);
END;
$$;

CREATE OR REPLACE FUNCTION add_author(
    last_name text,
    first_name text,
    middle_name text
)
RETURNS integer
LANGUAGE plpgsql
AS $$
DECLARE
    v_new_id integer;
BEGIN
    INSERT INTO authors (last_name, first_name, middle_name)
    VALUES (add_author.last_name, add_author.first_name, add_author.middle_name)
    RETURNING author_id INTO v_new_id;

    RETURN v_new_id;
END;
$$;

CREATE OR REPLACE FUNCTION buy_book(
    book_id integer
)
RETURNS void
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO operations (book_id, qty_change)
    VALUES (buy_book.book_id, -1);
END;
$$;
