SELECT 
  DATE_FORMAT(sa.actual_start_datetime,'%d-%m-%Y %h:%i %p')                  AS 'Actual Start date & time',
  DATE_FORMAT(sa.actual_end_datetime,'%d-%m-%Y %h:%i %p')                    AS 'Actual End date & time',
  concat(l.name, '')                                                         AS 'Operation Theatre',
  concat(pi.identifier, '')                                                  AS 'Patient ID',
  concat(pn.given_name, ' ', ifnull(pn.family_name, ''))                     AS 'Patient Name',
  concat(pns.given_name, ' ', ifnull(pns.family_name, ''))                   AS 'Surgeon Name',
  concat(pno.given_name, ' ', ifnull(pno.family_name, ''))                   AS 'Other Surgeon',
  concat(sa_assistant.value, '')                                             AS 'Surgical Assistant',
  concat(sa_Anaesthetist.value, '')                                          AS 'Anaesthetist',
  concat(sa_Scrub.value, '')                                                 AS 'Scrub Nurse',
  concat(sa_Circulating.value, '')                                           AS 'Circulating Nurse',
  concat(sa.notes , '')                                                      AS 'Actual notes'
  FROM surgical_appointment sa
  LEFT JOIN surgical_appointment_attribute sa_timehrs on sa_timehrs.surgical_appointment_id = sa.surgical_appointment_id and sa_timehrs.surgical_appointment_attribute_type_id = 2
  LEFT JOIN surgical_appointment_attribute sa_timemint on sa_timemint.surgical_appointment_id = sa.surgical_appointment_id and sa_timemint.surgical_appointment_attribute_type_id = 3
  LEFT JOIN surgical_appointment_attribute sa_other_s on sa_other_s.surgical_appointment_id = sa.surgical_appointment_id and sa_other_s.surgical_appointment_attribute_type_id = 5
  LEFT JOIN surgical_appointment_attribute sa_assistant on sa_assistant.surgical_appointment_id = sa.surgical_appointment_id and sa_assistant.surgical_appointment_attribute_type_id = 6
  LEFT JOIN surgical_appointment_attribute sa_Anaesthetist on sa_Anaesthetist.surgical_appointment_id = sa.surgical_appointment_id and sa_Anaesthetist.surgical_appointment_attribute_type_id = 7
  LEFT JOIN surgical_appointment_attribute sa_Scrub on sa_Scrub.surgical_appointment_id = sa.surgical_appointment_id and sa_Scrub.surgical_appointment_attribute_type_id = 8
  LEFT JOIN surgical_appointment_attribute sa_Circulating on sa_Circulating.surgical_appointment_id = sa.surgical_appointment_id and sa_Circulating.surgical_appointment_attribute_type_id = 9
  JOIN surgical_block sb ON sb.surgical_block_id = sa.surgical_block_id AND sb.voided is false 
  JOIN person p ON p.person_id = sa.patient_id AND p.voided IS FALSE
  JOIN person_name pn ON pn.person_id = sa.patient_id AND pn.voided IS FALSE
  LEFT join provider pro_s ON pro_s.provider_id = sb.primary_provider_id
  LEFT JOIN person_name pns ON pns.person_id = pro_s.person_id AND pns.voided IS FALSE
  LEFT join provider pro_other_s ON pro_other_s.provider_id = sa_other_s.value
  LEFT JOIN person_name pno ON pno.person_id = pro_other_s.person_id AND pno.voided IS FALSE
  LEFT JOIN patient_identifier pi ON pi.patient_id = pn.person_id AND pi.voided IS FALSE
  INNER JOIN patient_identifier_type pit ON pi.identifier_type = pit.patient_identifier_type_id AND
                                                 pit.name = 'Patient Identifier'
  JOIN location l ON sb.location_id = l.location_id AND l.retired IS FALSE
       WHERE cast(CONVERT_TZ(sa.date_created,'+00:00','+5:30') AS DATE) BETWEEN '#startDate#' AND '#endDate#' AND sa.voided IS FALSE AND sa.status = 'COMPLETED'
        GROUP BY sa.surgical_appointment_id;
