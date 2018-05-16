--make archive example
WITH moved_rows AS (
  DELETE FROM products
  WHERE
    "date" >= '2010-10-01' AND
    "date" < '2010-11-01'
  RETURNING *
)
INSERT INTO products_log
  SELECT * FROM moved_rows;

--remove parts 'our_product' with subparts
WITH RECURSIVE included_parts(sub_part, part) AS (
  SELECT sub_part, part FROM parts WHERE part = 'our_product'
  UNION ALL
  SELECT p.sub_part, p.part
  FROM included_parts pr, parts p
  WHERE p.part = pr.sub_part
)
DELETE FROM parts
WHERE part IN (SELECT part FROM included_parts);


WITH t AS (
  UPDATE products SET price = price * 1.05
  RETURNING *
)
SELECT * FROM products;

--the outer SELECT would return the original prices before the action of the UPDATE, while in

WITH t AS (
  UPDATE products SET price = price * 1.05
  RETURNING *
)
SELECT * FROM t;
--the outer SELECT would return the updated data.