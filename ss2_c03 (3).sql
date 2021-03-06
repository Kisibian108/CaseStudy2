create database if not exists codegym_management_c03 ;

use codegym_management_c03;

create table class_type (
	id int primary key auto_increment,
    `name` varchar(30)
);
create table class (
	id int primary key auto_increment,
    `name` varchar(30),
    id_class_type int,
    foreign key (id_class_type) references class_type(id)
);

create table `account` (
	 username varchar(20) primary key,
    `password` varchar(30)
);
create table student (
	id int primary key auto_increment,
    `name` varchar(30),
    address varchar(30),
    date_of_birth date,
    username varchar(20),
    id_class int,
    foreign key (id_class) references class (id),
    foreign key (username) references `account`(username)
);



create table instructor (
	id int primary key auto_increment,
    `name` varchar(30),
    address varchar(30),
    salary int
);
create table calendar(
	id_class int ,
    id_instructor int,
    `subject` varchar(30),
    primary key (id_class, id_instructor),
    foreign key (id_class) references class(id),
    foreign key (id_instructor) references instructor(id)
);

insert into class_type (`name`) values ('Fulltime'), ('Partime') ;
insert into class (`name`, id_class_type) values ('C0322G1', 1 );
insert into `account` (username, `password`) values ('ha.tran', '123123');

insert into student (`name`, address, date_of_birth, `username`, id_class)
values ('Hà', 'Quảng Trị', '2000-10-10', 'ha.tran', 2);


insert into instructor (`name`, address, salary) 
values ('Chiến', 'QB', 2000);

insert into calendar (id_class, id_instructor, `subject`) 
values (2, 1, 'SQL');

-- 1. Lấy ra thông tin các học viên, và cho biết các học viên đang theo học lớp nào.
-- 2. Lấy ra thông tin các học viên, và cho biết các học viên đang theo học lớp nào, lớp đó thuộc loại lớp nào.
-- 3. Lấy ra thông tin các học viên đang theo học tại các lớp kể cả các học viên không theo học lớp nào.
-- 4. Lấy thông tin của các học viên tên 'Tien' và 'Toan’.
-- 5. Lấy ra số lượng học viên của từng lớp.
-- 6. Lấy ra danh sách học viên và sắp xếp tên theo alphabet.


-- 1. Lấy ra thông tin các học viên, và cho biết các học viên đang theo học lớp nào.

select student.* , class.`name`, class_type.`name` as class_type from student 
inner join class on student.id_class = class.id
inner join class_type on class.id_class_type = class_type.id  ;

-- 3. Lấy ra thông tin các học viên đang theo học tại các lớp kể cả các học viên không theo học lớp nào.
select student.* , class.`name`, class_type.`name` as class_type from student 
left join class on student.id_class = class.id
left join class_type on class.id_class_type = class_type.id  ;

select student.* , class.`name`, class_type.`name` as class_type from student 
left join class on student.id_class = class.id
left join class_type on class.id_class_type = class_type.id  
UNION
select student.* , class.`name`, class_type.`name` as class_type from student 
right join class on student.id_class = class.id
right join class_type on class.id_class_type = class_type.id  ;

-- 4. Lấy thông tin của các học viên tên 'Chiến' và 'Đạt’.
select * from student 
where (`name` = "Chiến" or `name` = "Đạt") and address = "Quảng Trị";

-- 5. Lấy ra số lượng học viên của từng lớp.
select s.* , class.`name`, class_type.`name` as class_type , count( id_class ) as so_luong
from student s
right join class on s.id_class = class.id
right join class_type on class.id_class_type = class_type.id  
GROUP BY id_class
-- having class_type = "Fulltime" and so_luong > 0
;
-- 6. Lấy ra danh sách học viên và sắp xếp tên theo alphabet.
select * from student
order by `address` , date_of_birth desc
;

select s.* , c.name, i.name from student s
join class c on s.id_class = c.id
join calendar ca on c.id = ca.id_class
join instructor i on ca.id_instructor = i.id;

-- Lấy ra toàn bộ các instructor và student ở CodeGym. 

-- Lấy ra 3 học viên trẻ tuổi nhất ở CodeGym

-- Lấy ra thông tin các lớp, kể cả lớp không có học viên học.

-- Lấy ra thông tin các học viên kể cả các học viên không theo học lớp nào.

select  c.* , count(id_class) as so_luong  from student s
join class c on s.id_class = c.id
group by id_class
;
select s.*, c.name , ifnull(address*id_class,0) as DTB from student s
join class c on s.id_class = c.id 
;

select student.id, student.name , 'student' as `type` from student
UNION
select instructor.id, instructor.name, 'instructor' as `type` from instructor;

select student.id, student.name from student
UNION ALL
select student.id, student.name from student;

select * from student
limit 3
;
-- Lấy ra student không học lớp A11 ;

select * from student 
join class on student.id_class = class.id
where student.id not in (
select student.id from student 
join class on student.id_class = class.id
where class.name = "A1121I1"
)
;
-- Lấy ra những học sinh học lớp A11
select * from student s
where exists (select student.id from student
	join class on student.id_class = class.id
	where class.name = "A1121I1" and s.id = student.id );

select length('Chiến');
select char_length('Chiến');
select curdate();
select current_date();

select datediff( '2022-06-17', '2022-06-19' );

select * from student where username = 'chien.tran';
create index key_c03 on student(name);


select student.id, student.name , 'student' as `type` from student
UNION
select instructor.id, instructor.name, 'instructor' as `type` from instructor;

create view person_in_codegym as 
select student.id, student.name , 'student' as `type` from student
UNION
select instructor.id, instructor.name, 'instructor' as `type` from instructor;

select * from person_in_codegym;


-- Tham số IN
delimiter //
create procedure search_by_name( in name_search varchar(50) )
begin
    select * from student where `name` = name_search ;
end; 
// delimiter ;
call search_by_name('Chiến');

-- Tham số OUT
delimiter //
create procedure search_by_name2(in key_name varchar(10), out so_luong int )
begin
	set so_luong = ( select count(*) from student
    where name = key_name ) ;
end;
// delimiter ;

call search_by_name2("Chiến", @amount);
select @amount;

-- Dùng tham số dạng INOUT
delimiter //
create procedure search_by_name3( inout key_search varchar(10))
begin
	set key_search = ( select count(*) from student
    where name = key_search ) ;
end;
// delimiter ;

set @key_search = "Chiến";
call search_by_name3(@key_search);
select @key_search ;

-- FUNCTION 
delimiter //
create function sum_2_num(num1 int, num2 int) 
returns int
deterministic
begin
    declare total int;
    set total = num1 + num2 ;
    return total;
end;
// delimiter ;

select sum_2_num(5, 10);

-- Trigger
-- Khi thêm thông tin vào bảng student -> Tự động lấy email làm account, 
-- password mặc định là 123456 để tạo bảng jame .
-- new : Đại diện cho dòng dữ liệu thêm vào
drop trigger save_account_james2 ;
delimiter //
create trigger save_account_james
-- Hành động để kích hoạt trigger
before insert
on student for each row
begin
     insert into `account`
     -- new đại diện cho dòng dữ liệu vừa thêm vào
     -- old 
     values ( new.`name`, '123456') ;

    if new.`username`  is null then 
         set new.`username` = new.`name` ;
    end if;
end;
// delimiter ;     
insert into student (id, `name`, address )
values (11, 'tien.dat', 'QT');

delete from student 
where student.id  in (
select * from (
select student.id from student 
join class on student.id_class = class.id
where class.name = "A1121I1"
) temp
)
;


