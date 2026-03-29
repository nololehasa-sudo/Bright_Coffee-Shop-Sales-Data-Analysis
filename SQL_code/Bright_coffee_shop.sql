Select
      transaction_id,
      transaction_time,
      transaction_qty,
      store_id,
      store_location,
      product_id,
      unit_price,
      product_category,
      product_type,
      product_detail,
      transaction_date,
      dayname(transaction_date) AS Day_name,
      monthname(transaction_date) AS Month_name,
      date_format(transaction_time, 'HH:mm:ss') AS purchase_time,
      dayofmonth (transaction_date) AS day_of_month,


Case
      When date_format(transaction_time, 'HH:mm:ss') between '00:00:00' and '11:59:59' then '01.Morning'
      When date_format(transaction_time, 'HH:mm:ss') between '12:00:00' and '16:59:59' then '02.Afternoon'
      When date_format(transaction_time, 'HH:mm:ss') >= '17:00:00' then '03.Evening'
      End as time_buckets,

      Case
      When dayname(transaction_date) IN ('Sun', 'Sat') THEN 'Weekend'
      ELSE 'Weekday'
      End as Day_classification,

Case 
When (transaction_qty*unit_price) <=20 THEN '01.Low spender'
When (transaction_qty*unit_price) BETWEEN 21 AND 100 THEN '02.Medium spender'
Else '03.High spender'
   End as spending_buckets,
      
      COUNT(Distinct transaction_id) AS number_of_sales,
      COUNT(Distinct product_id) AS number_of_products,
      COUNT(Distinct store_id) AS number_of_stores,
  
      SUM(transaction_qty*unit_price) AS revenue_per_day
   
   From  `workspace`.`default`.`1771947879858_bright_coffee_shop_sales_2_2`

Group by transaction_date,
         Day_name,
         spending_buckets,
         Month_name,
         store_location,
         product_category,
         purchase_time,
         time_buckets,
         day_of_month,
         Day_classification,
         transaction_id,
         transaction_time,
         transaction_qty,
         store_id,
         store_location,
         product_id,
         unit_price,
         product_category,
         product_type,
         product_detail,
         transaction_date,
         product_detail;
