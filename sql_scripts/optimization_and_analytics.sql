CREATE INDEX idx_cust_city ON customers(city);

CREATE MATERIALIZED VIEW mv_order_analytics AS
SELECT o.onum, s.sname, p.name AS product, c.cname, o.amt
FROM orders o
JOIN sellers s ON o.snum = s.snum
JOIN products p ON o.pnum = p.pnum
JOIN customers c ON o.cnum = c.cnum
WHERE o.amt > (SELECT AVG(amt) FROM orders)
AND p.city != 'Saint-Petersburg';

SELECT 
    onum, 
    amt, 
    odate,
    amt - LAG(amt, 1, 0.0) OVER (PARTITION BY snum ORDER BY odate, onum) AS diff_prev,
    LEAD(amt, 1, 0.0) OVER (PARTITION BY snum ORDER BY odate, onum) - amt AS diff_next
FROM orders;

SELECT 
    onum, 
    amt,
    MAX(amt) OVER (ORDER BY odate, onum ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS max_so_far
FROM orders;
