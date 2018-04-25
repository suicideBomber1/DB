-- Q1. Find the names of all students who are friends with someone named Gabriel. 
select H2.name
from Highschooler H1, Highschooler H2, Friend
where H1.name = 'Gabriel' and H1.ID = Friend.ID1 and H2.ID = Friend.ID2

-- Q2. For every student who likes someone 2 or more grades younger than themselves, return that student's name and grade, and the name and grade of the student they like. 
select H1.name, H1.grade, H2.name, H2.grade
from Highschooler H1, Highschooler H2, Likes
where H1.ID = Likes.ID1 and H2.ID = Likes.ID2 and H1.grade - H2.grade >= 2

-- Q3. For every pair of students who both like each other, return the name and grade of both students. Include each pair only once, with the two names in alphabetical order. 
select H1.name, H1.grade, H2.name, H2.grade
from (
select L1.ID1 ID1, L1.ID2 ID2
from Likes L1, Likes L2
where L1.ID2 = L2.ID1 and L1.ID1 = L2.ID2) C, Highschooler H1, Highschooler H2
where H1.ID = C.ID1 and H2.ID = C.ID2 and H1.name < H2.name

-- Q4. Find all students who do not appear in the Likes table (as a student who likes or is liked) and return their names and grades. Sort by grade, then by name within each grade. 
select C.name, C.grade
from (
select ID, name, grade
from Highschooler
except
select ID1,Highschooler.name name, Highschooler.grade grade
from Likes join Highschooler
where Likes.ID1 = Highschooler.ID

intersect

select ID, name, grade
from Highschooler
except
select ID2, Highschooler.name name, Highschooler.grade grade
from Likes join Highschooler
where Likes.ID2 = Highschooler.ID
) C
order by grade, name

-- Q5. For every situation where student A likes student B, but we have no information about whom B likes (that is, B does not appear as an ID1 in the Likes table), return A and B's names and grades. 
select H1.name, H1.grade, H2.name, H2.grade
from Likes L1, Highschooler H1, Highschooler H2
where L1.ID2  not in (select ID1 from Likes) and H1.ID = L1.ID1 and H2.ID = L1.ID2

-- Q6.Find names and grades of students who only have friends in the same grade. Return the result sorted by grade, then by name within each grade. 
select name, grade
from Highschooler , (
select ID1
from Friend
except 
select ID1
from Highschooler H1, Highschooler H2, Friend
where H1.grade <> H2.grade and H1.ID = Friend.ID1 and H2.ID = Friend.ID2) C
where C.ID1 = Highschooler.ID
order by grade, name

-- Q7. For each student A who likes a student B where the two are not friends, find if they have a friend C in common (who can introduce them!). For all such trios, return the name and grade of A, B, and C. 
select distinct H1.name, H2.name, H3.name
from Highschooler H1, Highschooler H2, Highschooler H3, Friend F3, (
select  F1.ID1 ID1, F2.ID1 ID2, F2.ID2 CID
from Likes, Friend F1, Friend F2
where Likes.ID1 = F1.ID1 and Likes.ID2 = F2.ID1 and F1.ID2 = F2.ID2 and F1.ID2 is not in Likes.ID2 and
F2.ID2 is not in Likes.ID1) C
where H1.ID = C.ID1 and H2.ID = C.ID2 and H3.ID = C.CID 

-- Q8. Find the difference between the number of students in the school and the number of different first names. 
select count(ID) - count(distinct name)
from Highschooler

-- Q9. Find the name and grade of all students who are liked by more than one other student. 
select H1.name, H1.grade
from Highschooler H1, (
select ID2, count(ID1) n
from Likes
group by ID2) C
where H1.ID = C.ID2 and n > 1

