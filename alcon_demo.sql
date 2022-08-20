--Determine state which has the highest amount of taxes per person.
SELECT t.state_region, t.tax_name, round(t.taxes_collected/i.population,2） tax_per_person
FROM ustax t, usinfo i
WHERE tax_name = 'Total Taxes' AND t.state_code=i.state_code
ORDER BY tax_per_person DESC

--Determine state with the third largest amount of collected taxes.
SELECT state_region, tax_name, taxes_collected
FROM ustax
WHERE tax_name = 'Total Taxes'
ORDER BY taxes_collected DESC

--Name region with the smallest value of sum of "Individual Income Taxes" and "Income Taxes".
WITH ind_tax as(
SELECT region, tax_name, SUM(taxes_collected) sum_ind_tax
FROM ustax
WHERE tax_name = 'Individual Income Taxes'
GROUP BY region, tax_name
ORDER BY sum_ind_tax ASC
),

inc_tax as(
SELECT region, tax_name, SUM(taxes_collected) sum_inc_tax
FROM ustax
WHERE tax_name = 'Income Taxes'
GROUP BY region, tax_name
ORDER BY sum_inc_tax ASC
)

SELECT a.region, a.sum_ind_tax+b.sum_inc_tax sum_tax
FROM ind_tax a, inc_tax b
WHERE a.region=b.region
ORDER BY sum_tax ASC

--Calculate percent changes of personal consumption expenditures between 2018 and 2020 
--for each state and determine state and year with highest change (example: Florida 2018/2019)
SELECT state_region, ROUND(ABS((year2019-year2018)/year2018)*100,2) change_18_19
FROM usinfo
ORDER BY change_18_19 DESC

SELECT state_region, ROUND(ABS((year2020-year2019)/year2019)*100,2) change_19_20
FROM usinfo
ORDER BY change_19_20 DESC

--Determine Region with the highest average Personal Consumption Expenditures per person in 2020
SELECT region, ROUND(SUM(year2020)/SUM(population)*100,2) avg_consumption_per_100person
FROM usinfo
GROUP BY region
ORDER BY avg_consumption_per_100person DESC

--Ranking of regions based on average value of personal consumption expenditures per person.
SELECT region, ROUND(((SUM(year2018)+SUM(year2019)+SUM(year2020))/3)/SUM(population)*1000000,2) consumption_per_inDollor
FROM usinfo
GROUP BY region
ORDER BY consumption_per_inDollor DESC
