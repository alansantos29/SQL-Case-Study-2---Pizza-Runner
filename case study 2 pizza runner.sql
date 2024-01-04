/*
Case Study #2 - Pizza Runner

This case study has LOTS of questions - they are broken up by area of focus including:

Pizza Metrics
Runner and Customer Experience
Ingredient Optimisation
Pricing and Ratings
Bonus DML Challenges (DML = Data Manipulation Language)
Each of the following case study questions can be answered using a single SQL statement.
*/


-- Access the database Pizza_runner that will be used for the challenge
USE pizza_runner;

-- Create the tables  

-- Runners Table
DROP TABLE IF EXISTS runners;
CREATE TABLE  runners (
	runner_id INTEGER,
	registration_date DATE
);


-- customer_orders  Table 
DROP TABLE IF EXISTS customer_orders  ;
CREATE TABLE customer_orders (
  order_id INTEGER,
  customer_id INTEGER,
  pizza_id INTEGER,
  exclusions VARCHAR(4),
  extras VARCHAR(4),
  order_time TIMESTAMP
);


-- runner_orders Table
DROP TABLE IF EXISTS runner_orders;
CREATE TABLE runner_orders (
  order_id INTEGER,
  runner_id INTEGER,
  pickup_time VARCHAR(19),
  distance VARCHAR(7),
  duration VARCHAR(10),
  cancellation VARCHAR(23)
);



-- pizza_names Table
DROP TABLE IF EXISTS pizza_names;
CREATE TABLE pizza_names (
  pizza_id INTEGER,
  pizza_name TEXT
);



-- pizza_recipes Table
DROP TABLE IF EXISTS pizza_recipes;
CREATE TABLE pizza_recipes (
  pizza_id INTEGER,
  toppings TEXT
);



-- pizza_toppings Table
DROP TABLE IF EXISTS pizza_toppings;
CREATE TABLE pizza_toppings (
  topping_id INTEGER,
  topping_name TEXT
);


-- Inserting data to the tables

INSERT INTO runners
  (runner_id, registration_date)
VALUES
  (1, '2021-01-01'),
  (2, '2021-01-03'),
  (3, '2021-01-08'),
  (4, '2021-01-15');
  
  
INSERT INTO customer_orders
  (order_id, customer_id, pizza_id, exclusions, extras, order_time)
VALUES
  ('1', '101', '1', '', '', '2020-01-01 18:05:02'),
  ('2', '101', '1', '', '', '2020-01-01 19:00:52'),
  ('3', '102', '1', '', '', '2020-01-02 23:51:23'),
  ('3', '102', '2', '', NULL, '2020-01-02 23:51:23'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '2', '4', '', '2020-01-04 13:23:46'),
  ('5', '104', '1', 'null', '1', '2020-01-08 21:00:29'),
  ('6', '101', '2', 'null', 'null', '2020-01-08 21:03:13'),
  ('7', '105', '2', 'null', '1', '2020-01-08 21:20:29'),
  ('8', '102', '1', 'null', 'null', '2020-01-09 23:54:33'),
  ('9', '103', '1', '4', '1, 5', '2020-01-10 11:22:59'),
  ('10', '104', '1', 'null', 'null', '2020-01-11 18:34:49'),
  ('10', '104', '1', '2, 6', '1, 4', '2020-01-11 18:34:49');
  
  
  INSERT INTO runner_orders
  (order_id, runner_id, pickup_time, distance, duration, cancellation)
VALUES
  ('1', '1', '2020-01-01 18:15:34', '20km', '32 minutes', ''),
  ('2', '1', '2020-01-01 19:10:54', '20km', '27 minutes', ''),
  ('3', '1', '2020-01-03 00:12:37', '13.4km', '20 mins', NULL),
  ('4', '2', '2020-01-04 13:53:03', '23.4', '40', NULL),
  ('5', '3', '2020-01-08 21:10:57', '10', '15', NULL),
  ('6', '3', 'null', 'null', 'null', 'Restaurant Cancellation'),
  ('7', '2', '2020-01-08 21:30:45', '25km', '25mins', 'null'),
  ('8', '2', '2020-01-10 00:15:02', '23.4 km', '15 minute', 'null'),
  ('9', '2', 'null', 'null', 'null', 'Customer Cancellation'),
  ('10', '1', '2020-01-11 18:50:20', '10km', '10minutes', 'null');
  
  
  
  INSERT INTO pizza_names
  (pizza_id, pizza_name)
VALUES
  (1, 'Meatlovers'),
  (2, 'Vegetarian');



INSERT INTO pizza_recipes
  (pizza_id, toppings)
VALUES
  (1, '1, 2, 3, 4, 5, 6, 8, 10'),
  (2, '4, 6, 7, 9, 11, 12');
  
  

INSERT INTO pizza_toppings
  (topping_id, topping_name)
VALUES
  (1, 'Bacon'),
  (2, 'BBQ Sauce'),
  (3, 'Beef'),
  (4, 'Cheese'),
  (5, 'Chicken'),
  (6, 'Mushrooms'),
  (7, 'Onions'),
  (8, 'Pepperoni'),
  (9, 'Peppers'),
  (10, 'Salami'),
  (11, 'Tomatoes'),
  (12, 'Tomato Sauce');
  
  
  
  
  /*A. Pizza Metrics
1. How many pizzas were ordered?
  */

	SELECT
		COUNT(customer_orders.order_id)
  
	FROM
		customer_orders;
        
-- 2.How many unique customer orders were made?
	
  SELECT
		COUNT( DISTINCT customer_orders.order_id)
  
	FROM
		customer_orders;
	
    
-- 3.ow many successful orders were delivered by each runner?
	
    SELECT
		runner_orders.runner_id,
        COUNT( DISTINCT runner_orders.order_id) AS orders_made
    FROM
		runner_orders
	
    WHERE 
		cancellation NOT LIKE 'Restaurant Cancellation' OR 'Customer Cancellation'
	
    GROUP BY
		runner_orders.runner_id;
        
        
-- 4.How many of each type of pizza was delivered?
    
WITH DETAILS AS (
    SELECT
		pizza_names.pizza_name,
        SUM(runner_orders.order_id) OVER (PARTITION BY pizza_names.pizza_name ) AS TOTAL_ORDERS
        
    FROM 
		pizza_names
        
    INNER JOIN customer_orders ON pizza_names.pizza_id = customer_orders.pizza_id
    INNER JOIN runner_orders ON  runner_orders.order_id = customer_orders.order_id
    
    WHERE
		runner_orders.cancellation NOT LIKE 'Restaurant Cancellation' OR 'Customer Cancellation'
	
    GROUP BY
    
		pizza_names.pizza_name,
        runner_orders.order_id
)

SELECT 
 DISTINCT pizza_name,
 TOTAL_ORDERS
FROM 
	DETAILS;
    
    
-- 5.How many Vegetarian and Meatlovers were ordered by each customer?
WITH DETAILS AS (
    SELECT
		pizza_names.pizza_name,
        SUM(runner_orders.order_id) OVER (PARTITION BY pizza_names.pizza_name ) AS TOTAL_ORDERS
        
    FROM 
		pizza_names
        
    INNER JOIN customer_orders ON pizza_names.pizza_id = customer_orders.pizza_id
    INNER JOIN runner_orders ON  runner_orders.order_id = customer_orders.order_id
    
    WHERE
		runner_orders.cancellation NOT LIKE 'Restaurant Cancellation' OR 'Customer Cancellation'
        
    GROUP BY
    
		pizza_names.pizza_name,
        runner_orders.order_id
)

SELECT 
 DISTINCT pizza_name,
 TOTAL_ORDERS
FROM 
	DETAILS;
    
    
    
-- 6. What was the maximum number of pizzas delivered in a single order?
WITH ORDERS AS(
    SELECT
		runner_orders.runner_id,
        runner_orders.pickup_time,
        runner_orders.duration,
        runner_orders.distance,
        count(*) AS NUMBER_OF_ORDERS
        
    FROM 
		runner_orders
        
	WHERE 
		runner_orders.cancellation NOT LIKE 'Restaurant Cancellation' OR 'Customer Cancellation'
        
	GROUP BY
		runner_orders.runner_id,
		runner_orders.pickup_time,
        runner_orders.duration,
        runner_orders.distance
        
)

SELECT
	MAX(NUMBER_OF_ORDERS)

FROM
	ORDERS;
   
    
    -- 7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
    
    SELECT
		customer_orders.customer_id,
        COUNT((customer_orders.exclusions OR customer_orders.extras) LIKE ' ' OR NULL) AS  NO_CHANGE,
        COUNT((customer_orders.exclusions OR customer_orders.extras)) IS NOT NULL AS CHANGES
        
		
    FROM 
		customer_orders
    INNER JOIN  runner_orders   ON  customer_orders.order_id = runner_orders.order_id
    
    WHERE
		runner_orders.cancellation NOT LIKE 'Restaurant Cancellation' OR 'Customer Cancellation'
        
    
    GROUP BY
		customer_orders.customer_id;
  

       
       
-- 8. How many pizzas were delivered that had both exclusions and extras?

    SELECT
		COUNT(*) AS PIZZA_DELIVERED_WITH_EXTRA_AND_EXCLUSIONS
    FROM 
		customer_orders
    INNER JOIN  runner_orders   ON  customer_orders.order_id = runner_orders.order_id
    
    WHERE
		runner_orders.cancellation NOT LIKE 'Restaurant Cancellation' AND 
        runner_orders.cancellation NOT LIKE 'Customer Cancellation' AND 
        customer_orders.extras IS NULL AND
        customer_orders.extras NOT LIKE ''AND 
        customer_orders.exclusions IS NULL AND
        customer_orders.exclusions NOT LIKE '';



-- 9. What was the total volume of pizzas ordered for each hour of the day?

	SELECT
		HOUR(customer_orders.order_time) AS Hours,
        COUNT(*)
    
    FROM
		customer_orders
	
    GROUP BY
		Hours;
    
  
  -- 10. What was the volume of orders for each day of the week?
  SELECT
		DAYNAME(customer_orders.order_time) AS DAYOFTHEWEEK,
        COUNT(*)
    
    FROM
		customer_orders
	
    GROUP BY
		DAYOFTHEWEEK;
        

/* 									B. Runner and Customer Experience
1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)                */
	
    
   SELECT
    TIMESTAMPDIFF(WEEK, '2021-01-01', runners.registration_date) + 1 AS WEEK_NUMBER,
    COUNT(*) AS number_of_runners
FROM
    runners
GROUP BY
    WEEK_NUMBER;
    
    
-- 2.What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
WITH AVGTIME AS (
	SELECT
		runner_orders.runner_id,
		TIMESTAMPDIFF(MINUTE,customer_orders.order_time,runner_orders.pickup_time) AS TIME_DIFFERENCE
        
    FROM 
		runner_orders
        
	INNER JOIN customer_orders  ON  runner_orders.order_id = customer_orders.order_id
)
	SELECT
		runner_id,
        AVG(TIME_DIFFERENCE)
    FROM 
		AVGTIME
    
    GROUP BY
		runner_id;
		
        
        
	-- 3. Is there any relationship between the number of pizzas and how long the order takes to prepare?
		-- AVG TIME PER PIZZA TYPE
WITH AVGTIME_PIZZA AS (        
	SELECT
		customer_orders.pizza_id,
		TIMESTAMPDIFF(MINUTE,customer_orders.order_time,runner_orders.pickup_time) AS TIME_DIFFERENCE
        
    FROM 
		runner_orders
        
	INNER JOIN customer_orders  ON  runner_orders.order_id = customer_orders.order_id
)

SELECT
		pizza_id,
        TIME_DIFFERENCE,
        COUNT(*) AS OCCURRENCE_COUNT
    FROM 
		AVGTIME_PIZZA
    
    GROUP BY
		pizza_id,
        TIME_DIFFERENCE
	
    ORDER BY
    1,3,2;

    
/*                                                                               
Answer: No apparent relation
*/
    
    
    
    
-- 4.What was the average distance travelled for each customer?
	
WITH DISTANCE AS(
    SELECT
		customer_orders.customer_id,
        CAST(SUBSTRING_INDEX(runner_orders.distance, 'km',1) AS SIGNED) AS EXTRACTED_KM
        
    FROM 
		runner_orders
        
	INNER JOIN customer_orders  ON  runner_orders.order_id = customer_orders.order_id
    )
    
SELECT
	customer_id,
    AVG(EXTRACTED_KM)

FROM
	DISTANCE

GROUP BY
	customer_id;
    
    
    
-- 5. What was the difference between the longest and shortest delivery times for all orders?

WITH DISTANCE AS(
    SELECT
		customer_orders.customer_id,
		AVG(CAST(SUBSTRING_INDEX(runner_orders.distance, 'km',1) AS SIGNED)) AS AVG_KM
        
        
    FROM 
		runner_orders
        
	INNER JOIN customer_orders  ON  runner_orders.order_id = customer_orders.order_id
    
    GROUP BY
		customer_orders.customer_id
    )
    
SELECT
	(MAX(AVG_KM) - MIN(AVG_KM)) AS DIFERRENCE

FROM
	DISTANCE;



-- 6. What was the average speed for each runner for each delivery and do you notice any trend for these values?
WITH SPEED AS (	
    SELECT
		runner_orders.runner_id,
		customer_orders.order_time, 
		runner_orders.pickup_time,
        TIMESTAMPDIFF(SECOND,customer_orders.order_time,runner_orders.pickup_time) AS SECONDS,
        (CAST(SUBSTRING_INDEX(runner_orders.distance, 'km',1)AS SIGNED) *1000) AS METRES
        
    
    FROM 
		runner_orders
        
	INNER JOIN customer_orders ON runner_orders.order_id = customer_orders.order_id
    )
    
    SELECT
		runner_id,
      AVG(METRES/SECONDS) AS METRES_PER_SECONDS
    
    FROM
		SPEED
    GROUP BY
    	runner_id;
	
-- 7. What is the successful delivery percentage for each runner?
	
 SELECT 
    runner_id,
    COUNT(order_id) AS total_orders,
    SUM(CASE WHEN cancellation NOT LIKE 'Restaurant Cancellation' AND cancellation NOT LIKE 'Customer Cancellation' THEN 1 ELSE 0 END) AS successful_deliveries,
    (SUM(CASE WHEN cancellation NOT LIKE 'Restaurant Cancellation' AND cancellation NOT LIKE 'Customer Cancellation' THEN 1 ELSE 0 END) / COUNT(order_id)) * 100 AS delivery_percentage
FROM 
    runner_orders
GROUP BY 
    runner_id;
        
    
    
/*     
													C. Ingredient Optimisation
1.What are the standard ingredients for each pizza?
*/
	SELECT
    pizza_names.pizza_name,
    GROUP_CONCAT(pizza_toppings.topping_name ORDER BY pizza_toppings.topping_id) AS STANDARD_INGREDIENTS
FROM
    pizza_names
LEFT JOIN
    pizza_recipes ON pizza_names.pizza_id = pizza_recipes.pizza_id
LEFT JOIN
    pizza_toppings ON pizza_recipes.toppings = pizza_toppings.topping_id
GROUP BY
    pizza_names.pizza_name;
    
    
    
-- 2. What was the most commonly added extra?    
    
 SELECT
    pizza_name,
    SUBSTRING_INDEX(
        SUBSTRING_INDEX(
            GROUP_CONCAT(extras ORDER BY extras_count DESC),
            ',',
            1
        ),
        ',',
        -1
    ) AS most_common_extra
FROM (
    SELECT
        pizza_names.pizza_name,
        customer_orders.extras,
        COUNT(*) AS extras_count
    FROM
        pizza_names
    LEFT JOIN customer_orders ON pizza_names.pizza_id = customer_orders.pizza_id
    WHERE
        customer_orders.extras  NOT LIKE "null" AND customer_orders.extras != ''
    GROUP BY
        pizza_names.pizza_name, customer_orders.extras
) AS subquery
GROUP BY
    pizza_name;
   
   
-- 3.What was the most common exclusion?

	SELECT 
		pizza_name,
      SUBSTRING_INDEX(  
       SUBSTRING_INDEX( GROUP_CONCAT(exclusions ORDER BY exclusion_count DESC) ,
				",", 1),
                
                ",", -1
                
                )AS Most_Common_Exclusion
                
	FROM ( SELECT
		pizza_names.pizza_name,
        customer_orders.exclusions,
        COUNT(*) AS exclusion_count
    
    FROM
		customer_orders
    
    LEFT JOIN  pizza_names  ON customer_orders.pizza_id = pizza_names.pizza_id
    
    WHERE
		customer_orders.exclusions NOT LIKE "null" AND customer_orders.exclusions NOT LIKE ""
	
    GROUP BY
		pizza_names.pizza_name,
        customer_orders.exclusions
        ) AS subquery
	GROUP BY pizza_name;
	

   
   /* 4.  Generate an order item for each record in the customers_orders table in the format of one of the following:
Meat Lovers
Meat Lovers - Exclude Beef
Meat Lovers - Extra Bacon
Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers  */ 
 
    SELECT 
		pizza_names.pizza_name,
        CONCAT_WS(
					'-',
                   -- Name of the pizza 
				pizza_names.pizza_name,
				
                -- The Exclusion
                IF (customer_orders.exclusions NOT LIKE 'null' AND customer_orders.exclusions NOT LIKE '', 
					CONCAT('Exclude ', GROUP_CONCAT(pizza_toppings.topping_name, ',')), 
                    NULL),
        
				
                 -- The Extras
                IF (customer_orders.extras NOT LIKE 'null' AND customer_orders.exclusions NOT LIKE '', 
					CONCAT('Exclude ', GROUP_CONCAT(pizza_toppings.topping_name, ',')), 
                    NULL)
        ) AS order_item
        
        FROM 
			customer_orders
            
		LEFT JOIN pizza_names ON customer_orders.pizza_id = pizza_names.pizza_id
		LEFT JOIN pizza_recipes ON customer_orders.pizza_id = pizza_recipes.pizza_id
		LEFT JOIN pizza_toppings ON FIND_IN_SET(pizza_toppings.topping_id, pizza_recipes.toppings)
		GROUP BY pizza_names.pizza_name, customer_orders.order_id, customer_orders.exclusions, customer_orders.extras;
		



/*

5.Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table
 and add a 2x in front of any relevant ingredients
For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"

*/
  SELECT 
    pizza_names.pizza_name,
    CONCAT_WS(
        '-',
        pizza_names.pizza_name,
        -- The Exclusion
        IF (customer_orders.exclusions IS NOT NULL AND customer_orders.exclusions <> 'null', 
            CONCAT('Exclude ', GROUP_CONCAT(pizza_toppings.topping_name ORDER BY pizza_toppings.topping_name SEPARATOR ', ')), 
            NULL),
        -- The Extras
        IF (customer_orders.extras IS NOT NULL AND customer_orders.extras <> 'null', 
            CONCAT('Extra ', GROUP_CONCAT(CONCAT('2x ', pizza_toppings.topping_name) ORDER BY pizza_toppings.topping_name SEPARATOR ', ')), 
            NULL)
    ) AS order_item
FROM 
    customer_orders
LEFT JOIN pizza_names ON customer_orders.pizza_id = pizza_names.pizza_id
LEFT JOIN pizza_recipes ON customer_orders.pizza_id = pizza_recipes.pizza_id
LEFT JOIN pizza_toppings ON FIND_IN_SET(pizza_toppings.topping_id, pizza_recipes.toppings)
GROUP BY pizza_names.pizza_name, customer_orders.order_id, customer_orders.exclusions, customer_orders.extras;

   

-- 6.What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?

   SELECT
    pizza_toppings.topping_name,
    COUNT(*) AS total_quantity
FROM
    customer_orders
JOIN pizza_names ON customer_orders.pizza_id = pizza_names.pizza_id
JOIN pizza_recipes ON customer_orders.pizza_id = pizza_recipes.pizza_id
JOIN pizza_toppings ON FIND_IN_SET(pizza_toppings.topping_id, pizza_recipes.toppings)
JOIN runner_orders ON customer_orders.order_id = runner_orders.order_id
WHERE
   runner_orders.cancellation NOT LIKE 'Restaurant Cancellation' AND runner_orders.cancellation NOT LIKE 'Customer Cancellation'
GROUP BY
    pizza_toppings.topping_name
ORDER BY
    total_quantity DESC;

   
   /*
   
												D. Pricing and Ratings
                                                
1.If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes 
- how much money has Pizza Runner made so far if there are no delivery fees?
   
   */
   
SELECT
	pizza_names.pizza_name,
    SUM(CASE WHEN pizza_names.pizza_name = 'MeatLovers' THEN 12
             WHEN pizza_names.pizza_name = 'Vegetarian' THEN 10
             ELSE 0 END) AS total_revenue
FROM
    customer_orders
JOIN pizza_names ON customer_orders.pizza_id = pizza_names.pizza_id
GROUP BY pizza_names.pizza_name;

   
   
 
-- 2.What if there was an additional $1 charge for any pizza extras? Add cheese is $1 extra
   
  SELECT
	pizza_names.pizza_name,
    SUM(CASE WHEN pizza_names.pizza_name = 'MeatLovers' THEN 12
             WHEN pizza_names.pizza_name = 'Vegetarian' THEN 10
             ELSE 0 END) +
             SUM(CASE WHEN customer_orders.extras = '4' THEN 2
					  WHEN customer_orders.extras NOT LIKE "null" AND customer_orders.extras NOT LIKE "" THEN 1 
                      ELSE 0 END)AS total_revenue
FROM
    customer_orders
JOIN pizza_names ON customer_orders.pizza_id = pizza_names.pizza_id
GROUP BY pizza_names.pizza_name;
   
 
 
 /* 3. The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, 
 how would you design an additional table for this new dataset - generate a schema for this new table and insert your own data for ratings
 for each successful customer order between 1 to 5. */
   
   -- Creating the table
   CREATE TABLE order_ratings (
	rating_id integer,
    order_id integer,
    runner_id integer,
    customer_id integer,
    rating integer CHECK (rating >= 1 and rating <= 5),
    comment text,
    rating_date timestamp default current_timestamp
    );
   
 -- filling up the table
	INSERT INTO order_ratings (rating_id, order_id, runner_id, customer_id, rating, comment)
VALUES
    (1, 1, 1, 101, 4, 'Great service!'),
    (2, 2, 1, 101, 5, 'Prompt delivery')
    -- Add more sample to the order_ratings.
    ;
    
    
/*
4.Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?
customer_id
order_id
runner_id
rating
order_time
pickup_time
Time between order and pickup
Delivery duration
Average speed
Total number of pizzas
*/


-- Create the combined_deliveries table
CREATE TABLE combined_deliveries (
    customer_id integer,
    order_id integer,
    runner_id integer,
    rating integer,
    order_time timestamp,
    pickup_time timestamp,
    time_between_order_and_pickup time,
    delivery_duration varchar(10),
    average_speed decimal(10, 2),
    total_pizzas integer
);

-- Insert data into the combined_deliveries table
INSERT INTO combined_deliveries
SELECT
    customer_orders.customer_id,
    customer_orders.order_id,
    runner_orders.runner_id,
    ratings.rating,
    customer_orders.order_time,
    runner_orders.pickup_time,
    TIMEDIFF(runner_orders.pickup_time, customer_orders.order_time) AS time_between_order_and_pickup,
    runner_orders.duration AS delivery_duration,
    runner_orders.distance / TIME_TO_SEC(runner_orders.duration) AS average_speed,
    (SELECT COUNT(*) FROM customer_orders WHERE order_id = customer_orders.order_id) AS total_pizzas
FROM
    customer_orders
JOIN
    runner_orders  ON customer_orders.order_id = runner_orders.order_id
JOIN
    ratings  ON customer_orders.order_id = ratings.order_id;


   
   /*
   5.If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and 
   each runner is paid $0.30 per kilometre traveled 
   - how much money does Pizza Runner have left over after these deliveries?   
   */
   
   
   -- Constants
SET @meatLoversPrice = 12; -- Fixed price for Meat Lovers pizza
SET @vegetarianPrice = 10; -- Fixed price for Vegetarian pizza
SET @runnerPaymentRate = 0.30; -- Runner payment rate per kilometer
   
   
   -- Calculate revenue from pizza sales
SET @pizzaRevenue = (
    SELECT 
        SUM(
            CASE 
                WHEN pizza_id = 1 THEN @meatLoversPrice
                WHEN pizza_id = 2 THEN @vegetarianPrice
                ELSE 0
            END
        ) AS totalRevenue
    FROM customer_orders
);

-- Calculate expenses for runner payments
SET @runnerExpenses = (
    SELECT
        SUM(distance) * @runnerPaymentRate AS totalExpenses
    FROM runner_orders
);

-- Calculate the money left over
SET @moneyLeftOver = @pizzaRevenue - @runnerExpenses;

-- Display the results
SELECT
    @pizzaRevenue AS totalPizzaRevenue,
    @runnerExpenses AS totalRunnerExpenses,
    @moneyLeftOver AS moneyLeftOver;

   
 
 /*
													E. Bonus Questions
If Danny wants to expand his range of pizzas - how would this impact the existing data design? 
Write an INSERT statement to demonstrate what would happen if a new Supreme pizza with 
all the toppings was added to the Pizza Runner menu?
*/


-- 1. Add the Supreme pizza to pizza_names table
INSERT INTO pizza_names (pizza_id, pizza_name)
VALUES (3, 'Supreme');

-- 2. Add the toppings for Supreme pizza to pizza_recipes table
INSERT INTO pizza_recipes (pizza_id, toppings)
VALUES (3, '1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12');

-- 3. Add the topping names to pizza_toppings table
INSERT INTO pizza_toppings (topping_id, topping_name)
VALUES
  (13, 'Ham'),
  (14, 'Olives'),
  (15, 'Green Peppers'),
  (16, 'Mushrooms'),
  (17, 'Onions'),
  (18, 'Pepperoni'),
  (19, 'Sausage'),
  (20, 'Bacon'),
  (21, 'Tomatoes'),
  (22, 'BBQ Sauce'),
  (23, 'Cheese'),
  (24, 'Tomato Sauce');




