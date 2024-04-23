-- So let's break our functions into parts: we want to have a customer's information like firstname + surname, email
-- Numbers of films rented
-- Comma-separated list of rented films - so, here i hope it will be easier to use group_concat
-- Total number of payments made during this timeframe (left_boundary and right_boundary)
-- Total amount paid during this time period.

create or replace function report_customer( -- so, here we creating our function or just replace (duplicate)
client_id int, -- by our requirement, we need client_id
left_boundary date, -- and left boundary
right_boundary date -- also right one
)
-- so here we will use concept like: metric_name and it's value, for that we will create 2 metrics (variables)
returns table(
metric_name text,
metric_value text
) -- our variables
as $$ 
declare film_titles text; -- so we also need to declare this variable, because we need to manipulate with name of films, to make it in view that there will be separated with commas
begin -- start our function
	-- start here our first query Customer's name, surname and email address
	metric_name := 'customer''s info'; -- the name of our metric
	select into metric_value first_name || ' ' || last_name || ', ' || email -- concatenate customer information
	from customer
	where customer_id = report_customer.client_id; -- so here by condition we will find a customer, which is indicated in our function
	return next; -- so here we return our result and go to the next query
	
	-- start second query Number of films rented
	metric_name := 'num. of films rented';
	select into metric_value count(*)::text -- count the number of rentals, but WARNING, our metric_value: text, but aggregate function count make numeric one, so we should convert it
    from rental 
    where customer_id = report_customer.client_id -- so by condition we search for the rentals for this client
    and rental_date between report_customer.left_boundary and report_customer.right_boundary; -- our second condition with the timeframe
    return next;
   
    -- start third query Comma-separated list. Yey, we will try to use here group_concat function
	metric_name := 'rented films'' titles';
    select into film_titles group_concat(f.title) -- so if we need to comma-separated, we can use group_concat here, and!! this also take null values, so at the end we will connect it into our metric_value
    from rental r
    inner join inventory inv on r.inventory_id = inv.inventory_id -- go through the inventory to the film
    inner join film f on inv.film_id = f.film_id
    where r.customer_id = report_customer.client_id -- first condition
    and r.rental_date between report_customer.left_boundary and report_customer.right_boundary; -- second one
    metric_value := film_titles; -- assign our big list of our films
    return next;
   
    -- start our fourth query Number of payments
    metric_name := 'num. of payments';
    select into metric_value count(*)::text -- text, because our aggregate function give as numeric
    from payment -- so we need number of payments, thats why we need to go to the payment
    where customer_id = report_customer.client_id
    and payment_date between report_customer.left_boundary and report_customer.right_boundary;
    return next;
   
    -- start our fifth query Payments amount
    metric_name := 'payments'' amount';
    select into metric_value sum(amount)::text -- the same situation about aggregate functions
    from payment
    where customer_id = report_customer.client_id
    and payment_date between report_customer.left_boundary and report_customer.right_boundary;
    return next;
end;
$$ language plpgsql; -- write in pl/pgsql

-- example of use
select * from report_customer(15, '2016-05-12', '2017-05-12')
