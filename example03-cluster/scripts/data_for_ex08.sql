-- make sure the active db is dms_INE
use dms_INE;

-- see tables available
show tables;

-- exploratory selects to check the structure of tables
SELECT DISTINCT education_level  FROM education;

select DISTINCT type_labour from labour;

select * from education 

select * from labour l 

select * from production p 


-- make selects on the tables education, labour and production, for year 2019 and exclude rows with total categories

-- create a pivot table for the table education
select
		e.NutsID ,
		r.region_name , r.ParentCodeID, 
		sum( case when e.education_level = 'None' then e.value else null END) as e_none,
		sum( case when e.education_level = 'Basic' then e.value else NULL END) as e_basic,
		SUM( case when e.education_level = 'Secondary / post-secondary' then e.value else NULL END) as e_secondary,
		SUM( case when e.education_level = 'Superior' then e.value else NULL END) as e_superior
	from
		education e
	inner join region r on
		e.NutsID = r.NutsID
	where
		e.`year` = 2019
		and e.education_level <> 'Total'
		and r.`Level` = 5
	group by
		e.NutsID;
	
-- create a pivot table for labour
select
		e.NutsID ,
		sum( case when e.type_labour = 'Family labour force' then e.value else null END) as l_family,
		sum( case when e.type_labour = 'Holder' then e.value else NULL END) as l_holder,
		SUM( case when e.type_labour = 'Spouse' then e.value else NULL END) as l_spouse,
		SUM( case when e.type_labour = 'Other family members' then e.value else NULL END) as l_other_fam,
		SUM( case when e.type_labour = 'Regular' then e.value else NULL END) as l_regular,
		SUM( case when e.type_labour = 'Non-regular' then e.value else NULL END) as l_non_regular,
		SUM( case when e.type_labour = 'Workers not hired by the holder' then e.value else NULL END) as l_non_hired
	from
		labour e
	inner join region r on
		e.NutsID = r.NutsID
	where
		e.`year` = 2019
		and e.type_labour <> 'Total%'
		and r.`Level` = 5
	group by
		e.NutsID;

-- make the select for the table production
SELECT	p.NutsID, p.value_eur , p.area_ha FROM production p	WHERE p.`year` = 2019;

-- put everything togheter
-- and then joined using NutsID
SELECT
	edu.region_name AS freguesia,
	reg.region_name AS municipality,
	r3.region_name AS NUTS2,
	e_none,
	e_basic,
	e_secondary,
	e_superior,
	l_family,
	l_holder,
	l_spouse,
	l_other_fam,
	l_regular,
	l_non_regular,
	l_non_hired,
	value_eur,
	area_ha
FROM
	(
	select
		e.NutsID ,
		r.region_name , r.ParentCodeID, 
		sum( case when e.education_level = 'None' then e.value else null END) as e_none,
		sum( case when e.education_level = 'Basic' then e.value else NULL END) as e_basic,
		SUM( case when e.education_level = 'Secondary / post-secondary' then e.value else NULL END) as e_secondary,
		SUM( case when e.education_level = 'Superior' then e.value else NULL END) as e_superior
	from
		education e
	inner join region r on
		e.NutsID = r.NutsID
	where
		e.`year` = 2019
		and e.education_level <> 'Total'
		and r.`Level` = 5
	group by
		e.NutsID) as edu
INNER JOIN 
(
	select
		e.NutsID ,
		sum( case when e.type_labour = 'Family labour force' then e.value else null END) as l_family,
		sum( case when e.type_labour = 'Holder' then e.value else NULL END) as l_holder,
		SUM( case when e.type_labour = 'Spouse' then e.value else NULL END) as l_spouse,
		SUM( case when e.type_labour = 'Other family members' then e.value else NULL END) as l_other_fam,
		SUM( case when e.type_labour = 'Regular' then e.value else NULL END) as l_regular,
		SUM( case when e.type_labour = 'Non-regular' then e.value else NULL END) as l_non_regular,
		SUM( case when e.type_labour = 'Workers not hired by the holder' then e.value else NULL END) as l_non_hired
	from
		labour e
	inner join region r on
		e.NutsID = r.NutsID
	where
		e.`year` = 2019
		and e.type_labour <> 'Total%'
		and r.`Level` = 5
	group by
		e.NutsID) as lab ON
	edu.NutsID = lab.NutsID
INNER JOIN 
(
	SELECT
		p.NutsID,
		p.value_eur ,
		p.area_ha
	FROM
		production p
	WHERE
		p.`year` = 2019) AS prod
ON
	edu.NutsID = prod.NutsID
INNER JOIN region reg ON 
edu.ParentCodeID = reg.NutsID 
INNER JOIN region r2 ON
reg.ParentCodeID = r2.NutsID 
INNER JOIN region r3 ON
r2.ParentCodeID = r3.NutsID ;

