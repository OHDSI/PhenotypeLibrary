CREATE TABLE #Codesets (
  codeset_id int NOT NULL,
  concept_id bigint NOT NULL
)
;

INSERT INTO #Codesets (codeset_id, concept_id)
SELECT 1 as codeset_id, c.concept_id FROM (select distinct I.concept_id FROM
( 
  select concept_id from @vocabulary_database_schema.CONCEPT where concept_id in (444413,437663,4141062,4152360,43530637,4178904)
UNION  select c.concept_id
  from @vocabulary_database_schema.CONCEPT c
  join @vocabulary_database_schema.CONCEPT_ANCESTOR ca on c.concept_id = ca.descendant_concept_id
  and ca.ancestor_concept_id in (444413,437663,4141062,4152360,43530637,4178904)
  and c.invalid_reason is null

) I
LEFT JOIN
(
  select concept_id from @vocabulary_database_schema.CONCEPT where concept_id in (4346179,4170869,4226022,37205085,4318555,37016869,443908,4093997,4347651,440285,4087628,4143214,4039793,37397178,40493465,4199309,44784428,44784427,44784429,44782483,43530646,4086668,3197956,4094003,43530637,37017455,4087629,4150518,4184347,4326408,4200980,4229442,4239624,4300533,4308214,4099900,4094000,4087017,438963,4243806)
UNION  select c.concept_id
  from @vocabulary_database_schema.CONCEPT c
  join @vocabulary_database_schema.CONCEPT_ANCESTOR ca on c.concept_id = ca.descendant_concept_id
  and ca.ancestor_concept_id in (4346179,4170869,4226022,37205085,4318555,37016869,443908,4093997,4347651,440285,4087628,4143214,4039793,37397178,40493465,4199309,44784428,44784427,44784429,44782483,43530646,4086668,3197956,4094003,43530637,37017455,4087629,4150518,4184347,4326408,4200980,4229442,4239624,4300533,4308214,4099900,4094000,4087017,438963,4243806)
  and c.invalid_reason is null

) E ON I.concept_id = E.concept_id
WHERE E.concept_id is null
) C UNION ALL 
SELECT 2 as codeset_id, c.concept_id FROM (select distinct I.concept_id FROM
( 
  select concept_id from @vocabulary_database_schema.CONCEPT where concept_id in (3025085,21490870,21490688,3020891,3025926,3025704,3017614,3011783,3004750,3008557,3007846,3016117,3006749,3016715,3018145,3015039,3009553,4329518,4174894,21490907,21490588,4212763,44809208,21490906,21490590,4039793,4077057,4039791,4151775,3006322,3022060,4265708,3025163)
UNION  select c.concept_id
  from @vocabulary_database_schema.CONCEPT c
  join @vocabulary_database_schema.CONCEPT_ANCESTOR ca on c.concept_id = ca.descendant_concept_id
  and ca.ancestor_concept_id in (3025085,21490870,21490688,3020891,3025926,3025704,3017614,3011783,3004750,3008557,3007846,3016117,3006749,3016715,3018145,3015039,3009553,4329518,4174894,21490907,21490588,4212763,44809208,21490906,21490590,4039793,4077057,4039791,4151775,3006322,3022060,4265708,3025163)
  and c.invalid_reason is null

) I
LEFT JOIN
(
  select concept_id from @vocabulary_database_schema.CONCEPT where concept_id in (4189949,4040476,4039792,4040104,4164378,4039796,4039795,4040106,4039794,4038778,45769775,4267945)
UNION  select c.concept_id
  from @vocabulary_database_schema.CONCEPT c
  join @vocabulary_database_schema.CONCEPT_ANCESTOR ca on c.concept_id = ca.descendant_concept_id
  and ca.ancestor_concept_id in (4189949,4040476,4039792,4040104,4164378,4039796,4039795,4040106,4039794,4038778,45769775,4267945)
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
  JOIN #Codesets cs on (co.condition_concept_id = cs.concept_id and cs.codeset_id = 1)
) C


-- End Condition Occurrence Criteria

UNION ALL
-- Begin Measurement Criteria
select C.person_id, C.measurement_id as event_id, C.measurement_date as start_date, DATEADD(d,1,C.measurement_date) as END_DATE,
       C.visit_occurrence_id, C.measurement_date as sort_date
from 
(
  select m.* 
  FROM @cdm_database_schema.MEASUREMENT m
JOIN #Codesets cs on (m.measurement_concept_id = cs.concept_id and cs.codeset_id = 1)
) C


-- End Measurement Criteria

UNION ALL
-- Begin Measurement Criteria
select C.person_id, C.measurement_id as event_id, C.measurement_date as start_date, DATEADD(d,1,C.measurement_date) as END_DATE,
       C.visit_occurrence_id, C.measurement_date as sort_date
from 
(
  select m.* 
  FROM @cdm_database_schema.MEASUREMENT m
JOIN #Codesets cs on (m.measurement_concept_id = cs.concept_id and cs.codeset_id = 2)
) C

WHERE (C.value_as_number >= 38.0000 and C.value_as_number <= 42.0000)
AND C.unit_concept_id in (586323)
-- End Measurement Criteria

UNION ALL
-- Begin Measurement Criteria
select C.person_id, C.measurement_id as event_id, C.measurement_date as start_date, DATEADD(d,1,C.measurement_date) as END_DATE,
       C.visit_occurrence_id, C.measurement_date as sort_date
from 
(
  select m.* 
  FROM @cdm_database_schema.MEASUREMENT m
JOIN #Codesets cs on (m.measurement_concept_id = cs.concept_id and cs.codeset_id = 2)
) C

WHERE (C.value_as_number >= 100.4000 and C.value_as_number <= 120.0000)
AND C.unit_concept_id in (9289)
-- End Measurement Criteria

UNION ALL
-- Begin Observation Criteria
select C.person_id, C.observation_id as event_id, C.observation_date as start_date, DATEADD(d,1,C.observation_date) as END_DATE,
       C.visit_occurrence_id, C.observation_date as sort_date
from 
(
  select o.* 
  FROM @cdm_database_schema.OBSERVATION o
JOIN #Codesets cs on (o.observation_concept_id = cs.concept_id and cs.codeset_id = 2)
) C

WHERE (C.value_as_number >= 38.0000 and C.value_as_number <= 42.0000)
AND C.unit_concept_id in (586323)
-- End Observation Criteria

UNION ALL
-- Begin Observation Criteria
select C.person_id, C.observation_id as event_id, C.observation_date as start_date, DATEADD(d,1,C.observation_date) as END_DATE,
       C.visit_occurrence_id, C.observation_date as sort_date
from 
(
  select o.* 
  FROM @cdm_database_schema.OBSERVATION o
JOIN #Codesets cs on (o.observation_concept_id = cs.concept_id and cs.codeset_id = 2)
) C

WHERE (C.value_as_number >= 100.4000 and C.value_as_number <= 120.0000)
AND C.unit_concept_id in (9289)
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

create table #inclusion_events (inclusion_rule_id bigint,
	person_id bigint,
	event_id bigint
);

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

) Results

;

-- date offset strategy

select event_id, person_id, 
  case when DATEADD(day,3,end_date) > op_end_date then op_end_date else DATEADD(day,3,end_date) end as end_date
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
      , DATEADD(day,-1 * 30, event_date)  as end_date
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
          , DATEADD(day,30,end_date) as end_date
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
