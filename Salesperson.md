# QUERIES AND SOLUTIONS

---

### 1. Total Salesperson
~~~~sql
select count(distinct sales_agent)
from sales_teams;
~~~~

Answer
35

---

### 2. No of deals by top salesperson
~~~~sql
select sales_agent, count(product) as deals
from sales_pipeline
where deal_stage = 'Won'
group by sales_agent
order by deals desc limit 10;
~~~~

Answer
|     sales_agent    | deals |
|:------------------:|:-----:|
| Darcel Schlecht    | 349   |
| Vicki Laflamme     | 221   |
| Kary Hendrixson    | 209   |
| Anna Snelling      | 208   |
| Versie Hillebrand  | 176   |
| Kami Bicknell      | 174   |
| Jonathan Berthelot | 171   |
| Cassey Cress       | 163   |
| Zane Levy          | 161   |
| Donn Cantrell      | 158   |

---

### 3. Revenue earned by top salesperson
~~~~sql
select sales_agent, sum(close_value) as rev
from sales_pipeline
where deal_stage = 'Won'
group by sales_agent
order by rev desc limit 10;
~~~~

Answer
|   sales_agent   |   rev   |
|:---------------:|:-------:|
| Darcel Schlecht | 1153214 |
| Vicki Laflamme  | 478396  |
| Kary Hendrixson | 454298  |
| Cassey Cress    | 450489  |
| Donn Cantrell   | 445860  |
| Reed Clapper    | 438336  |
| Zane Levy       | 430068  |
| Corliss Cosme   | 421036  |
| James Ascencio  | 413533  |
| Daniell Hammack | 364229  |

---

### 4. Sales by regional office
~~~~sql
select regional_office, sum(close_value) as rev
from sales_pipeline s
join sales_teams t on t.sales_agent = s.sales_agent
group by regional_office;
~~~~

Answer
| regional_office |   rev   |
|:---------------:|:-------:|
| Central         | 3346293 |
| West            | 3568647 |
| East            | 3090594 |

---

### 5. Employees who left
~~~~sql
select *
from sales_teams
where status = 'Former';
~~~~

Answer
| sales_agent   |
|---------------|
| Garret Kinder |
| Donn Cantrell |
| Reed Clapper  |
---

### 6. Win, Loss and In Progress ratio by Manager
~~~~sql
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
~~~~

Answer
|      manager     | win_ratio | lost_ratio | in_progress_ratio |
|:----------------:|:---------:|:----------:|:-----------------:|
| Dustin Brinkmann | 47.19     | 27.73      | 25.08             |
| Melvin Marxen    | 45.72     | 27.79      | 26.49             |
| Summer Sewald    | 48.68     | 26.98      | 24.34             |
| Celia Rouche     | 47.07     | 27.16      | 25.77             |
| Rocco Neubert    | 52.07     | 31.80      | 16.13             |
| Cara Losch       | 49.79     | 27.49      | 22.72             |

---

### 7. Top 10 clients under respective manager
~~~~sql
with cte as(select sales_agent
from sales_pipeline
where deal_stage = 'Won'
group by sales_agent
order by sum(close_value) desc limit 10)

select manager, count(c.sales_agent) as emp_count
from cte c 
join sales_teams t on c.sales_agent = t.sales_agent
group by manager;
~~~~

Answer
| manager       | emp_count |
|---------------|-----------|
| Melvin Marxen | 1         |
| Cara Losch    | 1         |
| Rocco Neubert | 4         |
| Celia Rouche  | 1         |
| Summer Sewald | 3         |

---

### 8. Revenue by manager
~~~~sql
select manager, sum(close_value) as rev
from sales_pipeline s 
join sales_teams t on t.sales_agent = s.sales_agent
group by manager
order by rev desc;
~~~~

Answer
|      manager     |   rev   |
|:----------------:|:-------:|
| Melvin Marxen    | 2251930 |
| Summer Sewald    | 1964750 |
| Rocco Neubert    | 1960545 |
| Celia Rouche     | 1603897 |
| Cara Losch       | 1130049 |
| Dustin Brinkmann | 1094363 |

---

