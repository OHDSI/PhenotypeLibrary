CREATE TABLE #Codesets (
  codeset_id int NOT NULL,
  concept_id bigint NOT NULL
)
;

INSERT INTO #Codesets (codeset_id, concept_id)
SELECT 7 as codeset_id, c.concept_id FROM (select distinct I.concept_id FROM
( 
  select concept_id from @vocabulary_database_schema.CONCEPT where (concept_id in (1397141,1337620,1315411,44818489,40238188,955632,1318011,1367268,45892628,45775965,19100985,42903460,905078,1145571,40244266,43285052))
UNION  select c.concept_id
  from @vocabulary_database_schema.CONCEPT c
  join @vocabulary_database_schema.CONCEPT_ANCESTOR ca on c.concept_id = ca.descendant_concept_id
  WHERE c.invalid_reason is null
  and (ca.ancestor_concept_id in (1397141,1337620,1315411,44818489,40238188,955632,1318011,1367268,45892628,45775965,19100985,42903460,905078,1145571,40244266,43285052))

) I
) C UNION ALL 
SELECT 8 as codeset_id, c.concept_id FROM (select distinct I.concept_id FROM
( 
  select concept_id from @vocabulary_database_schema.CONCEPT where (concept_id in (4029715,2790569,2790570,2790572,2790571,2790566,2790565,2790567,2791105,2790847,2790843,2790845,2790844,2790848,2790846,2791106,2749093,2749095,2749097,2749099,2749101,40488450,2791109,2790853,2790849,2790851,2790850,2790854,2790852,2791108,2791074,2791072,2791073,2791594,2791595,2791597,2791596,2791591,2791590,2791592,2792088,2792084,2792086,2792085,2792089,2792087,2792355,2792094,2792090,2792092,2792091,2792095,2792093,2792356,4124880,4179064,2792336,2792334,2792335,4061549,4058775,4277939,4098879))

) I
LEFT JOIN
(
  select concept_id from @vocabulary_database_schema.CONCEPT where (concept_id in (35623447,4280568,4059385,4059384,42742549,42742550,42742551,4338745,4068538,37111538,4335177,4290270,4102130,4270754,4066316))
UNION  select c.concept_id
  from @vocabulary_database_schema.CONCEPT c
  join @vocabulary_database_schema.CONCEPT_ANCESTOR ca on c.concept_id = ca.descendant_concept_id
  WHERE c.invalid_reason is null
  and (ca.ancestor_concept_id in (35623447,4280568,4059385,4059384,42742549,42742550,42742551,4338745,4068538,37111538,4335177,4290270,4102130,4270754,4066316))

) E ON I.concept_id = E.concept_id
WHERE E.concept_id is null
) C UNION ALL 
SELECT 12 as codeset_id, c.concept_id FROM (select distinct I.concept_id FROM
( 
  select concept_id from @vocabulary_database_schema.CONCEPT where (concept_id in (21493971))

) I
) C UNION ALL 
SELECT 13 as codeset_id, c.concept_id FROM (select distinct I.concept_id FROM
( 
  select concept_id from @vocabulary_database_schema.CONCEPT where (concept_id in (21493970))

) I
) C UNION ALL 
SELECT 14 as codeset_id, c.concept_id FROM (select distinct I.concept_id FROM
( 
  select concept_id from @vocabulary_database_schema.CONCEPT where (concept_id in (21493969))

) I
) C UNION ALL 
SELECT 15 as codeset_id, c.concept_id FROM (select distinct I.concept_id FROM
( 
  select concept_id from @vocabulary_database_schema.CONCEPT where (concept_id in (21493968))

) I
) C UNION ALL 
SELECT 16 as codeset_id, c.concept_id FROM (select distinct I.concept_id FROM
( 
  select concept_id from @vocabulary_database_schema.CONCEPT where (concept_id in (21493972))

) I
) C UNION ALL 
SELECT 17 as codeset_id, c.concept_id FROM (select distinct I.concept_id FROM
( 
  select concept_id from @vocabulary_database_schema.CONCEPT where (concept_id in (35977040))

) I
) C UNION ALL 
SELECT 18 as codeset_id, c.concept_id FROM (select distinct I.concept_id FROM
( 
  select concept_id from @vocabulary_database_schema.CONCEPT where (concept_id in (35917471,35917835,35918368))

) I
) C UNION ALL 
SELECT 19 as codeset_id, c.concept_id FROM (select distinct I.concept_id FROM
( 
  select concept_id from @vocabulary_database_schema.CONCEPT where (concept_id in (42537577))

) I
) C UNION ALL 
SELECT 20 as codeset_id, c.concept_id FROM (select distinct I.concept_id FROM
( 
  select concept_id from @vocabulary_database_schema.CONCEPT where (concept_id in (3173676))

) I
) C UNION ALL 
SELECT 21 as codeset_id, c.concept_id FROM (select distinct I.concept_id FROM
( 
  select concept_id from @vocabulary_database_schema.CONCEPT where (concept_id in (35977041))

) I
) C UNION ALL 
SELECT 22 as codeset_id, c.concept_id FROM (select distinct I.concept_id FROM
( 
  select concept_id from @vocabulary_database_schema.CONCEPT where (concept_id in (443390))
UNION  select c.concept_id
  from @vocabulary_database_schema.CONCEPT c
  join @vocabulary_database_schema.CONCEPT_ANCESTOR ca on c.concept_id = ca.descendant_concept_id
  WHERE c.invalid_reason is null
  and (ca.ancestor_concept_id in (443390))

) I
LEFT JOIN
(
  select concept_id from @vocabulary_database_schema.CONCEPT where (concept_id in (4311439,432571,4300118,4102373,36536380,44500772,36544131,36567154,36715914,36554700,36554163,36563124,36555226,36533543,36522591,36549728,36564168,36523786,36525590,36564902,36527029,36555749,36548262,36543551,36533943,36540290,36536131,36518688,36544117,36518886,36544109,36517981,36554998,36549720,36542290,36530017,36517934,42512293,42511838,36534830,36517916,36526512,36527540,36560584,36542180,36562722,36538790,36562593,36526276,36533965,4283611,4289245,4289090,4289246,4289247,4289091,4289092,4289248,4283612,4289093,4289249,4289094,4283613,4289095,36522104,36525455,4311322,36543690,36538573,36541104,4171274,44500676,36565939,36565623,36533664,4180792,438699,4196256,442174))
UNION  select c.concept_id
  from @vocabulary_database_schema.CONCEPT c
  join @vocabulary_database_schema.CONCEPT_ANCESTOR ca on c.concept_id = ca.descendant_concept_id
  WHERE c.invalid_reason is null
  and (ca.ancestor_concept_id in (4311439,432571,4300118,4102373,36536380,44500772,36544131,36567154,36715914,36554700,36554163,36563124,36555226,36533543,36522591,36549728,36564168,36523786,36525590,36564902,36527029,36555749,36548262,36543551,36533943,36540290,36536131,36518688,36544117,36518886,36544109,36517981,36554998,36549720,36542290,36530017,36517934,42512293,42511838,36534830,36517916,36526512,36527540,36560584,36542180,36562722,36538790,36562593,36526276,36533965,4283611,4289245,4289090,4289246,4289247,4289091,4289092,4289248,4283612,4289093,4289249,4289094,4283613,4289095,36522104,36525455,4311322,36543690,36538573,36541104,4171274,44500676,36565939,36565623,36533664,4180792,438699,4196256,442174))

) E ON I.concept_id = E.concept_id
WHERE E.concept_id is null
) C UNION ALL 
SELECT 23 as codeset_id, c.concept_id FROM (select distinct I.concept_id FROM
( 
  select concept_id from @vocabulary_database_schema.CONCEPT where (concept_id in (37521056,45888910,2002969,2109157,4098879))
UNION  select c.concept_id
  from @vocabulary_database_schema.CONCEPT c
  join @vocabulary_database_schema.CONCEPT_ANCESTOR ca on c.concept_id = ca.descendant_concept_id
  WHERE c.invalid_reason is null
  and (ca.ancestor_concept_id in (37521056,45888910,2109157,4098879))

) I
LEFT JOIN
(
  select concept_id from @vocabulary_database_schema.CONCEPT where (concept_id in (4136782,4198190,4125436,4126235,4308819,4257890,2109209,4144719,2109216,4227266,2109122,4141227,4146476,4298165,4121239,4141228,4067932,4080163,2109450,4309197,4168529,4181781,37520956,4166761,4103380,4314569,4123406,45885771,37521041,4199870,37521038,2110180,2747308,2747310,2747314,2747312,4202223,4062763,4300501,4165586,2109163,2109162,40490505,40756915,40756981,2101766,2002964,4121233,2109725,4152086,4142326))
UNION  select c.concept_id
  from @vocabulary_database_schema.CONCEPT c
  join @vocabulary_database_schema.CONCEPT_ANCESTOR ca on c.concept_id = ca.descendant_concept_id
  WHERE c.invalid_reason is null
  and (ca.ancestor_concept_id in (4136782,4198190,4125436,4126235,4308819,4257890,2109209,4144719,2109216,4227266,2109122,4141227,4146476,4298165,4121239,4141228,4067932,4080163,2109450,4309197,4168529,4181781,37520956,4166761,4103380,4314569,4123406,45885771,37521041,4199870,37521038,2747308,2747310,2747314,2747312,4202223,4062763,4300501,4165586,2109163,2109162,40490505,40756915,40756981,2101766,2002964,4121233,2109725,4152086,4142326))

) E ON I.concept_id = E.concept_id
WHERE E.concept_id is null
) C;

UPDATE STATISTICS #Codesets;


SELECT event_id, person_id, start_date, end_date, op_start_date, op_end_date, visit_occurrence_id
INTO #qualified_events
FROM 
(
  select pe.event_id, pe.person_id, pe.start_date, pe.end_date, pe.op_start_date, pe.op_end_date, row_number() over (partition by pe.person_id order by pe.start_date ASC) as ordinal, cast(pe.visit_occurrence_id as bigint) as visit_occurrence_id
  FROM (-- Begin Primary Events
select P.ordinal as event_id, P.person_id, P.start_date, P.end_date, op_start_date, op_end_date, cast(P.visit_occurrence_id as bigint) as visit_occurrence_id
FROM
(
  select E.person_id, E.start_date, E.end_date,
         row_number() OVER (PARTITION BY E.person_id ORDER BY E.sort_date ASC, E.event_id) ordinal,
         OP.observation_period_start_date as op_start_date, OP.observation_period_end_date as op_end_date, cast(E.visit_occurrence_id as bigint) as visit_occurrence_id
  FROM 
  (
  select PE.person_id, PE.event_id, PE.start_date, PE.end_date, PE.visit_occurrence_id, PE.sort_date FROM (
-- Begin Condition Occurrence Criteria
SELECT C.person_id, C.condition_occurrence_id as event_id, C.start_date, C.end_date,
  C.visit_occurrence_id, C.start_date as sort_date
FROM 
(
  SELECT co.person_id,co.condition_occurrence_id,co.condition_concept_id,co.visit_occurrence_id,co.condition_start_date as start_date, COALESCE(co.condition_end_date, DATEADD(day,1,co.condition_start_date)) as end_date , row_number() over (PARTITION BY co.person_id ORDER BY co.condition_start_date, co.condition_occurrence_id) as ordinal
  FROM @cdm_database_schema.CONDITION_OCCURRENCE co
  JOIN #Codesets cs on (co.condition_concept_id = cs.concept_id and cs.codeset_id = 22)
) C

WHERE C.ordinal = 1
-- End Condition Occurrence Criteria

) PE
JOIN (
-- Begin Criteria Group
select 0 as index_id, person_id, event_id
FROM
(
  select E.person_id, E.event_id 
  FROM (SELECT Q.person_id, Q.event_id, Q.start_date, Q.end_date, Q.visit_occurrence_id, OP.observation_period_start_date as op_start_date, OP.observation_period_end_date as op_end_date
FROM (-- Begin Condition Occurrence Criteria
SELECT C.person_id, C.condition_occurrence_id as event_id, C.start_date, C.end_date,
  C.visit_occurrence_id, C.start_date as sort_date
FROM 
(
  SELECT co.person_id,co.condition_occurrence_id,co.condition_concept_id,co.visit_occurrence_id,co.condition_start_date as start_date, COALESCE(co.condition_end_date, DATEADD(day,1,co.condition_start_date)) as end_date , row_number() over (PARTITION BY co.person_id ORDER BY co.condition_start_date, co.condition_occurrence_id) as ordinal
  FROM @cdm_database_schema.CONDITION_OCCURRENCE co
  JOIN #Codesets cs on (co.condition_concept_id = cs.concept_id and cs.codeset_id = 22)
) C

WHERE C.ordinal = 1
-- End Condition Occurrence Criteria
) Q
JOIN @cdm_database_schema.OBSERVATION_PERIOD OP on Q.person_id = OP.person_id 
  and OP.observation_period_start_date <= Q.start_date and OP.observation_period_end_date >= Q.start_date
) E
  LEFT JOIN
  (
    -- Begin Correlated Criteria
select 0 as index_id, cc.person_id, cc.event_id
from (SELECT p.person_id, p.event_id 
FROM (SELECT Q.person_id, Q.event_id, Q.start_date, Q.end_date, Q.visit_occurrence_id, OP.observation_period_start_date as op_start_date, OP.observation_period_end_date as op_end_date
FROM (-- Begin Condition Occurrence Criteria
SELECT C.person_id, C.condition_occurrence_id as event_id, C.start_date, C.end_date,
  C.visit_occurrence_id, C.start_date as sort_date
FROM 
(
  SELECT co.person_id,co.condition_occurrence_id,co.condition_concept_id,co.visit_occurrence_id,co.condition_start_date as start_date, COALESCE(co.condition_end_date, DATEADD(day,1,co.condition_start_date)) as end_date , row_number() over (PARTITION BY co.person_id ORDER BY co.condition_start_date, co.condition_occurrence_id) as ordinal
  FROM @cdm_database_schema.CONDITION_OCCURRENCE co
  JOIN #Codesets cs on (co.condition_concept_id = cs.concept_id and cs.codeset_id = 22)
) C

WHERE C.ordinal = 1
-- End Condition Occurrence Criteria
) Q
JOIN @cdm_database_schema.OBSERVATION_PERIOD OP on Q.person_id = OP.person_id 
  and OP.observation_period_start_date <= Q.start_date and OP.observation_period_end_date >= Q.start_date
) P
JOIN (
  -- Begin Measurement Criteria
select C.person_id, C.measurement_id as event_id, C.start_date, C.end_date,
       C.visit_occurrence_id, C.start_date as sort_date
from 
(
  select m.person_id,m.measurement_id,m.measurement_concept_id,m.visit_occurrence_id,m.value_as_number,m.range_high,m.range_low,m.value_as_concept_id,m.measurement_date as start_date, DATEADD(day,1,m.measurement_date) as end_date 
  FROM @cdm_database_schema.MEASUREMENT m
JOIN #Codesets cs on (m.measurement_concept_id = cs.concept_id and cs.codeset_id = 12)
) C

WHERE C.value_as_concept_id in (36210129)
-- End Measurement Criteria

) A on A.person_id = P.person_id  AND A.START_DATE >= P.OP_START_DATE AND A.START_DATE <= P.OP_END_DATE AND A.START_DATE >= DATEADD(day,-7,P.START_DATE) AND A.START_DATE <= DATEADD(day,90,P.START_DATE) ) cc 
GROUP BY cc.person_id, cc.event_id
HAVING COUNT(cc.event_id) >= 1
-- End Correlated Criteria

UNION ALL
-- Begin Correlated Criteria
select 1 as index_id, cc.person_id, cc.event_id
from (SELECT p.person_id, p.event_id 
FROM (SELECT Q.person_id, Q.event_id, Q.start_date, Q.end_date, Q.visit_occurrence_id, OP.observation_period_start_date as op_start_date, OP.observation_period_end_date as op_end_date
FROM (-- Begin Condition Occurrence Criteria
SELECT C.person_id, C.condition_occurrence_id as event_id, C.start_date, C.end_date,
  C.visit_occurrence_id, C.start_date as sort_date
FROM 
(
  SELECT co.person_id,co.condition_occurrence_id,co.condition_concept_id,co.visit_occurrence_id,co.condition_start_date as start_date, COALESCE(co.condition_end_date, DATEADD(day,1,co.condition_start_date)) as end_date , row_number() over (PARTITION BY co.person_id ORDER BY co.condition_start_date, co.condition_occurrence_id) as ordinal
  FROM @cdm_database_schema.CONDITION_OCCURRENCE co
  JOIN #Codesets cs on (co.condition_concept_id = cs.concept_id and cs.codeset_id = 22)
) C

WHERE C.ordinal = 1
-- End Condition Occurrence Criteria
) Q
JOIN @cdm_database_schema.OBSERVATION_PERIOD OP on Q.person_id = OP.person_id 
  and OP.observation_period_start_date <= Q.start_date and OP.observation_period_end_date >= Q.start_date
) P
JOIN (
  -- Begin Measurement Criteria
select C.person_id, C.measurement_id as event_id, C.start_date, C.end_date,
       C.visit_occurrence_id, C.start_date as sort_date
from 
(
  select m.person_id,m.measurement_id,m.measurement_concept_id,m.visit_occurrence_id,m.value_as_number,m.range_high,m.range_low,m.value_as_concept_id,m.measurement_date as start_date, DATEADD(day,1,m.measurement_date) as end_date 
  FROM @cdm_database_schema.MEASUREMENT m
JOIN #Codesets cs on (m.measurement_concept_id = cs.concept_id and cs.codeset_id = 13)
) C

WHERE C.value_as_concept_id in (36210129)
-- End Measurement Criteria

) A on A.person_id = P.person_id  AND A.START_DATE >= P.OP_START_DATE AND A.START_DATE <= P.OP_END_DATE AND A.START_DATE >= DATEADD(day,-7,P.START_DATE) AND A.START_DATE <= DATEADD(day,90,P.START_DATE) ) cc 
GROUP BY cc.person_id, cc.event_id
HAVING COUNT(cc.event_id) >= 1
-- End Correlated Criteria

UNION ALL
-- Begin Correlated Criteria
select 2 as index_id, cc.person_id, cc.event_id
from (SELECT p.person_id, p.event_id 
FROM (SELECT Q.person_id, Q.event_id, Q.start_date, Q.end_date, Q.visit_occurrence_id, OP.observation_period_start_date as op_start_date, OP.observation_period_end_date as op_end_date
FROM (-- Begin Condition Occurrence Criteria
SELECT C.person_id, C.condition_occurrence_id as event_id, C.start_date, C.end_date,
  C.visit_occurrence_id, C.start_date as sort_date
FROM 
(
  SELECT co.person_id,co.condition_occurrence_id,co.condition_concept_id,co.visit_occurrence_id,co.condition_start_date as start_date, COALESCE(co.condition_end_date, DATEADD(day,1,co.condition_start_date)) as end_date , row_number() over (PARTITION BY co.person_id ORDER BY co.condition_start_date, co.condition_occurrence_id) as ordinal
  FROM @cdm_database_schema.CONDITION_OCCURRENCE co
  JOIN #Codesets cs on (co.condition_concept_id = cs.concept_id and cs.codeset_id = 22)
) C

WHERE C.ordinal = 1
-- End Condition Occurrence Criteria
) Q
JOIN @cdm_database_schema.OBSERVATION_PERIOD OP on Q.person_id = OP.person_id 
  and OP.observation_period_start_date <= Q.start_date and OP.observation_period_end_date >= Q.start_date
) P
JOIN (
  -- Begin Measurement Criteria
select C.person_id, C.measurement_id as event_id, C.start_date, C.end_date,
       C.visit_occurrence_id, C.start_date as sort_date
from 
(
  select m.person_id,m.measurement_id,m.measurement_concept_id,m.visit_occurrence_id,m.value_as_number,m.range_high,m.range_low,m.value_as_concept_id,m.measurement_date as start_date, DATEADD(day,1,m.measurement_date) as end_date 
  FROM @cdm_database_schema.MEASUREMENT m
JOIN #Codesets cs on (m.measurement_concept_id = cs.concept_id and cs.codeset_id = 14)
) C

WHERE C.value_as_concept_id in (36210129)
-- End Measurement Criteria

) A on A.person_id = P.person_id  AND A.START_DATE >= P.OP_START_DATE AND A.START_DATE <= P.OP_END_DATE AND A.START_DATE >= DATEADD(day,-7,P.START_DATE) AND A.START_DATE <= DATEADD(day,90,P.START_DATE) ) cc 
GROUP BY cc.person_id, cc.event_id
HAVING COUNT(cc.event_id) >= 1
-- End Correlated Criteria

UNION ALL
-- Begin Correlated Criteria
select 3 as index_id, cc.person_id, cc.event_id
from (SELECT p.person_id, p.event_id 
FROM (SELECT Q.person_id, Q.event_id, Q.start_date, Q.end_date, Q.visit_occurrence_id, OP.observation_period_start_date as op_start_date, OP.observation_period_end_date as op_end_date
FROM (-- Begin Condition Occurrence Criteria
SELECT C.person_id, C.condition_occurrence_id as event_id, C.start_date, C.end_date,
  C.visit_occurrence_id, C.start_date as sort_date
FROM 
(
  SELECT co.person_id,co.condition_occurrence_id,co.condition_concept_id,co.visit_occurrence_id,co.condition_start_date as start_date, COALESCE(co.condition_end_date, DATEADD(day,1,co.condition_start_date)) as end_date , row_number() over (PARTITION BY co.person_id ORDER BY co.condition_start_date, co.condition_occurrence_id) as ordinal
  FROM @cdm_database_schema.CONDITION_OCCURRENCE co
  JOIN #Codesets cs on (co.condition_concept_id = cs.concept_id and cs.codeset_id = 22)
) C

WHERE C.ordinal = 1
-- End Condition Occurrence Criteria
) Q
JOIN @cdm_database_schema.OBSERVATION_PERIOD OP on Q.person_id = OP.person_id 
  and OP.observation_period_start_date <= Q.start_date and OP.observation_period_end_date >= Q.start_date
) P
JOIN (
  -- Begin Measurement Criteria
select C.person_id, C.measurement_id as event_id, C.start_date, C.end_date,
       C.visit_occurrence_id, C.start_date as sort_date
from 
(
  select m.person_id,m.measurement_id,m.measurement_concept_id,m.visit_occurrence_id,m.value_as_number,m.range_high,m.range_low,m.value_as_concept_id,m.measurement_date as start_date, DATEADD(day,1,m.measurement_date) as end_date 
  FROM @cdm_database_schema.MEASUREMENT m
JOIN #Codesets cs on (m.measurement_concept_id = cs.concept_id and cs.codeset_id = 15)
) C

WHERE C.value_as_concept_id in (36210129)
-- End Measurement Criteria

) A on A.person_id = P.person_id  AND A.START_DATE >= P.OP_START_DATE AND A.START_DATE <= P.OP_END_DATE AND A.START_DATE >= DATEADD(day,-7,P.START_DATE) AND A.START_DATE <= DATEADD(day,90,P.START_DATE) ) cc 
GROUP BY cc.person_id, cc.event_id
HAVING COUNT(cc.event_id) >= 1
-- End Correlated Criteria

UNION ALL
-- Begin Correlated Criteria
select 4 as index_id, cc.person_id, cc.event_id
from (SELECT p.person_id, p.event_id 
FROM (SELECT Q.person_id, Q.event_id, Q.start_date, Q.end_date, Q.visit_occurrence_id, OP.observation_period_start_date as op_start_date, OP.observation_period_end_date as op_end_date
FROM (-- Begin Condition Occurrence Criteria
SELECT C.person_id, C.condition_occurrence_id as event_id, C.start_date, C.end_date,
  C.visit_occurrence_id, C.start_date as sort_date
FROM 
(
  SELECT co.person_id,co.condition_occurrence_id,co.condition_concept_id,co.visit_occurrence_id,co.condition_start_date as start_date, COALESCE(co.condition_end_date, DATEADD(day,1,co.condition_start_date)) as end_date , row_number() over (PARTITION BY co.person_id ORDER BY co.condition_start_date, co.condition_occurrence_id) as ordinal
  FROM @cdm_database_schema.CONDITION_OCCURRENCE co
  JOIN #Codesets cs on (co.condition_concept_id = cs.concept_id and cs.codeset_id = 22)
) C

WHERE C.ordinal = 1
-- End Condition Occurrence Criteria
) Q
JOIN @cdm_database_schema.OBSERVATION_PERIOD OP on Q.person_id = OP.person_id 
  and OP.observation_period_start_date <= Q.start_date and OP.observation_period_end_date >= Q.start_date
) P
JOIN (
  -- Begin Measurement Criteria
select C.person_id, C.measurement_id as event_id, C.start_date, C.end_date,
       C.visit_occurrence_id, C.start_date as sort_date
from 
(
  select m.person_id,m.measurement_id,m.measurement_concept_id,m.visit_occurrence_id,m.value_as_number,m.range_high,m.range_low,m.value_as_concept_id,m.measurement_date as start_date, DATEADD(day,1,m.measurement_date) as end_date 
  FROM @cdm_database_schema.MEASUREMENT m
JOIN #Codesets cs on (m.measurement_concept_id = cs.concept_id and cs.codeset_id = 16)
) C

WHERE C.value_as_concept_id in (21499079)
-- End Measurement Criteria

) A on A.person_id = P.person_id  AND A.START_DATE >= P.OP_START_DATE AND A.START_DATE <= P.OP_END_DATE AND A.START_DATE >= DATEADD(day,-7,P.START_DATE) AND A.START_DATE <= DATEADD(day,90,P.START_DATE) ) cc 
GROUP BY cc.person_id, cc.event_id
HAVING COUNT(cc.event_id) >= 1
-- End Correlated Criteria

UNION ALL
-- Begin Correlated Criteria
select 5 as index_id, cc.person_id, cc.event_id
from (SELECT p.person_id, p.event_id 
FROM (SELECT Q.person_id, Q.event_id, Q.start_date, Q.end_date, Q.visit_occurrence_id, OP.observation_period_start_date as op_start_date, OP.observation_period_end_date as op_end_date
FROM (-- Begin Condition Occurrence Criteria
SELECT C.person_id, C.condition_occurrence_id as event_id, C.start_date, C.end_date,
  C.visit_occurrence_id, C.start_date as sort_date
FROM 
(
  SELECT co.person_id,co.condition_occurrence_id,co.condition_concept_id,co.visit_occurrence_id,co.condition_start_date as start_date, COALESCE(co.condition_end_date, DATEADD(day,1,co.condition_start_date)) as end_date , row_number() over (PARTITION BY co.person_id ORDER BY co.condition_start_date, co.condition_occurrence_id) as ordinal
  FROM @cdm_database_schema.CONDITION_OCCURRENCE co
  JOIN #Codesets cs on (co.condition_concept_id = cs.concept_id and cs.codeset_id = 22)
) C

WHERE C.ordinal = 1
-- End Condition Occurrence Criteria
) Q
JOIN @cdm_database_schema.OBSERVATION_PERIOD OP on Q.person_id = OP.person_id 
  and OP.observation_period_start_date <= Q.start_date and OP.observation_period_end_date >= Q.start_date
) P
JOIN (
  -- Begin Measurement Criteria
select C.person_id, C.measurement_id as event_id, C.start_date, C.end_date,
       C.visit_occurrence_id, C.start_date as sort_date
from 
(
  select m.person_id,m.measurement_id,m.measurement_concept_id,m.visit_occurrence_id,m.value_as_number,m.range_high,m.range_low,m.measurement_date as start_date, DATEADD(day,1,m.measurement_date) as end_date 
  FROM @cdm_database_schema.MEASUREMENT m
JOIN #Codesets cs on (m.measurement_concept_id = cs.concept_id and cs.codeset_id = 17)
) C


-- End Measurement Criteria

) A on A.person_id = P.person_id  AND A.START_DATE >= P.OP_START_DATE AND A.START_DATE <= P.OP_END_DATE AND A.START_DATE >= DATEADD(day,-7,P.START_DATE) AND A.START_DATE <= DATEADD(day,90,P.START_DATE) ) cc 
GROUP BY cc.person_id, cc.event_id
HAVING COUNT(cc.event_id) >= 1
-- End Correlated Criteria

UNION ALL
-- Begin Correlated Criteria
select 6 as index_id, cc.person_id, cc.event_id
from (SELECT p.person_id, p.event_id 
FROM (SELECT Q.person_id, Q.event_id, Q.start_date, Q.end_date, Q.visit_occurrence_id, OP.observation_period_start_date as op_start_date, OP.observation_period_end_date as op_end_date
FROM (-- Begin Condition Occurrence Criteria
SELECT C.person_id, C.condition_occurrence_id as event_id, C.start_date, C.end_date,
  C.visit_occurrence_id, C.start_date as sort_date
FROM 
(
  SELECT co.person_id,co.condition_occurrence_id,co.condition_concept_id,co.visit_occurrence_id,co.condition_start_date as start_date, COALESCE(co.condition_end_date, DATEADD(day,1,co.condition_start_date)) as end_date , row_number() over (PARTITION BY co.person_id ORDER BY co.condition_start_date, co.condition_occurrence_id) as ordinal
  FROM @cdm_database_schema.CONDITION_OCCURRENCE co
  JOIN #Codesets cs on (co.condition_concept_id = cs.concept_id and cs.codeset_id = 22)
) C

WHERE C.ordinal = 1
-- End Condition Occurrence Criteria
) Q
JOIN @cdm_database_schema.OBSERVATION_PERIOD OP on Q.person_id = OP.person_id 
  and OP.observation_period_start_date <= Q.start_date and OP.observation_period_end_date >= Q.start_date
) P
JOIN (
  -- Begin Measurement Criteria
select C.person_id, C.measurement_id as event_id, C.start_date, C.end_date,
       C.visit_occurrence_id, C.start_date as sort_date
from 
(
  select m.person_id,m.measurement_id,m.measurement_concept_id,m.visit_occurrence_id,m.value_as_number,m.range_high,m.range_low,m.value_as_concept_id,m.measurement_date as start_date, DATEADD(day,1,m.measurement_date) as end_date 
  FROM @cdm_database_schema.MEASUREMENT m
JOIN #Codesets cs on (m.measurement_concept_id = cs.concept_id and cs.codeset_id = 18)
) C

WHERE C.value_as_concept_id in (35919051,35925319,35925626)
-- End Measurement Criteria

) A on A.person_id = P.person_id  AND A.START_DATE >= P.OP_START_DATE AND A.START_DATE <= P.OP_END_DATE AND A.START_DATE >= DATEADD(day,-7,P.START_DATE) AND A.START_DATE <= DATEADD(day,90,P.START_DATE) ) cc 
GROUP BY cc.person_id, cc.event_id
HAVING COUNT(cc.event_id) >= 1
-- End Correlated Criteria

UNION ALL
-- Begin Correlated Criteria
select 7 as index_id, cc.person_id, cc.event_id
from (SELECT p.person_id, p.event_id 
FROM (SELECT Q.person_id, Q.event_id, Q.start_date, Q.end_date, Q.visit_occurrence_id, OP.observation_period_start_date as op_start_date, OP.observation_period_end_date as op_end_date
FROM (-- Begin Condition Occurrence Criteria
SELECT C.person_id, C.condition_occurrence_id as event_id, C.start_date, C.end_date,
  C.visit_occurrence_id, C.start_date as sort_date
FROM 
(
  SELECT co.person_id,co.condition_occurrence_id,co.condition_concept_id,co.visit_occurrence_id,co.condition_start_date as start_date, COALESCE(co.condition_end_date, DATEADD(day,1,co.condition_start_date)) as end_date , row_number() over (PARTITION BY co.person_id ORDER BY co.condition_start_date, co.condition_occurrence_id) as ordinal
  FROM @cdm_database_schema.CONDITION_OCCURRENCE co
  JOIN #Codesets cs on (co.condition_concept_id = cs.concept_id and cs.codeset_id = 22)
) C

WHERE C.ordinal = 1
-- End Condition Occurrence Criteria
) Q
JOIN @cdm_database_schema.OBSERVATION_PERIOD OP on Q.person_id = OP.person_id 
  and OP.observation_period_start_date <= Q.start_date and OP.observation_period_end_date >= Q.start_date
) P
JOIN (
  -- Begin Condition Occurrence Criteria
SELECT C.person_id, C.condition_occurrence_id as event_id, C.start_date, C.end_date,
  C.visit_occurrence_id, C.start_date as sort_date
FROM 
(
  SELECT co.person_id,co.condition_occurrence_id,co.condition_concept_id,co.visit_occurrence_id,co.condition_start_date as start_date, COALESCE(co.condition_end_date, DATEADD(day,1,co.condition_start_date)) as end_date 
  FROM @cdm_database_schema.CONDITION_OCCURRENCE co
  JOIN #Codesets cs on (co.condition_concept_id = cs.concept_id and cs.codeset_id = 19)
) C


-- End Condition Occurrence Criteria

) A on A.person_id = P.person_id  AND A.START_DATE >= P.OP_START_DATE AND A.START_DATE <= P.OP_END_DATE AND A.START_DATE >= DATEADD(day,-7,P.START_DATE) AND A.START_DATE <= DATEADD(day,90,P.START_DATE) ) cc 
GROUP BY cc.person_id, cc.event_id
HAVING COUNT(cc.event_id) >= 1
-- End Correlated Criteria

UNION ALL
-- Begin Criteria Group
select 8 as index_id, person_id, event_id
FROM
(
  select E.person_id, E.event_id 
  FROM (SELECT Q.person_id, Q.event_id, Q.start_date, Q.end_date, Q.visit_occurrence_id, OP.observation_period_start_date as op_start_date, OP.observation_period_end_date as op_end_date
FROM (-- Begin Condition Occurrence Criteria
SELECT C.person_id, C.condition_occurrence_id as event_id, C.start_date, C.end_date,
  C.visit_occurrence_id, C.start_date as sort_date
FROM 
(
  SELECT co.person_id,co.condition_occurrence_id,co.condition_concept_id,co.visit_occurrence_id,co.condition_start_date as start_date, COALESCE(co.condition_end_date, DATEADD(day,1,co.condition_start_date)) as end_date , row_number() over (PARTITION BY co.person_id ORDER BY co.condition_start_date, co.condition_occurrence_id) as ordinal
  FROM @cdm_database_schema.CONDITION_OCCURRENCE co
  JOIN #Codesets cs on (co.condition_concept_id = cs.concept_id and cs.codeset_id = 22)
) C

WHERE C.ordinal = 1
-- End Condition Occurrence Criteria
) Q
JOIN @cdm_database_schema.OBSERVATION_PERIOD OP on Q.person_id = OP.person_id 
  and OP.observation_period_start_date <= Q.start_date and OP.observation_period_end_date >= Q.start_date
) E
  INNER JOIN
  (
    -- Begin Correlated Criteria
select 0 as index_id, cc.person_id, cc.event_id
from (SELECT p.person_id, p.event_id 
FROM (SELECT Q.person_id, Q.event_id, Q.start_date, Q.end_date, Q.visit_occurrence_id, OP.observation_period_start_date as op_start_date, OP.observation_period_end_date as op_end_date
FROM (-- Begin Condition Occurrence Criteria
SELECT C.person_id, C.condition_occurrence_id as event_id, C.start_date, C.end_date,
  C.visit_occurrence_id, C.start_date as sort_date
FROM 
(
  SELECT co.person_id,co.condition_occurrence_id,co.condition_concept_id,co.visit_occurrence_id,co.condition_start_date as start_date, COALESCE(co.condition_end_date, DATEADD(day,1,co.condition_start_date)) as end_date , row_number() over (PARTITION BY co.person_id ORDER BY co.condition_start_date, co.condition_occurrence_id) as ordinal
  FROM @cdm_database_schema.CONDITION_OCCURRENCE co
  JOIN #Codesets cs on (co.condition_concept_id = cs.concept_id and cs.codeset_id = 22)
) C

WHERE C.ordinal = 1
-- End Condition Occurrence Criteria
) Q
JOIN @cdm_database_schema.OBSERVATION_PERIOD OP on Q.person_id = OP.person_id 
  and OP.observation_period_start_date <= Q.start_date and OP.observation_period_end_date >= Q.start_date
) P
JOIN (
  -- Begin Measurement Criteria
select C.person_id, C.measurement_id as event_id, C.start_date, C.end_date,
       C.visit_occurrence_id, C.start_date as sort_date
from 
(
  select m.person_id,m.measurement_id,m.measurement_concept_id,m.visit_occurrence_id,m.value_as_number,m.range_high,m.range_low,m.value_as_concept_id,m.measurement_date as start_date, DATEADD(day,1,m.measurement_date) as end_date 
  FROM @cdm_database_schema.MEASUREMENT m
JOIN #Codesets cs on (m.measurement_concept_id = cs.concept_id and cs.codeset_id = 15)
) C

WHERE C.value_as_concept_id in (36210092)
-- End Measurement Criteria

) A on A.person_id = P.person_id  AND A.START_DATE >= P.OP_START_DATE AND A.START_DATE <= P.OP_END_DATE AND A.START_DATE >= DATEADD(day,-7,P.START_DATE) AND A.START_DATE <= DATEADD(day,90,P.START_DATE) ) cc 
GROUP BY cc.person_id, cc.event_id
HAVING COUNT(cc.event_id) >= 1
-- End Correlated Criteria

UNION ALL
-- Begin Correlated Criteria
select 1 as index_id, cc.person_id, cc.event_id
from (SELECT p.person_id, p.event_id 
FROM (SELECT Q.person_id, Q.event_id, Q.start_date, Q.end_date, Q.visit_occurrence_id, OP.observation_period_start_date as op_start_date, OP.observation_period_end_date as op_end_date
FROM (-- Begin Condition Occurrence Criteria
SELECT C.person_id, C.condition_occurrence_id as event_id, C.start_date, C.end_date,
  C.visit_occurrence_id, C.start_date as sort_date
FROM 
(
  SELECT co.person_id,co.condition_occurrence_id,co.condition_concept_id,co.visit_occurrence_id,co.condition_start_date as start_date, COALESCE(co.condition_end_date, DATEADD(day,1,co.condition_start_date)) as end_date , row_number() over (PARTITION BY co.person_id ORDER BY co.condition_start_date, co.condition_occurrence_id) as ordinal
  FROM @cdm_database_schema.CONDITION_OCCURRENCE co
  JOIN #Codesets cs on (co.condition_concept_id = cs.concept_id and cs.codeset_id = 22)
) C

WHERE C.ordinal = 1
-- End Condition Occurrence Criteria
) Q
JOIN @cdm_database_schema.OBSERVATION_PERIOD OP on Q.person_id = OP.person_id 
  and OP.observation_period_start_date <= Q.start_date and OP.observation_period_end_date >= Q.start_date
) P
JOIN (
  -- Begin Measurement Criteria
select C.person_id, C.measurement_id as event_id, C.start_date, C.end_date,
       C.visit_occurrence_id, C.start_date as sort_date
from 
(
  select m.person_id,m.measurement_id,m.measurement_concept_id,m.visit_occurrence_id,m.value_as_number,m.range_high,m.range_low,m.value_as_concept_id,m.measurement_date as start_date, DATEADD(day,1,m.measurement_date) as end_date 
  FROM @cdm_database_schema.MEASUREMENT m
JOIN #Codesets cs on (m.measurement_concept_id = cs.concept_id and cs.codeset_id = 14)
) C

WHERE C.value_as_concept_id in (36210092)
-- End Measurement Criteria

) A on A.person_id = P.person_id  AND A.START_DATE >= P.OP_START_DATE AND A.START_DATE <= P.OP_END_DATE AND A.START_DATE >= DATEADD(day,-7,P.START_DATE) AND A.START_DATE <= DATEADD(day,90,P.START_DATE) ) cc 
GROUP BY cc.person_id, cc.event_id
HAVING COUNT(cc.event_id) >= 1
-- End Correlated Criteria

UNION ALL
-- Begin Correlated Criteria
select 2 as index_id, cc.person_id, cc.event_id
from (SELECT p.person_id, p.event_id 
FROM (SELECT Q.person_id, Q.event_id, Q.start_date, Q.end_date, Q.visit_occurrence_id, OP.observation_period_start_date as op_start_date, OP.observation_period_end_date as op_end_date
FROM (-- Begin Condition Occurrence Criteria
SELECT C.person_id, C.condition_occurrence_id as event_id, C.start_date, C.end_date,
  C.visit_occurrence_id, C.start_date as sort_date
FROM 
(
  SELECT co.person_id,co.condition_occurrence_id,co.condition_concept_id,co.visit_occurrence_id,co.condition_start_date as start_date, COALESCE(co.condition_end_date, DATEADD(day,1,co.condition_start_date)) as end_date , row_number() over (PARTITION BY co.person_id ORDER BY co.condition_start_date, co.condition_occurrence_id) as ordinal
  FROM @cdm_database_schema.CONDITION_OCCURRENCE co
  JOIN #Codesets cs on (co.condition_concept_id = cs.concept_id and cs.codeset_id = 22)
) C

WHERE C.ordinal = 1
-- End Condition Occurrence Criteria
) Q
JOIN @cdm_database_schema.OBSERVATION_PERIOD OP on Q.person_id = OP.person_id 
  and OP.observation_period_start_date <= Q.start_date and OP.observation_period_end_date >= Q.start_date
) P
JOIN (
  -- Begin Measurement Criteria
select C.person_id, C.measurement_id as event_id, C.start_date, C.end_date,
       C.visit_occurrence_id, C.start_date as sort_date
from 
(
  select m.person_id,m.measurement_id,m.measurement_concept_id,m.visit_occurrence_id,m.value_as_number,m.range_high,m.range_low,m.value_as_concept_id,m.measurement_date as start_date, DATEADD(day,1,m.measurement_date) as end_date 
  FROM @cdm_database_schema.MEASUREMENT m
JOIN #Codesets cs on (m.measurement_concept_id = cs.concept_id and cs.codeset_id = 13)
) C

WHERE C.value_as_concept_id in (36210092)
-- End Measurement Criteria

) A on A.person_id = P.person_id  AND A.START_DATE >= P.OP_START_DATE AND A.START_DATE <= P.OP_END_DATE AND A.START_DATE >= DATEADD(day,-7,P.START_DATE) AND A.START_DATE <= DATEADD(day,90,P.START_DATE) ) cc 
GROUP BY cc.person_id, cc.event_id
HAVING COUNT(cc.event_id) >= 1
-- End Correlated Criteria

UNION ALL
-- Begin Correlated Criteria
select 3 as index_id, cc.person_id, cc.event_id
from (SELECT p.person_id, p.event_id 
FROM (SELECT Q.person_id, Q.event_id, Q.start_date, Q.end_date, Q.visit_occurrence_id, OP.observation_period_start_date as op_start_date, OP.observation_period_end_date as op_end_date
FROM (-- Begin Condition Occurrence Criteria
SELECT C.person_id, C.condition_occurrence_id as event_id, C.start_date, C.end_date,
  C.visit_occurrence_id, C.start_date as sort_date
FROM 
(
  SELECT co.person_id,co.condition_occurrence_id,co.condition_concept_id,co.visit_occurrence_id,co.condition_start_date as start_date, COALESCE(co.condition_end_date, DATEADD(day,1,co.condition_start_date)) as end_date , row_number() over (PARTITION BY co.person_id ORDER BY co.condition_start_date, co.condition_occurrence_id) as ordinal
  FROM @cdm_database_schema.CONDITION_OCCURRENCE co
  JOIN #Codesets cs on (co.condition_concept_id = cs.concept_id and cs.codeset_id = 22)
) C

WHERE C.ordinal = 1
-- End Condition Occurrence Criteria
) Q
JOIN @cdm_database_schema.OBSERVATION_PERIOD OP on Q.person_id = OP.person_id 
  and OP.observation_period_start_date <= Q.start_date and OP.observation_period_end_date >= Q.start_date
) P
JOIN (
  -- Begin Measurement Criteria
select C.person_id, C.measurement_id as event_id, C.start_date, C.end_date,
       C.visit_occurrence_id, C.start_date as sort_date
from 
(
  select m.person_id,m.measurement_id,m.measurement_concept_id,m.visit_occurrence_id,m.value_as_number,m.range_high,m.range_low,m.value_as_concept_id,m.measurement_date as start_date, DATEADD(day,1,m.measurement_date) as end_date 
  FROM @cdm_database_schema.MEASUREMENT m
JOIN #Codesets cs on (m.measurement_concept_id = cs.concept_id and cs.codeset_id = 12)
) C

WHERE C.value_as_concept_id in (36210092)
-- End Measurement Criteria

) A on A.person_id = P.person_id  AND A.START_DATE >= P.OP_START_DATE AND A.START_DATE <= P.OP_END_DATE AND A.START_DATE >= DATEADD(day,-7,P.START_DATE) AND A.START_DATE <= DATEADD(day,90,P.START_DATE) ) cc 
GROUP BY cc.person_id, cc.event_id
HAVING COUNT(cc.event_id) >= 1
-- End Correlated Criteria

UNION ALL
-- Begin Correlated Criteria
select 4 as index_id, cc.person_id, cc.event_id
from (SELECT p.person_id, p.event_id 
FROM (SELECT Q.person_id, Q.event_id, Q.start_date, Q.end_date, Q.visit_occurrence_id, OP.observation_period_start_date as op_start_date, OP.observation_period_end_date as op_end_date
FROM (-- Begin Condition Occurrence Criteria
SELECT C.person_id, C.condition_occurrence_id as event_id, C.start_date, C.end_date,
  C.visit_occurrence_id, C.start_date as sort_date
FROM 
(
  SELECT co.person_id,co.condition_occurrence_id,co.condition_concept_id,co.visit_occurrence_id,co.condition_start_date as start_date, COALESCE(co.condition_end_date, DATEADD(day,1,co.condition_start_date)) as end_date , row_number() over (PARTITION BY co.person_id ORDER BY co.condition_start_date, co.condition_occurrence_id) as ordinal
  FROM @cdm_database_schema.CONDITION_OCCURRENCE co
  JOIN #Codesets cs on (co.condition_concept_id = cs.concept_id and cs.codeset_id = 22)
) C

WHERE C.ordinal = 1
-- End Condition Occurrence Criteria
) Q
JOIN @cdm_database_schema.OBSERVATION_PERIOD OP on Q.person_id = OP.person_id 
  and OP.observation_period_start_date <= Q.start_date and OP.observation_period_end_date >= Q.start_date
) P
JOIN (
  -- Begin Measurement Criteria
select C.person_id, C.measurement_id as event_id, C.start_date, C.end_date,
       C.visit_occurrence_id, C.start_date as sort_date
from 
(
  select m.person_id,m.measurement_id,m.measurement_concept_id,m.visit_occurrence_id,m.value_as_number,m.range_high,m.range_low,m.value_as_concept_id,m.measurement_date as start_date, DATEADD(day,1,m.measurement_date) as end_date 
  FROM @cdm_database_schema.MEASUREMENT m
JOIN #Codesets cs on (m.measurement_concept_id = cs.concept_id and cs.codeset_id = 16)
) C

WHERE C.value_as_concept_id in (45879403,45881795,21498576)
-- End Measurement Criteria

) A on A.person_id = P.person_id  AND A.START_DATE >= P.OP_START_DATE AND A.START_DATE <= P.OP_END_DATE AND A.START_DATE >= DATEADD(day,-7,P.START_DATE) AND A.START_DATE <= DATEADD(day,90,P.START_DATE) ) cc 
GROUP BY cc.person_id, cc.event_id
HAVING COUNT(cc.event_id) >= 1
-- End Correlated Criteria

UNION ALL
-- Begin Correlated Criteria
select 5 as index_id, cc.person_id, cc.event_id
from (SELECT p.person_id, p.event_id 
FROM (SELECT Q.person_id, Q.event_id, Q.start_date, Q.end_date, Q.visit_occurrence_id, OP.observation_period_start_date as op_start_date, OP.observation_period_end_date as op_end_date
FROM (-- Begin Condition Occurrence Criteria
SELECT C.person_id, C.condition_occurrence_id as event_id, C.start_date, C.end_date,
  C.visit_occurrence_id, C.start_date as sort_date
FROM 
(
  SELECT co.person_id,co.condition_occurrence_id,co.condition_concept_id,co.visit_occurrence_id,co.condition_start_date as start_date, COALESCE(co.condition_end_date, DATEADD(day,1,co.condition_start_date)) as end_date , row_number() over (PARTITION BY co.person_id ORDER BY co.condition_start_date, co.condition_occurrence_id) as ordinal
  FROM @cdm_database_schema.CONDITION_OCCURRENCE co
  JOIN #Codesets cs on (co.condition_concept_id = cs.concept_id and cs.codeset_id = 22)
) C

WHERE C.ordinal = 1
-- End Condition Occurrence Criteria
) Q
JOIN @cdm_database_schema.OBSERVATION_PERIOD OP on Q.person_id = OP.person_id 
  and OP.observation_period_start_date <= Q.start_date and OP.observation_period_end_date >= Q.start_date
) P
JOIN (
  -- Begin Measurement Criteria
select C.person_id, C.measurement_id as event_id, C.start_date, C.end_date,
       C.visit_occurrence_id, C.start_date as sort_date
from 
(
  select m.person_id,m.measurement_id,m.measurement_concept_id,m.visit_occurrence_id,m.value_as_number,m.range_high,m.range_low,m.value_as_concept_id,m.measurement_date as start_date, DATEADD(day,1,m.measurement_date) as end_date 
  FROM @cdm_database_schema.MEASUREMENT m
JOIN #Codesets cs on (m.measurement_concept_id = cs.concept_id and cs.codeset_id = 18)
) C

WHERE C.value_as_concept_id in (35919389,35919449,35924647,35939269,35935438,35936847)
-- End Measurement Criteria

) A on A.person_id = P.person_id  AND A.START_DATE >= P.OP_START_DATE AND A.START_DATE <= P.OP_END_DATE AND A.START_DATE >= DATEADD(day,-7,P.START_DATE) AND A.START_DATE <= DATEADD(day,90,P.START_DATE) ) cc 
GROUP BY cc.person_id, cc.event_id
HAVING COUNT(cc.event_id) >= 1
-- End Correlated Criteria

UNION ALL
-- Begin Correlated Criteria
select 6 as index_id, cc.person_id, cc.event_id
from (SELECT p.person_id, p.event_id 
FROM (SELECT Q.person_id, Q.event_id, Q.start_date, Q.end_date, Q.visit_occurrence_id, OP.observation_period_start_date as op_start_date, OP.observation_period_end_date as op_end_date
FROM (-- Begin Condition Occurrence Criteria
SELECT C.person_id, C.condition_occurrence_id as event_id, C.start_date, C.end_date,
  C.visit_occurrence_id, C.start_date as sort_date
FROM 
(
  SELECT co.person_id,co.condition_occurrence_id,co.condition_concept_id,co.visit_occurrence_id,co.condition_start_date as start_date, COALESCE(co.condition_end_date, DATEADD(day,1,co.condition_start_date)) as end_date , row_number() over (PARTITION BY co.person_id ORDER BY co.condition_start_date, co.condition_occurrence_id) as ordinal
  FROM @cdm_database_schema.CONDITION_OCCURRENCE co
  JOIN #Codesets cs on (co.condition_concept_id = cs.concept_id and cs.codeset_id = 22)
) C

WHERE C.ordinal = 1
-- End Condition Occurrence Criteria
) Q
JOIN @cdm_database_schema.OBSERVATION_PERIOD OP on Q.person_id = OP.person_id 
  and OP.observation_period_start_date <= Q.start_date and OP.observation_period_end_date >= Q.start_date
) P
JOIN (
  -- Begin Measurement Criteria
select C.person_id, C.measurement_id as event_id, C.start_date, C.end_date,
       C.visit_occurrence_id, C.start_date as sort_date
from 
(
  select m.person_id,m.measurement_id,m.measurement_concept_id,m.visit_occurrence_id,m.value_as_number,m.range_high,m.range_low,m.measurement_date as start_date, DATEADD(day,1,m.measurement_date) as end_date 
  FROM @cdm_database_schema.MEASUREMENT m
JOIN #Codesets cs on (m.measurement_concept_id = cs.concept_id and cs.codeset_id = 21)
) C


-- End Measurement Criteria

) A on A.person_id = P.person_id  AND A.START_DATE >= P.OP_START_DATE AND A.START_DATE <= P.OP_END_DATE AND A.START_DATE >= DATEADD(day,-7,P.START_DATE) AND A.START_DATE <= DATEADD(day,90,P.START_DATE) ) cc 
GROUP BY cc.person_id, cc.event_id
HAVING COUNT(cc.event_id) >= 1
-- End Correlated Criteria

UNION ALL
-- Begin Correlated Criteria
select 7 as index_id, cc.person_id, cc.event_id
from (SELECT p.person_id, p.event_id 
FROM (SELECT Q.person_id, Q.event_id, Q.start_date, Q.end_date, Q.visit_occurrence_id, OP.observation_period_start_date as op_start_date, OP.observation_period_end_date as op_end_date
FROM (-- Begin Condition Occurrence Criteria
SELECT C.person_id, C.condition_occurrence_id as event_id, C.start_date, C.end_date,
  C.visit_occurrence_id, C.start_date as sort_date
FROM 
(
  SELECT co.person_id,co.condition_occurrence_id,co.condition_concept_id,co.visit_occurrence_id,co.condition_start_date as start_date, COALESCE(co.condition_end_date, DATEADD(day,1,co.condition_start_date)) as end_date , row_number() over (PARTITION BY co.person_id ORDER BY co.condition_start_date, co.condition_occurrence_id) as ordinal
  FROM @cdm_database_schema.CONDITION_OCCURRENCE co
  JOIN #Codesets cs on (co.condition_concept_id = cs.concept_id and cs.codeset_id = 22)
) C

WHERE C.ordinal = 1
-- End Condition Occurrence Criteria
) Q
JOIN @cdm_database_schema.OBSERVATION_PERIOD OP on Q.person_id = OP.person_id 
  and OP.observation_period_start_date <= Q.start_date and OP.observation_period_end_date >= Q.start_date
) P
JOIN (
  -- Begin Condition Occurrence Criteria
SELECT C.person_id, C.condition_occurrence_id as event_id, C.start_date, C.end_date,
  C.visit_occurrence_id, C.start_date as sort_date
FROM 
(
  SELECT co.person_id,co.condition_occurrence_id,co.condition_concept_id,co.visit_occurrence_id,co.condition_start_date as start_date, COALESCE(co.condition_end_date, DATEADD(day,1,co.condition_start_date)) as end_date 
  FROM @cdm_database_schema.CONDITION_OCCURRENCE co
  JOIN #Codesets cs on (co.condition_concept_id = cs.concept_id and cs.codeset_id = 20)
) C


-- End Condition Occurrence Criteria

) A on A.person_id = P.person_id  AND A.START_DATE >= P.OP_START_DATE AND A.START_DATE <= P.OP_END_DATE AND A.START_DATE >= DATEADD(day,-7,P.START_DATE) AND A.START_DATE <= DATEADD(day,90,P.START_DATE) ) cc 
GROUP BY cc.person_id, cc.event_id
HAVING COUNT(cc.event_id) >= 1
-- End Correlated Criteria

  ) CQ on E.person_id = CQ.person_id and E.event_id = CQ.event_id
  GROUP BY E.person_id, E.event_id
  HAVING COUNT(index_id) > 0
) G
-- End Criteria Group

  ) CQ on E.person_id = CQ.person_id and E.event_id = CQ.event_id
  GROUP BY E.person_id, E.event_id
  HAVING COUNT(index_id) <= 0
) G
-- End Criteria Group
) AC on AC.person_id = pe.person_id and AC.event_id = pe.event_id

  ) E
	JOIN @cdm_database_schema.observation_period OP on E.person_id = OP.person_id and E.start_date >=  OP.observation_period_start_date and E.start_date <= op.observation_period_end_date
  WHERE DATEADD(day,365,OP.OBSERVATION_PERIOD_START_DATE) <= E.START_DATE AND DATEADD(day,0,E.START_DATE) <= OP.OBSERVATION_PERIOD_END_DATE
) P
WHERE P.ordinal = 1
-- End Primary Events
) pe
  
) QE

;

--- Inclusion Rule Inserts

select 0 as inclusion_rule_id, person_id, event_id
INTO #Inclusion_0
FROM 
(
  select pe.person_id, pe.event_id
  FROM #qualified_events pe
  
JOIN (
-- Begin Criteria Group
select 0 as index_id, person_id, event_id
FROM
(
  select E.person_id, E.event_id 
  FROM #qualified_events E
  LEFT JOIN
  (
    -- Begin Correlated Criteria
select 0 as index_id, cc.person_id, cc.event_id
from (SELECT p.person_id, p.event_id 
FROM #qualified_events P
JOIN (
  -- Begin Drug Exposure Criteria
select C.person_id, C.drug_exposure_id as event_id, C.start_date, C.end_date,
  C.visit_occurrence_id,C.start_date as sort_date
from 
(
  select de.person_id,de.drug_exposure_id,de.drug_concept_id,de.visit_occurrence_id,days_supply,quantity,refills,de.drug_exposure_start_date as start_date, COALESCE(de.drug_exposure_end_date, DATEADD(day,de.days_supply,de.drug_exposure_start_date), DATEADD(day,1,de.drug_exposure_start_date)) as end_date 
  FROM @cdm_database_schema.DRUG_EXPOSURE de
JOIN #Codesets cs on (de.drug_concept_id = cs.concept_id and cs.codeset_id = 7)
) C


-- End Drug Exposure Criteria

) A on A.person_id = P.person_id  AND A.START_DATE >= P.OP_START_DATE AND A.START_DATE <= P.OP_END_DATE AND A.START_DATE >= DATEADD(day,-180,P.START_DATE) AND A.START_DATE <= P.OP_END_DATE ) cc 
GROUP BY cc.person_id, cc.event_id
HAVING COUNT(cc.event_id) >= 1
-- End Correlated Criteria

  ) CQ on E.person_id = CQ.person_id and E.event_id = CQ.event_id
  GROUP BY E.person_id, E.event_id
  HAVING COUNT(index_id) <= 0
) G
-- End Criteria Group
) AC on AC.person_id = pe.person_id AND AC.event_id = pe.event_id
) Results
;

select 1 as inclusion_rule_id, person_id, event_id
INTO #Inclusion_1
FROM 
(
  select pe.person_id, pe.event_id
  FROM #qualified_events pe
  
JOIN (
-- Begin Criteria Group
select 0 as index_id, person_id, event_id
FROM
(
  select E.person_id, E.event_id 
  FROM #qualified_events E
  LEFT JOIN
  (
    -- Begin Correlated Criteria
select 0 as index_id, cc.person_id, cc.event_id
from (SELECT p.person_id, p.event_id 
FROM #qualified_events P
JOIN (
  -- Begin Procedure Occurrence Criteria
select C.person_id, C.procedure_occurrence_id as event_id, C.start_date, C.end_date,
       C.visit_occurrence_id, C.start_date as sort_date
from 
(
  select po.person_id,po.procedure_occurrence_id,po.procedure_concept_id,po.visit_occurrence_id,po.quantity,po.procedure_date as start_date, DATEADD(day,1,po.procedure_date) as end_date 
  FROM @cdm_database_schema.PROCEDURE_OCCURRENCE po
JOIN #Codesets cs on (po.procedure_concept_id = cs.concept_id and cs.codeset_id = 8)
) C


-- End Procedure Occurrence Criteria

) A on A.person_id = P.person_id  AND A.START_DATE >= P.OP_START_DATE AND A.START_DATE <= P.OP_END_DATE AND A.START_DATE >= DATEADD(day,-180,P.START_DATE) AND A.START_DATE <= P.OP_END_DATE ) cc 
GROUP BY cc.person_id, cc.event_id
HAVING COUNT(cc.event_id) >= 1
-- End Correlated Criteria

  ) CQ on E.person_id = CQ.person_id and E.event_id = CQ.event_id
  GROUP BY E.person_id, E.event_id
  HAVING COUNT(index_id) <= 0
) G
-- End Criteria Group
) AC on AC.person_id = pe.person_id AND AC.event_id = pe.event_id
) Results
;

select 2 as inclusion_rule_id, person_id, event_id
INTO #Inclusion_2
FROM 
(
  select pe.person_id, pe.event_id
  FROM #qualified_events pe
  
JOIN (
-- Begin Criteria Group
select 0 as index_id, person_id, event_id
FROM
(
  select E.person_id, E.event_id 
  FROM #qualified_events E
  LEFT JOIN
  (
    -- Begin Correlated Criteria
select 0 as index_id, cc.person_id, cc.event_id
from (SELECT p.person_id, p.event_id 
FROM #qualified_events P
JOIN (
  -- Begin Procedure Occurrence Criteria
select C.person_id, C.procedure_occurrence_id as event_id, C.start_date, C.end_date,
       C.visit_occurrence_id, C.start_date as sort_date
from 
(
  select po.person_id,po.procedure_occurrence_id,po.procedure_concept_id,po.visit_occurrence_id,po.quantity,po.procedure_date as start_date, DATEADD(day,1,po.procedure_date) as end_date 
  FROM @cdm_database_schema.PROCEDURE_OCCURRENCE po
JOIN #Codesets cs on (po.procedure_concept_id = cs.concept_id and cs.codeset_id = 23)
) C


-- End Procedure Occurrence Criteria

) A on A.person_id = P.person_id  AND A.START_DATE >= P.OP_START_DATE AND A.START_DATE <= P.OP_END_DATE AND A.START_DATE >= DATEADD(day,-180,P.START_DATE) AND A.START_DATE <= P.OP_END_DATE ) cc 
GROUP BY cc.person_id, cc.event_id
HAVING COUNT(cc.event_id) >= 1
-- End Correlated Criteria

  ) CQ on E.person_id = CQ.person_id and E.event_id = CQ.event_id
  GROUP BY E.person_id, E.event_id
  HAVING COUNT(index_id) <= 0
) G
-- End Criteria Group
) AC on AC.person_id = pe.person_id AND AC.event_id = pe.event_id
) Results
;

SELECT inclusion_rule_id, person_id, event_id
INTO #inclusion_events
FROM (select inclusion_rule_id, person_id, event_id from #Inclusion_0
UNION ALL
select inclusion_rule_id, person_id, event_id from #Inclusion_1
UNION ALL
select inclusion_rule_id, person_id, event_id from #Inclusion_2) I;
TRUNCATE TABLE #Inclusion_0;
DROP TABLE #Inclusion_0;

TRUNCATE TABLE #Inclusion_1;
DROP TABLE #Inclusion_1;

TRUNCATE TABLE #Inclusion_2;
DROP TABLE #Inclusion_2;


select event_id, person_id, start_date, end_date, op_start_date, op_end_date
into #included_events
FROM (
  SELECT event_id, person_id, start_date, end_date, op_start_date, op_end_date, row_number() over (partition by person_id order by start_date ASC) as ordinal
  from
  (
    select Q.event_id, Q.person_id, Q.start_date, Q.end_date, Q.op_start_date, Q.op_end_date, SUM(coalesce(POWER(cast(2 as bigint), I.inclusion_rule_id), 0)) as inclusion_rule_mask
    from #qualified_events Q
    LEFT JOIN #inclusion_events I on I.person_id = Q.person_id and I.event_id = Q.event_id
    GROUP BY Q.event_id, Q.person_id, Q.start_date, Q.end_date, Q.op_start_date, Q.op_end_date
  ) MG -- matching groups
{3 != 0}?{
  -- the matching group with all bits set ( POWER(2,# of inclusion rules) - 1 = inclusion_rule_mask
  WHERE (MG.inclusion_rule_mask = POWER(cast(2 as bigint),3)-1)
}
) Results
WHERE Results.ordinal = 1
;



-- generate cohort periods into #final_cohort
select person_id, start_date, end_date
INTO #cohort_rows
from ( -- first_ends
	select F.person_id, F.start_date, F.end_date
	FROM (
	  select I.event_id, I.person_id, I.start_date, CE.end_date, row_number() over (partition by I.person_id, I.event_id order by CE.end_date) as ordinal
	  from #included_events I
	  join ( -- cohort_ends
-- cohort exit dates
-- By default, cohort exit at the event's op end date
select event_id, person_id, op_end_date as end_date from #included_events
    ) CE on I.event_id = CE.event_id and I.person_id = CE.person_id and CE.end_date >= I.start_date
	) F
	WHERE F.ordinal = 1
) FE;


select person_id, min(start_date) as start_date, DATEADD(day,-1 * 0, max(end_date)) as end_date
into #final_cohort
from (
  select person_id, start_date, end_date, sum(is_start) over (partition by person_id order by start_date, is_start desc rows unbounded preceding) group_idx
  from (
    select person_id, start_date, end_date, 
      case when max(end_date) over (partition by person_id order by start_date rows between unbounded preceding and 1 preceding) >= start_date then 0 else 1 end is_start
    from (
      select person_id, start_date, DATEADD(day,0,end_date) as end_date
      from #cohort_rows
    ) CR
  ) ST
) GR
group by person_id, group_idx;

DELETE FROM @target_database_schema.@target_cohort_table where cohort_definition_id = @target_cohort_id;
INSERT INTO @target_database_schema.@target_cohort_table (cohort_definition_id, subject_id, cohort_start_date, cohort_end_date)
select @target_cohort_id as cohort_definition_id, person_id, start_date, end_date 
FROM #final_cohort CO
;

{1 != 0}?{
-- BEGIN: Censored Stats

delete from @results_database_schema.cohort_censor_stats where cohort_definition_id = @target_cohort_id;

-- END: Censored Stats
}
{1 != 0 & 3 != 0}?{

-- Create a temp table of inclusion rule rows for joining in the inclusion rule impact analysis

select cast(rule_sequence as int) as rule_sequence
into #inclusion_rules
from (
  SELECT CAST(0 as int) as rule_sequence UNION ALL SELECT CAST(1 as int) as rule_sequence UNION ALL SELECT CAST(2 as int) as rule_sequence
) IR;


-- Find the event that is the 'best match' per person.  
-- the 'best match' is defined as the event that satisfies the most inclusion rules.
-- ties are solved by choosing the event that matches the earliest inclusion rule, and then earliest.

select q.person_id, q.event_id
into #best_events
from #qualified_events Q
join (
	SELECT R.person_id, R.event_id, ROW_NUMBER() OVER (PARTITION BY R.person_id ORDER BY R.rule_count DESC,R.min_rule_id ASC, R.start_date ASC) AS rank_value
	FROM (
		SELECT Q.person_id, Q.event_id, COALESCE(COUNT(DISTINCT I.inclusion_rule_id), 0) AS rule_count, COALESCE(MIN(I.inclusion_rule_id), 0) AS min_rule_id, Q.start_date
		FROM #qualified_events Q
		LEFT JOIN #inclusion_events I ON q.person_id = i.person_id AND q.event_id = i.event_id
		GROUP BY Q.person_id, Q.event_id, Q.start_date
	) R
) ranked on Q.person_id = ranked.person_id and Q.event_id = ranked.event_id
WHERE ranked.rank_value = 1
;

-- modes of generation: (the same tables store the results for the different modes, identified by the mode_id column)
-- 0: all events
-- 1: best event


-- BEGIN: Inclusion Impact Analysis - event
-- calculte matching group counts
delete from @results_database_schema.cohort_inclusion_result where cohort_definition_id = @target_cohort_id and mode_id = 0;
insert into @results_database_schema.cohort_inclusion_result (cohort_definition_id, inclusion_rule_mask, person_count, mode_id)
select @target_cohort_id as cohort_definition_id, inclusion_rule_mask, count_big(*) as person_count, 0 as mode_id
from
(
  select Q.person_id, Q.event_id, CAST(SUM(coalesce(POWER(cast(2 as bigint), I.inclusion_rule_id), 0)) AS bigint) as inclusion_rule_mask
  from #qualified_events Q
  LEFT JOIN #inclusion_events I on q.person_id = i.person_id and q.event_id = i.event_id
  GROUP BY Q.person_id, Q.event_id
) MG -- matching groups
group by inclusion_rule_mask
;

-- calculate gain counts 
delete from @results_database_schema.cohort_inclusion_stats where cohort_definition_id = @target_cohort_id and mode_id = 0;
insert into @results_database_schema.cohort_inclusion_stats (cohort_definition_id, rule_sequence, person_count, gain_count, person_total, mode_id)
select @target_cohort_id as cohort_definition_id, ir.rule_sequence, coalesce(T.person_count, 0) as person_count, coalesce(SR.person_count, 0) gain_count, EventTotal.total, 0 as mode_id
from #inclusion_rules ir
left join
(
  select i.inclusion_rule_id, count_big(i.event_id) as person_count
  from #qualified_events Q
  JOIN #inclusion_events i on Q.person_id = I.person_id and Q.event_id = i.event_id
  group by i.inclusion_rule_id
) T on ir.rule_sequence = T.inclusion_rule_id
CROSS JOIN (select count(*) as total_rules from #inclusion_rules) RuleTotal
CROSS JOIN (select count_big(event_id) as total from #qualified_events) EventTotal
LEFT JOIN @results_database_schema.cohort_inclusion_result SR on SR.mode_id = 0 AND SR.cohort_definition_id = @target_cohort_id AND (POWER(cast(2 as bigint),RuleTotal.total_rules) - POWER(cast(2 as bigint),ir.rule_sequence) - 1) = SR.inclusion_rule_mask -- POWER(2,rule count) - POWER(2,rule sequence) - 1 is the mask for 'all except this rule'
;

-- calculate totals
delete from @results_database_schema.cohort_summary_stats where cohort_definition_id = @target_cohort_id and mode_id = 0;
insert into @results_database_schema.cohort_summary_stats (cohort_definition_id, base_count, final_count, mode_id)
select @target_cohort_id as cohort_definition_id, PC.total as person_count, coalesce(FC.total, 0) as final_count, 0 as mode_id
FROM
(select count_big(event_id) as total from #qualified_events) PC,
(select sum(sr.person_count) as total
  from @results_database_schema.cohort_inclusion_result sr
  CROSS JOIN (select count(*) as total_rules from #inclusion_rules) RuleTotal
  where sr.mode_id = 0 and sr.cohort_definition_id = @target_cohort_id and sr.inclusion_rule_mask = POWER(cast(2 as bigint),RuleTotal.total_rules)-1
) FC
;

-- END: Inclusion Impact Analysis - event

-- BEGIN: Inclusion Impact Analysis - person
-- calculte matching group counts
delete from @results_database_schema.cohort_inclusion_result where cohort_definition_id = @target_cohort_id and mode_id = 1;
insert into @results_database_schema.cohort_inclusion_result (cohort_definition_id, inclusion_rule_mask, person_count, mode_id)
select @target_cohort_id as cohort_definition_id, inclusion_rule_mask, count_big(*) as person_count, 1 as mode_id
from
(
  select Q.person_id, Q.event_id, CAST(SUM(coalesce(POWER(cast(2 as bigint), I.inclusion_rule_id), 0)) AS bigint) as inclusion_rule_mask
  from #best_events Q
  LEFT JOIN #inclusion_events I on q.person_id = i.person_id and q.event_id = i.event_id
  GROUP BY Q.person_id, Q.event_id
) MG -- matching groups
group by inclusion_rule_mask
;

-- calculate gain counts 
delete from @results_database_schema.cohort_inclusion_stats where cohort_definition_id = @target_cohort_id and mode_id = 1;
insert into @results_database_schema.cohort_inclusion_stats (cohort_definition_id, rule_sequence, person_count, gain_count, person_total, mode_id)
select @target_cohort_id as cohort_definition_id, ir.rule_sequence, coalesce(T.person_count, 0) as person_count, coalesce(SR.person_count, 0) gain_count, EventTotal.total, 1 as mode_id
from #inclusion_rules ir
left join
(
  select i.inclusion_rule_id, count_big(i.event_id) as person_count
  from #best_events Q
  JOIN #inclusion_events i on Q.person_id = I.person_id and Q.event_id = i.event_id
  group by i.inclusion_rule_id
) T on ir.rule_sequence = T.inclusion_rule_id
CROSS JOIN (select count(*) as total_rules from #inclusion_rules) RuleTotal
CROSS JOIN (select count_big(event_id) as total from #best_events) EventTotal
LEFT JOIN @results_database_schema.cohort_inclusion_result SR on SR.mode_id = 1 AND SR.cohort_definition_id = @target_cohort_id AND (POWER(cast(2 as bigint),RuleTotal.total_rules) - POWER(cast(2 as bigint),ir.rule_sequence) - 1) = SR.inclusion_rule_mask -- POWER(2,rule count) - POWER(2,rule sequence) - 1 is the mask for 'all except this rule'
;

-- calculate totals
delete from @results_database_schema.cohort_summary_stats where cohort_definition_id = @target_cohort_id and mode_id = 1;
insert into @results_database_schema.cohort_summary_stats (cohort_definition_id, base_count, final_count, mode_id)
select @target_cohort_id as cohort_definition_id, PC.total as person_count, coalesce(FC.total, 0) as final_count, 1 as mode_id
FROM
(select count_big(event_id) as total from #best_events) PC,
(select sum(sr.person_count) as total
  from @results_database_schema.cohort_inclusion_result sr
  CROSS JOIN (select count(*) as total_rules from #inclusion_rules) RuleTotal
  where sr.mode_id = 1 and sr.cohort_definition_id = @target_cohort_id and sr.inclusion_rule_mask = POWER(cast(2 as bigint),RuleTotal.total_rules)-1
) FC
;

-- END: Inclusion Impact Analysis - person

TRUNCATE TABLE #best_events;
DROP TABLE #best_events;

TRUNCATE TABLE #inclusion_rules;
DROP TABLE #inclusion_rules;
}



TRUNCATE TABLE #cohort_rows;
DROP TABLE #cohort_rows;

TRUNCATE TABLE #final_cohort;
DROP TABLE #final_cohort;

TRUNCATE TABLE #inclusion_events;
DROP TABLE #inclusion_events;

TRUNCATE TABLE #qualified_events;
DROP TABLE #qualified_events;

TRUNCATE TABLE #included_events;
DROP TABLE #included_events;

TRUNCATE TABLE #Codesets;
DROP TABLE #Codesets;
