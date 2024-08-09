-- Northwind Analysis
USE Northwind;
-- ---------------------------------------------
-- Query 1
-- Customers who placed most numbers of orders (Top 10)

SELECT customers.customerid, 
       customername,
       COUNT(Orderid) AS Total_orders
FROM Customers
LEFT JOIN orders
ON customers.customerid=orders.customerid
GROUP BY  customers.customerid, customername
ORDER BY Total_orders DESC
LIMIT 10;

-- ---------------------------------------------
-- Query 2
-- Cities that placed most numbers of orders (Top 10)

SELECT customers.city, 
       COUNT(Orderid) AS Total_orders
FROM Customers
LEFT JOIN orders
ON customers.customerid=orders.customerid
GROUP BY  customers.city
ORDER BY Total_orders DESC
LIMIT 10;

-- ---------------------------------------------
-- Query 3
-- Contribution in total orders by every country

SELECT customers.country, 
       COUNT(Orderid) AS Total_orders,
       ROUND(COUNT(Orderid)/(SELECT COUNT(Orderid)
			     FROM orders)*100,3) AS Contribution_in_total_orders_percent
FROM Customers
LEFT JOIN orders
ON customers.customerid=orders.customerid
GROUP BY  customers.country
ORDER BY Total_orders DESC;

-- ---------------------------------------------
-- Query 4
-- Contribution in total orders by shippers

SELECT shippers.shipperid,
       shippername,
       COUNT(Orderid) AS number_of_orders,
       ROUND(COUNT(Orderid)/(SELECT COUNT(orderid)
			     FROM orders)*100,2) AS contribution
FROM orders
INNER JOIN shippers
ON orders.shipperid=shippers.shipperid
GROUP BY shippers.shipperid, shippername
ORDER BY number_of_orders DESC;

-- ---------------------------------------------
-- Query 5
-- Contribution in total orders by months

SELECT MONTHNAME(Orderdate) AS Month_name,
       COUNT(orderid) AS total_orders,
       ROUND(COUNT(Orderid)/(SELECT COUNT(orderid)
			     FROM orders)*100,2) AS contribution
FROM orders
GROUP BY MONTH(Orderdate), MONTHNAME(Orderdate)
ORDER BY MONTH(Orderdate);

-- ---------------------------------------------
-- Query 6
-- Contribution in total orders by years

SELECT YEAR(Orderdate) AS Year_,
       COUNT(orderid) AS total_orders,
       ROUND(COUNT(Orderid)/(SELECT COUNT(orderid)
			     FROM orders)*100,2) AS contribution
FROM orders
GROUP BY Year_
ORDER BY Year_;

-- ---------------------------------------------
-- Query 7
-- Contribution in total orders by employees

SELECT employees.employeeid,
       CONCAT(firstname,' ',lastname) AS full_name,
       COUNT(orderid) AS total_orders,
       ROUND(COUNT(Orderid)/(SELECT COUNT(orderid)
			     FROM orders)*100,2) AS contribution
FROM employees
INNER JOIN orders
ON employees.employeeid=orders.employeeid
GROUP BY employees.employeeid, full_name
ORDER BY total_orders DESC;

-- ---------------------------------------------
-- Query 8
-- Total sales and Average order Value

SELECT SUM( price* quantity) AS total_sales,
       COUNT(DISTINCT Orders.orderid) AS total_orders,
       ROUND(SUM( price* quantity)/ COUNT(DISTINCT Orders.orderid),2) AS Average_order_value
FROM customers
LEFT JOIN orders
ON customers.customerid=orders.customerid
LEFT JOIN Orderdetails
ON orders.orderid=Orderdetails.orderid
LEFT JOIN products
ON Orderdetails.productid=products.productid;

-- ---------------------------------------------
-- Creating a View for total sales (to make upcoming queries look cleaner)

CREATE VIEW Total_sales AS
SELECT SUM(quantity*price) AS sales
FROM orderdetails
INNER JOIN products
ON orderdetails.productid=products.productid;

-- ---------------------------------------------
-- Query 9
-- Top 10 customers according to sales (and their contribution)

  SELECT customers.customerid,
	 customername,
         SUM(quantity*price) AS sales,
         ROUND(SUM(quantity*price)/(SELECT sales
				    FROM total_sales)*100,2) AS contribution_in_percent
FROM customers
LEFT JOIN orders
ON customers.customerid=orders.customerid
LEFT JOIN Orderdetails
ON orders.orderid=Orderdetails.orderid
LEFT JOIN products
ON Orderdetails.productid=products.productid
GROUP BY  customerid, customername
ORDER BY sales DESC
LIMIT 10;

-- ---------------------------------------------
-- Query 10
-- Top 10 cities according to avg_order_value

  SELECT city,
         SUM(quantity*price) AS sales,
         COUNT(DISTINCT Orders.orderid) AS total_orders,
	       ROUND(SUM(quantity*price)/ COUNT(DISTINCT orders.orderid),2) AS avg_order_value
FROM customers
LEFT JOIN orders
ON customers.customerid=orders.customerid
LEFT JOIN Orderdetails
ON orders.orderid=Orderdetails.orderid
LEFT JOIN products
ON Orderdetails.productid=products.productid
GROUP BY  city
ORDER BY avg_order_value DESC;

-- ---------------------------------------------
-- Query 11
-- Top 10 city according to sales (and their contribution)

  SELECT city,
         SUM(quantity*price) AS sales,
         ROUND(SUM(quantity*price)/(SELECT sales
				    FROM total_sales)*100,2) AS contribution_in_percent
FROM customers
LEFT JOIN orders
ON customers.customerid=orders.customerid
LEFT JOIN Orderdetails
ON orders.orderid=Orderdetails.orderid
LEFT JOIN products
ON Orderdetails.productid=products.productid
GROUP BY  city
ORDER BY sales DESC
LIMIT 10;

-- ---------------------------------------------
-- Query 12
-- Selecting countries according to sales (and their contribution) [Also includes avg_order_value]

  SELECT country,
         SUM(quantity*price) AS sales,
         COUNT(DISTINCT orders.orderid) AS total_orders,
         ROUND(SUM(quantity*price)/ COUNT( DISTINCT orders.orderid),2) AS avg_order_value,
         ROUND(SUM(quantity*price)/(SELECT sales
				    FROM total_sales)*100,2) AS contribution_in_percent
FROM customers
LEFT JOIN orders
ON customers.customerid=orders.customerid
LEFT JOIN Orderdetails
ON orders.orderid=Orderdetails.orderid
LEFT JOIN products
ON Orderdetails.productid=products.productid
GROUP BY  country
ORDER BY sales DESC;

-- ---------------------------------------------
-- Query 13
-- Selecting products according to sales (and their contribution) 

  SELECT products.productid,
         productname,
         SUM(quantity*price) AS sales,
         ROUND(SUM(quantity*price)/(SELECT sales
				    FROM total_sales)*100,2) AS contribution_in_percent
FROM customers
LEFT JOIN orders
ON customers.customerid=orders.customerid
LEFT JOIN Orderdetails
ON orders.orderid=Orderdetails.orderid
LEFT JOIN products
ON Orderdetails.productid=products.productid
GROUP BY  products.productid, productname
ORDER BY sales DESC;

-- ---------------------------------------------
-- Query 14
-- Selecting categories according to sales (and their contribution) 

  SELECT categories.categoryid,
         categoryname,
         SUM(quantity*price) AS sales,
         ROUND(SUM(quantity*price)/(SELECT sales
				    FROM total_sales)*100,2) AS contribution_in_percent
FROM customers
LEFT JOIN orders
ON customers.customerid=orders.customerid
LEFT JOIN Orderdetails
ON orders.orderid=Orderdetails.orderid
LEFT JOIN products
ON Orderdetails.productid=products.productid
LEFT JOIN categories
ON products.categoryid=categories.categoryid
GROUP BY categories.categoryid, categoryname
ORDER BY sales DESC;

-- ---------------------------------------------
-- Query 15
-- Selecting shippers according to sales (and their contribution) 

  SELECT shippers.shipperid,
         shippername,
         SUM(quantity*price) AS sales,
         ROUND(SUM(quantity*price)/(SELECT sales
				    FROM total_sales)*100,2) AS contribution_in_percent
FROM customers
LEFT JOIN orders
ON customers.customerid=orders.customerid
LEFT JOIN Orderdetails
ON orders.orderid=Orderdetails.orderid
LEFT JOIN products
ON Orderdetails.productid=products.productid
LEFT JOIN shippers
ON shippers.shipperid=orders.shipperid
GROUP BY shippers.shipperid, shippername
ORDER BY sales DESC;

-- ---------------------------------------------
-- Query 16
-- Selecting  sales according to month

  SELECT MONTH(orderdate) AS month_number,
		 MONTHNAME(orderdate) AS month_name,
         SUM(quantity*price) AS sales,
         ROUND(SUM(quantity*price)/(SELECT sales
				    FROM total_sales)*100,2) AS contribution_in_percent
FROM customers
INNER JOIN orders
ON customers.customerid=orders.customerid
LEFT JOIN Orderdetails
ON orders.orderid=Orderdetails.orderid
LEFT JOIN products
ON Orderdetails.productid=products.productid
GROUP BY month_number, month_name
ORDER BY month_number, month_name ;

-- ---------------------------------------------
-- Query 17
-- Selecting  sales according to Year

SELECT  YEAR(Orderdate) AS Year_,
		SUM(quantity*price) AS sales,
		ROUND(SUM(quantity*price)/(SELECT sales
					   FROM total_sales)*100,2) AS contribution_in_percent
FROM customers
INNER JOIN orders
ON customers.customerid=orders.customerid
LEFT JOIN Orderdetails
ON orders.orderid=Orderdetails.orderid
LEFT JOIN products
ON Orderdetails.productid=products.productid
GROUP BY Year_
ORDER BY Year_;

-- ---------------------------------------------
-- Query 18
-- Selecting employees according to sales (and their contribution) [Also includes average order value]

  SELECT employees.employeeid,
	 CONCAT(Firstname,' ',Lastname) AS full_name,
         SUM(quantity*price) AS sales,
         COUNT(DISTINCT orders.Orderid) AS total_orders,
	 ROUND(SUM(quantity*price)/ COUNT( DISTINCT orders.orderid),2) AS avg_order_value,
         ROUND(SUM(quantity*price)/(SELECT sales
				    FROM total_sales)*100,2) AS contribution_in_percent
FROM customers
LEFT JOIN orders
ON customers.customerid=orders.customerid
LEFT JOIN Orderdetails
ON orders.orderid=Orderdetails.orderid
LEFT JOIN products
ON Orderdetails.productid=products.productid
LEFT JOIN employees
ON orders.employeeid=employees.employeeid
GROUP BY employees.employeeid, full_name
ORDER BY sales DESC;

-- ---------------------------------------------
-- Query 19
-- Selecting customers according to city

SELECT City,
       COUNT(customerid) AS total_customers
FROM customers
GROUP BY city
ORDER BY total_customers DESC;

-- ---------------------------------------------
-- Query 20
-- Selecting customers according to country

SELECT Country,
       COUNT(customerid) AS total_customers
FROM customers
GROUP BY country
ORDER BY total_customers DESC;

-- ---------------------------------------------
-- Query 21
-- Selecting suppliers according to country

SELECT Country,
       COUNT(supplierid) AS total_suppliers
FROM suppliers
GROUP BY country
ORDER BY total_suppliers DESC;

-- ---------------------------------------------
-- Query 22
-- Selecting customers with 0 orders

SELECT *
FROM customers
WHERE customers.customerid NOT IN (SELECT customerid
				   FROM orders);
                                   
-- DONE---------------------------------------------------


