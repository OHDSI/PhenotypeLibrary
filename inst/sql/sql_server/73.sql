CREATE TABLE #Codesets (
  codeset_id int NOT NULL,
  concept_id bigint NOT NULL
)
;

INSERT INTO #Codesets (codeset_id, concept_id)
SELECT 11 as codeset_id, c.concept_id FROM (select distinct I.concept_id FROM
( 
  select concept_id from @vocabulary_database_schema.CONCEPT where concept_id in (42739743,2101807,2004526,2004525,4014461,4151169,4149449,4149457,4014299,4149451,4150406,4150405,4150404,4028644,4216316,4192676,193277,444113,441641,4128030,2004489,4138740,4074867,4195545,4170151,4282169,194694,75605,436228,4148097,4118056,4063309,72726,40482735,4171115,2721012,433260,440847,437369,440833,4194423,441128,432695,40539858,4086393,4147874,4064709,4058403,36712702,4150401,4153287,4086797,4170121,136530,2514572,42740403,2514571,2514570,4297250,2110328)
UNION  select c.concept_id
  from @vocabulary_database_schema.CONCEPT c
  join @vocabulary_database_schema.CONCEPT_ANCESTOR ca on c.concept_id = ca.descendant_concept_id
  and ca.ancestor_concept_id in (42739743,2101807,2004526,2004525,4014461,4151169,4149449,4149457,4014299,4149451,4150406,4150405,4150404,4028644,4216316,4192676,193277,444113,441641,4128030,2004489,4138740,4074867,4195545,4170151,4282169,194694,75605,436228,4148097,4118056,4063309,72726,40482735,4171115,2721012,433260,440847,437369,440833,4194423,441128,432695,40539858,4086393,4147874,4064709,4058403,36712702,4150401,4153287,4086797,4170121,136530,2514572,42740403,2514571,2514570,4297250,2110328)
  and c.invalid_reason is null

) I
) C UNION ALL 
SELECT 12 as codeset_id, c.concept_id FROM (select distinct I.concept_id FROM
( 
  select concept_id from @vocabulary_database_schema.CONCEPT where concept_id in (4059050,4149783,4125440,4060034,4064724,137974,314099,440216,4061847,4007285,4064723,4034155,441092,4061809,3045859,4086931,4041176,4041177,4042555,4042557,4314756,4056119,4056118,4057159,4056114,433880,4057154,4043930,4077055,4060259,4061530,4061528,4061793,42739743,2101814,2101807,2101815,2101809,2100998,2101013,2101808,2101806,2101593,4079835,4015137,4061154,4237327,4015139,439656,4061435,4061434,4060245,4060098,4060240,4147941,4181975,4047845,4084186,4257036,4254205,4170305,4062361,4087243,4152443,4087235,40483081,4015140,4257039,4152444,4152445,4061131,4061157,4310443,4061802,4081196,435887,4060264,4061156,4014472,4014304,4016464,4239302,2004526,42739500,2213363,2213362,42739562,4090719,4028644,2213365,2213364,4014291,4182460,4014612,4014740,4016487,4015277,4014465,40759177,4034150,4042936,4014314,4015160,4192676,4015307,4014441,443330,77624,81086,73282,4066258,4015144,40766616,45757109,4055694,4012802,317669,4065094,2110305,2110304,4048139,4132566,197043,4127841,4021397,4024006,195870,435875,4309151,4129020,37110279,4182769,4008239,441964,4145939,4071869,4071195,4194229,4220675,200791,4149398,4048592,4060252,4015590,443243,434715,440481,437062,432396,4252738,4127549,4028634,4129700,4028636,4062551,2514560,4060107,3011536,4038495,43054893,4061795,4156955,4150421,4243314,4058243,3030608,4124226,434482,4016060,4086786,2004490,2004489,4138740,4074867,4072420,4084845,4063155,200524,80471,439658,4195545,201091,4149463,4149462,4087245,443250,4122728,4193062,4064450,4207588,4031038,4241991,4108901,4265609,4327048,4253816,4345685,4059478,4182148,4170151,4147078,40479820,2213361,4070533,4061800,4060255,4061527,4061152,4100327,4079844,4323285,4334808,4210896,4127418,4145315,4015303,433309,432429,436218,4070421,4118054,434744,441127,436517,440829,442148,432734,4299735,4015304,4014437,4129553,2110289,4042411,4042923,4344625,4154314,4127854,4124636,4104311,195877,4116804,4124634,432441,439156,4124479,4199274,4128832,4199558,4124637,4126258,4096531,4140071,4109462,4060108,4127104,4072421,4150651,4061522,42594973,4055678,4164266,4204988,4084217,4006949,45757133,440218,4016061,3048599,441630,4062565,4151190,4041368,4041367,2110306,4030415,4049777,4311629,2110084,4344630,44804252,4136449,4062356,4014439,4028781,4060312,4085257,2514569,2514563,2213360,3046418,4072424,4311540,4074869,4199599,4058246,4079751,36712669,4221837,40760193,4152967,4021675,3002314,4145062,4061791,4081274,40482735,4096534,45769909,4129022,4106176,4214980,4130310,4280517,4010041,4244279,434697,42534813,4062359,4062628,4126725,4129174,4127049,4091197,4188630,4060424,4305717,4252093,4330861,4014582,4014316,4102166,4142637,3045823,2213206,2213201,4236626,4212326,4071721,252442,434154,440840,4172864,4049043,4143745,4129185,4302027,193323,4173170,4071202,4150930,23034,4337102,4172867,443618,4174302,76221,81400,439140,318856,4048751,137099,4047937,4048755,194598,2101016,2101598,4079843,40480440,4060249,4124478,4305304,4080067,4289014,4193440,3002549,4021781,4091321,2721745,4061473,4141544,4129186,4084521,4080059,4090071,4095947,4302541,4062124,4070225,4039090,4038571,4038572,4039088,4039610,4207166,4039609,4038763,4038573,4038762,4034650,4153591,4073719,4072862,4145318,4146393,45757164,4060109,4061149,4061526,4061525,3016572,4080867,195075,4131053,40664802,260212,4024541,4187201,4048152,195064,4162557,4089917,45757135,45757136,4119977,4014585,4096532,4090740,4064854,4328506,4014717,4014444,4028624,4012558,440833,4194423,441128,433542,4057979,4063042,4063043,3005975,4148890,4064793,4063126,4064791,37208877,44806658,4302270,4094911,4094910,37208879,4077075,3171301,3188475,4034085,4299535,4059984,4040733,4089558,40770920,4119100,4205452,4244737,4148926,4330449,4142640,4049024,4133029,4060105,4082072,4088432,4095809,45757171,4136097,4061423,4091640,3046853,4138138,4150401,77619,4190767,4081292,4084693,4214930,4089069,3040000,4153287,4123182,4075175,4086797,319138,4061848,437061,4129345,4014584,4113995,4120817,4047853,4074158,4083415,4260976,42742501,4235812,4092760,45757172,45757173,4127241,4060253,4065627,4065625,198212,4092290,4047868,4063159,4238119,43530882,43530886,43530884,43530888,4129023,4071588,4024302,4075040,139895,4047866,40664765,433604,4327033,439149,435076,436234,4014290,4145940,4219108,2211785,3031159,40756968,44790261,45887772,45888652,45888041,45888752,2211756,2211755,2211757,4028913,4157006,4152021,4125141,4241830,4028642,4080866,4060623,4060622,4061129,2110338,4129703,4034079,4129015,4129016,4193463,4129043,4170459,4072710,4145316,315881,4079752,4129689,40767416,4085140)
UNION  select c.concept_id
  from @vocabulary_database_schema.CONCEPT c
  join @vocabulary_database_schema.CONCEPT_ANCESTOR ca on c.concept_id = ca.descendant_concept_id
  and ca.ancestor_concept_id in (4059050,4149783,4125440,4060034,4064724,137974,314099,440216,4061847,4007285,4064723,4034155,441092,4061809,3045859,4086931,4041176,4041177,4042555,4042557,4314756,4056119,4056118,4057159,4056114,433880,4057154,4043930,4077055,4060259,4061530,4061528,4061793,42739743,2101814,2101807,2101815,2101809,2100998,2101013,2101808,2101806,2101593,4079835,4015137,4061154,4237327,4015139,439656,4061435,4061434,4060245,4060098,4060240,4147941,4181975,4047845,4084186,4257036,4254205,4170305,4062361,4087243,4152443,4087235,40483081,4015140,4257039,4152444,4152445,4061131,4061157,4310443,4061802,4081196,435887,4060264,4061156,4014472,4014304,4016464,4239302,2004526,42739500,2213363,2213362,42739562,4090719,4028644,2213365,2213364,4014291,4182460,4014612,4014740,4016487,4015277,4014465,40759177,4034150,4042936,4014314,4015160,4192676,4015307,4014441,443330,77624,81086,73282,4066258,4015144,40766616,45757109,4055694,4012802,317669,4065094,2110305,2110304,4048139,4132566,197043,4127841,4021397,4024006,195870,435875,4309151,4129020,37110279,4182769,4008239,441964,4145939,4071869,4071195,4194229,4220675,200791,4149398,4048592,4060252,4015590,443243,434715,440481,437062,432396,4252738,4127549,4028634,4129700,4028636,4062551,2514560,4060107,3011536,4038495,43054893,4061795,4156955,4150421,4243314,4058243,3030608,4124226,434482,4016060,4086786,2004490,2004489,4138740,4074867,4072420,4084845,4063155,200524,80471,439658,4195545,201091,4149463,4149462,4087245,443250,4122728,4193062,4064450,4207588,4031038,4241991,4108901,4265609,4327048,4253816,4345685,4059478,4182148,4170151,4147078,40479820,2213361,4070533,4061800,4060255,4061527,4061152,4100327,4079844,4323285,4334808,4210896,4127418,4145315,4015303,433309,432429,436218,4070421,4118054,434744,441127,436517,440829,442148,432734,4299735,4015304,4014437,4129553,2110289,4042411,4042923,4344625,4154314,4127854,4124636,4104311,195877,4116804,4124634,432441,439156,4124479,4199274,4128832,4199558,4124637,4126258,4096531,4140071,4109462,4060108,4127104,4072421,4150651,4061522,42594973,4055678,4164266,4204988,4084217,4006949,45757133,440218,4016061,3048599,441630,4062565,4151190,4041368,4041367,2110306,4030415,4049777,4311629,2110084,4344630,44804252,4136449,4062356,4014439,4028781,4060312,4085257,2514569,2514563,2213360,3046418,4072424,4311540,4074869,4199599,4058246,4079751,36712669,4221837,40760193,4152967,4021675,3002314,4145062,4061791,4081274,40482735,4096534,45769909,4129022,4106176,4214980,4130310,4280517,4010041,4244279,434697,42534813,4062359,4062628,4126725,4129174,4127049,4091197,4188630,4060424,4305717,4252093,4330861,4014582,4014316,4102166,4142637,3045823,2213206,2213201,4236626,4212326,4071721,252442,434154,440840,4172864,4049043,4143745,4129185,4302027,193323,4173170,4071202,4150930,23034,4337102,4172867,443618,4174302,76221,81400,439140,318856,4048751,137099,4047937,4048755,194598,2101016,2101598,4079843,40480440,4060249,4124478,4305304,4080067,4289014,4193440,3002549,4021781,4091321,2721745,4061473,4141544,4129186,4084521,4080059,4090071,4095947,4302541,4062124,4070225,4039090,4038571,4038572,4039088,4039610,4207166,4039609,4038763,4038573,4038762,4034650,4153591,4073719,4072862,4145318,4146393,45757164,4060109,4061149,4061526,4061525,3016572,4080867,195075,4131053,40664802,260212,4024541,4187201,4048152,195064,4162557,4089917,45757135,45757136,4119977,4014585,4096532,4090740,4064854,4328506,4014717,4014444,4028624,4012558,440833,4194423,441128,433542,4057979,4063042,4063043,3005975,4148890,4064793,4063126,4064791,37208877,44806658,4302270,4094911,4094910,37208879,4077075,3171301,3188475,4034085,4299535,4059984,4040733,4089558,40770920,4119100,4205452,4244737,4148926,4330449,4142640,4049024,4133029,4060105,4082072,4088432,4095809,45757171,4136097,4061423,4091640,3046853,4138138,4150401,77619,4190767,4081292,4084693,4214930,4089069,3040000,4153287,4123182,4075175,4086797,319138,4061848,437061,4129345,4014584,4113995,4120817,4047853,4074158,4083415,4260976,42742501,4235812,4092760,45757172,45757173,4127241,4060253,4065627,4065625,198212,4092290,4047868,4063159,4238119,43530882,43530886,43530884,43530888,4129023,4071588,4024302,4075040,139895,4047866,40664765,433604,4327033,439149,435076,436234,4014290,4145940,4219108,2211785,3031159,40756968,44790261,45887772,45888652,45888041,45888752,2211756,2211755,2211757,4028913,4157006,4152021,4125141,4241830,4028642,4080866,4060623,4060622,4061129,2110338,4129703,4034079,4129015,4129016,4193463,4129043,4170459,4072710,4145316,315881,4079752,4129689,40767416,4085140)
  and c.invalid_reason is null

) I
LEFT JOIN
(
  select concept_id from @vocabulary_database_schema.CONCEPT where concept_id in (36716760,4283942,377980,441364,443404,437985,433315,4296686,436529,436534,4289543,4297233,4207827,201136,4049041,4297232,4015149,4047392,2110314,2101832,4203918,45773073,4057246,36675035,258866,36713471,40483591,4171358,141370,4062637,4071863,4169915)
UNION  select c.concept_id
  from @vocabulary_database_schema.CONCEPT c
  join @vocabulary_database_schema.CONCEPT_ANCESTOR ca on c.concept_id = ca.descendant_concept_id
  and ca.ancestor_concept_id in (36716760,4283942,377980,441364,443404,437985,433315,4296686,436529,436534,4289543,4297233,4207827,201136,4049041,4297232,4015149,4047392,2110314,2101832,4203918,45773073,4057246,36675035,258866,36713471,40483591,4171358,141370,4062637,4071863,4169915)
  and c.invalid_reason is null

) E ON I.concept_id = E.concept_id
WHERE E.concept_id is null
) C
;

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
  -- Begin Condition Occurrence Criteria
SELECT C.person_id, C.condition_occurrence_id as event_id, C.condition_start_date as start_date, COALESCE(C.condition_end_date, DATEADD(day,1,C.condition_start_date)) as end_date,
  C.visit_occurrence_id, C.condition_start_date as sort_date
FROM 
(
  SELECT co.* 
  FROM @cdm_database_schema.CONDITION_OCCURRENCE co
  JOIN #Codesets cs on (co.condition_concept_id = cs.concept_id and cs.codeset_id = 12)
) C
JOIN @cdm_database_schema.PERSON P on C.person_id = P.person_id
WHERE (YEAR(C.condition_start_date) - P.year_of_birth >= 12 and YEAR(C.condition_start_date) - P.year_of_birth <= 55)
AND P.gender_concept_id in (8532)
-- End Condition Occurrence Criteria

UNION ALL
-- Begin Procedure Occurrence Criteria
select C.person_id, C.procedure_occurrence_id as event_id, C.procedure_date as start_date, DATEADD(d,1,C.procedure_date) as END_DATE,
       C.visit_occurrence_id, C.procedure_date as sort_date
from 
(
  select po.* 
  FROM @cdm_database_schema.PROCEDURE_OCCURRENCE po
JOIN #Codesets cs on (po.procedure_concept_id = cs.concept_id and cs.codeset_id = 12)
) C
JOIN @cdm_database_schema.PERSON P on C.person_id = P.person_id
WHERE (YEAR(C.procedure_date) - P.year_of_birth >= 12 and YEAR(C.procedure_date) - P.year_of_birth <= 55)
AND P.gender_concept_id in (8532)
-- End Procedure Occurrence Criteria

UNION ALL
-- Begin Observation Criteria
select C.person_id, C.observation_id as event_id, C.observation_date as start_date, DATEADD(d,1,C.observation_date) as END_DATE,
       C.visit_occurrence_id, C.observation_date as sort_date
from 
(
  select o.* 
  FROM @cdm_database_schema.OBSERVATION o
JOIN #Codesets cs on (o.observation_concept_id = cs.concept_id and cs.codeset_id = 12)
) C
JOIN @cdm_database_schema.PERSON P on C.person_id = P.person_id
WHERE (YEAR(C.observation_date) - P.year_of_birth >= 12 and YEAR(C.observation_date) - P.year_of_birth <= 55)
AND P.gender_concept_id in (8532)
-- End Observation Criteria

  ) E
	JOIN @cdm_database_schema.observation_period OP on E.person_id = OP.person_id and E.start_date >=  OP.observation_period_start_date and E.start_date <= op.observation_period_end_date
  WHERE DATEADD(day,0,OP.OBSERVATION_PERIOD_START_DATE) <= E.START_DATE AND DATEADD(day,0,E.START_DATE) <= OP.OBSERVATION_PERIOD_END_DATE
) P

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
  INNER JOIN
  (
    -- Begin Correlated Criteria
select 0 as index_id, cc.person_id, cc.event_id
from (SELECT p.person_id, p.event_id 
FROM #qualified_events P
JOIN (
  -- Begin Condition Occurrence Criteria
SELECT C.person_id, C.condition_occurrence_id as event_id, C.condition_start_date as start_date, COALESCE(C.condition_end_date, DATEADD(day,1,C.condition_start_date)) as end_date,
  C.visit_occurrence_id, C.condition_start_date as sort_date
FROM 
(
  SELECT co.* 
  FROM @cdm_database_schema.CONDITION_OCCURRENCE co
  JOIN #Codesets cs on (co.condition_concept_id = cs.concept_id and cs.codeset_id = 11)
) C


-- End Condition Occurrence Criteria

) A on A.person_id = P.person_id  AND A.START_DATE >= P.OP_START_DATE AND A.START_DATE <= P.OP_END_DATE AND A.START_DATE >= DATEADD(day,1,P.START_DATE) AND A.START_DATE <= DATEADD(day,300,P.START_DATE) ) cc 
GROUP BY cc.person_id, cc.event_id
HAVING COUNT(cc.event_id) >= 1
-- End Correlated Criteria

UNION ALL
-- Begin Correlated Criteria
select 1 as index_id, cc.person_id, cc.event_id
from (SELECT p.person_id, p.event_id 
FROM #qualified_events P
JOIN (
  -- Begin Observation Criteria
select C.person_id, C.observation_id as event_id, C.observation_date as start_date, DATEADD(d,1,C.observation_date) as END_DATE,
       C.visit_occurrence_id, C.observation_date as sort_date
from 
(
  select o.* 
  FROM @cdm_database_schema.OBSERVATION o
JOIN #Codesets cs on (o.observation_concept_id = cs.concept_id and cs.codeset_id = 11)
) C


-- End Observation Criteria

) A on A.person_id = P.person_id  AND A.START_DATE >= P.OP_START_DATE AND A.START_DATE <= P.OP_END_DATE AND A.START_DATE >= DATEADD(day,1,P.START_DATE) AND A.START_DATE <= DATEADD(day,300,P.START_DATE) ) cc 
GROUP BY cc.person_id, cc.event_id
HAVING COUNT(cc.event_id) >= 1
-- End Correlated Criteria

UNION ALL
-- Begin Correlated Criteria
select 2 as index_id, cc.person_id, cc.event_id
from (SELECT p.person_id, p.event_id 
FROM #qualified_events P
JOIN (
  -- Begin Procedure Occurrence Criteria
select C.person_id, C.procedure_occurrence_id as event_id, C.procedure_date as start_date, DATEADD(d,1,C.procedure_date) as END_DATE,
       C.visit_occurrence_id, C.procedure_date as sort_date
from 
(
  select po.* 
  FROM @cdm_database_schema.PROCEDURE_OCCURRENCE po
JOIN #Codesets cs on (po.procedure_concept_id = cs.concept_id and cs.codeset_id = 11)
) C


-- End Procedure Occurrence Criteria

) A on A.person_id = P.person_id  AND A.START_DATE >= P.OP_START_DATE AND A.START_DATE <= P.OP_END_DATE AND A.START_DATE >= DATEADD(day,1,P.START_DATE) AND A.START_DATE <= P.OP_END_DATE ) cc 
GROUP BY cc.person_id, cc.event_id
HAVING COUNT(cc.event_id) >= 1
-- End Correlated Criteria

UNION ALL
-- Begin Correlated Criteria
select 3 as index_id, cc.person_id, cc.event_id
from (SELECT p.person_id, p.event_id 
FROM #qualified_events P
JOIN (
  select PE.person_id, PE.event_id, PE.start_date, PE.end_date, PE.visit_occurrence_id, PE.sort_date FROM (
-- Begin Observation Period Criteria
select C.person_id, C.observation_period_id as event_id, C.observation_period_start_date as start_date, C.observation_period_end_date as end_date,
       CAST(NULL as bigint) as visit_occurrence_id, C.observation_period_start_date as sort_date

from 
(
        select op.*, row_number() over (PARTITION BY op.person_id ORDER BY op.observation_period_start_date) as ordinal
        FROM @cdm_database_schema.OBSERVATION_PERIOD op
) C


-- End Observation Period Criteria

) PE
JOIN (
-- Begin Criteria Group
select 0 as index_id, person_id, event_id
FROM
(
  select E.person_id, E.event_id 
  FROM (SELECT Q.person_id, Q.event_id, Q.start_date, Q.end_date, Q.visit_occurrence_id, OP.observation_period_start_date as op_start_date, OP.observation_period_end_date as op_end_date
FROM (-- Begin Observation Period Criteria
select C.person_id, C.observation_period_id as event_id, C.observation_period_start_date as start_date, C.observation_period_end_date as end_date,
       CAST(NULL as bigint) as visit_occurrence_id, C.observation_period_start_date as sort_date

from 
(
        select op.*, row_number() over (PARTITION BY op.person_id ORDER BY op.observation_period_start_date) as ordinal
        FROM @cdm_database_schema.OBSERVATION_PERIOD op
) C


-- End Observation Period Criteria
) Q
JOIN @cdm_database_schema.OBSERVATION_PERIOD OP on Q.person_id = OP.person_id 
  and OP.observation_period_start_date <= Q.start_date and OP.observation_period_end_date >= Q.start_date
) E
  INNER JOIN
  (
    -- Begin Demographic Criteria
SELECT 0 as index_id, e.person_id, e.event_id
FROM (SELECT Q.person_id, Q.event_id, Q.start_date, Q.end_date, Q.visit_occurrence_id, OP.observation_period_start_date as op_start_date, OP.observation_period_end_date as op_end_date
FROM (-- Begin Observation Period Criteria
select C.person_id, C.observation_period_id as event_id, C.observation_period_start_date as start_date, C.observation_period_end_date as end_date,
       CAST(NULL as bigint) as visit_occurrence_id, C.observation_period_start_date as sort_date

from 
(
        select op.*, row_number() over (PARTITION BY op.person_id ORDER BY op.observation_period_start_date) as ordinal
        FROM @cdm_database_schema.OBSERVATION_PERIOD op
) C


-- End Observation Period Criteria
) Q
JOIN @cdm_database_schema.OBSERVATION_PERIOD OP on Q.person_id = OP.person_id 
  and OP.observation_period_start_date <= Q.start_date and OP.observation_period_end_date >= Q.start_date
) E
JOIN @cdm_database_schema.PERSON P ON P.PERSON_ID = E.PERSON_ID
WHERE E.end_date > DATEFROMPARTS(2020, 1, 1)
GROUP BY e.person_id, e.event_id
-- End Demographic Criteria

  ) CQ on E.person_id = CQ.person_id and E.event_id = CQ.event_id
  GROUP BY E.person_id, E.event_id
  HAVING COUNT(index_id) = 1
) G
-- End Criteria Group
) AC on AC.person_id = pe.person_id and AC.event_id = pe.event_id

) A on A.person_id = P.person_id  AND A.START_DATE >= P.OP_START_DATE AND A.START_DATE <= P.OP_END_DATE AND A.START_DATE >= P.OP_START_DATE AND A.START_DATE <= DATEADD(day,0,P.START_DATE) AND A.END_DATE >= DATEADD(day,0,P.START_DATE) AND A.END_DATE <= DATEADD(day,300,P.START_DATE) ) cc 
GROUP BY cc.person_id, cc.event_id
HAVING COUNT(cc.event_id) >= 1
-- End Correlated Criteria

  ) CQ on E.person_id = CQ.person_id and E.event_id = CQ.event_id
  GROUP BY E.person_id, E.event_id
  HAVING COUNT(index_id) > 0
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
  INNER JOIN
  (
    -- Begin Correlated Criteria
select 0 as index_id, p.person_id, p.event_id
from #qualified_events p
LEFT JOIN (
SELECT p.person_id, p.event_id 
FROM #qualified_events P
JOIN (
  -- Begin Condition Occurrence Criteria
SELECT C.person_id, C.condition_occurrence_id as event_id, C.condition_start_date as start_date, COALESCE(C.condition_end_date, DATEADD(day,1,C.condition_start_date)) as end_date,
  C.visit_occurrence_id, C.condition_start_date as sort_date
FROM 
(
  SELECT co.* 
  FROM @cdm_database_schema.CONDITION_OCCURRENCE co
  JOIN #Codesets cs on (co.condition_concept_id = cs.concept_id and cs.codeset_id = 11)
) C


-- End Condition Occurrence Criteria

) A on A.person_id = P.person_id  AND A.START_DATE >= P.OP_START_DATE AND A.START_DATE <= P.OP_END_DATE AND A.START_DATE >= DATEADD(day,-60,P.START_DATE) AND A.START_DATE <= DATEADD(day,-1,P.START_DATE) ) cc on p.person_id = cc.person_id and p.event_id = cc.event_id
GROUP BY p.person_id, p.event_id
HAVING COUNT(cc.event_id) = 0
-- End Correlated Criteria

UNION ALL
-- Begin Correlated Criteria
select 1 as index_id, p.person_id, p.event_id
from #qualified_events p
LEFT JOIN (
SELECT p.person_id, p.event_id 
FROM #qualified_events P
JOIN (
  -- Begin Procedure Occurrence Criteria
select C.person_id, C.procedure_occurrence_id as event_id, C.procedure_date as start_date, DATEADD(d,1,C.procedure_date) as END_DATE,
       C.visit_occurrence_id, C.procedure_date as sort_date
from 
(
  select po.* 
  FROM @cdm_database_schema.PROCEDURE_OCCURRENCE po
JOIN #Codesets cs on (po.procedure_concept_id = cs.concept_id and cs.codeset_id = 11)
) C


-- End Procedure Occurrence Criteria

) A on A.person_id = P.person_id  AND A.START_DATE >= P.OP_START_DATE AND A.START_DATE <= P.OP_END_DATE AND A.START_DATE >= DATEADD(day,-60,P.START_DATE) AND A.START_DATE <= DATEADD(day,-1,P.START_DATE) ) cc on p.person_id = cc.person_id and p.event_id = cc.event_id
GROUP BY p.person_id, p.event_id
HAVING COUNT(cc.event_id) = 0
-- End Correlated Criteria

UNION ALL
-- Begin Correlated Criteria
select 2 as index_id, p.person_id, p.event_id
from #qualified_events p
LEFT JOIN (
SELECT p.person_id, p.event_id 
FROM #qualified_events P
JOIN (
  -- Begin Observation Criteria
select C.person_id, C.observation_id as event_id, C.observation_date as start_date, DATEADD(d,1,C.observation_date) as END_DATE,
       C.visit_occurrence_id, C.observation_date as sort_date
from 
(
  select o.* 
  FROM @cdm_database_schema.OBSERVATION o
JOIN #Codesets cs on (o.observation_concept_id = cs.concept_id and cs.codeset_id = 11)
) C


-- End Observation Criteria

) A on A.person_id = P.person_id  AND A.START_DATE >= P.OP_START_DATE AND A.START_DATE <= P.OP_END_DATE AND A.START_DATE >= DATEADD(day,-60,P.START_DATE) AND A.START_DATE <= DATEADD(day,-1,P.START_DATE) ) cc on p.person_id = cc.person_id and p.event_id = cc.event_id
GROUP BY p.person_id, p.event_id
HAVING COUNT(cc.event_id) = 0
-- End Correlated Criteria

  ) CQ on E.person_id = CQ.person_id and E.event_id = CQ.event_id
  GROUP BY E.person_id, E.event_id
  HAVING COUNT(index_id) = 3
) G
-- End Criteria Group
) AC on AC.person_id = pe.person_id AND AC.event_id = pe.event_id
) Results
;

SELECT inclusion_rule_id, person_id, event_id
INTO #inclusion_events
FROM (select inclusion_rule_id, person_id, event_id from #Inclusion_0
UNION ALL
select inclusion_rule_id, person_id, event_id from #Inclusion_1) I;
TRUNCATE TABLE #Inclusion_0;
DROP TABLE #Inclusion_0;

TRUNCATE TABLE #Inclusion_1;
DROP TABLE #Inclusion_1;


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

  -- the matching group with all bits set ( POWER(2,# of inclusion rules) - 1 = inclusion_rule_mask
  WHERE (MG.inclusion_rule_mask = POWER(cast(2 as bigint),2)-1)

) Results

;

-- date offset strategy

select event_id, person_id, 
  case when DATEADD(day,270,start_date) > op_end_date then op_end_date else DATEADD(day,270,start_date) end as end_date
INTO #strategy_ends
from #included_events;


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
-- End Date Strategy
SELECT event_id, person_id, end_date from #strategy_ends

UNION ALL
-- Censor Events
select i.event_id, i.person_id, MIN(c.start_date) as end_date
FROM #included_events i
JOIN
(
-- Begin Condition Occurrence Criteria
SELECT C.person_id, C.condition_occurrence_id as event_id, C.condition_start_date as start_date, COALESCE(C.condition_end_date, DATEADD(day,1,C.condition_start_date)) as end_date,
  C.visit_occurrence_id, C.condition_start_date as sort_date
FROM 
(
  SELECT co.* 
  FROM @cdm_database_schema.CONDITION_OCCURRENCE co
  JOIN #Codesets cs on (co.condition_concept_id = cs.concept_id and cs.codeset_id = 11)
) C


-- End Condition Occurrence Criteria

) C on C.person_id = I.person_id and C.start_date >= I.start_date and C.START_DATE <= I.op_end_date
GROUP BY i.event_id, i.person_id

UNION ALL
select i.event_id, i.person_id, MIN(c.start_date) as end_date
FROM #included_events i
JOIN
(
-- Begin Observation Criteria
select C.person_id, C.observation_id as event_id, C.observation_date as start_date, DATEADD(d,1,C.observation_date) as END_DATE,
       C.visit_occurrence_id, C.observation_date as sort_date
from 
(
  select o.* 
  FROM @cdm_database_schema.OBSERVATION o
JOIN #Codesets cs on (o.observation_concept_id = cs.concept_id and cs.codeset_id = 11)
) C


-- End Observation Criteria

) C on C.person_id = I.person_id and C.start_date >= I.start_date and C.START_DATE <= I.op_end_date
GROUP BY i.event_id, i.person_id

UNION ALL
select i.event_id, i.person_id, MIN(c.start_date) as end_date
FROM #included_events i
JOIN
(
-- Begin Procedure Occurrence Criteria
select C.person_id, C.procedure_occurrence_id as event_id, C.procedure_date as start_date, DATEADD(d,1,C.procedure_date) as END_DATE,
       C.visit_occurrence_id, C.procedure_date as sort_date
from 
(
  select po.* 
  FROM @cdm_database_schema.PROCEDURE_OCCURRENCE po
JOIN #Codesets cs on (po.procedure_concept_id = cs.concept_id and cs.codeset_id = 11)
) C


-- End Procedure Occurrence Criteria

) C on C.person_id = I.person_id and C.start_date >= I.start_date and C.START_DATE <= I.op_end_date
GROUP BY i.event_id, i.person_id


    ) CE on I.event_id = CE.event_id and I.person_id = CE.person_id and CE.end_date >= I.start_date
	) F
	WHERE F.ordinal = 1
) FE;

select person_id, min(start_date) as start_date, end_date
into #final_cohort
from ( --cteEnds
	SELECT
		 c.person_id
		, c.start_date
		, MIN(ed.end_date) AS end_date
	FROM #cohort_rows c
	JOIN ( -- cteEndDates
    SELECT
      person_id
      , DATEADD(day,-1 * 0, event_date)  as end_date
    FROM
    (
      SELECT
        person_id
        , event_date
        , event_type
        , MAX(start_ordinal) OVER (PARTITION BY person_id ORDER BY event_date, event_type, start_ordinal ROWS UNBOUNDED PRECEDING) AS start_ordinal 
        , ROW_NUMBER() OVER (PARTITION BY person_id ORDER BY event_date, event_type, start_ordinal) AS overall_ord
      FROM
      (
        SELECT
          person_id
          , start_date AS event_date
          , -1 AS event_type
          , ROW_NUMBER() OVER (PARTITION BY person_id ORDER BY start_date) AS start_ordinal
        FROM #cohort_rows

        UNION ALL


        SELECT
          person_id
          , DATEADD(day,0,end_date) as end_date
          , 1 AS event_type
          , NULL
        FROM #cohort_rows
      ) RAWDATA
    ) e
    WHERE (2 * e.start_ordinal) - e.overall_ord = 0
  ) ed ON c.person_id = ed.person_id AND ed.end_date >= c.start_date
	GROUP BY c.person_id, c.start_date
) e
group by person_id, end_date
;

DELETE FROM @target_database_schema.@target_cohort_table where cohort_definition_id = @target_cohort_id;
INSERT INTO @target_database_schema.@target_cohort_table (cohort_definition_id, subject_id, cohort_start_date, cohort_end_date)
select @target_cohort_id as cohort_definition_id, person_id, start_date, end_date 
FROM #final_cohort CO
;


-- BEGIN: Censored Stats

delete from @results_database_schema.cohort_censor_stats where cohort_definition_id = @target_cohort_id;

-- END: Censored Stats



-- Create a temp table of inclusion rule rows for joining in the inclusion rule impact analysis

select cast(rule_sequence as int) as rule_sequence
into #inclusion_rules
from (
  SELECT CAST(0 as int) as rule_sequence UNION ALL SELECT CAST(1 as int) as rule_sequence
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


TRUNCATE TABLE #strategy_ends;
DROP TABLE #strategy_ends;


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
