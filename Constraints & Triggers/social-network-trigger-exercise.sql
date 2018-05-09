-- Q1. Write a trigger that makes new students named 'Friendly' automatically like everyone else in their grade. That is, after the trigger runs, we should have ('Friendly', A) in the Likes table for every other Highschooler A in the same grade as 'Friendly'.
create trigger friendly
after insert on Highschooler
for each row
when new.name = 'Friendly'
begin
insert into Likes
select new.ID, Highschooler.ID
from Highschooler
where new.grade = Highschooler.grade and new.ID <> Highschooler.ID;
end;

-- Q2. Write one or more triggers to manage the grade attribute of new Highschoolers. If the inserted tuple has a value less than 9 or greater than 12, change the value to NULL. On the other hand, if the inserted tuple has a null value for grade, change it to 9. 
create trigger T1
after insert on Highschooler
for each row
when new.grade < 9 or new.grade > 12
begin 
update Highschooler
set grade = null
where new.ID = Highschooler.ID;
end

|

create trigger T2
after insert on Highschooler
for each row
when new.grade is null
begin 
update Highschooler
set grade = 9
where new.ID = Highschooler.ID;

end;

--Q3. Write one or more triggers to maintain symmetry in friend relationships. Specifically, if (A,B) is deleted from Friend, then (B,A) should be deleted too. If (A,B) is inserted into Friend then (B,A) should be inserted too. Don't worry about updates to the Friend table. 
create trigger T1
after insert on Friend
for each row
when not exists (select * from Friend where new.ID2 = ID1 and new.ID1 = ID2)
begin
insert into Friend
values (new.ID2, new.ID1);
end

|

create trigger T2
after delete on Friend
for each row
when exists (select * from Friend where ID2 = old.ID1 and ID1 = old.ID2)
begin
delete from Friend
where (ID2 = old.ID1 and ID1 = old.ID2);
end;

--Q4. Write a trigger that automatically deletes students when they graduate, i.e., when their grade is updated to exceed 12. 
create trigger T1
after update on Highschooler
for each row
when new.grade > 12
begin
delete from Highschooler
where new.ID = Highschooler.ID;
end;

--Q5. Write a trigger that automatically deletes students when they graduate, i.e., when their grade is updated to exceed 12 (same as Question 4). In addition, write a trigger so when a student is moved ahead one grade, then so are all of his or her friends. 
create trigger T1
after update on Highschooler
for each row
when new.grade > 12
begin
delete from Highschooler
where new.ID = Highschooler.ID;
end

|

create trigger T2
after update on Highschooler
for each row
when new.grade = old.grade + 1
begin
update Highschooler
set grade = grade + 1
where (select ID2 from Friend
where ID1 = new.ID and ID2 = Highschooler.ID);
end;

--Q6. Write a trigger to enforce the following behavior: If A liked B but is updated to A liking C instead, and B and C were friends, make B and C no longer friends. Don't forget to delete the friendship in both directions, and make sure the trigger only runs when the "liked" (ID2) person is changed but the "liking" (ID1) person is not changed. 
create trigger NoLongerFriend
after update of ID2 on Likes
for each row
when Old.ID1 = New.ID1 and Old.ID2 <> New.ID2
begin
 delete from Friend
 where (Friend.ID1 = Old.ID2 and Friend.ID2 = New.ID2)
 or (Friend.ID1 = New.ID2 and Friend.ID2 = Old.ID2);
 end;
