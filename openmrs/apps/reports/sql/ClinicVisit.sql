SELECT
  DISTINCT(pi.identifier)                                                   AS "Patient Identifier",
  concat(pn.given_name, " ", ifnull(pn.family_name, ""))                    AS "Patient Name",
  floor(DATEDIFF(DATE(v.date_started), p.birthdate) / 365)                  AS "Age",
  DATE_FORMAT(p.birthdate, "%d-%b-%Y")                                      AS "Birthdate",
  p.gender                                                                  AS "Gender",
  DATE_FORMAT(CONVERT_TZ(p.date_created,'+00:00','+5:30'), "%d-%b-%Y")      AS "Patient Created Date",
  vt.name                                                                   AS "Visit type",
  DATE_FORMAT(CONVERT_TZ(v.date_started,'+00:00','+5:30'), "%d-%b-%Y")      AS "Date started",
  DATE_FORMAT(CONVERT_TZ(v.date_stopped,'+00:00','+5:30'), "%d-%b-%Y")      AS "Date stopped",
  va.date_created                                                           AS "Date of Admission",
  if(va.value_reference = "Discharged", va.date_changed, NULL)              AS "Date of discharge",
  IF(DATE(v.date_started) = DATE(p.date_created),"Yes","No")                AS "New patient visit",
  paddress.address1                                                         AS "address1",
  va.value_reference                                                        AS "Admission Status",
  paddress.city_village                                                     AS "City/Village",
  va.visit_id                                                               AS "visit Id",
  CASE WHEN v.date_stopped IS NULL THEN "Active"
  ELSE "Inactive"
  END                                                                       AS "Visit Status"
FROM visit v
  join visit_attribute va on va.visit_id and va.attribute_type_id=2
  JOIN visit_type vt ON v.visit_type_id = vt.visit_type_id
  JOIN person p ON p.person_id = v.patient_id AND p.voided is FALSE
  JOIN patient_identifier pi ON p.person_id = pi.patient_id AND pi.voided is FALSE
  JOIN patient_identifier_type pit ON pi.identifier_type = pit.patient_identifier_type_id AND pit.retired is FALSE
  JOIN person_name pn ON pn.person_id = p.person_id AND pn.voided is FALSE
  LEFT OUTER JOIN person_address paddress ON p.person_id = paddress.person_id AND paddress.voided is FALSE
  LEFT OUTER JOIN person_attribute pa ON pa.person_id = p.person_id AND pa.voided is FALSE
  LEFT OUTER JOIN person_attribute_type pat ON pat.person_attribute_type_id = pa.person_attribute_type_id AND pat.retired is FALSE
  WHERE v.voided is FALSE
  AND cast(CONVERT_TZ(v.date_started,'+00:00','+5:30') AS DATE) BETWEEN '#startDate#' AND '#endDate#'
GROUP BY v.visit_id;
