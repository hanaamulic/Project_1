#What’s the average time between the order being placed and the product being delivered?
#12,5days

#datediff each order all products
SELECT datediff(order_delivered_customer_date,order_purchase_timestamp) AS difference
FROM orders
ORDER BY difference DESC;

#avg datediff all products
SELECT AVG(datediff(order_delivered_customer_date,order_purchase_timestamp)) AS difference
FROM orders;

#avg delivery time of tech products for each category
select avg(datediff(order_delivered_customer_date, order_purchase_timestamp)) as avg_delivery_time, pc.product_category_name_english, o.order_status, s.seller_id   
from orders o
inner join order_items oi on oi.order_id = o.order_id
inner join products p on p.product_id = oi.product_id
inner join product_category_name_translation pc on pc.product_category_name = p.product_category_name
inner join sellers s on oi.seller_id = s.seller_id
where pc.product_category_name_english in ('electronics','computers_accessories','pc_gamer','computers','consoles_games', 'telephony', 'watches_gifts') and o.order_status = 'delivered'
group by pc.product_category_name_english
order by avg_delivery_time desc;

#delivery times for categories
select datediff(order_delivered_customer_date, order_purchase_timestamp) as customer_purhasted_delivery_time, pc.product_category_name_english, o.order_status  
from orders o
inner join order_items oi on oi.order_id = o.order_id
inner join products p on p.product_id = oi.product_id
inner join product_category_name_translation pc on pc.product_category_name = p.product_category_name
inner join sellers s on oi.seller_id = s.seller_id
where pc.product_category_name_english in ('electronics','computers_accessories','pc_gamer','computers','consoles_games', 'telephony', 'watches_gifts') and o.order_status = 'delivered'
order by avg_delivery_time desc;

#delivery time case too long, long, ontime, fast

SELECT COUNT(*) AS Total, ROUND(AVG(delivery_time)) AS Average_delivery_time, explanation FROM(

SELECT del.delivery_time,(CASE 	WHEN del.delivery_time >= 50 THEN 'ridiculus >50'
		WHEN delivery_time >= 20 THEN 'too long >20'
        WHEN delivery_time >= 8 THEN 'long >8'
        WHEN delivery_time > 3 THEN 'acceptable >3'
        ELSE 'fast <3'
        END) AS explanation
FROM(
select datediff(order_delivered_customer_date, order_purchase_timestamp) as delivery_time
from orders o
inner join order_items oi on oi.order_id = o.order_id
inner join products p on p.product_id = oi.product_id
inner join product_category_name_translation pc on pc.product_category_name = p.product_category_name
inner join sellers s on oi.seller_id = s.seller_id
where pc.product_category_name_english in ('electronics','computers_accessories','computers', 'telephony', 'watches_gifts') and o.order_status = 'delivered'
order by delivery_time asc) 
AS del) 
AS big
GROUP BY explanation;


#
SELECT 

AS difference
FROM orders
ORDER BY difference DESC;

#sabrina

SELECT products.product_category_name,product_category_name_translation.product_category_name_english,COUNT(products.product_id)
FROM product_category_name_translation 
INNER JOIN products ON product_category_name_translation.product_category_name = products.product_category_name
GROUP BY products.product_category_name;



select p.product_category_name,
    count(case when datediff(o.order_estimated_delivery_date, o.order_purchase_timestamp) <= 3 then 1 end) as 'very fast delivery < 3 days',
    count(case when datediff(o.order_estimated_delivery_date, o.order_purchase_timestamp) > 3 and datediff(o.order_estimated_delivery_date, o.order_purchase_timestamp) <= 8 then 1 end) as 'acceptable delivery',
    count(case when datediff(o.order_estimated_delivery_date, o.order_purchase_timestamp) >= 8 and datediff(o.order_estimated_delivery_date, o.order_purchase_timestamp) <= 20 then 1 end) as 'long delivery',
    count(case when datediff(o.order_estimated_delivery_date, o.order_purchase_timestamp) >= 20 and datediff(o.order_estimated_delivery_date, o.order_purchase_timestamp) <= 50 then 1 end) as 'too long delivery',
    count(case when datediff(o.order_estimated_delivery_date, o.order_purchase_timestamp) >= 50 then 1 end) as 'ridiculous'
from orders o
inner join order_items oi on o.order_id = oi.order_id
inner join products p on p.product_id = oi.product_id
where order_status = 'delivered' 
    and p.product_category_name in ('consoles_games', 'eletronicos', 'informatica_acessorios', 'pc_gamer', 'pcs', 'telefonia', 'relogios_presentes')
group by p.product_category_name;


SELECT del.delivery_time,(CASE 	WHEN del.delivery_time >= 50 THEN 'ridiculus'
		WHEN delivery_time >= 20 THEN 'too long'
        WHEN delivery_time >= 8 THEN 'long'
        WHEN delivery_time > 3 THEN 'acceptable'
        ELSE 'very fast'
        END) AS explanation
FROM(
select datediff(order_delivered_customer_date, order_purchase_timestamp) as delivery_time
from orders o
inner join order_items oi on oi.order_id = o.order_id
inner join products p on p.product_id = oi.product_id
inner join product_category_name_translation pc on pc.product_category_name = p.product_category_name
inner join sellers s on oi.seller_id = s.seller_id
where pc.product_category_name_english in ('electronics','computers_accessories','computers', 'telephony', 'watches_gifts') and o.order_status = 'delivered'
order by delivery_time asc) 
AS del;



SELECT products.product_category_name,product_category_name_translation.product_category_name_english,COUNT(products.product_id),
CASE
 WHEN product_category_name_translation.product_category_name_english IN ('food','food_drink','drinks') THEN 'Food&Drink'
 WHEN product_category_name_translation.product_category_name_english IN ('auto') THEN 'Automotive'
 WHEN product_category_name_translation.product_category_name_english IN ('art','arts_and_craftmanship','party_supplies','christmas_supplies') THEN 'Art&Craft'
 WHEN product_category_name_translation.product_category_name_english IN ('electronics','computers_accessories','pc_gamer','computers','consoles_games','telephony','watches_gifts') THEN 'Tech'
WHEN product_category_name_translation.product_category_name_english IN ('sports_leisure','fashion_bags_accessories','fashion_shoes','fashion_sport','fashio_female_clothing','fashion_male_clothing','fashion_childrens_clothes','fashion_underwear_beach','luggage_accessories') THEN 'Fashion'
 WHEN product_category_name_translation.product_category_name_english IN ('bed_bath_table','home_confort','home_comfort_2','air_conditioning','home_appliances','home_appliances_2','small_appliances','garden_tools','flowers','la_cuisine','furniture_mattress_and_upholstery','office_furniture','furniture_bedroom','furniture_living_room','small_appliances_home_oven_and_coffee','portable_kitchen_food_processors','housewares','kitchen_dining_laundry_garden_furniture','furniture_decor') THEN 'Home&Living'
 WHEN product_category_name_translation.product_category_name_english IN ('home_construction','construction_tools_construction','costruction_tools_tools','construction_tools_lights','costruction_tools_garden','construction_tools_safety') THEN 'Construction'
 WHEN product_category_name_translation.product_category_name_english IN ('books_imported','books_general_interest','books_technical') THEN 'Book'
 WHEN product_category_name_translation.product_category_name_english IN ('baby','health_beauty','toys','diapers_and_hygiene','perfumery') THEN 'Beauty&Baby'
 WHEN product_category_name_translation.product_category_name_english IN ('agro_industry_and_commerce','industry_commerce_and_business') THEN 'Industry'
  WHEN product_category_name_translation.product_category_name_english IN ('audio','cds_dvds_musicals','cine_photo','dvds_blu_ray','musical_instruments','music','tablets_printing_image') THEN 'Audio&Photo'
WHEN product_category_name_translation.product_category_name_english IN ('cool_stuff','market_place','others','stationery','pet_shop','security_and_services','fixed_telephony','signaling_and_security') THEN 'Other'
 END AS  'Categories'
FROM product_category_name_translation 
INNER JOIN products ON product_category_name_translation.product_category_name = products.product_category_name
GROUP BY Categories;