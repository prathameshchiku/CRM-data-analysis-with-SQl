-- revenue

select sum(close_value)
from sales_pipeline
where deal_stage = 'Won';

-- products sold

select count(product)
from sales_pipeline
where deal_stage = 'Won';

-- products not sold

select product
from products
where product not in (select product from sales_pipeline);

-- revenue and no by product

select product, count(product) as sold, sum(close_value) as revenue
from sales_pipeline
where deal_stage = 'Won'
group by product
order by revenue desc;

select p.product, sum(sales_price - close_value)
from products p
join sales_pipeline s on s.product = p.product
where deal_stage = 'Won'
group by p.product;

-- expected and gained revenue

with cte as(select product, count(product) as sold, sum(close_value) as gained_rev
from sales_pipeline s
where deal_stage = 'Won'
group by product)
select c.product, sold, sold*sales_price as exp_rev, gained_rev
from cte c
join products p on p.product = c.product;


-- variance

with cte as(select product, count(product) as sold, sum(close_value) as gained_rev
from sales_pipeline s
where deal_stage = 'Won'
group by product), 
cte2 as(select c.product, sold, sold*sales_price as exp_rev, gained_rev
from cte c
join products p on p.product = c.product)

select product, exp_rev - gained_rev as diff
from cte2
order by diff desc;

-- total difference in variance

with cte as(select product, count(product) as sold, sum(close_value) as gained_rev
from sales_pipeline s
where deal_stage = 'Won'
group by product), 
cte2 as(select c.product, sold, sold*sales_price as exp_rev, gained_rev
from cte c
join products p on p.product = c.product), cte3 as(select product, exp_rev - gained_rev as diff
from cte2
order by diff desc)

select sum(diff) as total_difference
from cte3;

-- deal stage count

select deal_stage, count(deal_stage) as c
from sales_pipeline
group by deal_stage;

-- deals in progress

select count(product) as deals
from sales_pipeline
where deal_stage = 'In Progress';

-- value of expected deals

select s.product, sum(sales_price) as in_progress
from sales_pipeline s
join products p on p.product = s.product
where deal_stage = 'In Progress'
group by s.product
order by in_progress desc;

-- total value of expected deals

select sum(sales_price) as total_value
from sales_pipeline s
join products p on p.product = s.product
where deal_stage = 'In Progress';

-- lost deals

select count(product) as lost
from sales_pipeline
where deal_stage = 'Lost';

-- value of lost deals

select sum(sales_price) as lost_value
from sales_pipeline s 
join products p on p.product = s.product
where deal_stage = 'Lost';

-- lost deals count and value by product

select s.product, count(s.product) as lost_count, sum(sales_price) as lost_value
from sales_pipeline s
join products p on p.product = s.product
where deal_stage = 'Lost'
group by s.product
order by lost_value desc;

-- days to win a deal

with cte as(select datediff(str_to_date(close_date, '%d-%m-%Y'), str_to_date(created_date, '%d-%m-%Y')) as diff
from sales_pipeline
where deal_stage = 'Won')

select diff, count(diff) as c
from cte
where diff is not null
group by diff
order by c desc limit 10;

