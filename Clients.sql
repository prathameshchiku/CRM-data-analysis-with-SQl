-- total clients

select count(distinct account)
from sales_pipeline;

-- products and revenue by each client

select account, count(product) as qty, sum(close_value) as rev
from sales_pipeline
where deal_Stage = 'Won'
group by account
order by rev desc limit 10;

-- revenue by top 10 clients as % of total revenue

with cte as(select account, count(product) as qty, sum(close_value) as rev
from sales_pipeline
where deal_Stage = 'Won'
group by account
order by rev desc limit 10)

select round(sum(rev)/(select sum(close_value) from sales_pipeline)*100, 2) as perc
from cte;

-- products and top 10 clients

with cte as(select account
from sales_pipeline
where deal_Stage = 'Won'
group by account
order by sum(close_value) desc limit 10)

select s.account,
sum(case
	when product = 'GTX Pro' then 1
    else 0
end) as gtx_pro,
sum(case
	when product = 'GTX Basic' then 1
    else 0
end) as gtx_basic,
sum(case
	when product = 'MG Special' then 1
    else 0
end) as mg_special,
sum(case
	when product = 'MG Advanced' then 1
    else 0
end) as mg_advanced,
sum(case
	when product = 'GTX Plus Pro' then 1
    else 0
end) as gtx_plus_pro,
sum(case
	when product = 'GTX Plus Basic' then 1
    else 0
end) as gtx_plus_basic,
sum(case
	when product = 'GTK 500' then 1
    else 0
end) as gtk_500
from  cte c
join sales_pipeline s on s.account = c.account
where deal_stage = 'Won'
group by account;

-- lost deals

select account, count(s.product) as lost_deals, sum(sales_price) as lost_value
from sales_pipeline s
join products p on p.product = s.product
where deal_stage = 'Lost'
group by account
order by lost_deals desc limit 10;
