use sakila;

#1.Actors with first name being Scarlett
Select * from actor
WHERE first_name='Scarlett';

#2, Actors with last name being Johnasson
SELECT * from actor
WHERE last_name='Johansson';

#3,No. of dinstinct actors last name
#SELECT count(distinct last_name)  as count_last_name
#from actor;

set @count_last_name=
 (SELECT count(distinct last_name)  as count_last_name
from actor);

select @count_last_name;

#4, Which last names are not repeated
SELECT DISTINCT last_name 
from actor;




#5, which last names appear more than once
SELECT last_name, count(distinct first_name)
FROM actor
group by last_name
having COUNT(distinct first_name) > 1;

#6, which actor has appeared in the most films
set @max_film= (select count(film_actor.film_id) as c
from film_actor 
group by actor_id 
order by c desc
limit 1);

select @max_film;

select first_name, last_name, count(f.actor_id) from actor a
join film_actor f
on a.actor_id=f.actor_id
group by f.actor_id
having count(f.actor_id)=@max_film;




#7 Is 'Academy Dinosaur' available for rent from Store 1?
# Step 1: which copies are at Store 1?
# Step 2: pick an inventory_id to rent:

select distinct(inventory_id)
from film f inner join inventory i
using (film_id)
inner join rental
using (inventory_id)
where store_id=1 and f.title="academy dinosaur" and 
	inventory_id not in (select inventory_id from rental where return_date is null);


#8. Insert a record to represent Mary Smith renting 'Academy Dinosaur' from Mike Hillyer at Store 1 today .

select * from rental;
insert into rental (rental_date, inventory_id,customer_id,staff_id)
values(now(), 1,1,1);
    
#9. When is 'Academy Dinosaur' due?
 
-- Step 1: what is the rental duration?
-- Step 2: Which rental are we referring to -- the last one.
-- Step 3: add the rental duration to the rental date.
#我的思路： 
#   step 1: film table, find rental duration
#   step 2:找到rental中所有租借A- D-的record by using inventory_id 
#		怎么找到inventory_id？ 在inventory table里通过film_Id找
#   	怎么找到film_id?在film table里通过title找 
#		max rental date --> latest rental
#   step 3: 不会加

set @latest_rental=
(SELECT max(rental_date) as Latest_rental FROM RENTAL WHERE INVENTORY_ID	IN 
	(SELECT INVENTORY_ID FROM inventory where film_id=
		(select film_id from film where title='academy dinosaur')));
select @latest_rental;


set @rental_duration=
(Select rental_duration from film where title="academy dinosaur");
select @rental_duration;



#10. What is that average length of all the films in the sakila DB
#select avg(length) from film



#11. Which film categories are long? Long = lengh is longer than the average film length

set @average_length= 
(select avg(length) from film);
select @average_length;

select c.name, avg(length)
from film f 
inner join film_category fc
on fc.film_id=f.film_id
inner join category c
on c.category_id=fc.category_id
group by c.name
having avg(length) > @average_length;



############### PART 2 ########################

-- 1a. Display the first and last names of all actors from the table actor.
 SELECT first_name, last_name from actor;
 
 
-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
 SELECT concat(first_name, last_name) 
 AS Actor_name
 from actor;

 
-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe."
--  	What is one query would you use to obtain this information?
 
select actor_id, first_name, last_name from actor
where first_name='Joe';
 
-- 2b. Find all actors whose last name contain the letters GEN:
select * from actor
where last_name like "%GEN%";
 
 
-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
select * from actor
where last_name like "%LI%"
order by last_name, first_name;

 
-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
select country.country_id, country.country from country
where country.country in ('Afghanistan', 'Bangladesh', 'China');
 
 
-- 3a. Add a middle_name column to the table actor. Position it between first_name and last_name. Hint: you will need to specify the data type.


ALTER TABLE actor
ADD middle_name varchar(255);

 
 
-- 3b. You realize that some of these actors have tremendously long last names.
--  Change the data type of the middle_name column to blobs.
-- 问题。。。。
alter table actor
modify column middle_name blob;
 
 
 
-- 3c. Now delete the middle_name column.
 
alter table actor
drop column middle_name;
 
-- 4a. List the last names of actors, as well as how many actors have that last name.
 select last_name, count(actor_id) 
 from actor
 group by last_name;
 
 
-- 4b. List last names of actors and the number of actors who have that last name,
-- 	but only for names that are shared by at least two actors
 select last_name, count(actor_id) 
 from actor
 group by last_name
 having count(actor_id)>1;
 
 
 
-- 4c. Oh, no! The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS,
-- 	the name of Harpo's second cousin's husband's yoga teacher. Write a query to fix the record.

update actor
set first_name="HARPO"
where  first_name = 'groucho' and last_name="williams";
 
 
-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct
-- name after all!
-- In a single query, if the first name of the actor is currently HARPO,
-- change it to GROUCHO. Otherwise, change the first name to MUCHO GROUCHO, as that is exactly what
-- the actor will be with the grievous error. BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR
-- TO MUCHO GROUCHO, HOWEVER!
-- (Hint: update the record using a unique identifier.)

 
-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?


-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:

 #select stf.first_name, stf.last_name, addr.address
 #from staff stf
 #inner join address addr
 #on stf.address_id=addr.address_id 
 
 
-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
 select payment.staff_id , sum(payment.amount)
 from staff
 inner join payment
 using (staff_id)
where month(payment.payment_date)=5 and year(payment.payment_date)=2005
 group by payment.staff_id;
 
 
 
-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
 #select film.title as Film_name, count(film_actor.actor_id) as Number_of_actors
 #from film 
 #inner join film_actor
 #on film.film_id=film_actor.film_id
 #group by film.title;
 
 
-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
 #select film.title as Film_name, count(inventory.inventory_id) as Number_of_copies
 #from inventory
 #inner join film 
 #on inventory.film_id=film.film_id
 #group by film.title
 
 
 
-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer.
-- 	List the customers alphabetically by last name:
 #select c.customer_id, c.first_name, c.last_name, sum(p.amount) as Total_payment
 #from customer c
 #inner join payment p
 #on c.customer_id=p.customer_id
 #group by customer_id
 
 
 
 
-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence,
--  films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of
--  movies starting with the letters K and Q whose language is English.
 
 #select title 
 #from film 
 #where title like "K%" or title like "Q%" and language_id = (select language_id from language where name="English")
 
 
-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.
# select a.first_name, a.last_name
# from actor a
# inner join film_actor fa
# where a.actor_id=fa.actor_id and fa.film_id=(select film_id from film where film.title='Alone Trip')

 
 
 
-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and
-- 	email addresses of all Canadian customers.
-- 	Use joins to retrieve this information.
 
 #select c.first_name, c.last_name, c.email from customer c 
 #inner join address a
 #on c.address_id=a.address_id
 #where a.city_id in (select city_id from city where country_id= (select country_id from country where country='canada'))
 
-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion.
--  Identify all movies categorized as famiy films.
 
#solution 1 
#select title from film
#where film_id in 
# ( select film_id
#	from film_category
#	where category_id=(
#		select category_id from category where category.name='Family'))
 
 #solution 2
 
# select film.title from film where film.film_id in
#	(select fc.film_id
#	from film_category fc
#	inner join category c
#	on fc.category_id=c.category_id
#	where c.name='Family')
 
-- 7e. Display the most frequently rented movies in descending order.
# join两次 
 
# select f.title, count(i.inventory_id)  
# from rental r
# inner join inventory i
# on i.inventory_id=r.inventory_id
# inner join film f
# on f.film_id=i.film_id
# group by i.film_id
# order by count(i.inventory_id)  desc;
 
 
-- 7f. Write a query to display how much business, in dollars, each store brought in.
 # select store.store_id, sum(payment.amount) 
 # from payment 
 # inner join staff 
 # on staff.staff_id=payment.staff_id
 # inner join store
 # on store.store_id=staff.store_id
 # group by store.store_id
 
-- 7g. Write a query to display for each store its store ID, city, and country.
#select store.store_id, city.city,country.country
#from store
#inner join address
#on store.address_id=address.address_id
#inner join city
#on city.city_id=address.city_id
#inner join country
#on country.country_id=city.country_id;
 
 
-- 7h. List the top five genres in gross revenue in descending order.
-- (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
 
 select *
 from payment
 full join rental 
 on rental.rental_id=payment.rental_id 
 #inner join inventory
 #on inventory.inventory_id=rental.rental_id
 #inner join film_category
 #on film_category.film_id=inventory.inventory_id
 #inner join category
 #on category.category_id=film_category.category_id
 #group by category.name
 #order by count(payment.payment_id) desc;

 
 
-- 8a. In your new role as an executive, you would like to have an easy way of viewing
--  	the Top five genres by gross revenue. Use the solution from the problem above to create a view.
--  	If you haven't solved 7h, you can substitute another query to create a view.
  
-- 8b. How would you display the view that you created in 8a?
 
-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.


