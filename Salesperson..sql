-- total salesperson

select count(distinct sales_agent)
from sales_teams;

-- deals finalized

select sales_agent, count(product) as deals
from sales_pipeline
where deal_stage = 'Won'
group by sales_agent
order by deals desc limit 10;

-- value obtained

select sales_agent, sum(close_value) as rev
from sales_pipeline
where deal_stage = 'Won'
group by sales_agent
order by rev desc limit 10;


-- sales by regional office

select regional_office, sum(close_value) as rev
from sales_pipeline s
join sales_teams t on t.sales_agent = s.sales_agent
group by regional_office;

-- emp who left

select *
from sales_teams
where status = 'Former';

-- manager with wins and losses

with cte as(select manager,
sum(case 
	when deal_stage= 'Won' then 1 else 0
end) as won_count,
sum(case
	when deal_stage = 'Lost' then 1 else 0
end) as lost_count,
sum(case 
	when deal_stage = 'In Progress' then 1 else 0
end) as in_progress_count
from sales_pipeline s
join sales_teams t on t.sales_agent = s.sales_agent
group by manager)

select manager, round(won_count/(won_count + lost_count + in_progress_count)*100, 2) as win_ratio,
round(lost_count/(won_count + lost_count + in_progress_count)*100, 2) as lost_ratio,
round(in_progress_count/(won_count + lost_count + in_progress_count)*100, 2) as in_progress_ratio
from cte;

-- top 10 employees under manager

with cte as(select sales_agent
from sales_pipeline
where deal_stage = 'Won'
group by sales_agent
order by sum(close_value) desc limit 10)

select manager, count(c.sales_agent) as emp_count
from cte c 
join sales_teams t on c.sales_agent = t.sales_agent
group by manager;

-- value by manager

select manager, sum(close_value) as rev
from sales_pipeline s 
join sales_teams t on t.sales_agent = s.sales_agent
group by manager
order by rev desc;

-- employees with lost deals and revenue generated

with cte as(select sales_agent, sum(
case 
	when deal_stage = 'Lost' then 1 else 0
end) as lost_count, sum(close_value) as rev_earned
from sales_pipeline
group by sales_agent
order by lost_count desc)

select sales_agent,
ntile(5) over (order by lost_count asc, rev_earned desc) as r
from cte;


