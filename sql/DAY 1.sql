# CRUD : READ
# SELECT FROM
use world;

select *
from country;

select code, name, population
from country;

select code as country_code, name as country_name, population
from country;

/*show databases;
show tables;*/
-- desc country;

select code
#		,name
from country;

select code, name, gnp, gnp * 1000 as gnp_1000
from country;

select code, name, continent, continent = "Asia" as is_asia
from country;

SELECT 
    code,
    name,
    population,
    lifeExpectancy,
    (lifeExpectancy >= 70)
        AND (population >= 5000 * 10000)
FROM
    country;
    
    
    
# WHERE
# 인구가 1억 이상인 국가 출력
select code, name, population
from country
where population >= 10000 * 10000;


# 인구가 7천만 ~ 1억인 국가 출력
select code, name, population
from country
where (population <= 10000 * 10000) and (population >= 7000 * 10000);

# BETWEEN
select code, name, population
from country
where population between 7000*10000 and 10000*10000;

# 아시아와 아프리카 대륙의 국가 데이터를 출력
select code, name, continent,population
from country
where continent = "Asia" or continent = "Africa";

# IN, NOT IN
select code, name, continent,population
from country
where continent in ("Asia", "Africa");

select code, name, continent,population
from country
where continent not in ("Asia", "Africa");

# LIKE : 특정 문자열이 포함되어 있는 데이터를 출력

select code, name, localname
from country
where localname like "A%";

# ORDER BY : 데이터의 순서를 정렬
# 오름차수으로 인구수 순으로 국가의 데이터를 출력
select code, name, population
from country
order by population DESC;

select countrycode, name, population
from city
order by countrycode desc, population asc;

# LIMIT : 조회되는 데이터의 수를 제한
# 인구 상위 5개의 국가를 내림차순으로 출력
select code, name, population
from country
order by population desc
limit 5;



# 인구 상위 6위 ~ 8위까지의 국가를 내림차순으로 출력
select code, name, population
from country
order by population desc
limit 5, 3;   # 5개 스킴 밑으로 3개 출력

# DISTINCT : 중복을 제거해주는 예약어
# 도시의 인구가 800만 이상의 도시를 가지고 있는 국가의 국가 코드를 출력
select distinct countrycode
from city
where population >= 800 * 10000;

# Quiz : 한국(국가코드:KOR) 도시 중 인구수가 100만이 넘는 도시를 인구수 순으로 오름차순으로 정렬해서 출력

select name, countrycode,population
from city
where (countrycode = "KOR") and (population >= 100 * 10000)
order by population asc;






















