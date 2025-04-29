use [DataWarehouseAnalytics]
select 
year(order_date) as order_year,
month(order_date) as order_month,
sum(sales_amount) as total_sales,
COUNT(distinct customer_key) as total_customers,
SUM(quantity) as total_quantity
from gold.fact_sales
where order_date is not null
group by year(order_date),month(order_date)
order by order_year,order_month

--Calculate the total sales per month and the running total of sales over time
select
order_date,
total_sales,
sum(total_sales) over ( order by order_date) as running_total_sales,
avg(avg_price) over ( order by order_date) as moving_averge_price
from
(
select 
DATETRUNC(MONTH,order_date) as order_date,
SUM(sales_amount) as total_sales,
avg(price) as avg_price
from gold.fact_sales
where order_date is not null
group by DATETRUNC(MONTH,order_date)
) t

/* Analyze the yearly performance of products by comparing their sales
to both the average sales performance of the product and the previous year's sales*/
with yearly_product_sales as (
select
year(f.order_date) as order_year,
p.product_name,
sum(f.sales_amount) as current_sales
from gold.fact_sales f
left join gold.dim_products p
on f.product_key = p.product_key
where order_date is not null
group by year(f.order_date),p.product_name
)
select 
order_year,
product_name,
current_sales,
AVG(current_sales) over (partition by product_name) avg_sales,
current_sales - AVG(current_sales) over (partition by product_name) as diff_avg,
case when current_sales - AVG(current_sales) over (partition by product_name) > 0 then 'Above Avg'
	 when current_sales - AVG(current_sales) over (partition by product_name) < 0 then 'Below Avg'
	 else 'Avg'
end avg_change,
--Year-over-year Analysis
LAG(current_sales) over (partition by product_name order by order_year) py_sales,
current_sales - LAG(current_sales) over (partition by product_name order by order_year) diff_py,
case when current_sales - LAG(current_sales) over (partition by product_name order by order_year) > 0 then 'Increase'
	 when current_sales - LAG(current_sales) over (partition by product_name order by order_year) < 0 then 'Decrease'
	 else 'No Change'
end py_change
from yearly_product_sales
order by product_name,order_year

--Which categories contribute the most to overall sales ?
with category_sales as (
select 
category,
SUM(sales_amount) total_sales
from gold.fact_sales f
left join gold.dim_products p 
on p.product_key = f.product_key
group by category
)
select 
category,
total_sales,
sum(total_sales) over () overall_sales,
concat(round((cast(total_sales as float) / sum(total_sales) over()) * 100, 2),'%') as percentage_of_total
from category_sales
order by total_sales desc

/*Segement products into cost ranges and count how many products fall into each segment*/
with prodcut_segment as (
select 
product_key,
product_name,
cost,
case when cost < 100 then 'Below 100'
	 when cost between 100 and 500 then '100-500'
	 when cost between 500 and 1000 then '500-1000'
	 else 'Above 1000'
end cost_range
from gold.dim_products
)
select 
cost_range,
count(product_key) as total_products
from prodcut_segment
group by cost_range
order by total_products desc

/*Group cusstomers into three sgments based on their spending behavior:
	- VIP: Customers with at least 12 months of history and spending more than 5,000.
	- Regular: Customers with at least 12 months of history but spending more than 5,000 or less.
	- New:  Customers with a lifespan less than 12 months.
And find the total number of customers by each group*/
with customer_spending as (
select 
c.customer_key,
sum(f.sales_amount) as total_spending,
min(f.order_date) as first_order,
max(f.order_date) as last_order,
DATEDIFF(MONTH,min(order_date),max(order_date)) as lifespan
from gold.fact_sales f 
left join gold.dim_customers c
on f.customer_key = c.customer_key
group by c.customer_key
)

select 
customer_segment,
count(customer_key) as total_customers
from (
	select 
	customer_key,
	total_spending,
	lifespan,
	case when lifespan > 12 and total_spending > 5000 then 'VIP'
		 when lifespan >= 12 and total_spending < 5000 then 'Regular'
		 else 'New'
	end customer_segment
	from customer_spending ) t
group by customer_segment
order by total_customers desc


