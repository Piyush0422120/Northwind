# Northwind
Objective: Analysis of Northwind Ltd. performance (A big multinational FMCG Company)

Total number of Queries: 22  <br><br>
![image](https://github.com/user-attachments/assets/a3336fba-d72a-4e89-a696-1ec359e23f68)

---
## SNAPSHOTS  


#1 Contribution in total orders by every country   <BR>

```
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
```

![image](https://github.com/user-attachments/assets/c4c43574-b16a-473f-b502-95e0632e4014)

<BR>

#2 Total sales and Average order Value  <BR>

```
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

```
![image](https://github.com/user-attachments/assets/2f1bfb57-6202-4090-9173-16259526f983)

<BR>

#3 Top 10 customers according to sales <BR>

```
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

```
![image](https://github.com/user-attachments/assets/db9bb4f3-8864-4ab2-b4f7-0da155d85800)

<BR>

#4 Selecting products according to sales (and their contribution)  <BR>

```
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
```
![image](https://github.com/user-attachments/assets/ddd0bfb3-14f4-46a5-9005-788adae14242)

<BR>

#5 Selecting categories according to sales (and their contribution) <BR>

```
-- Query 14
-- Selecting categories according to sales (and their contribution)

SELECT   categories.categoryid,
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
```

![image](https://github.com/user-attachments/assets/65e74cd2-5076-4237-9475-bf6b147653fc)





