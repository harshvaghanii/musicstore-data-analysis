-- Easy Questions

/* Q1: Who is the senior most employee based on job title? */

select * from employee
order by levels desc
limit 1;



/* Q2: Which country has the most Invoices? */

select billing_country, count(*) as Total_Invoices
from invoice
group by billing_country
order by Total_Invoices desc
limit 1;

/* Q3: What are top 3 values of total invoice? */

select invoice_id, customer_id, invoice_date, ROUND(total,2)
from invoice
order by total desc
limit 3;


/* Q4: Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. 
Write a query that returns one city that has the highest sum of invoice totals. 
Return both the city name & sum of all invoice totals 
*/

select billing_city, ROUND(sum(total), 2) as invoice_total
from invoice
group by billing_city
order by invoice_total desc
limit 1;

/* Q5: Who is the best customer? The customer who has spent the most money will be declared the best customer. 
Write a query that returns the person who has spent the most money.*/

select c.customer_id, c.first_name, c.last_name, ROUND(sum(i.total), 2) as total
from customer c
inner join invoice i
on c.customer_id = i.customer_id
group by c.customer_id, c.first_name, c.last_name
order by total desc
limit 1;