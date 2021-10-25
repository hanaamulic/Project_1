USE magist;

#How many orders are there in the dataset?
SELECT COUNT(*) FROM orders;

#Are orders actually delivered?
SELECT order_status, COUNT(*) FROM orders group by order_status;

#Is Magist having user growth?

 SELECT CONCAT(MONTH(order_purchase_timestamp),'/', YEAR(order_purchase_timestamp)) AS MonthYear, COUNT(order_id) 
 FROM orders GROUP BY MonthYear ORDER BY YEAR(order_purchase_timestamp), MONTH(order_purchase_timestamp);
 
 #How many products are there in the products table?
 
 SELECT DISTINCT COUNT(product_id) FROM products;
 
 #Which are the categories with most products?
 
SELECT t.product_category_name, product_category_name_english, COUNT(*) 
FROM products AS p INNER JOIN product_category_name_translation 
AS t ON p.product_category_name = t.product_category_name 
GROUP BY product_category_name ORDER BY COUNT(*) DESC;

#How many of those products were present in actual transactions?

SELECT pcnt.product_category_name_english, COUNT(*) 
	FROM product_category_name_translation pcnt 
		INNER JOIN (SELECT product_category_name 
						FROM products p INNER JOIN order_items oi 
										ON p.product_id=oi.product_id) spanish
	ON spanish.product_category_name = pcnt.product_category_name_english
    GROUP BY pcnt.product_category_name_english;
    
    SELECT count(DISTINCT product_id) AS n_products
FROM
	order_items;

#What’s the price for the most expensive and cheapest products?