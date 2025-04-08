
select product_name,count(*)
from ecommerce_products
group by product_name;

select * from ecommerce_products

UPDATE ecommerce_products
SET product_name = 
  CASE
    WHEN product_name LIKE 'SHOES' THEN 'SHOES'
    WHEN product_name LIKE 'BLACK PANTS' THEN 'BLACK PANTS'
    WHEN product_name LIKE 'BLUE SHIRT' THEN 'BLUE SHIRT'
    WHEN product_name LIKE 'PANTS BLACK' THEN 'BLACK PANTS'
    WHEN product_name LIKE 'SHIRT BLUE' THEN 'BLUE SHIRT'
    WHEN product_name LIKE 'SHOES WHITE' THEN 'SHOES'
    ELSE product_name
  END;

select product_name, count(*)
from ecommerce_products
group by 1;

/*Exercise 2: Handling Missing Values
Scenario:
The same e-commerce dataset has some missing values for product prices and quantities sold.*/

alter table ecommerce_products
add  column price_new_double double;

with cte as (
select product_id,product_name,price,cast(price as double) as price1
from ecommerce_products)
update ecommerce_products e 
join cte c
on e.product_id= c.product_id
and e.product_name= c.product_name
and e.price = c.price
set price_new_double=price1;

set SQL_SAFE_UPDATEs=0;
alter table ecommerce_products
drop column price_new;
select * from ecommerce_products

alter table ecommerce_products
drop column quantity_new;
alter table ecommerce_products
add  column quantity_new double;
-- creating a table with the values
with cte as(
select product_id,product_name,quantity,cast(quantity as double) as qty1
from ecommerce_products)
update ecommerce_products e join cte c
on e.product_id= c.product_id
and e.product_name= c.product_name
and e.quantity = c.quantity
set e.quantity_new=c.qty1;

-- replacing blanks or zero (price)
with cte as (
select product_id,round(avg(price_new_double)) as new_price
from ecommerce_products
group by product_id)
update ecommerce_products e
join cte c
on e.product_id = c.product_id
set price_new_double= new_price
where price_new_double =0;

-- replacing blanks or zero (quantity)
with cte as (
select product_id,round(avg(quantity_new)) as new_quantity
from ecommerce_products
group by product_id)
update ecommerce_products e
join cte c
on e.product_id = c.product_id
set quantity_new= new_quantity
where quantity_new =0;

select * from ecommerce_products