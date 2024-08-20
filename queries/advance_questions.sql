-- Advance questions


/* Q1: Find how much amount spent by each customer on the best artist? Write a query to return customer name, artist name and total spent */


with best_selling_artist as 
(
select t1.artist_id, t1.name, sum(t4.quantity * t4.unit_price)
from artist t1
inner join album t2 on t1.artist_id = t2.artist_id
inner join track t3 on t2.album_id = t3.album_id
inner join invoice_line t4 on t3.track_id = t4.track_id

group by 1, 2
order by 3 desc
limit 1
)

select t1.customer_id, t1.first_name, t1.last_name, bsa.name, SUM(t3.quantity * t4.unit_price) as total_spent
from customer t1
inner join invoice t2 on t1.customer_id = t2.customer_id
inner join invoice_line t3 on t2.invoice_id = t3.invoice_id
inner join track t4 on t3.track_id = t4.track_id
inner join album t5 on t4.album_id = t5.album_id
inner join best_selling_artist bsa on t5.artist_id = bsa.artist_id
group by 1, 2, 3, 4
order by 5 desc;

/* Q2: We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre 
with the highest amount of purchases. Write a query that returns each country along with the top Genre. For countries where 
the maximum number of purchases is shared return any one Genre. */


with popular_genre AS
(
select t1.billing_country, t4.name, count(t2.quantity) as purchases,
ROW_NUMBER() OVER (PARTITION BY t1.billing_country ORDER BY count(t2.quantity) desc) as RN
from invoice t1
inner join invoice_line t2 on t1.invoice_id = t2.invoice_id
inner join track t3 on t2.track_id = t3.track_id
inner join genre t4 on t3.genre_id = t4.genre_id
GROUP BY 1, 2
ORDER BY 1 asc, 3 desc
)

select pg.billing_country, pg.name, pg.purchases
from popular_genre pg
where pg.rn <= 1;


/* Q3: Write a query that determines the customer that has spent the most on music for each country. 
Write a query that returns the country along with the top customer and how much they spent. 
For countries where the top amount spent is shared, provide all customers who spent this amount. */

WITH RECURSIVE 
	customter_with_country AS (
		SELECT customer.customer_id,first_name,last_name,billing_country,SUM(total) AS total_spending
		FROM invoice
		JOIN customer ON customer.customer_id = invoice.customer_id
		GROUP BY 1,2,3,4
		ORDER BY 2,3 DESC),

	country_max_spending AS(
		SELECT billing_country,MAX(total_spending) AS max_spending
		FROM customter_with_country
		GROUP BY billing_country)

SELECT cc.billing_country, cc.total_spending, cc.first_name, cc.last_name, cc.customer_id
FROM customter_with_country cc
JOIN country_max_spending ms
ON cc.billing_country = ms.billing_country
WHERE cc.total_spending = ms.max_spending
ORDER BY 1;
