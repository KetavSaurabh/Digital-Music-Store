# Who is the most senior employee based on job title ?
SELECT 
    CONCAT(first_name, ' ', last_name) AS full_name,
    levels
FROM
    employee
ORDER BY levels DESC
LIMIT 1;

# Which countries have the most invoices ?
SELECT 
    COUNT(*) AS cnt,
    billing_country
FROM
    invoice
GROUP BY billing_country
ORDER BY cnt DESC;

# Which are the top 3 values of total invoice ?
SELECT 
    total
FROM
    invoice
ORDER BY total DESC
LIMIT 3;

# The Music Company would like to throw a promotional Music Festival in the city it made the most money. Which city has the best customers in terms of total money ?
SELECT 
    SUM(total) AS `Sum of total invoices`,
    billing_city
FROM
    invoice
GROUP BY billing_city
ORDER BY `Sum of total invoices` DESC
LIMIT 1;

# The customer who has spent the most money will be declared the best customer. Who is it ?
SELECT CONCAT(first_name , " " , last_name) AS `Full Name`,
SUM(total) AS `Sum of total invoices`
FROM customer
LEFT JOIN invoice
ON customer.customer_id = invoice.customer_id
GROUP BY `Full Name`
ORDER BY `Sum of total invoices` DESC
LIMIT 1;

# Print the details (e.g.- first name , last name , email id , full name) and genre of all Rock music listeners. Printing should be done alphabetically by email id starting with 'A'
WITH RockFam AS
(
	SELECT track_id
    FROM track
	INNER JOIN genre
	ON track.genre_id = genre.genre_id
	WHERE genre.genre_id = 1
)

SELECT DISTINCT
    first_name AS `First Name`,
    last_name AS `Last Name`,
    email AS `E-Mail ID`
FROM
customer
INNER JOIN invoice
ON customer.customer_id = invoice.customer_id
INNER JOIN invoice_line
ON invoice.invoice_id = invoice_line.invoice_id
WHERE track_id IN (SELECT * FROM RockFam)
ORDER BY email;

# Which artists have written the most Rock music ? Also, what is the total track count of the top 10 Rock Bands ?
WITH RockArtist AS
(
	SELECT track_id FROM track
    INNER JOIN genre
    ON genre.genre_id = track.genre_id
    WHERE genre.genre_id = 1
)

SELECT 
	artist.name,
    COUNT(*) AS `Total Track Count`
FROM artist
INNER JOIN album
ON artist.artist_id = album.artist_id
INNER JOIN track
ON album.album_id = track.album_id
WHERE track.track_id IN (SELECT * FROM RockArtist)
GROUP BY artist.name
ORDER BY `Total Track Count` DESC
LIMIT 10;

# Give all Track Names that have their song lengths greater than the average song length. Their Name and Time (Milliseconds) in Descending ORDER
SELECT 
	name AS Name,
    milliseconds AS `Track Time`
FROM track
WHERE milliseconds > (SELECT AVG(milliseconds) from track)
ORDER BY milliseconds DESC;

# How much time is spent by each customer on artists ? (customer name , artist name , total spent/sales)

# APPROACH : Firstly , total spent is found out ; then later on , when I am doing the connection of various required tables
# for getting the full name , I have connected this CTE with the myriad of connection of tables here , while also connecting required table for getting artist name

WITH sales_by_artist AS
(
	SELECT 
		artist.artist_id AS artist_id,
        artist.name AS artist_name,
        SUM(invoice_line.unit_price * invoice_line.quantity) AS sales_per_artist
	FROM invoice_line
	INNER JOIN track
	ON track.track_id = invoice_line.track_id
	INNER JOIN album
	ON track.album_id = album.album_id
	INNER JOIN artist
	ON artist.artist_id = album.artist_id
	GROUP BY artist.artist_id , artist.name
)

SELECT
	CONCAT(customer.first_name , " " , customer.last_name) AS full_name,
    artist.name AS artist_name,
    SUM(invoice_line.unit_price * invoice_line.quantity) AS sales_by_customer
FROM invoice_line
INNER JOIN invoice
ON invoice.invoice_id = invoice_line.invoice_id
INNER JOIN customer
ON customer.customer_id = invoice.customer_id
INNER JOIN track
ON track.track_id = invoice_line.track_id
INNER JOIN album
ON album.album_id = track.album_id
INNER JOIN artist
ON artist.artist_id = album.artist_id
INNER JOIN sales_by_artist
ON sales_by_artist.artist_id = artist.artist_id
GROUP BY full_name , artist.name
ORDER BY sales_by_customer DESC;

# Which customers have spent the most on music from each country ? And how much is their expenditure ? 
SELECT * FROM
(
	SELECT 
		customer.customer_id,
		CONCAT(customer.first_name , " " , customer.last_name) AS full_name,
		billing_country,
		SUM(total) AS total_expenditure,
		DENSE_RANK() OVER(PARTITION BY billing_country ORDER BY SUM(total) DESC) AS rank_total
	FROM invoice
	INNER JOIN customer 
    ON customer.customer_id = invoice.customer_id
	GROUP BY full_name , customer.customer_id , billing_country
	ORDER BY total_expenditure DESC
)
AS top_customers
WHERE top_customers.rank_total = 1;

# What is the most popular music genre for each country ?
SELECT 
	total_purchases.country,
	total_purchases.name,
	total_purchases.amount_of_purchases
FROM
(
	SELECT
		customer.country,
		genre.genre_id,
		genre.name,
		COUNT(invoice_line.quantity) AS amount_of_purchases,
		DENSE_RANK() OVER(PARTITION BY customer.country ORDER BY COUNT(invoice_line.quantity) DESC) AS rank_based_on_genre_of_countries
	FROM invoice_line
	INNER JOIN invoice
	ON invoice.invoice_id = invoice_line.invoice_id
	INNER JOIN customer 
	ON customer.customer_id = invoice.customer_id
	INNER JOIN track
	ON track.track_id = invoice_line.track_id
	INNER JOIN genre
	ON genre.genre_id = track.genre_id
	GROUP BY customer.country , genre.name , genre.genre_id
	ORDER BY amount_of_purchases DESC) 
AS total_purchases
WHERE total_purchases.rank_based_on_genre_of_countries = 1;
