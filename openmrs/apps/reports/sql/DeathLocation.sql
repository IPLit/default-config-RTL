SELECT
  DISTINCT(pi.identifier)                                                   AS "Patient Identifier",
  concat(pn.given_name, " ", ifnull(pn.family_name, ""))                    AS "Patient Name",
  floor(DATEDIFF(DATE(v.date_started), p.birthdate) / 365)                  AS "Age",
  DATE_FORMAT(p.birthdate, "%d-%b-%Y")                                      AS "Birthdate",
  p.gender                                                                  AS "Gender",
  va.value_reference                                                        AS "Admission Status",
  l.name                                                                    AS "Admission Location",
  cn.name                                                                   AS "cause of death",
  p.death_date                                                              AS "death date and time"
FROM visit v
  left outer join visit_attribute va on va.visit_id=v.visit_id and va.attribute_type_id=2
  left outer join visit_attribute va_location on va.visit_id=v.visit_id and va.attribute_type_id=3
  JOIN location l ON v.location_id = l.location_id AND l.retired IS FALSE
  JOIN visit_type vt ON v.visit_type_id = vt.visit_type_id
  JOIN person p ON p.person_id = v.patient_id AND p.voided is FALSE
  join concept_name cn ON cn.concept_id=p.cause_of_death
  JOIN patient_identifier pi ON p.person_id = pi.patient_id AND pi.voided is FALSE
  INNER JOIN patient_identifier_type pit ON pi.identifier_type = pit.patient_identifier_type_id AND
                                                 pit.name = 'Patient Identifier'
  JOIN person_name pn ON pn.person_id = p.person_id AND pn.voided is FALSE
  LEFT OUTER JOIN person_address paddress ON p.person_id = paddress.person_id AND paddress.voided is FALSE
  LEFT OUTER JOIN person_attribute pa ON pa.person_id = p.person_id AND pa.voided is FALSE
                                                                    AND pa.person_attribute_type_id=27
  LEFT OUTER JOIN person_attribute_type pat ON pat.person_attribute_type_id = pa.person_attribute_type_id AND pat.retired is FALSE
  WHERE v.voided is FALSE
  AND cast(CONVERT_TZ(v.date_started,'+00:00','+5:30') AS DATE) BETWEEN '#startDate#' AND '#endDate#' AND p.dead=1
GROUP BY p.death_date;
