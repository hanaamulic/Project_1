USE magist;

#How many sellers are there?
SELECT COUNT(*) FROM sellers;
#3095
SELECT COUNT(DISTINCT s.seller_id)
FROM sellers s
INNER JOIN order_items oi ON s.seller_id = oi.seller_id
INNER JOIN orders o ON oi.order_id = o.order_id
INNER JOIN products p ON oi.product_id = p.product_id
INNER JOIN product_category_name_translation pt ON p.product_category_name = pt.product_category_name
WHERE pt.product_category_name_english IN ('electronics','computers_accessories','computers','telephony','watches_gifts');
#What’s the average monthly revenue of Magist’s sellers?

#AVERAGE, MIN AND MAX MONTHLY REVENUE BY EACH MONTH
SELECT ROUND(AVG(mix.seller_monthly_income),2) AS 'Average monthly income', ROUND(MAX(mix.seller_monthly_income),2) AS 'Maximum monthly income', ROUND(MIN(mix.seller_monthly_income),2) AS 'Minimum monthly income',  mix.monthyear FROM (

SELECT s.seller_id, SUM(price) AS seller_monthly_income, date_format(o.order_purchase_timestamp, '%M %Y') AS monthyear
FROM sellers s
INNER JOIN order_items oi ON s.seller_id = oi.seller_id
INNER JOIN orders o ON oi.order_id = o.order_id
GROUP BY s.seller_id, date_format(order_purchase_timestamp, '%M %Y')
ORDER BY year(order_purchase_timestamp),month(order_purchase_timestamp)
)
 AS mix
GROUP BY mix.monthyear;


#What’s the average revenue of sellers that sell tech products by month?

SELECT ROUND(AVG(mix.seller_monthly_income),2) AS 'Average monthly income', 
ROUND(MAX(mix.seller_monthly_income),2) AS 'Maximum monthly income', 
ROUND(MIN(mix.seller_monthly_income),2) AS 'Minimum monthly income',  
mix.monthyear FROM (
SELECT s.seller_id, SUM(price) AS seller_monthly_income, date_format(o.order_purchase_timestamp, '%M %Y') AS monthyear
FROM sellers s
INNER JOIN order_items oi ON s.seller_id = oi.seller_id
INNER JOIN orders o ON oi.order_id = o.order_id
INNER JOIN products p ON oi.product_id = p.product_id
INNER JOIN product_category_name_translation pt ON p.product_category_name = pt.product_category_name
WHERE pt.product_category_name_english IN ('electronics','computers_accessories','pc_gamer','computers','consoles_games','telephony')
GROUP BY s.seller_id, date_format(order_purchase_timestamp, '%M %Y')
ORDER BY year(order_purchase_timestamp),month(order_purchase_timestamp)) AS mix
GROUP BY mix.monthyear;

#What’s the average revenue of sellers that sell tech products   980eur
SELECT AVG(allof.Average_monthly_income) FROM(
SELECT ROUND(AVG(mix.seller_monthly_income),2) AS 'Average_monthly_income', 
ROUND(MAX(mix.seller_monthly_income),2) AS 'Maximum monthly income', 
ROUND(MIN(mix.seller_monthly_income),2) AS 'Minimum monthly income',  
mix.monthyear FROM (
SELECT s.seller_id, SUM(price) AS seller_monthly_income, date_format(o.order_purchase_timestamp, '%M %Y') AS monthyear
FROM sellers s
INNER JOIN order_items oi ON s.seller_id = oi.seller_id
INNER JOIN orders o ON oi.order_id = o.order_id
INNER JOIN products p ON oi.product_id = p.product_id
INNER JOIN product_category_name_translation pt ON p.product_category_name = pt.product_category_name
WHERE pt.product_category_name_english IN ('electronics','computers_accessories','computers','telephony','watches_gifts')
GROUP BY s.seller_id, date_format(order_purchase_timestamp, '%M %Y')
ORDER BY year(order_purchase_timestamp),month(order_purchase_timestamp)) AS mix
GROUP BY mix.monthyear) AS allof; 

#What’s the average monthly revenue of sellers that sell tech products between TOP (more than 20 orders) sellers?
SELECT ROUND(AVG(mix.seller_monthly_income),2) AS 'Average monthly income', 
ROUND(MAX(mix.seller_monthly_income),2) AS 'Maximum monthly income', 
ROUND(MIN(mix.seller_monthly_income),2) AS 'Minimum monthly income',  
mix.monthyear FROM (
SELECT s.seller_id, SUM(price) AS seller_monthly_income, date_format(o.order_purchase_timestamp, '%M %Y') AS monthyear
FROM sellers s
INNER JOIN order_items oi ON s.seller_id = oi.seller_id
INNER JOIN orders o ON oi.order_id = o.order_id
INNER JOIN products p ON oi.product_id = p.product_id
INNER JOIN product_category_name_translation pt ON p.product_category_name = pt.product_category_name
WHERE pt.product_category_name_english IN ('electronics','computers_accessories','computers','telephony')
GROUP BY s.seller_id, date_format(order_purchase_timestamp, '%M %Y')
HAVING COUNT(oi.order_id)>20
ORDER BY year(order_purchase_timestamp),month(order_purchase_timestamp)) AS mix
GROUP BY mix.monthyear;

#What’s the average monthly revenue of sellers that sell tech products between TOP (more than 20 orders) sellers Entire time?
#3722
SELECT AVG(allt.Average_monthly_income) FROM (
SELECT ROUND(AVG(mix.seller_monthly_income),2) AS 'Average_monthly_income', 
ROUND(MAX(mix.seller_monthly_income),2) AS 'Maximum monthly income', 
ROUND(MIN(mix.seller_monthly_income),2) AS 'Minimum monthly income',  
mix.monthyear FROM (
SELECT s.seller_id, SUM(price) AS seller_monthly_income, date_format(o.order_purchase_timestamp, '%M %Y') AS monthyear
FROM sellers s
INNER JOIN order_items oi ON s.seller_id = oi.seller_id
INNER JOIN orders o ON oi.order_id = o.order_id
INNER JOIN products p ON oi.product_id = p.product_id
INNER JOIN product_category_name_translation pt ON p.product_category_name = pt.product_category_name
WHERE pt.product_category_name_english IN ('electronics','computers_accessories','computers','telephony','watches_gifts')
GROUP BY s.seller_id, date_format(order_purchase_timestamp, '%M %Y')
HAVING COUNT(oi.order_id)>20
ORDER BY year(order_purchase_timestamp),month(order_purchase_timestamp)) AS mix
GROUP BY mix.monthyear) AS allt;

#Sellers with greatest numbers of orders in TECH

SELECT s.seller_id, COUNT(o.order_id) AS seller_number_of_orders
FROM sellers s
INNER JOIN order_items oi ON s.seller_id = oi.seller_id
INNER JOIN orders o ON oi.order_id = o.order_id
INNER JOIN products p ON oi.product_id = p.product_id
INNER JOIN product_category_name_translation pt ON p.product_category_name = pt.product_category_name
WHERE pt.product_category_name_english IN ('electronics','computers_accessories','pc_gamer','computers','consoles_games','telephony')
GROUP BY s.seller_id
ORDER BY COUNT(o.order_id) DESC;

#Seller with highest income in TECH

SELECT s.seller_id, ROUND(SUM(oi.price),2) AS seller_with_highest_income
FROM sellers s
INNER JOIN order_items oi ON s.seller_id = oi.seller_id
INNER JOIN orders o ON oi.order_id = o.order_id
INNER JOIN products p ON oi.product_id = p.product_id
INNER JOIN product_category_name_translation pt ON p.product_category_name = pt.product_category_name
WHERE pt.product_category_name_english IN ('electronics','computers_accessories','computers','telephony')
GROUP BY s.seller_id
ORDER BY SUM(oi.price) DESC LIMIT 20;

#Category with highest income in TECH

SELECT pt.product_category_name_english, ROUND(SUM(oi.price),2) AS seller_with_highest_income
FROM sellers s
INNER JOIN order_items oi ON s.seller_id = oi.seller_id
INNER JOIN orders o ON oi.order_id = o.order_id
INNER JOIN products p ON oi.product_id = p.product_id
INNER JOIN product_category_name_translation pt ON p.product_category_name = pt.product_category_name
WHERE pt.product_category_name_english IN ('electronics','computers_accessories','pc_gamer','computers','consoles_games','telephony')
GROUP BY pt.product_category_name_english
ORDER BY SUM(oi.price) DESC;

#highest incomes by category by seller in TECH
SELECT s.seller_id, pt.product_category_name, ROUND(SUM(oi.price),2) AS seller_with_highest_income
FROM sellers s
INNER JOIN order_items oi ON s.seller_id = oi.seller_id
INNER JOIN orders o ON oi.order_id = o.order_id
INNER JOIN products p ON oi.product_id = p.product_id
INNER JOIN product_category_name_translation pt ON p.product_category_name = pt.product_category_name
WHERE pt.product_category_name_english IN ('electronics','computers_accessories','pc_gamer','computers','consoles_games','telephony')
GROUP BY pt.product_category_name, s.seller_id
ORDER BY SUM(oi.price) DESC;

#seller with highest income sells computer and phones
SELECT s.seller_id, pt.product_category_name
FROM sellers s
INNER JOIN order_items oi ON s.seller_id = oi.seller_id
INNER JOIN orders o ON oi.order_id = o.order_id
INNER JOIN products p ON oi.product_id = p.product_id
INNER JOIN product_category_name_translation pt ON p.product_category_name = pt.product_category_name
WHERE pt.product_category_name_english IN ('electronics','computers_accessories','pc_gamer','computers','consoles_games','telephony')
AND s.seller_id = '53243585a1d6dc2643021fd1853d8905'
GROUP BY pt.product_category_name;


SELECT oi.*, pt.product_category_name_english FROM(
SELECT s.seller_id, ROUND(SUM(oi.price),2) AS seller_with_highest_income
FROM sellers s
INNER JOIN order_items oi ON s.seller_id = oi.seller_id
INNER JOIN orders o ON oi.order_id = o.order_id
INNER JOIN products p ON oi.product_id = p.product_id
INNER JOIN product_category_name_translation pt ON p.product_category_name = pt.product_category_name
WHERE pt.product_category_name_english 
IN ('electronics','computers_accessories','pc_gamer','computers','consoles_games','telephony')
GROUP BY s.seller_id
ORDER BY SUM(oi.price) DESC LIMIT 5) AS top5
INNER JOIN order_items oi ON top5.seller_id = oi.seller_id
INNER JOIN orders o ON oi.order_id = o.order_id
INNER JOIN products p ON oi.product_id = p.product_id
INNER JOIN product_category_name_translation pt ON p.product_category_name = pt.product_category_name
ORDER BY top5.seller_id ASC, oi.price DESC;

#'3dd2a17168ec895c781a9191c1e95ad7' Product wich is sold often by ''de722cd6dad950a92b7d4f82673f8833' seller

SELECT oi.price, orw.review_comment_message FROM products p
INNER JOIN order_items oi ON p.product_id=oi.product_id
INNER JOIN order_reviews orw ON oi.order_id=orw.order_id
INNER JOIN product_category_name_translation pt ON pt.product_category_name = p.product_category_name
WHERE pt.product_category_name_english = 'telephony' AND orw.review_comment_message !='';


#kristina

select city, state, lat, lng, count(c.customer_id) as num_customers
from geo g
inner join customers c on c.customer_zip_code_prefix = g.zip_code_prefix
inner join orders o on o.customer_id = c.customer_id
inner join order_items oi on oi.order_id = o.order_id
inner join products p on p.product_id = oi.product_id
where p.product_category_name in ('consoles_games', 'eletronicos', 'informatica_acessorios', 'pc_gamer', 'pcs', 'telefonia', 'relogios_presentes')
group by city
HAVING COUNT(c.customer_id) > 50
order by num_customers desc
Limit 300;


#review scores
SELECT orw.review_score AS 'Review score', COUNT(*) AS 'Total number of products' FROM products p
INNER JOIN order_items oi ON p.product_id=oi.product_id
INNER JOIN order_reviews orw ON oi.order_id=orw.order_id
INNER JOIN product_category_name_translation pt ON pt.product_category_name = p.product_category_name
WHERE pt.product_category_name_english 
IN ('electronics','computers_accessories','computers','telephony','watches_gifts')
GROUP BY orw.review_score
ORDER BY orw.review_score DESC;

#review scores for biggest seller
SELECT orw.review_score AS 'Review score', COUNT(*) AS 'Total number of products' FROM products p
INNER JOIN order_items oi ON p.product_id=oi.product_id
INNER JOIN order_reviews orw ON oi.order_id=orw.order_id
INNER JOIN product_category_name_translation pt ON pt.product_category_name = p.product_category_name
WHERE pt.product_category_name_english 
IN ('electronics','computers_accessories','computers','telephony','watches_gifts')
AND oi.seller_id = '53243585a1d6dc2643021fd1853d8905'
GROUP BY orw.review_score
ORDER BY orw.review_score DESC;

#bad review scores messages
SELECT orw.review_comment_title, orw.review_comment_message FROM products p
INNER JOIN order_items oi ON p.product_id=oi.product_id
INNER JOIN order_reviews orw ON oi.order_id=orw.order_id
INNER JOIN product_category_name_translation pt ON pt.product_category_name = p.product_category_name
WHERE pt.product_category_name_english 
IN ('electronics','computers_accessories','pc_gamer','computers','consoles_games','telephony')
AND oi.seller_id = '53243585a1d6dc2643021fd1853d8905' AND orw.review_score=1;
