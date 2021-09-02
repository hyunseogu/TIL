# 1. 멕시코(Mexico)보다 인구가 많은 나라이름과 인구수를 조회하시고 인구수 순으로 내림차순하세요.

use world;

select name, population
from country
where population > (select population from country where name = "Mexico")
order by population desc;

# 2. 국가별 몇개의 도시가 있는지 조회하고 도시수 순으로 10위까지 내림차순하세요.

select country.name, count(city.name) as count
from country
join city
on country.code = city.countrycode
group by country.code
order by count desc
limit 10;

# 3. 언어별 사용인구를 출력하고 언어 사용인구 순으로 10위까지 내림차순하세요.


select countrylanguage.language, round(sum(countrylanguage.percentage * country.population / 100), 0) as count
from countrylanguage
join country
on country.code = countrylanguage.countrycode
group by countrylanguage.language
order by count desc
limit 10;

# 4. 나라 전체 인구의 10%이상인 도시에서 도시인구가 500만이 넘는 도시를 아래와 같이 조회 하세요.

select city.name, city.countrycode, country.name, 
	   round(city.population / country.population * 100, 2) as percentage, city.population
from city
join country
on country.code = city.CountryCode
having city.population >= 500 * 10000 and percentage >= 10
order by percentage desc;

# 5. 면적이 10000km^2 이상인 국가의 인구밀도(1km^2 당 인구수)를 구하고 인구밀도(density)가 200이상인
# 국가들의 사용하고 있는 언어가 2가지인 나라를 조회 하세요. 
# 출력 : 국가 이름, 인구밀도, 언어 수 출력 

select country.name, country.density, 
	   count(countrylanguage.language) as count, 
       group_concat(language) as language_list
from(
		select code, name, round(population/surfacearea, 0) as density, SurfaceArea
		from
				(select * from country where SurfaceArea >= 10000) as country
		having density >= 200
		order by SurfaceArea desc
) as country
join countrylanguage
on country.code = countrylanguage.countrycode
group by country.name, country.density
having count = 2
order by count;




# 6. 사용하는 언어가 3가지 이하인 국가중 도시인구가 300만 이상인 도시를 아래와 같이 조회하세요. 
# * GROUP_CONCAT(LANGUAGE) 을 사용하면 group by 할때 문자열을 합쳐서 볼수 있습니다.
# * VIEW를 이용해서 query를 깔끔하게 수정하세요

create view city3 as 
	select city.countrycode, city.name as city_name , city.population, country.name
	from city
	join country
	on city.CountryCode = country.code
	having city.population >= 300 * 10000;


select city3.countrycode, 
	   city3.city_name,
       city3.population,
       city3.name,
       count(countrylanguage.language) as count,
       group_concat(language) as languages
from city3
join countrylanguage
on city3.CountryCode = countrylanguage.CountryCode
group by city3.countrycode, city3.city_name, city3.population
having count <= 3
order by population desc;



# Quiz 7. 한국와 미국의 인구와 GNP를 세로로 아래와 같이 나타내세요. (쿼리문에 국가 코드명을 문자열로 사용
# 해도 됩니다.)

select code, gnp, population
from country
where code = "KOR" or code = "USA";
    


# Quiz 8. sakila 데이터 베이스의 payment 테이블에서 수입(amount)의 총합을 아래와 같이 출력하세요.




create view pay1 as
select date_format(payment_date, "%Y-%m") as date,
sum(amount) as amount
from payment
group by date;

SELECT 
	sum(case when date='2005-05' then amount end) as '2005-05', 
	sum(case when date='2005-06' then amount end) as '2005-06', 
	sum(case when date='2005-07' then amount end) as '2005-07',
	sum(case when date='2005-08' then amount end) as '2005-08',
	sum(case when date='2006-02' then amount end) as '2006-02'  
FROM pay1;





# Quiz 9. 위의 결과에서 payment 테이블에서 월별 렌트 횟수 데이터를 추가하여 아래와 같이 출력하세요.



