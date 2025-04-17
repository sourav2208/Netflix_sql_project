create table Netflix
(
    show_id varchar(10),
    types  varchar (10),
    title varchar(150),
    director varchar(250),
    casts varchar(1000),
    country varchar(200),
    date_added varchar (50),
    release_year INT,
    rating varchar (20),
    duration varchar(100),
    listed_in varchar(100),
    description varchar (1000)
);

select * from Netflix;

select count(*)as total_content from Netflix;

-- 1. count the number of TV Shows and Movies.

select types, 
count(*) as total_content
from Netflix
group by types

--2. most common ratting for movies and TV Shows.
select types , rating from
(select types, rating, count(*),
rank()over(partition by types order by count(*) desc) as ranking
from Netflix
group by 1,2)
as t1
where ranking = 1

--3. list all movies released in a specific year(e.g., 2020).
select * from Netflix
where 
     types = 'Movie' 
     and  
     release_year = 2020

--4. Find the top 5 coutries with the most content on Netflix.
select 
   unnest(string_to_array(country, ',')) as  new_country ,
   count(show_id)as total_content 
from Netflix
group by 1
order by total_content desc
limit 5;

--5. Identify the longest movie.
select * from Netflix
where
	types = 'Movie'
	and
	duration = (select max(duration)from Netflix);
	
--6.Find content added in the last 5 years.
select *from Netflix
where 
To_date(date_added, 'Month DD, YYYY') >= current_date - interval '5 years'

--7. find all the movies and TV Shows by director 'Rajiv Chilaka'.

select * from Netflix
where 
types in ('Movie', 'TV Show')
and
director = 'Rajiv Chilaka'


-- 2nd solution
select * from Netflix
where director  ilike  '%Rajiv Chilaka%'

-- 8.list all TV Shows with more than 5 seasons

select * from netflix
where types = 'TV Show'
and
split_part(duration, ' ', 1):: numeric > 5

-- second solution
SELECT *
FROM netflix
WHERE types = 'TV Show'
  AND duration LIKE '%Seasons'
  AND split_part(duration, ' ', 1)::int > 5;
 
-- 9. count the number of content items in each genre.
select 
unnest(string_to_array(listed_in, ','))as genre,
count(show_id)as total_content,
unnest(string_to_array(listed_in, ','))
from Netflix
group by 1;


--SELECT 
--  TRIM(unnest(string_to_array(listed_in, ','))) AS genre,
--  COUNT(*) AS total_content
--FROM netflix
--GROUP BY genre
--ORDER BY total_content DESC;


-- 10. find each year and the average number of content released by india on netflix.return top 5 with highest average content release.


SELECT 
EXTRACT (YEAR FROM TO_DATE (date_added, 'Month DD, YYYY')) as year, 
COUNT(*), 
COUNT(*):: numeric/(SELECT COUNT(*) FROM Netflix WHERE Country = 'India')* 100 as avg_content_per_year 
FROM netflix 
WHERE country = 'India' 
GROUP BY 1
----------------------------
SELECT 
EXTRACT (YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) as year, 
COUNT(*) as yearly_content, 
ROUND ( 
COUNT(*):: numeric/(SELECT COUNT(*) FROM netflix WHERE country = 'India')::numeric * 100, 
2)as avg_content_per_year 
FROM netflix 
WHERE country = 'India' 
GROUP BY 1

-- 11. list all movies that are documentary
SELECT * 
FROM netflix
where listed_in ilike '%Documentaries'

-- 12. Find all content withouut a director
select * from Netflix
where director isnull

-- 13. Find how many movies actor salman khan appread in last 10 years.
select * from netflix
where casts ilike ('%salman khan%')
and
release_year > extract (year from current_date )- 10				   
				   
				   
				   
-- 14.  Find the top 10 actors who have appread in the highest number of movies produced in India.
Select  
unnest(string_to_array (casts, ',')) as Actors,
count(*) as total_content
from Netflix
where country ilike '%India%'
group by Actors
order by 2 desc
limit 10;

-- 15. Categorize the content based on the presence of the keywords 'kill' and 'violence' in the description field. Label content containing these keywords as 'Bad' and all other content as 'Good'. Count how many items fall into each category.

SELECT 
  CASE 
    WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
    ELSE 'Good'
  END AS content_category,
  COUNT(*) AS total_items
FROM netflix
GROUP BY content_category;




