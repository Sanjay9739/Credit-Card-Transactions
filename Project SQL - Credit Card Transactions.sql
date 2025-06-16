use sample_db;

-- 1- write a query to print top 5 cities with highest spends and 
-- their percentage contribution of total credit card spends 

with cte as
(
select city, sum(amount) as total_city_spends, 
sum(amount)*100/(select sum(amount) from credit_card) as percentage
from credit_card
group by city
),
cte1 as
(
select city, total_city_spends,sum(total_city_spends) over() as overall_spend,
dense_rank() over(order by total_city_spends desc) as rnk
from cte
)
select city, total_city_spends, total_city_spends*100/overall_spend as percentage
from cte1
where rnk<=5;

-- 2- write a query to print highest spend month for each year and 
-- amount spent in that month for each card type

with cte as(
SELECT year(transaction_date) as yearoftrans, month(transaction_date)as monthoftrans,
SUM(amount) AS total_spend,card_type
FROM credit_card
GROUP BY year(transaction_date), month(transaction_date),card_type
),
cte1 as
(
select yearoftrans, monthoftrans,card_type,total_spend,
dense_rank() over(partition by card_type order by total_spend desc) as rnk1
from cte
)
select yearoftrans, monthoftrans,card_type,total_spend
from cte1
where rnk1 =1;

-- 3- write a query to print the transaction details(all columns from the 
-- table) for each card type when it reaches a cumulative of 1000000 
-- total spends(We should have 4 rows in the o/p one for each card type)

with cte as
(
select *, 
sum(amount) over(partition by card_type 
order by transaction_id) as cumulative_amount
from credit_card
),
cte1 as
(
select *
from cte 
where cumulative_amount>=1000000
),
cte2 as
(
select card_type, min(cumulative_amount) as startamt
from cte1
group by card_type
)
select cte1.*
from cte1
join cte2
on cte1.card_type=cte2.card_type
and cte1.cumulative_amount = startamt;

-- 4- write a query to find city which had lowest percentage 
-- spend for gold card type
with cte as
(
select city, sum(amount) as total_spend, card_type
from credit_card
where card_type = "Gold"
group by city
), 
cte1 as
(
select city, card_type, total_spend,
sum(total_spend) over() as overall_spend,rank() over(order by total_spend) as rnk
from cte
)
select city, total_spend, total_spend*100/overall_spend as percentage
from cte1
where rnk=1;


-- 5- write a query to print 3 columns: city, highest_expense_type ,
-- lowest_expense_type (example format : Delhi , bills, Fuel)

with cte1 as
(
select city, exp_type, amount,
ROW_NUMBER() over( partition by city order by amount desc) as highestrank,
ROW_NUMBER() over( partition by city order by amount ) as lowestrank
from credit_card
),
cte2 as
(
select city, exp_type as highestexp
from cte1
where highestrank = 1
),
cte3 as
(
select city, exp_type as lowestexp
from cte1
where lowestrank = 1
)
select cte3.city, lowestexp, highestexp
from cte2
join cte3
on cte2.city=cte3.city;

-- 6- write a query to find percentage contribution of spends by females 
-- for each expense type
with cte as
(
select exp_type, sum(amount) as total_f_spends
from credit_card
where gender= "F"
group by exp_type
),
cte1 as (
select exp_type, sum(amount) as total_spends
from cte
group by exp_type
)
select exp_type, total_f_spends*100.0/total_spends
from cte as c
join cte1 as c1
on c1.exp_type=c.exp_type;

-- OR

SELECT 
    exp_type,
   round( (SUM(CASE WHEN gender = 'F' THEN amount ELSE 0 END) * 100.0)
    / SUM(amount),2 ) AS Female_spends_percentage
FROM 
    credit_card
GROUP BY 
    exp_type; 

-- 7- which card and expense type combination saw highest month over month 
-- growth in Jan-2014

with cte as
(
select card_type, exp_type, month(transaction_date) as month1, 
year(transaction_date) as year1, sum(amount) as totalSpend
from credit_card
group by card_type, exp_type, month(transaction_date), year(transaction_date)
)
select card_type, exp_type, month1, year1
from cte
where month1 = 1 AND year1 = 2014;

-- 8- during weekends which city has highest total spend to total 
-- no of transcations ratio 

select city, sum(amount) as totalspends, 
count(transaction_id) as transactioncount,  
round(sum(amount)*1.0/count(transaction_id),0) as ratio
from credit_card
WHERE DAYNAME(transaction_date) in ('Saturday','Sunday')
group by city
order by ratio desc
limit 1;

-- 9- which city took least number of days to reach its 500th 
-- transaction after the first transaction in that city

with cte as
(
select city, transaction_date,
row_number() over(partition by city order by transaction_date ) as rnk1
from credit_card
),
cte1 as
(
select city, min(transaction_date) as first_date
from credit_card
group by city
),
cte2 as
(
select city, rnk1, transaction_date as last_date
from cte
where rnk1=500
)
select cte2.city, first_date, last_date,
datediff(last_date,first_date) as days_transaction
from cte1
join cte2
on cte1.city=cte2.city
order by days_transaction
limit 1; 
























