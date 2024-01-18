		--------------------------------------------------
		-- Exercise 5.4. Write the following queries
		--					using the database JARDINERIA
		--------------------------------------------------

				--------------------------
				--		QUERIES		    --
				--------------------------

---------------------------------------
-- A) Queries using a single table (17) --
---------------------------------------

-- 1. Return a list with the office code and the city where there are offices.
--SELECT ;

-- 2. Return a list with the city and the telephone number of the offices in Spain.
--SELECT ;

-- 3. Return a list with the first name, last name, and email of employees whose boss has a boss code equal to 7.
--SELECT ;

-- 4. Return the name of the position, name, surname and email of the head of the company (jefe). Tip: You will recognise the boss because it does not have a boss.
--SELECT ;

-- 5. Return a list with the name, surname and post of those employees who are not sales representatives (remember that the != operator is not SQL standard and should not be used).
--SELECT ;

-- 6. Return a list with the name of every Spanish clients.
--SELECT ;

-- 7. Return a list with the different states through which an order can pass (without repeating them).
--SELECT ;

-- 8. Return a list with the customer code of those customers who made a payment in 2023. Please note that you will need to remove repeat customer codes.
--SELECT ;

-- 9. Return a listing with the order code, customer code, expected date and delivery date of orders that have not been delivered on time.
--SELECT ;

-- 10. Return a list with the order code, customer code, expected date and delivery date of orders whose delivery date has been at least two days before the expected date.
--     Using the DATEADD function
--SELECT ;

-- 11. Same query, but using the DATEDIFF function
--SELECT ;

-- 12. Return a list of all orders that were rejected (rechazados) in 2022
--SELECT ;

-- 13. Return a list of all orders that have been delivered in the month of January of any year
--SELECT ;

-- 14. Return a list of all payments made in 2022 using ‘PayPal’. Sort the result from highest to lowest price (de mayor a menor)
--SELECT ;

-- 15. Return a list of all the payment methods that appear in the payment table. Please note that repeated payment methods should not appear.
--SELECT ;

-- 16. Return a list with all the products that belong to the ‘Ornamentales’ category and that have more than 100 units in stock.
-- NOTE: The list must be sorted by its sale price, showing first the highest price.
--SELECT ;

-- 17. Return a list with all customers who are from the city of Madrid and whose sales representative has the employee code 11 or 30.
--SELECT ;


----------------------------------------------------------------
-- B) Grouping queries and/or aggregated functions (14)       --
----------------------------------------------------------------
-- 18. How many employees are there in the company?
--SELECT ;

-- 19. How many customers does each country have?
--SELECT ;

-- 20. What was the average payments for 2022?
--SELECT ;

-- 21. How many orders are there in each state? Sorts the result downward by the number of orders.
--SELECT ;

-- 22. Calculate the sale price of the most expensive and cheapest product in the same consultation.
--SELECT ;

-- 23. How many customers does the city of Madrid have?
--SELECT ;

-- 24. How many customers does each of the cities that start with M have?
--SELECT ;

-- 25. Returns the employee code of the sales reps and the number of customers each serves.
--SELECT ;

-- 26. Calculate the number of customers you are not assigned a sales representative.
--SELECT ;

-- 27. Calculate the number of different products in each of the orders.
--SELECT ;

-- 28. Calculate the sum of the total quantity of all the products that appear in each of the orders
--SELECT ;

-- 29. Return a list of the 20 best-selling products and the total number of units of each that have been sold.
-- The list must be ordered by the total number of units sold.
--SELECT ;

-- 30. Get the number of employees per office, as long as the number of employees is greater than 4.
--SELECT ;

-- 31. Obtain the customers who have made more than two payments of minimum 1000 euros. Also show the number of payments made.
--SELECT ;


----------------------------------------------------------------
--				C) Multitable queries (10)				  --
----------------------------------------------------------------

-- 32. Get product names, quantity, and price for products included in orders 3 and 5. Order it by order number and product number ascending.
--SELECT ;

-- 33. Get a list of the names of customers who have made a payment. The fields customer name, payment date and total should appear in ascending order by id client and payment date.
--SELECT ;

-- 34. Get a list with each customer's name and the first and last name of their sales representative.
--SELECT ;

-- 35. Show the name of the customers that have made payments along with the name of their sales representatives. They should only appear once.
--SELECT ;

-- 36. Return the name of the customers who have made payments and the name of their representatives along with the city of the office to which the representative belongs.
--SELECT ;

-- 37. List the address of the offices that have clients in Fuenlabrada.
--SELECT ;

-- 38. Return a list with the name of the employees along with the name of their bosses (you must use two aliases for the EMPLEADOS table).
--SELECT ;

-- 39. Return the name of customers who have not been delivered an order on time.
-- If multiple orders have been delayed, the customer should only appear once.
--SELECT ;

-- 40. Display the name of customers and the number of payments they have made.
-- They must appear all of them, regardless of whether they have made a payment or not (aparecerán todos hayan hecho o no algún pago).
--SELECT ;

-- 41. Show the name of clients and the number of orders that have been delivered.
-- They must all appear, regardless of whether they have made an order or not.
--SELECT ;


