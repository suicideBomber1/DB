-- Q1. For every situation where student A likes student B, but student B likes a different student C, return the names and grades of A, B, and C. 
select H1.name, H1.grade, H2.name, H2.grade, H3.name, H3.grade
from Likes L1, Highschooler H1, Highschooler H2, Likes L2, Highschooler H3
where L1.ID1 = H1.ID and L1.ID2 = H2.ID and L1.ID2 = L2.ID1 and L2.ID2 = H3.ID and 
L2.ID2 <> L1.ID1

-- Q2. Find those students for whom all of their friends are in different grades from themselves. Return the students' names and grades. 
-- Friends in same grade
select H3.name, H3.grade
from Highschooler H3, (
select ID1 from Friend
except
select ID1
from Friend F, Highschooler H1, Highschooler H2
where F.ID1 = H1.ID and F.ID2 = H2.ID and H1.grade = H2.grade )
where H3.ID = ID1

-- Q3. What is the average number of friends per student? (Your result should be just one number.) 
select avg(C.n)
from (
select count(ID2) n
from Friend
group by ID1) C

-- Q4. Find the number of students who are either friends with Cassandra or are friends of friends of Cassandra. Do not count Cassandra, even though technically she is a friend of a friend. 
select count(ID)
from (
-- Friends of Cassandra
select ID, Friend.ID2
from Highschooler, Friend 
where name = 'Cassandra' and Friend.ID1 = ID
union 
--Friends of Friends of Cassandra
select ID, F2.ID2
from Highschooler, Friend F1, Friend F2
where name = 'Cassandra' and F1.ID1 = ID and F1.ID2 = F2.ID1 and F2.ID2 <> F1.ID1)

-- Q5. Find the name and grade of the student(s) with the greatest number of friends. 
select H1.name, H1.grade
from Highschooler H1, (
select ID1 from Friend
except
select distinct (FC1.ID1)
from(
(select ID1, count(ID2) n
from Friend
group by ID1) FC1 ,
(select ID1, count(ID2) n
from Friend
group by ID1) FC2)
where FC1.n  < FC2.n) MaxFriend
where H1.ID = MaxFriend.ID1
