use ssac;

CREATE TABLE user (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(30) NOT NULL
);

CREATE TABLE addr (
    addr_id INT PRIMARY KEY AUTO_INCREMENT,
    addr_name VARCHAR(30) NOT NULL,
    user_id INT NOT NULL
);

insert into user(name)
values ("jin") , ("po") , ("alice");

insert into addr(addr_name, user_id)
values ("seoul",1),("pusan",2),("daegu",4),("seoul",5);

select * from user;
select * from addr;


# inner join

select *
from user
join addr
where user.user_id = addr.user_id;

select user.user_id, user.name, addr.addr_name
from user
join addr
on user.user_id = addr.user_id;

# left join

select user.user_id, user.name, addr.addr_name
from user
left join addr
on user.user_id = addr.user_id;


# rigth join

select addr.user_id, user.name, addr.addr_name
from user
right join addr
on user.user_id = addr.user_id;


# 국가코드, 국가이름, 국가인구, 도시이름, 도시인구 출력
# 도시인국가 500만 이상인 도시만 출력
# 도시인구 순으로 내림차순
# 도시의 국가인구에 대한 비율을 출력하는 컬럼을 추가하세요.
use world;
select country.code, country.name, country.population, city.name, city.population,
		round(city.population / country.population * 100, 2) as rate
from country
join city
on country.code = city.countrycode
having city.population >= 500 * 10000
order by rate desc
limit 10;


# 스태프 아이디, 스태프 풀네임, 매출액 
# join, concat
use sakila;
select payment.staff_id, concat(staff.first_name," ", staff.last_name) as full_name, amount
from payment
join staff
on payment.staff_id = staff.staff_id;


# 스태프별 발생한 총 매출을 출력 : group by
select payment.staff_id, concat(first_name," ", last_name) as full_name, sum(amount)
from payment
join staff
on payment.staff_id = staff.staff_id
group by payment.staff_id, full_name;

# 테이블 세개 조인
# 국가이름, 도시이름, 사용언어, 사용언어 비율
use world;

SELECT 
    country.name AS country_name,
    city.name AS city_name,
    language,
    percentage
FROM
    country
JOIN
    city ON country.code = city.countrycode
JOIN
    countrylanguage ON country.code = countrylanguage.countrycode;


SELECT 
    country.name AS country_name,
    city.name AS city_name,
    language,
    percentage
FROM
    country,
    city,
    countrylanguage
WHERE
    country.code = city.countrycode
AND country.code = countrylanguage.countrycode;


----------------------------------


# 국가의 언어 사용 비율은 도시의 언어사용 비율과 같다고 가정할때,
# 도시의 언어 사용 인구를 출력
SELECT 
    country.name AS country_name,
    city.name AS city_name,
    countrylanguage.language,
    countrylanguage.percentage,
    round(city.population * countrylanguage.percentage / 100, 0) as rate
FROM
    country,
    city,
    countrylanguage
WHERE
    country.code = city.countrycode
AND country.code = countrylanguage.countrycode;


# UNION : 쿼리를 실행한 결과를 row 데이터 기준으로 합쳐서 출력
# 중복데이터 제거 (제거하고 싶지 않으면 union all)
use ssac;
select name
from user
union
select addr_name
from addr;

# outer join
select user.user_id, user.name, addr.addr_name
from user
left join addr
on user.user_id = addr.user_id
union
select user.user_id, user.name, addr.addr_name
from user
right join addr
on user.user_id = addr.user_id;

# sub query : 쿼리 안에 쿼리를 사용
# select, from, where

# sub query : select
# 전체 나라수, 전체 도시수, 전체 언어수를 하나의 row, 세개의 column으로 출력
use world;
select (select count(*) from country) as country_count
		,(select count(*) from city) as city_couny
        ,(select count(distinct(language)) from countrylanguage) as language_count
from dual;


# 800만 이상이 되는 도시의 국가코드, 국가이름, 도시이름, 도시인구수 출려

select country.name, country.code, city.name, city.population
from country
join city
on country.code = city.countrycode
having city.population >= 800 * 10000;


select country.name, country.code, city.name, city.population
from (select * from city where population >= 800 * 10000) as city
join country
on country.code = city.countrycode;


# sub query : where
# 800만 이상 도시의 국가코드, 국가이름, 대통령이름을 출력

use world;
select countrycode
from city
where population >= 800 * 10000;

select code, name, headofstate
from country
where code in (
		select countrycode
		from city
		where population >= 800 * 10000
        );
        
# any : 둘중에 한가지만 만족해도 True

select code, name, headofstate, population
from country
where population >=  any (
	select population from country where code in ("KOR", "BRA")
);

# all : 둘다 만족해야 True

select code, name, headofstate, population
from country
where population >=  all (
	select population from country where code in ("KOR", "BRA")
);
        
        
# 대륙과 지역별 사용하는 언어의 수 출력

select country.continent, country.region, countrylanguage.language
from country
join countrylanguage
on country.code = countrylanguage.countrycode;

# continent, region별 language의 수 출력

select country.continent, country.region, count(countrylanguage.language)
from country
join countrylanguage
on country.code = countrylanguage.countrycode
group by country.continent, country.region;
     
SELECT 
    continent, region, COUNT(language)
FROM
    (SELECT 
        country.continent, country.region, countrylanguage.language
    FROM
        country
    JOIN countrylanguage ON country.code = countrylanguage.countrycode) AS sub
GROUP BY continent , region;


# view
# 가상의 테이블로 특정 쿼리를 실행한 결과 데이터를 출력하는 용도
# 실제 데이터를 저장 X -> 수정 및 인덱스 설정 불가능
# 쿼리를 조금 더 단순하게 작성하게 해주는 기능

# 800만 이상의 도시인구가 있는 국가의 국가코드, 국가이름, 도시이름

SELECT 
    country.code, country.name, city_800.name
FROM
    (SELECT countrycode, name
     FROM  city
     WHERE population >= 800 * 10000) AS city_800
JOIN
    country
ON country.code = city_800.countrycode;

create view city2 as 
SELECT countrycode, name
FROM  city
WHERE population >= 800 * 10000;

select country.code, country.name
from city2;


# index : 테이블에서 데이터를 빠르게 검색할 수 있도록 해주는 기능

use employees;

select *
from salaries;

select count(*)
from salaries;

show index from salaries;
desc salaries;


select * from salaries where to_date < "1986-01-01";

create index tdate on salaries(to_date);


select * from salaries where to_date < "1986-01-01";

drop index tdate on salaries;

explain
select * from salaries where to_date < "1986-01-01";


create index tdate on salaries(to_date);
show index from salaries;

explain
select * from salaries where to_date < "1986-01-01";

# trigger : 특정 테이블을 감시하고 있다가 설정한 조건이 감지되면 지정해놓은 쿼리가 자동으로 실행
use test;
show tables;
drop table user;
drop table money;


create table chat(
		chat_id int primary key auto_increment,
        msg varchar(200)
);

create table backup(
	backup_id int primary key auto_increment,
    backup_msg varchar(200),
    backup_date timestamp default current_timestamp
);

insert into chat(msg)
values("hello"), ("hi") ,("my name is peter!");

select * from chat;

delimiter |
	create trigger backup_tr
	before delete on chat
	for each row begin
		insert into backup(backup_msg)
		value (old.msg);
end |
show triggers;

delete triggers;

select * from chat;
select * from backup;

delete from chat
where msg like "h%"
limit 10;

insert into chat(msg)
select backup_msg
from backup;

select * from chat;

use test;
drop trigger backup_tr;

# join
# 국가별로 국가코드, 국가이름, 국가인구, 도시인구, 도시개수를 출력
use world;

select *
from city;


























































































































































        
























































