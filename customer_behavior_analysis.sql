select * from customer_behavior

--Q1. What is the total revenue generatyed by male vs female customers?

select gender, sum(purchase_amount) as total_generated_revenue
from customer_behavior
group by gender

--Q2. Which customers used a discount but still spent more than average purchase amount?

select customer_id, purchase_amount
from customer_behavior 
where discount_applied = 'Yes' and purchase_amount >=
(select avg(purchase_amount) from customer_behavior)

--Q3. Which are the top 5 products with the highest average review rating 

select item_purchased, round(avg(review_rating::numeric),2) as "avg_product_rating"
from customer_behavior 
group by item_purchased order by avg(review_rating) 
limit 5

--Q4. Compare the average Purchase amount between Standard and express Shipping.

select shipping_type, round(avg(purchase_amount),2)
from customer_behavior 
where shipping_type in ('Standard', 'Express')
group by shipping_type

--Q5. Do scbscribed customers spend more? comapre avg spend and total revenue between 
-- subscribe or non-subscribe

select subscription_status, count(customer_id) as total_reveneu,
round(avg(purchase_amount),2) as avg_spend,
round(sum(purchase_amount),2) as total_revenue
from customer_behavior
group by 1 order by total_reveneu,avg_spend desc

--Q6. Which 5 products have the highest percentage of purchase with discount applied?

select item_purchased,
round(100 * sum(case when discount_applied = 'Yes' then 1 else 0 end) / count(*),2)as discount_rate
from customer_behavior
group by 1 order by discount_rate desc
limit 5

--Q7. Segment customers into New, Returning and Loyal based on their total number of previous purchases 
-- and show the count of each segment.

with customer_type as (
select customer_id, previous_purchases,
case
     when previous_purchases = 1 then 'New'
     when previous_purchases between 2 and 10 then 'Returning'
     else 'Loyal' 
end as customer_segment from customer_behavior)
select customer_segment, count(*) as No_of_customers
from customer_type group by customer_segment
order by No_of_customers desc

--Q8. What are the top 3 most purchased products within each category?

with item as (
select category, item_purchased, count(customer_id) as total_orders,
row_number() over(partition by category order by count(customer_id) desc ) as item_rnk
from customer_behavior 
group by 1,2 )
select item_rnk, category, item_purchased,total_orders 
from item  where item_rnk <= 3

--Q9. Are customers who are repeat buyers (more than 5 previous purchases) also likely to subscribe?

select subscription_status, count(customer_id) as repeat_buyers
from customer_behavior 
where previous_purchases > 5
group by 1

--Q10. What is the revenue contribution of each age group ?

select age_group , sum(purchase_amount) as total_revenue
from customer_behavior 
group by 1 order by total_revenue desc





































