# QUERIES AND SOLUTIONS

---

### 1. Total Revenue
~~~~sql
select sum(close_value)
from sales_pipeline
where deal_stage = 'Won';
~~~~

Answer
10005534

---

### 2. No. of products sold
~~~~sql
select count(product)
from sales_pipeline
where deal_stage = 'Won';
~~~~

Answer
4238

---
### 3. Products not sold
~~~~sql
select product
from products
where product not in (select product from sales_pipeline);
~~~~
Answer
| product      |
|--------------|
| MG Mono      |
| Alpha Caryad |

---

### 4. Revenue and quantity by product
~~~~sql
select product, count(product) as sold, sum(close_value) as revenue
from sales_pipeline
where deal_stage = 'Won'
group by product
order by revenue desc;
~~~~

Answer
| product        | quantity | revenue |
|----------------|----------|---------|
| GTX Pro        | 729      | 3510578 |
| GTX Plus Pro   | 479      | 2629651 |
| MG Advanced    | 654      | 2216387 |
| GTX Plus Basic | 653      | 705275  |
| GTX Basic      | 915      | 499263  |
| GTK 500        | 15       | 400612  |
| MG Special     | 793      | 43768   |

---

### 5. Expected and Gained revnue
~~~~sql
with cte as(select product, count(product) as sold, sum(close_value) as gained_rev
from sales_pipeline s
where deal_stage = 'Won'
group by product)
select c.product, sold, sold*sales_price as exp_rev, gained_rev
from cte c
join products p on p.product = c.product;
~~~~
Answer
| product        | quantity | exp_rev | gained_rev |
|----------------|----------|---------|------------|
| GTX Plus Basic | 653      | 715688  | 705275     |
| GTX Pro        | 729      | 3514509 | 3510578    |
| MG Special     | 793      | 43615   | 43768      |
| GTX Basic      | 915      | 503250  | 499263     |
| GTX Plus Pro   | 479      | 2625878 | 2629651    |
| MG Advanced    | 654      | 2219022 | 2216387    |
| GTK 500        | 15       | 401520  | 400612     |

---

### 6. Variance in Revenue
~~~~sql
with cte as(select product, count(product) as sold, sum(close_value) as gained_rev
from sales_pipeline s
where deal_stage = 'Won'
group by product), 
cte2 as(select c.product, sold, sold*sales_price as exp_rev, gained_rev
from cte c
join products p on p.product = c.product)

select product, exp_rev - gained_rev as diff
from cte2
~~~~

Answer
| product        | variance |
|----------------|----------|
| GTX Plus Basic | 10413    |
| GTX Basic      | 3987     |
| GTX Pro        | 3931     |
| MG Advanced    | 2635     |
| GTK 500        | 908      |
| MG Special     | -153     |
| GTX Plus Pro   | -3773    |

---

### 7. Total Difference in variance
~~~~sql
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
~~~~

Answer
17948

---

### 8. Deals in progress
~~~~sql
select count(product) as deals
from sales_pipeline
where deal_stage = 'In Progress';
~~~~

Answer
2089

---

### 9. Value of deals in progress
~~~~sql
select s.product, sum(sales_price) as in_progress
from sales_pipeline s
join products p on p.product = s.product
where deal_stage = 'In Progress'
group by s.product
order by in_progress desc;
~~~~

Answer
| product        | in_progress |
|----------------|-------------|
| GTX Pro        | 1605393     |
| GTX Plus Pro   | 1222486     |
| MG Advanced    | 1112904     |
| GTK 500        | 401520      |
| GTX Plus Basic | 363872      |
| GTX Basic      | 236500      |
| MG Special     | 23540       |

---

### 10. Total value of deals in progress
~~~~sql
select sum(sales_price) as total_value
from sales_pipeline s
join products p on p.product = s.product
where deal_stage = 'In Progress';
~~~~

Answer
4966215

---

### 11. Lost Deals
~~~~sql
select count(product) as lost
from sales_pipeline
where deal_stage = 'Lost';
~~~~

Answer
2473

### 12. Value of Lost deals
~~~~sql
select sum(sales_price) as lost_value
from sales_pipeline s 
join products p on p.product = s.product
where deal_stage = 'Lost';
~~~~

Answer
5946468

### 13. Lost delas count and value by porduct
~~~~sql
select s.product, count(s.product) as lost_count, sum(sales_price) as lost_value
from sales_pipeline s
join products p on p.product = s.product
where deal_stage = 'Lost'
group by s.product
order by lost_value desc;
~~~~

Answer
|     product    | lost_count | lost_value |
|:--------------:|:----------:|:----------:|
| GTX Pro        | 418        | 2015178    |
| MG Advanced    | 430        | 1458990    |
| GTX Plus Pro   | 266        | 1458212    |
| GTX Plus Basic | 398        | 436208     |
| GTX Basic      | 521        | 286550     |
| GTK 500        | 10         | 267680     |
| MG Special     | 430        | 23650      |

---

### 14. Days between ordering and confirming
~~~~sql
 with cte as(select datediff(str_to_date(close_date, '%d-%m-%Y'), str_to_date(created_date, '%d-%m-%Y')) as diff
from sales_pipeline
where deal_stage = 'Won')

select diff, count(diff) as c
from cte
where diff is not null
group by diff
order by c desc limit 10;
~~~~

Answer
| diff |  c  |
|:----:|:---:|
| 9    | 192 |
| 7    | 168 |
| 8    | 166 |
| 1    | 158 |
| 10   | 153 |
| 2    | 140 |
| 11   | 126 |
| 6    | 114 |
| 5    | 82  |
| 13   | 66  |

