# Estandarizar meses
ALTER TABLE tortilla_prices
MODIFY COLUMN month VARCHAR(20);

UPDATE tortilla_prices
SET month =
    CASE month
        WHEN 1 THEN 'January'
        WHEN 2 THEN 'February'
        WHEN 3 THEN 'March'
        WHEN 4 THEN 'April'
        WHEN 5 THEN 'May'
        WHEN 6 THEN 'June'
        WHEN 7 THEN 'July'
        WHEN 8 THEN 'August'
        WHEN 9 THEN 'September'
        WHEN 10 THEN 'October'
        WHEN 11 THEN 'November'
        WHEN 12 THEN 'December'
    END;

#Estandarizar estados
UPDATE tortilla_prices
SET state =
    CASE state
        WHEN 'D.F.' THEN 'CDMX'
        WHEN 'Edo. Mexico' THEN 'Estado de Mexico'
        ELSE state
    END;

#Crear prep tables
#crime
create table prep_mexico_crime as (
SELECT year, month, entity, type_of_crime, SUM(count) AS count_of_crimes
FROM mexico_crime
GROUP BY year, month, entity, type_of_crime);
select count(*) from prep_mexico_crime;

#tortilla
create table prep_tortilla_prices as (
select year, month, state, store_type, avg(price_per_kg) as tortilla_price from tortilla_prices
group by year, month, state, store_type);
select count(*)  from prep_tortilla_prices;

#Redonder decimales
UPDATE prep_tortilla_prices
SET tortilla_price = ROUND(tortilla_price, 2);

#Crear estructura de nueva table
#Estructura buscada: metric | state | year | Month | tortilla_price | store_type | count_of_crimes | type_of_crime
CREATE TABLE mexico_crime_and_tortilla (
	metric VARCHAR(255), 
    state VARCHAR(255),
    year INT,
    month VARCHAR(255),
    tortilla_price DECIMAL(10, 2),
    store_type VARCHAR(255),
    count_of_crimes INT,
    type_of_crime VARCHAR(255)
);

#Insertar data de crimes
INSERT INTO mexico_crime_and_tortilla (metric, state, year, month, tortilla_price, store_type, count_of_crimes, type_of_crime)
SELECT 'crimes', entity, year, month, 0 as tortilla_price, null as store_type, count_of_crimes, type_of_crime
FROM prep_mexico_crime;


#Insertar data de tortillas
INSERT INTO mexico_crime_and_tortilla (metric, state, year, month, tortilla_price, store_type, count_of_crimes, type_of_crime)
SELECT 'tortilla_prices', state, year, month, tortilla_price, store_type, 0 as count_of_crimes, null as type_of_crime
FROM prep_tortilla_prices;


select * from mexico_crime_and_tortilla;
