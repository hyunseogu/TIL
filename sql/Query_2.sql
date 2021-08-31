use world;
desc city;




use ssac;
create table number1(data tinyint);
show tables;
desc ;
insert into number1 value(127);

select * from number1;



create table number2(data tinyint unsigned);
insert into number2 value(128);
select * from number2;

create table number3(data float);
create table number4(data double);
insert into number3 value(123.456789);
insert into number4 value(123.4567890123456789);

select * from number3;
select * from number4;

use ssac;

desc items;



# DDL : CREATE : database, table
create database test;
show databases;
use ssac;
select database();


create table user1(
	user_id int,
    name varchar(20),
    email varchar(30),
    age int,
    rdate date

);
show tables;
desc user1;

create table user2(
	user_id int primary key auto_increment,
    name varchar(20) not null,
    email varchar(30) not null unique,
    age int default 30,
    rdate timestamp

);
desc user2;




# DDL : ALTER
show variables like "character_set_database";
alter database ssac character set = ascii;
alter database ssac character set = utf8;

# Column ADD
alter table user2 add tmp text;
desc user2;

# Column Modify
alter table user2 modify column tmp int;
desc user2;

# Column Drop
alter table user2 drop tmp;
desc user2;

# Table 인코딩 확인
show full columns from user2;

# Table 인코딩 변경
alter table user2 convert to character set ascii;
show full columns from user2;
alter table user2 convert to character set utf8;
desc user2;



# DDL : DELETE
show tables;
drop table number1;
drop table number2;
drop table number3;
drop table number4;
show tables;

show databases;
drop database test;
show databases;

# CRUD - CREATE : insert
use ssac;
desc user2;
insert into user2(name, email, age)
value("peter","peter@gmail.com","23");
select * from user2;


insert into user2(name, email, age)
values ("and","andy@gmail.com","32")
,	  ("po","andy@naver.com","25")
,     ("ted","ted@gmail.com","39");
select * from user2;

insert into user2(name, email)
value ("mysql", "mysql@gmail.com");
select * from user2;


# 중복 불가
insert into user2(name, email)
value ("alice", "ted@gmail.com");
select * from user2;


use world;
select countrycode, name, population
from city
where population >= 800 * 10000;

create table city_800(
	countrycode char(3),
    name varchar(50),
    population int
);
desc city_800;

insert into city_800
select countrycode, name, population
from city
where population >= 800 * 10000;
select * from city_800;


# UPDATE
use ssac;
select * from user2;
update user2
set email="mysql@naver.com", age=40
where name="mysql"
limit 5;
select * from user2;

# DELETE
select * from user2
where age<= 30;                  # 삭제전에 한번 확인하기

delete from user2
where age<= 30
limit 2;

select * from user2;

# Foreign Key
# 데이터의 무결성을 지킬수 있는 제약조건입니다.
create database test;
use test;
create table user(
	user_id int primary key auto_increment,
    name varchar(20),
    addr varchar(20)
);
create table money(
	money_id int primary key auto_increment,
    income int,
    user_id int
);
# foreign key 생성
desc money;
alter table money add constraint fk_user
foreign key (user_id)
references user (user_id);
desc money;

insert into user(name, addr)
values ("peter","seoul"),("andy","pusan");
select * from user;

insert into money(income, user_id)
values (5000, 1),(6000, 2);
select * from money;

insert into money(income, user_id)
value (10000, 3);    # foreign key가 없기때문에 추가 x

delete from user
where user_id = 1
limit 1;      # foreign key를 money table에서 사용하고있어서 삭제 x

# on delete, on update 설정
# 참조되는 데이터를 수정, 삭제할때 참조하는 데이터를 어떻게 처리할지를 설정
# cascade     : 참조되는 테이블 데이터를 삭제, 수정하면 참조하는 테이블 데이터도 삭제, 수정
# set null    : 참조하는 데이터 null값으로 변경
# no action   : 참조하는 데이터를 변경하지 않음
# set default : 참조하는 데이터를 컬럼의 default값으로 변경
# restrict    : 참조하는 데이터를 삭제하거나 수정할 수 없음




drop table user;
create table user(
	user_id int primary key auto_increment,
    name varchar(20),
    addr varchar(20)
);

insert into user(name, addr)
values ("peter","seoul"),("andy","pusan");
select * from user;

drop table money;
create table money(
	money_id int primary key auto_increment,
    income int,
    user_id int,
    foreign key (user_id) references user(user_id)
    on update cascade on delete set null
);


insert into money(income, user_id)
values (5000, 1),(6000, 1),(9000, 2),(8000, 2) ;
select * from money;

update user
set user_id=3
where user_id=2
limit 1;

select * from user;
select * from money;

delete from user
where user_id=3
limit 1;


select * from user;
select * from money;

# Functions 1 : round, date_format, concat, count, distinct
use world;
select countrycode, language, percentage,
		ceil(percentage), round(percentage, 0), truncate(percentage, 0)
from countrylanguage;

# data_format() : 날짜데이터에 대한 포멧을 변경
use sakila;
select payment_date, date_format (payment_date, "%Y-%m")
from payment;
select distinct(date_format(payment_date, "%H")) as unique_hour
from payment
order by unique_hour;



# concat
use world;
select code, name, concat(name,"(",code,")")
from country;

# count : row의 개수를 세어줌
# 100만 인구 이상의 도시 개수를 출력
select count(name)
from city
where population >= 100 * 10000;

# countrylanguage 테이블에서 전세계 언어 종류의 개수를 출력
# count, distinct

select count(distinct(language))
from countrylanguage;


# Functions 2 : if, ifnull, case when then
# if
# 도시의 인구가 100만이 넘으면 big, 아니면 small을 출력하는 scale 컬럼을 추가하세요.

select name, population, if(population>= 100*10000 ,"big", "small")
from city
order by population desc;

# ifnull
select code, name, indepyear, ifnull(indepyear, 0)
from country;

# case when then : 조건이 여러개인경우 사용
# 국가의 인구가 1억이상 big, 1000만이상 medium, 1000만미만 small
select name, population,
       case
			when population >= 10000 * 10000 then "big"
            when population >= 1000 * 10000 then "medium"
            else "small"
	   end as scale
from country
order by population desc;


# GROUP BY & HAVING
# 특정 컬럼에 있는 동일한 데이터를 합쳐주는 방법
# 반드시 결합함수를 사용 : count, min, max, avg, sum ...
# 국가 코드별 도시의 개수

select countrycode, count(countrycode) as city_count
from city
group by countrycode
order by city_count desc
limit 5;

# 국가 코드별 모든 도시의 인구 총합을 출력
select countrycode, sum(population) as total_population
from city
group by countrycode
order by total_population desc;

# country 테이블에서 대륙별 인구의 총합을 출력
select continent, sum(population) as total_population
from country
group by continent
order by total_population desc;

# GNP의 총합, 대륙별 인당 GNP를 출력
select continent, sum(gnp) as total_GNP, sum(gnp) / sum(population) as personal_GNP
from country
group by continent
order by personal_GNP desc;

# 년월별 총 매출을 출력
use sakila;
select date_format(payment_date, "%Y-%m") as pay_date, sum(amount)
from payment
group by pay_date;

# 시간다별 총 매출 출력
select date_format(payment_date, "%H") as pay_hour, sum(amount)
from payment
group by pay_hour;


# Having
# group by, join 과 같은 쿼리를 실행한 결과데이터를 필터링 할때 사용
# 대륙별 전체 인구를 출력하고 전체 인구가 5억 이상인 대륙을 출력
# where 절은 from에서 조건, having은 group by 후 조건
use world;
select continent, sum(population) as population
from country
group by continent
having population >= 50000 * 10000;

# with rollup
# 여러개의 컬럼을 group by하고 각 컬럼별 총합을 row로 출력
# 대륙별, 지역별 인구수의 총합
select ifnull(continent, "total"), ifnull(region, "total"),
       sum(population) as population
from country
group by continent, region
with rollup;

# 변수선언
set @data = 1;
select @data;

# city 테이블에서 도시의 인구수가 많은 5개 도시를 출력하고 내림차순으로 소팅
set @RANK =0;

select @RANK := @RANK+1 as ranking, countrycode, name, population
from city
order by population desc
limit 5;


# countrylanguage 에서 언어별 20개 이상의 국가에서 사용하는 언어를 조회해서
# 언어별 사용되는 국가 수에 따라서 내림차순으로 정렬 해서 출력
select language, count(language) as count
from countrylanguage
group by language
having count >= 20
order by count desc;


# country 테이블에서 대륙별 전체면적, 전체인구,인구밀도(전체인구/표면적)
select continent,sum(surfacearea) as total_area,sum(population) as total_population, 
        sum(population) / sum(surfacearea) as personal
from country
group by continent
order by personal desc;

--


# summary
# datatype: int, float, double, char, varchar, text, datetime, timestamp
# constraint : not null, unique, primary key, auto_increment, foreign key
# foreign key : 무결성 - on update, on delete
# DDL : CREATE, ALTER, DROP
# DML : CRUD - CREATE(INSERT), READ(SELECT), UPDATE(UPDATE), DELETE(DELETE)
# Function : ceil, round, truncate, date_format, concat, count
# if, ifnull, case when then
# group by, having 
































































