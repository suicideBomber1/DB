-- Q1 Find the titles of all movies directed by Steven Spielberg. 

select title
from Movie
where director = 'Steven Spielberg'

--Q2 Find all years that have a movie that received a rating of 4 or 5, and sort them in increasing order. 

select distinct (year)
from movie join rating using (mID)
where stars = 4 or stars = 5

--Q3 Find the titles of all movies that have no ratings. 

select title
from Movie
where mID not in 
(select distinct mID
from Movie join Rating using (mID))

--Q4 Some reviewers didn't provide a date with their rating. 
--Find the names of all reviewers who have ratings with a NULL value for the date. 

select name
from Reviewer
where rID in 
(select rID
from Rating
where ratingDate is null)

--Q5 Write a query to return the ratings data in a more readable format: reviewer name, movie title, stars, and ratingDate. 
--Also, sort the data, first by reviewer name, then by movie title, and lastly by number of stars. 

select name, title, stars, ratingDate
from (Reviewer join Rating using (rID)) join Movie using (mID)
order by name, title, stars

--Q6 For all cases where the same reviewer rated the same movie twice and gave it a higher rating the second time, 
--return the reviewer's name and the title of the movie. 

select name, title
from Movie, Reviewer, (
select R1.rID, R1.mID
from Rating R1 join  Rating R2
where R1.rID = R2.rID and R1.mID = R2.mID and R1.stars < R2.stars and R1.ratingDate< R2.ratingDate) C
where Movie.mID = C.mID and Reviewer.rID = C.rID

--Q7 For each movie that has at least one rating, find the highest number of stars that movie received. 
--Return the movie title and number of stars. Sort by movie title. 

select title, C.stars
from Movie, (
select mID, max(stars) stars
from Rating
group by mID
having count(stars) >=1)  C
where C.mID = Movie.mID
order by title

--Q8 For each movie, return the title and the 'rating spread', that is, the difference between highest 
--and lowest ratings given to that movie. Sort by rating spread from highest to lowest, then by movie title. 

select title, C."rating spread"
from Movie, (
select mID, max(stars)-min(stars) "rating spread"
from Rating
group by mID) C
where C.mID = Movie.mID
order by C."rating spread" DESC, title

--Q9 Find the difference between the average rating of movies released before 1980 and the average rating of movies released after 1980. 
--(Make sure to calculate the average rating for each movie, then the average of those averages for movies before 1980 and movies after. 
--Don't just calculate the overall average rating before and after 1980.) 

select abs(avg(T1.stars)-avg(T2.stars))
from (
select mID, avg(stars) stars, year
from Movie join Rating using (mID)
where year < 1980
group by (mID)) T1, 
(
select mID, avg(stars) stars, year
from Movie join Rating using (mID)
where year > 1980
group by (mID)) T2
