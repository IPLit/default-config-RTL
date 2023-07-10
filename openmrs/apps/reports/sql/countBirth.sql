SELECT
 SUM(CASE WHEN o.concept_id=1965 and o.value_coded=1087 then 1 ELSE 0 END)     AS "Male",
 SUM(CASE WHEN o.concept_id=1965 and o.value_coded=1088 then 1 ELSE 0 END)     AS "Female",
 SUM(CASE WHEN o.concept_id=1965 and o.value_coded=3644 then 1 ELSE 0 END)     AS "Other",
 SUM(CASE WHEN o.concept_id=1965 and o.value_coded=1087 then 1 
     WHEN o.concept_id=1965 and o.value_coded=1088 then 1
     WHEN o.concept_id=1965 and o.value_coded=3644 then 1 ELSE 0 END)          AS "All"
FROM obs o
JOIN concept c ON c.concept_id = o.concept_id AND o.voided=0 and o.status='FINAL'
where cast(CONVERT_TZ(o.obs_datetime,'+00:00','+5:30') AS DATE) BETWEEN '#startDate#' AND '#endDate#';