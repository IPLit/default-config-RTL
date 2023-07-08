SELECT
 SUM(CASE WHEN p.gender='M' then 1 ELSE 0 END)     AS "Male",
 SUM(CASE WHEN p.gender='F' then 1 ELSE 0 END)     AS "Female",
 SUM(CASE WHEN p.gender='O' then 1 ELSE 0 END)     AS "Other",
 SUM(CASE WHEN p.gender='M' then 1 
     WHEN p.gender='F' then 1
     WHEN p.gender='O' then 1 ELSE 0 END)     AS "All"
FROM person_name pn
LEFT JOIN person p ON pn.person_id = p.person_id AND p.voided is FALSE AND p.dead=1
where cast(CONVERT_TZ(p.death_date,'+00:00','+5:30') AS DATE) BETWEEN '#startDate#' AND '#endDate#';
