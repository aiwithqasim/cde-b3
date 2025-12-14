CREATE TABLE production.parts(
    part_id   INT NOT NULL, 
    part_name VARCHAR(100)
);

INSERT INTO 
    production.parts(part_id, part_name)
VALUES
    (1,'Frame'),
    (2,'Head Tube'),
    (3,'Handlebar Grip'),
    (4,'Shock Absorber'),
    (5,'Fork');

SELECT * FROM production.parts;

CREATE TABLE production.part_prices(
    part_id int,
    valid_from date,
    price decimal(18,4) not null,
    PRIMARY KEY(part_id, valid_from) -- composite
);

CREATE CLUSTERED INDEX ix_parts_id
ON production.parts (part_id); 

SELECT * FROM production.parts 
WHERE part_id = 5;

-- NON  CLUSTERED INDEX
-------------------------

SELECT 
    customer_id, 
    city
FROM 
    sales.customers
WHERE 
    city = 'Atwater';

CREATE INDEX ix_customers_city
ON sales.customers(city);

SELECT 
    customer_id, 
    city
FROM 
    sales.customers
WHERE 
    city = 'Atwater';

SELECT 
    customer_id, 
    first_name, 
    last_name
FROM 
    sales.customers
WHERE 
    last_name = 'Berg' AND 
    first_name = 'Monika';

CREATE INDEX ix_customers_name 
ON sales.customers(last_name, first_name);

SELECT 
    customer_id, 
    first_name, 
    last_name
FROM 
    sales.customers
WHERE 
    last_name = 'Berg' AND 
    first_name = 'Monika';

-- RENAME with UI
-- DISABLE index

ALTER INDEX [ix_customers_city]
ON [sales].[customers]
DISABLE;

ALTER INDEX ALL
ON [sales].[customers]
DISABLE;

ALTER INDEX ALL
ON [sales].[customers]
REBUILD;

-- TASK:
-- simply query on any table.
-- create non-cluster index
-- query again and observe
-- rename the index
-- query again and observe
-- disable the index
-- query again and oberve
-- rebuild and query again
SELECT product_name FROM production.products;

CREATE INDEX ix_product_name ON production.products(product_name);

SELECT product_name FROM production.products;

ALTER INDEX product_name ON product.products;

-- UNIQUE INDEX

SELECT
    customer_id, 
    email 
FROM
    sales.customers
WHERE 
    email = 'caren.stephens@msn.com';

-- duplicate emails
SELECT 
    email, 
    COUNT(email)
FROM 
    sales.customers
GROUP BY 
    email
HAVING 
    COUNT(email) > 1;

-- unique
CREATE UNIQUE INDEX ix_cust_email 
ON sales.customers(email);

----------------------------
DROP TABLE t1;

CREATE TABLE t1 (
    a INT, 
    b INT
);

CREATE UNIQUE INDEX ix_uniq_ab 
ON t1(a, b);

INSERT INTO t1(a,b) VALUES(1,1);
INSERT INTO t1(a,b) VALUES(1,2);
INSERT INTO t1(a,b) VALUES(1,2);

-- Notes: UNIQUE Index
-- no duplciates prior
-- can't add NULL

-- DROP INDEX

DROP INDEX [product_name]
ON [production].[products];

-- multiple filter with multiple column

SELECT
    customer_id, 
    email,
	first_name
FROM
    sales.customers
WHERE 
    email = 'caren.stephens@msn.com';


--- filter index

SELECT count(*) AS HAVE_NO_PHONE
FROM [sales].[customers]
WHERE phone is NULL
GROUP BY phone; -- 1267

SELECT *
FROM [sales].[customers]; -- 1445

SELECT 1445 - 1267; -- 178

CREATE INDEX ix_cust_phone
ON sales.customers(phone)
WHERE phone IS NOT NULL;

SELECT    
    first_name,
    last_name, 
    phone
FROM    
    sales.customers
WHERE phone = '(281) 363-3309';

-- 2025-12-14 15:53:34.200
SELECT CAST('2025-12-14 15:53:34.200' AS date) AS tradedate;

-- computed filter
-- SELECT SUBSTRING('garry.espinoza@gmail.com', 0, 15);

SELECT    
    first_name,
    last_name,
    email
FROM    
    sales.customers
WHERE 
    SUBSTRING(email, 0, 
        CHARINDEX('@', email, 0)
    ) = 'garry.espinoza';

ALTER TABLE sales.customers
ADD 
    email_local_part AS 
        SUBSTRING(email, 
            0, 
            CHARINDEX('@', email, 0)
        );

SELECT email_local_part, * FROM sales.customers;

CREATE INDEX ix_cust_email_local_part
ON sales.customers(email_local_part);

SELECT    
    first_name,
    last_name,
    email
FROM    
    sales.customers
WHERE 
    email_local_part = 'garry.espinoza';

SELECT    
    store_name,
    email
FROM    
    sales.stores
WHERE 
    email_local_parts = 'garry.espinoza';



SELECT    
    store_name,
    email
FROM    
    sales.stores
WHERE 
    SUBSTRING(email, 0, 
        CHARINDEX('@', email, 0)
    ) = 'santacruz';

ALTER TABLE sales.stores
ADD 
    email_local_parts AS 
        SUBSTRING(email, 
            0, 
            CHARINDEX('@', email, 0)
        );

CREATE INDEX ix_cust_email_local_parts
ON sales.stores(email_local_parts);

select 
	store_name,
	email
from sales.stores
where email_local_parts = 'santacruz';

-- STORED PROCEDURE

CREATE PROCEDURE sp_ny_customers
AS
BEGIN
	SELECT * 
	FROM [sales].[customers] 
	WHERE state = 'NY';
END;

EXEC sp_ny_customers;

