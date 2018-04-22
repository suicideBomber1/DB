
-- Q1. Find the name of all reviewers who rated "Gone with the wind"
select distinct name
from Reviewer join 
(select rID
from Movie join Rating using (mID)
where title = 'Gone with the Wind') using (rID)

-- Q2. For any rating where the reviewer is the same as the director of the movie,
-- return the reviewer name, movie title and number of stars
select C.name, Movie.title, C.stars
from Movie,
(select mID, stars, name
from Reviewer join Rating using (rID)) C
where Movie.director = C.name and Movie.mID = C.mID

-- Q3. Return all reviewer names and movie names together in a single list, alphabetized
select name
from Reviewer
union
select title
from Movie
order by name, title

-- Q4. Find the titles of all the movies not reviewed by Chris Jackson
select Movie.title
from
(select mID
from Movie
except
select mID
from Reviewer join Rating using (rID)
where Reviewer.name is  'Chris Jackson') join Movie using (mID)

-- Q5. For all the pairs of reviewers such that reviewers gave a rating to the same movie, 
-- return the names of both reviewers. Eliminate the duplicates, don't pair reviewers with 
-- themselves, and include each pair only once. For each pair, return the names in the pair in 
-- alphabetical order.
select distinct *
from (
select Re1.name name1, Re2.name name2
from Rating R1, Rating R2, Reviewer Re1, Reviewer Re2
where R1.rID <> R2.rID and R1.mID = R2.mID and Re1.rID = R1.rID and Re2.rID = R2.rID
and Re1.name < Re2.name)

-- Q6. For each rating that is the lowest (fewest stars) currently in the database, 
-- return the reviewer name, movie title, and number of stars.
select name, title, stars
from (
(select mID, rID, stars
from Rating
where stars = (select min(stars)
from Rating)) join Reviewer using(rID)) join Movie using(mID)

-- Q7. List movie titles and average ratings, from highest-rated to lowest-rated. 
-- If two or more movies have the same average rating, list them in alphabetical order.
select title, stars
from (
select mID, avg(stars) stars
from Rating
group by mID) join Movie using (mID)
order by stars DESC, title

-- Q8. Find the names of all reviewers who have contributed three or more ratings. 
--(As an extra challenge, try writing the query without HAVING or without COUNT.) 
select Reviewer.name
from
(select rID, count(mID) number
from Rating
group by rID) C, Reviewer
where C.number >=3 and Reviewer.rID = C.rID

-- Q9. Some directors directed more than one movie. For all such directors, return the titles of all movies directed by them,
--along with the director name. Sort by director name, then movie title. 
--(As an extra challenge, try writing the query both with and without COUNT.) 
select Movie.title, C.director
from(
select director, count(mID) number
from Movie
group by director) C, Movie
where C.number > 1 and C.director = Movie.director

-- Q10. Find the movies with the highest average rating. Return the movie(s) title and average rating.
select *
from (
select title, avg(stars) stars
from Rating join Movie using (mID)
group by mID
) 
where stars = (
select max(stars)
from (
select mID, title, avg(stars) stars
from Rating join Movie using (mID)
group by mID) 
)
 
