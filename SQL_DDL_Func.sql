create or replace view sales_revenue_by_category_qtr as -- create or replace, to ensure that there will be no duplicate view
select cat.name as category_name, sum(pay.amount) as total_revenue -- so we will select only that information that we need by requirement
  from category cat -- we will start from category -> film_category -> film -> inventory -> rental -> payment
 inner join film_category fcat on cat.category_id = fcat.category_id
 inner join film f on fcat.film_id = f.film_id
 inner join inventory inv on f.film_id = inv.film_id -- we have access for film and rental because of inventory
 inner join rental ren on inv.inventory_id = ren.inventory_id
 inner join payment pay on ren.rental_id = pay.rental_id
 where extract(year from pay.payment_date) = extract(year from current_date) -- so, because of this condition -> it will be always check the current month and next step qurter
   and extract(quarter from pay.payment_date) = extract(quarter from current_date)
 group by cat.category_id
having sum(pay.amount) > 0; -- we must see only that revenue, that have at least 1 payment (which mean >0)

select * from sales_revenue_by_category_qtr
 where category_name = 'Horror'; -- example of using

select *
  from category; -- to find a correct category_name

select count(*) from payment  -- to ensure that code is correct and there no payments for 2024
 where extract(quarter from payment_date) = extract(quarter from current_date)
   and extract(year from payment_date) = extract(year from current_date);
  
select *
  from payment;
  
 -- So here we will make some correction to the view sales_revenue_by_category_qtr - and make something more dinamic
 
 create or replace function get_sales_revenue_by_category_qtr(quarter integer, year integer) -- to ensure that there no duplicates. types integer
returns table(category_name text, total_revenue numeric) as $$ -- if there will be some of decimal payments like 1.22$ we will give a type numeric, and string text category_name
  begin return query -- open block part of the function, execute a query
 select cat.name as category_name, sum(pay.amount) as total_revenue -- the same as in view
   from category cat
  inner join film_category fcat on cat.category_id = fcat.category_id
  inner join film f on fcat.film_id = f.film_id
  inner join inventory inv on f.film_id = inv.film_id -- we have access for film and rental because of inventory
  inner join rental ren on inv.inventory_id = ren.inventory_id
  inner join payment pay on ren.rental_id = pay.rental_id
  where extract(quarter from pay.payment_date) = quarter -- to equal to the quarter that we inputed
    and extract(year from pay.payment_date) = year -- to equal to the year
  group by cat.category_id
 having sum(pay.amount) > 0; -- we must see only that revenue, that have at least 1 payment (which mean >0)
   end; -- close block part of the function
 $$ language plpgsql stable; -- function is written in the PL/pgSQL, stable because of payments that was in the past quarter and typically will not changed
 
 select * from get_sales_revenue_by_category_qtr(1, 2017); -- we will try this function, to ensure that all work.
 
 
 /*
  * Way of joins to the country: country -> city -> address -> customer -> rental -> inventory -> film -> language, 
  * So we here want to go through the customer, because we need from it, country, where he rented the film, to count rentals and then choose one of it.
  */

create or replace function most_popular_films_by_countries(country_names text[]) -- creation of the function that wait for the array by text[]
returns table(country text, film text, rating text, language text, length int, release_year int) as $$ -- we are waiting for the table in result, and declare types what we are waiting for
declare countries text; -- declare the varuable, which will be for our loop function, that will retrieve all country names from our array
begin for countries in select unnest(country_names) -- unnest, to break array into the parts (1 country name)
loop -- begin our loop here
	return query -- waiting for result set
	select c.country, f.title, f.rating::text, l.name::text, f.length::int, f.release_year::int -- i had some of problems with types, so we will transfer it into the types, that we want to see
	from country c -- start from the country
	inner join city ct on ct.country_id = c.country_id  -- go to the city
	inner join address ad on ad.city_id = ct.city_id -- to the address
	inner join customer cst on cst.address_id = ad.address_id -- to the customer, because we want addresses and countries from the customer
	inner join rental r on r.customer_id = cst.customer_id -- go to the rental, to count it
	inner join inventory inv on inv.inventory_id = r.inventory_id -- go to the invenory, because we need films
	inner join film f on f.film_id = inv.film_id -- go to the film
	inner join language l on f.language_id = l.language_id -- and to the language
	where c.country = countries -- so here the condition, that it must be in array of our countries
	group by c.country, f.title, f.rating, l.name, f.length, f.release_year -- grouping it with the all of attributes from select
	order by c.country, count(r.rental_id) desc -- here we order it in descending order, to retrieve top-1 film by rentals
	limit 1; -- limit it, because we need only top-1
end loop; -- end our loop here
end; -- end of our function
$$ language plpgsql; -- our language, procedure language
	

select *
from most_popular_films_by_countries(array['Afghanistan', 'Brazil', 'United States']); 

-- Task 4. Create procedure language functions
/* Create a function that generates a list of movies available in stock based on a partial title match (e.g., movies containing the word 'love' in their title).
 * The titles of these movies are formatted as '%...%', and if a movie with the specified title is not in stock, return a message indicating that it was not found.
 * The function should produce the result set in the following format (note: the 'row_num' field is an automatically generated counter field, starting from 1 and incrementing for each entry, e.g., 1, 2, ..., 100, 101, ...).
 * 
 * Query (example):select * from core.films_in_stock_by_title('%love%’);
 */

create or replace function films_in_stock_by_title(part_title text) -- so create function with text input
returns table(row_num int, film_title text, language text, customer_name text, rental_date timestamp) as $$ -- what we are expecting
begin
	if not exists ( -- so firstly let's try to find such movie and check in stock inventory
	select 1 -- select only 1, because we need only one row to ensure that it exists.
	from film f
	inner join inventory inv on inv.film_id = f.film_id
	where f.title ilike '%' || part_title || '%' and inventory_in_stock(inv.inventory_id) -- here we use function inventory_in_stock which gave us true or false value, if this film available in stock
	) then 
	raise notice 'No movies with the title found in stock.'; -- raise a notice, that there no such movie in stock
	return; -- exit the function
	end if;
	
	return query -- start our function, return set of results
select distinct on (f.title) cast(row_number() over (order by f.title) as int) as row_num, f.title as film_title, l.name::text as language, -- im not sure, if we want distinct select here or no, but we see, if there duplicates we will see it with the row_number, so we need cast it into type of int row_numb
(c.first_name || ' ' || c.last_name) as customer_name, r.rental_date::timestamp -- also we need customer name as name and surname, and make rental_date into timestamp type
from film f -- so we will start from film
inner join language l on f.language_id = l.language_id -- go to the language
inner join inventory inv on inv.film_id = f.film_id -- to the inventory
inner join rental r on r.inventory_id = inv.inventory_id -- then to the rental
inner join customer c on r.customer_id = c.customer_id -- and customer, for name
where f.title ilike '%' || part_title || '%' and exists (select 1 from inventory where film_id = f.film_id) -- so here condtion that we need particular film of the part of it and see, if some of it in the inventory table or no
order by f.title; -- sort it by the title
end; -- end our function
$$ language plpgsql; -- procedure language 

select * 
from films_in_stock_by_title('%asdasdsa%');

-- So, in the function we need to 1) check if the language is in our table exist,
-- if not - make as default, and the release_year by the default current_date (extract year)
-- because our function is not give as a result a row -> we will use returns void

-- Make a default language in our language table
-- So in this case I would give creating default language not in function, but out of it - to use raise exception
insert into language (name)
values ('Klingon')
returning *;

create or replace function new_movie(movie_title text, release_year int default extract(year from current_date)::int, language_name text default 'Klingon') -- so we need 3 attributes by requirement
returns void as $$ -- returns void, because we don't except of some result
declare 
actual_language_id int; -- it will be for language
new_film_id int; -- it will be for raising a notice, that it was successfully added
begin -- start our function
	select language_id into actual_language_id from language  -- tring to find a language, if it was inputed
	where name = language_name;

    if actual_language_id is null then -- if not, we will change it to the default Klingon, but firstly we should find it
	select language_id into actual_language_id from language where name = 'Klingon';
      if actual_language_id is null then -- if there no such language as Klingon - so raise an exception, that it cannot be found
      raise exception 'Default language Klingon does not exist.';
     end if; -- end our second if function
end if; -- end our first if function

insert into film(title, release_year, language_id, rental_rate, rental_duration, replacement_cost) -- inserting our data
values (movie_title, release_year, actual_language_id, 4.99, 3, 19.99) -- by default some of attributes have already values like rental_rate, rental_duration, replacement_cost
returning film_id into new_film_id;

raise notice 'New movie created successfully with film_id: %', new_film_id; -- notice that all done successfully

end;
$$ language plpgsql;

-- Examples of execute
SELECT new_movie('Movie Title');
SELECT new_movie('Movie Title', 2023, 'English');
