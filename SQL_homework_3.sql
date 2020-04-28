-- 1a. Display the first and last names of all actors from the table actor.
select first_name, last_name
from actor;

 
-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
 select concat(first_name,last_name)
 from actor;
-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe."
--  	What is one query would you use to obtain this information?
 select actor_id,first_name,last_name
 from actor
 where first_name='Joe';
 
-- 2b. Find all actors whose last name contain the letters GEN:
select * from actor
where last_name like '%gen%'; 
-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
 select * from actor
 where last_name like '%li%'
 order by last_name, first_name;
-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
 select country_id from country
 where country in ('Afghanistan', 'China', 'Bangladesh');
 
-- 3a. Add a middle_name column to the table actor. Position it between first_name and last_name. Hint: you will need to specify the data type.
alter table `sakila`.`actor`
add column `middle_name` varchar(45) null after `first_name`;
 
-- 3b. You realize that some of these actors have tremendously long last names.
--  Change the data type of the middle_name column to blobs.
 
-- 3c. Now delete the middle_name column.
alter table actor
drop middle_name;

-- 4a. List the last names of actors, as well as how many actors have that last name.
select last_name, count(*)
from actor
group by last_name
order by count(*) desc ;
 
-- 4b. List last names of actors and the number of actors who have that last name,
-- 	but only for names that are shared by at least two actors
select last_name, count(*) 
from actor
group by last_name
having count(*) >=2
order by count(*) desc;

-- 4c. Oh, no! The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS,
-- 	the name of Harpo's second cousin's husband's yoga teacher. Write a query to fix the record.
 
update actor
set first_name = 'Harpo'
where first_name='groucho' and last_name='williams';

 
-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct
-- name after all!
-- In a single query, if the first name of the actor is currently HARPO,
-- change it to GROUCHO. Otherwise, change the first name to MUCHO GROUCHO, as that is exactly what
-- the actor will be with the grievous error. BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR
-- TO MUCHO GROUCHO, HOWEVER!
-- (Hint: update the record using a unique identifier.)
 update actor
 set first_name = (case when first_name='harpo' 
						then 'groucho'
						else 'Mucho Groucho'
                        end)
where actor_id=172;
 
 
 
-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
 
 describe address;
 
-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
 select first_name, last_name, address 
 from address inner join staff using (address_id);
 
-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
 select sum(amount), staff_id
 from payment 
 inner join staff
 using (staff_id)
 where 
 year(payment_date)=2005 and month(payment_date)=8
 group by staff_id;
 
 
-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
 select f.film_id, f.title, count(fa.actor_id)
 from film f 
 inner join film_actor fa 
 using (film_id)
 group by f.film_id;
-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
 select count(i.inventory_id) 
 from inventory i
 inner join film f
 using (film_id)
 where f.title='Hunchback Impossible';
 
-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer.
-- 	List the customers alphabetically by last name:
 
 select c.first_name, c.last_name, sum(p.amount)
 from payment p
 inner join customer c
 using (customer_id)
 group by c.last_name
 order by c.last_name;
 
-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence,
--  films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of
--  movies starting with the letters K and Q whose language is English.
select title from film 
where title like 'k%' or title like 'q%' and language_id = (select language_id from language where name='English');

 
-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.
 select * from actor
 where actor_id in (select actor_id from film_actor where film_id = (select film_id from film where title='alone trip'));
 
-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and
-- 	email addresses of all Canadian customers.
-- 	Use joins to retrieve this information.
 select customer.first_name, customer.last_name, customer.email
 from customer 
 inner join address using (address_id)
 inner join city using (city_id)
 inner join country using (country_id)
 where country.country='Canada';
 
-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion.
--  Identify all movies categorized as famiy films.
 select * from film 
 inner join film_category
 using (film_id)
 inner join category
 using (category_id)
 where category.name ='family';
 
-- 7e. Display the most frequently rented movies in descending order.
 select film.title, count(film.film_id)
 from inventory 
 inner join rental 
 using (inventory_id)
 inner join film
 using (film_id)
 group by film_id
 order by count(film_id) desc;
 
-- 7f. Write a query to display how much business, in dollars, each store brought in.
 select store_id, sum(amount)
 from payment
 inner join staff
 using (staff_id)
 inner join store
 using (store_id)
 group by store_id;
 
-- 7g. Write a query to display for each store its store ID, city, and country.
 select store.store_id, city.city,country.country
 from store
 inner join address
 using (address_id)
 inner join city
 using (city_id)
 inner join country
 using (country_id);
 
-- 7h. List the top five genres in gross revenue in descending order.
-- (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
 
 select category.name, sum(payment.amount)
from payment 
join rental
using (rental_id)
join inventory
using (inventory_id)
join film
using (film_id)
join film_category
using (film_id)
join category
using (category_id)
group by category.name
order by sum(payment.amount) desc
limit 5;
 
 
-- 8a. In your new role as an executive, you would like to have an easy way of viewing
--  	the Top five genres by gross revenue. Use the solution from the problem above to create a view.
--  	If you haven't solved 7h, you can substitute another query to create a view.
  
  create view top_five_rented_genre as 

 select category.name, sum(payment.amount)
from payment 
join rental
using (rental_id)
join inventory
using (inventory_id)
join film
using (film_id)
join film_category
using (film_id)
join category
using (category_id)
group by category.name
order by sum(payment.amount) desc
limit 5;

  
-- 8b. How would you display the view that you created in 8a?
 select * from top_five_rented_genre;
 
-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
 
 
drop view top_five_rented_genre;