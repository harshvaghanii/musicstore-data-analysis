-- Moderate Questions

/* Q1: Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
Return your list ordered alphabetically by email starting with A. 
*/

select distinct t1.email, t1.first_name, t1.last_name
from customer t1
inner join invoice t2
on t1.customer_id = t2.customer_id
inner join invoice_line t3
on t2.invoice_id = t3.invoice_id
inner join track t4
on t3.track_id = t4.track_id
inner join genre t5
on t4.genre_id = t5.genre_id
where t5.name = "Rock"
order by email;

/* Q2: Let's invite the artists who have written the most rock music in our dataset. 
Write a query that returns the Artist name and total track count of the top 10 rock bands. 
*/

select t1.artist_id, t1.name, count(t1.artist_id) as number_of_songs
from track t3
inner join album t2 on t2.album_id = t3.album_id
inner join artist t1 on t1.artist_id = t2.artist_id
inner join genre t4 on t3.genre_id = t4.genre_id
where t4.name LIKE "Rock"
group by t1.artist_id, t1.name
order by number_of_songs desc
limit 10;

/* Q3: Return all the track names that have a song length longer than the average song length. 
Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first. 
*/

with Average_track_length as
(
select avg(milliseconds) as avg_time from track
)

select name, milliseconds from track
where milliseconds > (select * from Average_track_length)
order by milliseconds desc;