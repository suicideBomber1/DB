-- Q1. Add the reviewer Roger Ebert to your database, with an rID of 209. 
insert into Reviewer values (209, 'Roger Ebert')

-- Q2. Insert 5-star ratings by James Cameron for all movies in the database. Leave the review date as NULL. 
insert into Rating (rID, mID, stars, ratingDate)
select rID, mID, 5 stars, null ratingDate
from Reviewer, Movie
where name = 'James Cameron'

-- Q3. For all movies that have an average rating of 4 stars or higher, add 25 to the release year. (Update the existing tuples; don't insert new tuples.) 
update Movie 
set year = year + 25
where mID in (
select C.mID as mID
from Movie, (
select mID, avg(stars) stars
from Rating
group by mID) C
where C.stars >= 4 and Movie.mID = C.mID)

-- Q4. Remove all ratings where the movie's year is before 1970 or after 2000, and the rating is fewer than 4 stars. 
delete from Rating
where mID in (
select distinct Rating.mID
from Movie, Rating
where Movie.mID = Rating.mID and (Movie.year < 1970 or Movie.year > 2000)) 
and stars < 4
