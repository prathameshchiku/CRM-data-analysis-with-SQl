# QUERIES AND SOLUTIONS

---

### 1. Total Clients
~~~~sql
select count(distinct account)
from sales_pipeline;
~~~~

Answer
85

---

### 2. Top 10 Clients
~~~~sql
select account, count(product) as qty, sum(close_value) as rev
from sales_pipeline
where account is not null
group by account
order by rev desc limit 10;
~~~~

Answer
|   account  | qty |   rev  |
|:----------:|:---:|:------:|
| Kan-code   | 196 | 341455 |
| Konex      | 178 | 269245 |
| Condax     | 170 | 206410 |
| Cheers     | 98  | 198020 |
| Hottechi   | 200 | 194957 |
| Goodsilron | 95  | 182522 |
| Treequote  | 116 | 176751 |
| Warephase  | 106 | 170046 |
| Xx-holding | 87  | 169357 |
| Isdom      | 119 | 164683 |

---

### 3. Revenue by top 10 clients as % of Total Revenue
~~~~sql
with cte as(select account, count(product) as qty, sum(close_value) as rev
from sales_pipeline
where deal_Stage = 'Won'
group by account
order by rev desc limit 10)

select round(sum(rev)/(select sum(close_value) from sales_pipeline)*100, 2) as perc
from cte;
~~~~

Answer
20.72%

---

### 4. Products of top 10 Clients
~~~~sql
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
~~~~

Answer
|   account  | gtx_pro | gtx_basic | mg_special | mg_advanced | gtx_plus_pro | gtx_plus_basic | gtk_500 |
|:----------:|:-------:|:---------:|:----------:|:-----------:|:------------:|:--------------:|:-------:|
| Isdom      | 10      | 10        | 11         | 15          | 9            | 10             | 0       |
| Cheers     | 6       | 15        | 5          | 11          | 5            | 12             | 3       |
| Treequote  | 12      | 11        | 14         | 12          | 11           | 5              | 0       |
| Warephase  | 12      | 11        | 12         | 12          | 9            | 14             | 0       |
| Xx-holding | 10      | 10        | 3          | 9           | 4            | 10             | 2       |
| Goodsilron | 9       | 19        | 8          | 7           | 12           | 9              | 1       |
| Kan-code   | 26      | 26        | 10         | 20          | 17           | 15             | 1       |
| Konex      | 18      | 24        | 12         | 22          | 13           | 19             | 0       |
| Condax     | 15      | 22        | 30         | 9           | 13           | 16             | 0       |
| Hottechi   | 15      | 37        | 19         | 14          | 6            | 20             | 0       |

---

### 5. Lost Deals
~~~~sql
select account, count(s.product) as lost_deals, sum(sales_price) as lost_value
from sales_pipeline s
join products p on p.product = s.product
where deal_stage = 'Lost'
group by account
order by lost_deals desc limit 10
~~~~

Answer
|   account  | lost_deals | lost_value |
|:----------:|:----------:|------------|
| Hottechi   | 82         | 180595     |
| Kan-code   | 72         | 199621     |
| Konex      | 63         | 187122     |
| Condax     | 54         | 125292     |
| Dontechi   | 47         | 105232     |
| Isdom      | 47         | 118777     |
| Codehow    | 45         | 108044     |
| Treequote  | 41         | 137291     |
| Streethex  | 41         | 102023     |
| Funholding | 40         | 91698      |

---

