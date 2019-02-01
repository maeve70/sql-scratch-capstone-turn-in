/*Question 1- What columns does the survey table have?*/
SELECT *
FROM survey
LIMIT 10; 

/*Question 2 create a quiz funnel. what are the responses for each question?*/
SELECT question, COUNT(user_id)
FROM survey
GROUP BY question;

/*Question 3-what is the percentage of users who answer each question?

1- 100%
2- 95%
3- 80%
4- 95%
5- 75%
 */

/*Q 4-Home try-on funnel. A/B test. Find out whether or not users who get more pairs to try on at home will be more likely to make a purchase.*/

SELECT *
FROM quiz
LIMIT 5;

SELECT *
FROM home_try_on
LIMIT 5;

SELECT *
FROM purchase
LIMIT 5;


/*Q 5- combine 3 tables using LEFT JOIN*/

SELECT DISTINCT q.user_id, 
h.user_id IS NOT NULL AS 'is_home_try_on',
h.number_of_pairs, 
p.user_id IS NOT NULL AS 
 'is_purchase'
FROM quiz q
LEFT JOIN home_try_on h
   ON q.user_id = h.user_id
LEFT JOIN purchase p
ON p.user_id = q.user_id
LIMIT 10;


/*Q6 Actionable Insights:*/

/*Product ID & Model name*/

SELECT DISTINCT product_id, model_name
FROM purchase
ORDER BY product_id;

/*Most popular model purchased?*/

SELECT product_id, COUNT(model_name), 
       model_name, style
FROM purchase
GROUP BY product_id
ORDER BY COUNT(model_name) DESC;

/*Number of models purchased & their price & total sales for each*/
SELECT product_id, model_name, 
	COUNT(model_name), ROUND(price, 2), SUM(price)
FROM purchase
GROUP BY model_name
ORDER BY COUNT(model_name) DESC;

/*popular responses by question*/
SELECT question, MAX(response)
FROM survey
GROUP BY question;


/*user id, model name and AVG price. Not in slides.*/
SELECT user_id, model_name, SUM(price)
FROM purchase
GROUP BY user_id
LIMIT 10; 


WITH funnel AS
  (SELECT DISTINCT q.user_id, h.user_id IS NOT NULL AS 'is_home_try_on',
h.number_of_pairs, 
p.user_id IS NOT NULL AS 
 'is_purchase'
FROM quiz q
LEFT JOIN home_try_on h
   ON q.user_id = h.user_id
LEFT JOIN purchase p
ON p.user_id = q.user_id
   )
   
SELECT number_of_pairs, SUM(is_home_try_on),
SUM(is_purchase)
FROM funnel
GROUP BY number_of_pairs;
  
--3 pairs: 53% purchase rate
--5 pairs: 79%


--conversion rate of home try-on to purchase:

/*Calculating conversion from browse to home try on to purchase.... */
WITH funnel AS
  (
  SELECT DISTINCT q.user_id, h.user_id IS NOT NULL AS 'is_home_try_on',
h.number_of_pairs, 
p.user_id IS NOT NULL AS 
 'is_purchase'
FROM quiz q
LEFT JOIN home_try_on h
   ON q.user_id = h.user_id
LEFT JOIN purchase p
ON p.user_id = q.user_id
 )
SELECT number_of_pairs,
COUNT(*) AS 'num_browse',
	SUM(is_home_try_on) AS 'num_try_on', 
  SUM(is_purchase) AS 'num_purchase',
  1.0 * SUM(is_purchase) /
  SUM(is_home_try_on) AS 'try_on_to_purchase'
 FROM funnel
 GROUP BY number_of_pairs;

  
  
















