-- SCM SUPPLY CHAIN MANAGEMENT
use mahendra;
show tables;
describe f_sales;
describe pos;

-- Changing col names and datatype
alter table f_sales modify Date datetime;
alter table pos change `ï»¿Order_Number` order_number int;
alter table f_sales change `order Number` order_Num int;

-- 1. Total sales
select sum(sales_amount) as Total_sales from pos;

-- 2.Year wise sales
select distinct year(s.Date) as year , sum(p.sales_amount) as total
from f_sales s join pos p on s.order_Num = p.order_number
group by year order by year;

-- 3.Yearly growth
with s1 as (
select year(s.Date) as year , 
       sum(p.sales_amount) as CY
from f_sales s 
join pos p on s.order_Num = p.order_number
group by year
         ),
s2 as(
select *, 
lag(CY) over (order by year) as py from s1
     )
select *, round(((CY-py)/py)*100, 2) as Yearly_growth from s2;

-- 4.Monthly Sales

select month(s.Date) as mnth, sum(p.sales_amount) as sales from f_sales s join pos p
on s.order_num = p.order_number group by mnth
order by mnth;

-- 5.Daywise sales
select date(s.date) as dt , sum(p.sales_amount) as sales from f_sales s join pos p
on s.order_num = p.order_number group by dt
order by dt;

-- 6.TOP 10 STORE wise SALES

select d.`store name`, sum(p.sales_amount) as sales from d_store d left join f_sales s 
on d.`store key`= s.`store key` left join pos p on s.order_num = p.order_Number 
group by d.`store name` order by sales desc limit 10;

-- 7. Store Region wise sales
select d.`store Region`, sum(p.sales_amount) as sales 
from d_store d 
left join f_sales s on d.`store key`= s.`store key` 
left join pos p on s.order_num = p.order_Number 
group by d.`store Region`;

-- 8. Purchase Method wise sales
select s.`purchase Method`, sum(p.sales_amount) as t_sales
from f_sales s right join pos p on s.order_num = p.order_number
group by s.`purchase Method`;

-- 9. Product-wise sales
select 
    p.`Product Type`,
    SUM(s.sales_amount) AS Total_Sales
FROM pos s
JOIN f_inventory_adjusted p
ON s.`Product_Key` = p.`Product Key`
GROUP BY p.`Product Type`
ORDER BY Total_Sales DESC;

select *  from f_inventory_adjusted;
select * from pos;

-- 10. Total Inventory cost
select round(sum(`Cost Amount`*`Quantity on Hand`), 2) as Inventory from f_inventory_adjusted;

-- 11. Total Inventory
select sum(`Quantity on Hand`) as Total_Quantity from  f_inventory_adjusted;

-- 12. In-stock, Out-of-stock, Under-stock:
select 
       case when `Quantity on Hand` = 3 then "Instock"
            when `Quantity on Hand`=2 then "UnderStock"
         else "Out of Stock" end as Inventory_status,
         sum(`Quantity on Hand`) as "Total Quantity"
from f_inventory_adjusted group by Inventory_status;


                                                           
           


