--CREATING COMBINED_TABLE
SELECT A.Customer_Name, A.Province, A.Region, A.Customer_Segment, A.Cust_ID, B.Ord_ID, B.Prod_ID, B.Ship_ID, 
        B.Sales, B.Discount, B.Order_Quantity, B.Product_Base_Margin, C.Order_Date, C.Order_Priority, 
		D.Product_Category, D.Product_Sub_Category, E.Ship_Mode, E.Ship_Date,
		DATEDIFF(DAY, CONVERT(DATE, Order_Date), CONVERT(DATE, Ship_Date)) DaysTakenForShipping
INTO combined_table
FROM cust_dimen A, market_fact B, orders_dimen C, prod_dimen D, shipping_dimen E
WHERE E.Ship_ID = B.Ship_ID
AND   A.Cust_ID = B.Cust_ID
AND   D.Prod_ID = B.Prod_ID
AND   C.Ord_ID = B.Ord_ID

--FINDING TOP 3 CUSTOMERS WHO HAVE THE MAXIMUM COUNT OF ORDERS
SELECT DISTINCT TOP 3 A.Cust_ID, A.Customer_Name, COUNT(B.Ord_ID) count_of_orders
FROM cust_dimen A, market_fact B, orders_dimen C
WHERE A.Cust_ID = B.Cust_ID
AND   C.Ord_ID = B.Ord_ID
GROUP BY A.Cust_ID, B.Ord_ID, A.Customer_Name
ORDER BY COUNT(B.Ord_ID) DESC

--CREATING A NEW COLUMN 'DAYS TAKEN FOR SHIPPING'
SELECT A.Customer_Name, A.Province, A.Region, A.Customer_Segment, A.Cust_ID, B.Ord_ID, B.Prod_ID, B.Ship_ID, 
        B.Sales, B.Discount, B.Order_Quantity, B.Product_Base_Margin, C.Order_Date, C.Order_Priority, 
		D.Product_Category, D.Product_Sub_Category, E.Ship_Mode, E.Ship_Date,
		DATEDIFF(DAY, CONVERT(DATE, Order_Date), CONVERT(DATE, Ship_Date)) DaysTakenForShipping
INTO combined_table2
FROM cust_dimen A, market_fact B, orders_dimen C, prod_dimen D, shipping_dimen E
WHERE E.Ship_ID = B.Ship_ID
AND   A.Cust_ID = B.Cust_ID
AND   D.Prod_ID = B.Prod_ID
AND   C.Ord_ID = B.Ord_ID

--Find the customer whose order took the maximum time to get shipping.
SELECT TOP 1 Customer_Name, DaysTakenForShipping
FROM combined_table2
ORDER BY 2 DESC

--Count the total number of unique customers in January and how many of them came back every month over the entire year in 2011
--January
SELECT DISTINCT Cust_ID, Customer_Name, Order_Date
FROM combined_table2
WHERE CONVERT(DATE, Order_Date) BETWEEN '2011-01-01' AND '2011-01-31'
--January and February
SELECT DISTINCT Cust_ID, Customer_Name
FROM combined_table2
WHERE CONVERT(DATE, Order_Date) BETWEEN '2011-02-01' AND '2011-02-28'
AND Cust_ID IN (
SELECT DISTINCT Cust_ID
FROM combined_table2
WHERE CONVERT(DATE, Order_Date) BETWEEN '2011-01-01' AND '2011-01-31'
)
--January and March
SELECT DISTINCT Cust_ID, Customer_Name
FROM combined_table2
WHERE CONVERT(DATE, Order_Date) BETWEEN '2011-03-01' AND '2011-03-31'
AND Cust_ID IN (
SELECT DISTINCT Cust_ID
FROM combined_table2
WHERE CONVERT(DATE, Order_Date) BETWEEN '2011-01-01' AND '2011-01-31'
)
--Write a query to return for each user the time elapsed between the first
--purchasing and the third purchasing, in ascending order by Customer ID.
WITH T1 AS (
SELECT DISTINCT Cust_ID, Customer_Name, Ord_ID, CONVERT(DATE, Order_Date) order_date2
FROM combined_table2
), T2 AS (
SELECT Cust_ID, Customer_Name, COUNT(Ord_ID) OVER (PARTITION BY Cust_ID) ord_num,
       Ord_ID, order_date2
FROM T1
), T3 AS (
SELECT DISTINCT *,
       LEAD(order_date2, 2) OVER (ORDER BY Cust_ID, order_date2) AS order_date3
FROM T2
WHERE ord_num > 2
), T4 AS (
SELECT DISTINCT Cust_ID, Customer_Name,
       FIRST_VALUE (order_date2) OVER (PARTITION BY Cust_ID ORDER BY Cust_ID, order_date2) first_order,
       FIRST_VALUE (order_date3) OVER (PARTITION BY Cust_ID ORDER BY Cust_ID, order_date2) third_order
FROM T3
)
SELECT DISTINCT Cust_ID, Customer_Name,
	   DATEDIFF(DAY, first_order, third_order) AS DayDiff
FROM T4

--Write a query that returns customers who purchased both product 11 and product 14,
--as well as the ratio of these products to the total number of products purchased by the customer.

SELECT COUNT(Prod_ID)
FROM combined_table2
WHERE Prod_ID = 'Prod_11'
AND Cust_ID IN

(SELECT DISTINCT Cust_ID
FROM combined_table2
WHERE Prod_ID = 'Prod_11'
AND Cust_ID IN (SELECT Cust_ID
			   FROM combined_table2
               WHERE Prod_ID = 'Prod_14'))

SELECT COUNT(Prod_ID)
FROM combined_table2
WHERE Prod_ID = 'Prod_11'
----------------------
SELECT COUNT(Prod_ID)
FROM combined_table2
WHERE Prod_ID = 'Prod_14'
AND Cust_ID IN

(SELECT DISTINCT Cust_ID
FROM combined_table2
WHERE Prod_ID = 'Prod_11'
AND Cust_ID IN (SELECT Cust_ID
			   FROM combined_table2
               WHERE Prod_ID = 'Prod_14'))

SELECT COUNT(Prod_ID)
FROM combined_table2
WHERE Prod_ID = 'Prod_14'