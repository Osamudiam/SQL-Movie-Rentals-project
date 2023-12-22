USE SAKILA;

-- 1. Find all the movies which have a rating of PG and length greater than 50 minutes.

SELECT TITLE, RATING, LENGTH 
FROM FILM
WHERE RATING = 'PG' AND LENGTH > 50;

-- 2. Find the total payment received on or after 2006-01-01.

SELECT SUM(AMOUNT) AS TOTAL_PAYMENT_RECEIVED
FROM PAYMENT
WHERE PAYMENT_DATE >= '2006-01-01';

-- 3. Which actors have the last name ‘Hopkins’?

SELECT *  FROM ACTOR
WHERE LAST_NAME = 'HOPKINS';

-- 4. Which last names are not repeated?

SELECT DISTINCT LAST_NAME FROM ACTOR;

-- 5. How many unique last names are there?

SELECT COUNT(DISTINCT LAST_NAME) AS UNIQUE_LAST_NAME
FROM ACTOR;


-- 6. Which actor has appeared in the most films? And show the number of films.

SELECT A.ACTOR_ID, CONCAT(A.FIRST_NAME, ' ', A.LAST_NAME) AS ACTOR_NAME, COUNT(*) AS NUMBER_OF_FILMS
FROM ACTOR A 
JOIN FILM_ACTOR FA ON A.ACTOR_ID = FA.ACTOR_ID
GROUP BY A.ACTOR_ID
ORDER BY NUMBER_OF_FILMS DESC
LIMIT 1;


-- 7. When is ‘Academy Dinosaur’ due?

SELECT F.TITLE, R.RENTAL_DATE, R.RETURN_DATE
FROM FILM F 
JOIN INVENTORY I ON F.FILM_ID = I.FILM_ID
JOIN RENTAL R ON I.INVENTORY_ID = R.INVENTORY_ID
WHERE F.TITLE = 'ACADEMY DINOSAUR'
AND R.RETURN_DATE IS NULL
ORDER BY R.RENTAL_DATE DESC;



-- 8. What is the average running time for all the films?

SELECT AVG(LENGTH) AS AVERAGE_RUNNING_TIME FROM FILM;



-- 9. What is the average running time for all the films by category?

SELECT AVG(F.LENGTH) AS AVERAGE_RUNNING_TIME, FC.CATEGORY_ID AS CATEGORY
FROM FILM F 
JOIN FILM_CATEGORY FC ON F.FILM_ID = FC.FILM_ID
GROUP BY CATEGORY_ID;

-- 10. What does the query below do and why does it return an empty set?
select * from film natural join inventory;

/*
THE QUERY ABOVE SHOWS THE JOINING OF TWO TABLES TO RETURN A GIVEN RESULT SET
THE RESULT SET RETURNS EMPTY BECAUSE THE MATCHING TABLES IN USE, DO NOT HAVE THE SAME NUMBER OF COLUMN AND DATASET
*/


-- 11. What is the total revenue of all stores?

SELECT SUM(AMOUNT) AS TOTAL_REVENUE
FROM PAYMENT;


-- 12.  Write a query to get all the full names of customers that have rented sci-fi movies more than 2 times. Arrange these names in alphabetical order.

SELECT concat(C.FIRST_NAME, ' ',  C.LAST_NAME) AS FULLNAME, COUNT(R.RENTAL_ID) AS NUMBER_OF_TIME_RENTED
FROM CUSTOMER C 
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category ct ON fc.category_id = ct.category_id
WHERE ct.name = 'Sci-Fi' 
GROUP BY c.customer_id
HAVING COUNT(*) > 2
ORDER BY FULLNAME;


-- 13. Write a query to find the city which generated the maximum revenue for the business. 

SELECT C.CITY, SUM(P.AMOUNT) AS MAXIMUM_REVENUE
FROM CITY C
JOIN ADDRESS A ON C.CITY_ID = A.CITY_ID
JOIN STORE S ON A.ADDRESS_ID = S.ADDRESS_ID
JOIN STAFF ST ON S.STORE_ID = ST.STORE_ID
JOIN RENTAL R ON ST.STAFF_ID = R.STAFF_ID
JOIN PAYMENT P ON R.CUSTOMER_ID = P.CUSTOMER_ID
group by C.CITY_ID
order by MAXIMUM_REVENUE desc LIMIT 1;


-- 14. Find the names (first and last) of all the actors and customers whose first name is the same as the first name of the actor with ID 8. Do not return the actor with ID 8 himself. 


SELECT first_name, last_name
FROM actor
WHERE first_name = (SELECT first_name FROM actor WHERE actor_id = 8)
  AND actor_id != 8

UNION

SELECT first_name, last_name
FROM customer
WHERE first_name = (SELECT first_name FROM actor WHERE actor_id = 8);


-- 15.  In how many film categories is the average difference between the film replacement cost and the rental rate larger than 17

SELECT COUNT(*) AS num_categories
FROM (
    SELECT c.name,
           AVG(f.replacement_cost - f.rental_rate) AS avg_difference
    FROM category c
    JOIN film_category fc ON c.category_id = fc.category_id
    JOIN film f ON fc.film_id = f.film_id
    GROUP BY c.name
    HAVING avg_difference > 17
) AS categories_with_large_difference;



