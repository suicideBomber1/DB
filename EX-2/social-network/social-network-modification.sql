-- Q1. It's time for the seniors to graduate. Remove all 12th graders from Highschooler. 
delete from Highschooler
where Highschooler.grade = 12

-- Q2. If two students A and B are friends, and A likes B but not vice-versa, remove the Likes tuple. 
delete  from Likes 
where ID1 in (
select distinct ID1 
from (
select distinct F1.ID1 ID1, F1.ID2 ID2, L1.ID2 ID3, L2.ID2
from Likes L1, Friend F1, Likes L2
where F1.ID1 = L1.ID1 and F1.ID2 = L1.ID2 and ((ID3 = L2.ID1 and L2.ID2 <> L1.ID1) or ID3 not in (select ID1 from Likes))))

-- Q3. For all cases where A is friends with B, and B is friends with C, add a new friendship for the pair A and C. Do not add duplicate friendships, friendships that already exist, or friendships with oneself. (This one is a bit challenging; congratulations if you get it right.) 
insert into Friend

select distinct F1.ID1, F2.ID2
from Friend F1, Friend F2
where F1.ID2 = F2.ID1 and F2.ID2 <> F1.ID1
except 
select ID1, ID2
from Friend
