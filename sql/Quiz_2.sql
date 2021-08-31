# Quiz 1. 국가 코드별 도시의 갯수를 출력하세요. (상위 5개를 출력)
use world;

select countrycode, count(name) as count
from city
group by countrycode
order by count desc
limit 5;

# Quiz 2. 대륙별 몇개의 국가가 있는지 대륙별 국가의 갯수로 내림차순하여 출력하세요.

select continent, count(name) as count
from country
group by continent
order by count desc;

# Quiz 3. 대륙별 인구가 1000만명 이상인 국가의 수와 GNP의 평균을 소수 둘째 자리에서 
# 반올림하여 첫째자리까지 출력하세요.

select continent, count(name) as count, round(avg(gnp), 2) as avg_gnp
from country
where population >= 1000 * 10000
group by continent
order by avg_gnp desc;

# Quiz 4. city 테이블에서 국가코드(CountryCode) 별로 총인구가 몇명인지 조회하고
# 총인구순으로 내림차순하세요. (총인구가 5천만 이상인 도시만 출력)

select CountryCode, sum(population) as population
from city
group by CountryCode
having Population >= 5000 * 10000
order by Population desc;

# Quiz 5. countrylanguage 테이블에서 언어별 사용하는 국가수를 조회하고 많이 사용하는
# 언어를 6위에서 10위까지 조회하세요

select Language, count(CountryCode) as count
from countrylanguage
group by Language
order by count desc
limit 5, 5;

# Quiz 6. countrylanguage 테이블에서 언어별 20개 국가 이상에서 사용되는 언어를 조회하고
# 언어별 사용되는 국가수에 따라 내림차순하세요

select language, count(countrycode) as count
from countrylanguage
group by language
having count >= 20
order by count desc;


# Quiz 7. country 테이블에서 대륙별 전체 표면적크기를 구하고 표면적 크기 순으로 내림차순하세요.

select Continent, sum(SurfaceArea) as surfacearea
from country
group by Continent
order by surfacearea desc;

# Quiz 8. World 데이터 베이스의 countrylanguage에서 언어의 사용 비율이 
# 90%대(90 ~ 99.9)의 사용율을 갖는 언어의 갯수를 출력하세요. 
use world;

select count(distinct(language))
from countrylanguage
where Percentage between 90 and 99.9;

# Quiz 9. 1800년대에 독립한 국가의 수와 1900년대에 독립한 국가의수를 출력하세요

select  case
			when indepyear >= 1900  then 1900
            when indepyear >= 1800  then 1800
            else null
		end as indepyear_ages
        ,count(IndepYear) as count
from country
group by indepyear_ages
order by count desc
limit 2;

# Quiz 10. sakila의 payment 테이블에서 월별 총 수입을 출력하세요.

use sakila;
select date_format(payment_date, "%Y-%m") as pay_date, sum(amount)
from payment
group by pay_date;

# Quiz 11. actor 테이블에서 가장 많이 사용된 first_name을 아래와 같이 출력하세요. 
# * 가장 많이 사용된 first_name의 횟수를 먼저 구하고, 횟수를 Query에 넣어서 결과를 출력하세요.

select first_name, count(first_name) as count
from actor
group by first_name
having count = 4
order by first_name desc;




# Quiz 12. film_list 뷰에서 카테고리별 가장 많은 매출을 올린 카테고리 3개를 매출순으로 
# 정렬하여 아래와 같이 출력하세요.

select category, sum(price) as price
from film_list
group by category
order by price desc
limit 3;






select first_name, count(first_name) as count
from actor
group by first_name
order by count desc;

select first_name
from actor
group by first_name
having count(first_name)=4;



