/*students streaks analysis with SQL*/

-- 1-What
/*Streak is a metric used usually by EdTech businesses and learning platforms , 
it is the number of consecutive interactions counted by days*/

-- 2-Whay
/*streak is useful to know how often people engage with the product.*/


-- The statement of business task:
/*Identifying your most engaged students 
so they can give you insights into how and why they engage with the product.*/



-- Prepare the Data :
 /*In this Student Steaks Analysis with SQL project, 
 I’ll work with real-world data in SQL and a provided learning streak table from 365 Data Science website.
 'https://learn.365datascience.com/projects/student-streaks-analysis-with-sql/'*/
 
 
 
 -- Processing the Data :
 
SELECT 
    *
FROM
    streaks.user_streaks_sql
LIMIT 10;
 
 
 DESCRIBE streaks.user_streaks_sql ;
 
 
 
-- Analyzing the Data :
 
  -- 1- Calculating Longest Streak
       
	-- Initialize the variables
SET @streak_count = 0;
SET @prev_user_id = NULL;
SET @prev_streak_active = NULL;


with streaks_new AS(
SELECT
    streak_id,
    user_id,
    streak_created,
    streak_active,
    streak_frozen,
    CASE
        WHEN user_id = @prev_user_id AND streak_active = 1 AND @prev_streak_active = 1 THEN @streak_count := @streak_count + 1
        ELSE @streak_count := 1
    END AS streak_count,
    @prev_user_id := user_id,
    @prev_streak_active := streak_active
FROM user_streaks_sql
ORDER BY user_id, streak_created)



-- 2-Identify the Top Performers
/*Question 1: How many users have a streak longer or equal to 30, according to our data?
Answer: 66*/
SELECT
    user_id,
    MAX(streak_count) AS max_streak_length
FROM streaks_new
WHERE streak_count > 30  -- Filter streaks with 30 days or longer and scence the ids streaks count change respectfuly then the ids who once has a 30 counts will be promoted to has a count with 31 and who ever styes in the state of 30 means he didnt finsh the 30 
GROUP BY user_id
ORDER BY max_streak_length DESC;

/*Question 2: Which following user_id is NOT a part of the top learners list of user streaks?
Answer: 123894*/
SELECT distinct user_id , streak_count 
FROM streaks_new
WHERE user_id IN (427200, 293843, 181776, 123894);
    
    
/*Question 3: How many subscribers have accomplished the maximum streak of 31 active days on the platform?
Answer: 5*/
SELECT
    user_id,
    streak_count 
FROM streaks_new
WHERE streak_count = 32  -- Filter streaks with 30 days or longer and scence the ids streaks count change respectfuly then the ids who once has a 30 counts will be promoted to has a count with 31 and who ever styes in the state of 30 means he didnt finsh the 30 
;


-- In conclusion:

-- *There are 66 users with streaks of 30 days or longer.
-- *The user with the ID 123894 is not part of the top learners list of user streaks.
-- *5 subscribers have accomplished the maximum streak of 31 active days on the platform.

/*Please note that these conclusions are based on the information provided 
and the analysis performed using the SQL queries. If you have any further questions or
 need additional assistance, feel free to ask!*/
 
 -- raed oukal--





































/*-- 1- Calculating Longest Streak 1.2
select * from streaks.user_streaks_sql;

WITH Streaks AS (
    SELECT
        user_id,
        streak_created,
        streak_active,
        CASE
        WHEN LAG(streak_active, 1, 0) OVER (PARTITION BY user_id ORDER BY streak_created) = 1 AND streak_active = 1 THEN
            ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY streak_created)
        ELSE
            0
        END AS streak_length
    FROM
        streaks.user_streaks_sql
)

SELECT
    user_id,
    MAX(streak_length) AS max_streak_length
FROM
    Streaks
WHERE
    streak_length >= 30
GROUP BY
    user_id
ORDER BY
    max_streak_length DESC;
    
    

-- by using a subquery or a CTE (Common Table Expression)
/*WITH StreaksWithActiveBefore AS (SELECT *,
       LAG(streak_active, 1,0) OVER (PARTITION BY user_id ORDER BY streak_created) AS active_before
FROM streaks.user_streaks_sql),
/*this indicates the streak where active before, it could be null if it was not active before
/*I'm going to compare that if the streaks were active and they were active before that's a continuation of being active*/
/*is this streak is zero and the previous one was 1 that's an end of a streak*/

/*streak_changed as (select user_id,streak_active,streak_frozen,active_before,streak_created,
 case when streak_active <> active_before then 1 else 0 end as streak_changed
 FROM StreaksWithActiveBefore),
 
 streaks_identified as(
 SELECT *,
SUM(streak_changed) OVER (PARTITION BY user_id order by streak_created) as streaks_identifier
FROM streak_changed
 ),
 
/*select * from streaks_identified where streaks_identifier > 3;*/
 
 /*record_counts as(select *, 
 row_number() over(PARTITION BY user_id , streaks_identifier order by streak_created)as streak_length
 from streaks_identified)
 select * from record_counts where streak_length > 29;
 
 -- I had to deal with some data cleaning since the comparison doesn't work with null values
-- SET SQL_SAFE_UPDATES = 0;

UPDATE streaks.user_streaks_sql
SET streak_frozen = 0
WHERE streak_frozen IS NULL;

select * from streaks.user_streaks_sql;*/







/*

with prev_user_id as( 
    SELECT *,
       LAG(user_id, 1,0) OVER (PARTITION BY user_id ORDER BY streak_created) AS prev_user
FROM streaks.user_streaks_sql

),
 prev_streak_active as(SELECT *,
       LAG(streak_active, 1,0) OVER (PARTITION BY user_id ORDER BY streak_created) AS active_before
FROM prev_user_id),
/* select * from prev_streak_active;*/
 /*SET @streak_count = 0;*/
/*streaks_new as (select *,
CASE
	WHEN user_id = prev_user AND streak_active = 1 AND active_before = 1 THEN @streak_count := @streak_count + 1
	ELSE @streak_count := 1
    END AS streak_count
    from prev_streak_active)
   -- Identify the Top Performers
SELECT
    distinct user_id,
    MAX(streak_count) AS max_streak_length
FROM streaks_new
WHERE streak_count >= 30  -- Filter streaks with 30 days or longer
GROUP BY user_id
ORDER BY max_streak_length DESC;*/







/*SET @streak_count2 = 0;
SET @prev_user_id2 = NULL;
SET @prev_streak_active2 = NULL;

WITH streaks_new_cte AS (
    SELECT
        streak_id,
        user_id,
        streak_created,
        streak_active,
        streak_frozen,
        CASE
            WHEN user_id = @prev_user_id2 AND streak_active = 1 AND @prev_streak_active2 = 1 THEN @streak_count2 := @streak_count2 + 1
            ELSE @streak_count2 := 1
        END AS streak_count,
        @prev_user_id2 := user_id,
        @prev_streak_active2 := streak_active
    FROM user_streaks_sql
    ORDER BY user_id, streak_created
)
SELECT
    user_id,
    MAX(streak_count) AS max_streak_length
FROM streaks_new_cte
WHERE streak_count >= 30  -- Filter streaks with 30 days or longer
GROUP BY user_id
ORDER BY max_streak_length DESC;*/








    
    
    

