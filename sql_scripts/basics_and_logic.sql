SELECT * FROM orders WHERE cnum != 2003;

SELECT pnum, weight, name, city FROM products WHERE weight <= 700;

SELECT DISTINCT cnum FROM orders WHERE snum > 3003;

SELECT * FROM sellers WHERE comm > 0.12 AND city != 'London';

SELECT * FROM orders WHERE snum IN (3001, 3002, 3007);

SELECT city FROM products WHERE city ~* '^[mn].*k$';

SELECT name FROM sellers WHERE name ~* 'e' ORDER BY name;

SELECT REPLACE(REPLACE(REPLACE(LOWER(city), 'a', 'o'), 'e', 'o'), 'i', 'o') 
FROM products 
WHERE LENGTH(city) > 6;

SELECT pnum || '.' || name || '.' || city FROM products WHERE name ~* 'rd';

SELECT CURRENT_DATE - MAX(odate) FROM orders;

SELECT TO_CHAR(CURRENT_TIMESTAMP, 'HH24.MI.SS');

SELECT DISTINCT city FROM sellers WHERE city ~* '^[bcdfghjklmnpqrstvwxyz][aeiouy]';

SELECT name FROM customers WHERE name ~ '^[^A-D].*m.*';

SELECT COUNT(*) FROM sellers WHERE comm < 0.16;

SELECT MIN(city), MAX(city) FROM products;

SELECT pnum, MAX(amt) FROM orders GROUP BY pnum;

SELECT COUNT(DISTINCT cnum) FROM orders WHERE snum IN (3001, 3002, 3006);

SELECT pnum, SUM(amt) FROM orders GROUP BY pnum HAVING SUM(amt) < 20;

SELECT cnum, pnum, COUNT(*) FROM orders GROUP BY cnum, pnum;

SELECT odate FROM orders GROUP BY odate HAVING COUNT(DISTINCT cnum) >= 2 AND COUNT(DISTINCT pnum) >= 2;

SELECT * FROM orders WHERE amt > (SELECT AVG(amt) FROM orders);

SELECT pnum, SUM(amt) FROM orders GROUP BY pnum 
HAVING SUM(amt) < (SELECT SUM(amt) FROM orders WHERE pnum = 1002);

SELECT DISTINCT cnum FROM orders 
WHERE snum = 3006 AND pnum IN (SELECT pnum FROM orders WHERE snum = 3002);

SELECT name FROM customers 
WHERE cnum NOT IN (SELECT cnum FROM orders WHERE pnum IN (SELECT pnum FROM products WHERE city = 'Obninsk'));

SELECT * FROM products WHERE weight > ALL (SELECT weight FROM products WHERE city = 'Novosibirsk');

SELECT * FROM sellers s 
WHERE city IN (SELECT city FROM products p WHERE p.pnum IN (SELECT pnum FROM orders o WHERE o.snum = s.snum));

SELECT *, 
    CASE 
        WHEN city IN ('Saint-Petersburg', 'Moscow') THEN 'federal' 
        WHEN city IN ('Novosibirsk', 'Ekaterinburg') THEN 'millionaire' 
        ELSE 'other' 
    END 
FROM products;

SELECT o.*, c.cname FROM orders o LEFT JOIN customers c ON o.cnum = c.cnum;

SELECT o.onum, o.amt, p.name, p.city 
FROM orders o 
JOIN products p ON o.pnum = p.pnum 
WHERE p.city != 'Obninsk';

SELECT c.cname, MAX(o.amt) 
FROM customers c 
LEFT JOIN orders o ON c.cnum = o.cnum 
WHERE c.rating >= 300 
GROUP BY c.cname;

SELECT p1.pnum, p2.pnum FROM products p1 CROSS JOIN products p2 WHERE p1.pnum < p2.pnum;

SELECT city FROM products WHERE city ~* 'a' 
UNION 
SELECT city FROM customers WHERE city ~* 'a' 
UNION 
SELECT city FROM sellers WHERE city ~* 'a';
