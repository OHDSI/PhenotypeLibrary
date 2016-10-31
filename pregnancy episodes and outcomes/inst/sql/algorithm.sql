select a.category, a.gest_value, a.person_id, a.start_date, a.type, a.value_as_string, a.value_as_number
into #raw_events
from
(
	select b.category, b.gest_value, person_id, a.CONDITION_CONCEPT_ID as CONCEPT_ID,  condition_start_date as start_date,  'Cond' as type, ' ' as value_as_string,null as value_as_number
	from @cdm_database_schema.condition_occurrence a
	join @target_database_schema.@tablestem_pregnancy_concepts b on a.CONDITION_CONCEPT_ID=b.concept_id

	union all
	select b.category, b.gest_value, person_id, a.PROCEDURE_CONCEPT_ID as CONCEPT_ID, procedure_date as start_date, 'Proc' as type, ' ' as value_as_string,null as value_as_number
	from @cdm_database_schema.procedure_occurrence a
	join @target_database_schema.@tablestem_pregnancy_concepts b on a.PROCEDURE_CONCEPT_ID=b.concept_id

	union all
	select b.category, b.gest_value, person_id, a.OBSERVATION_CONCEPT_ID as CONCEPT_ID, observation_date as start_date, 'Obs' as type, value_as_string, value_as_number
	from @cdm_database_schema.observation a
	join @target_database_schema.@tablestem_pregnancy_concepts b on a.OBSERVATION_CONCEPT_ID=b.concept_id
	where b.data_value = '' or (b.data_value = a.value_as_string)

	union all
	select b.category, b.gest_value, person_id, a.MEASUREMENT_CONCEPT_ID as CONCEPT_ID, measurement_date as start_date, 'Meas' as type, value_source_value, value_as_number
	from @cdm_database_schema.measurement a
	join @target_database_schema.@tablestem_pregnancy_concepts b on a.measurement_CONCEPT_ID=b.concept_id
	where b.data_value = '' or (b.data_value = a.value_source_value)
) a
;

with cteDiabetesMembers as /* Patients with a Glucose test record */
(
	select distinct person_id from #raw_events where category = 'DIAB'
)
select PERSON_ID, CATEGORY, GEST_VALUE, START_DATE
into #events_nondrug
from
(
  select PERSON_ID,
  Category,
  /*convert gestational weeks to days */
  case when category='GEST' and value_as_number is not null then 7*value_as_number
      when category='GEST' and gest_value is not null then 7*gest_value
  	  else null end as gest_value,
  start_date
  from #raw_events
  where person_id not in /* exclude people who have ONLY glucose tests */
  (
  	select e.person_id
  	from #raw_events e
  	join cteDiabetesMembers m on e.person_id = m.person_id
  	group by e.person_id
  	having count(distinct e.category) = 1
  )
) a
where not (category='GEST' and (gest_value is null or gest_value>301))
;

select f.person_id, f.category, f.start_date, f.gest_value
INTO #events_drug
from (
  select distinct person_id from #events_nondrug
) a
join (
  select person_id, a.DRUG_CONCEPT_ID as CONCEPT_ID,  DRUG_exposure_start_date as start_date,
    'Drug' as type, ' ' as value_as_string, null as value_as_number, e.gest_value, e.category
	from @cdm_database_schema.drug_exposure a
	join (
	  select c.concept_id, c.concept_name, d.gest_value, d.category
    from @cdm_database_schema.concept c
    join (
      select b.descendant_concept_id, a.concept_id, a.category, a.gest_value
      from @cdm_database_schema.concept_ancestor b
      join (
        select concept_id, category, gest_value
        from @target_database_schema.@tablestem_pregnancy_concepts
        where category in ('CONTRA','MTX','OVULDR')
      ) a on a.concept_id=b.ANCESTOR_CONCEPT_ID
    ) d on c.concept_id=d.DESCENDANT_CONCEPT_ID
    where c.concept_class_id in ('Branded Drug','Branded Pack','Clinical Drug','Clinical Pack','Ingredient')
  ) e on a.DRUG_CONCEPT_ID=e.concept_id
) f on a.person_id=f.person_id
;

select person_id, category, event_date, gest_value
INTO #events_all
FROM  (
	select person_id, category, start_date as event_date, gest_value
	from #events_nondrug

	UNION ALL
	select person_id, category, start_date as event_date, gest_value
	from #events_drug
) E
;

select PERSON_ID, ROW_NUMBER() OVER (PARTITION BY person_id ORDER BY event_date) AS event_id,
  category, event_date, gest_value
into #pregnancy_events
from #events_all
;

TRUNCATE TABLE #events_drug;
DROP TABLE #events_drug;

TRUNCATE TABLE #events_nondrug;
DROP TABLE #events_nondrug;

TRUNCATE TABLE #events_all;
DROP TABLE #events_all;

TRUNCATE TABLE  #raw_events;
DROP TABLE  #raw_events;

-- Step 1. Initlaize temp tables

CREATE TABLE #ValidOutcomes
(
  PERSON_ID bigint not null,
	EVENT_ID int not null
)
;


-- Step 2. populate #ValidOutcomes with 'true' LB pregnancy outcome dates

with cteTargetPeople (person_id) as
(
  select distinct person_id
  from #pregnancy_events pe
  where pe.category = 'LB'
),
cteTargetCategory (category) as
(
  select first_preg_category from @target_database_schema.@tablestem_outcome_limit
  UNION
  select outcome_preg_category from @target_database_schema.@tablestem_outcome_limit
)
SELECT pe.person_id, min(pe.EVENT_ID) as event_id
INTO #PregnancyEvents
from #pregnancy_events pe
join cteTargetPeople tp on pe.person_id = tp.person_id
join cteTargetCategory tc on tc.category = pe.category
group by pe.person_id, pe.category, pe.event_date, pe.gest_value
;

while (1=1)
BEGIN

with outcomeCodes (CATEGORY) as
(
	select distinct FIRST_PREG_CATEGORY from @target_database_schema.@tablestem_outcome_limit
	where first_preg_category='LB'
),
numberedOutcomeEvents AS
(
	SELECT p.EVENT_ID, p.PERSON_ID, p.Category, p.gest_value, p.EVENT_DATE,
	row_number() over (partition by p.PERSON_ID order by p.event_date, p.event_id) as rn
	FROM #pregnancy_events p
	JOIN #PregnancyEvents e on p.person_id = e.person_id and p.EVENT_ID = e.EVENT_ID
	JOIN outcomeCodes oc on p.CATEGORY = oc.CATEGORY
)
select PERSON_ID, EVENT_ID
INTO #FirstOutcomeEvent
FROM numberedOutcomeEvents
WHERE rn = 1;

if (select count(*) from #FirstOutcomeEvent) = 0
  break;

INSERT INTO #ValidOutcomes (PERSON_ID, EVENT_ID)
select PERSON_ID, EVENT_ID from #FirstOutcomeEvent;

select e.PERSON_ID, e.EVENT_ID
INTO #deletedEvents
FROM #PregnancyEvents e
JOIN #pregnancy_events pe on e.PERSON_ID = pe.PERSON_ID and pe.EVENT_ID = e.EVENT_ID
JOIN #FirstOutcomeEvent fo on fo.PERSON_ID = pe.PERSON_ID
JOIN #pregnancy_events foe on foe.person_id = fo.person_id and foe.EVENT_ID = fo.EVENT_ID
JOIN @target_database_schema.@tablestem_outcome_limit ol on ol.FIRST_PREG_CATEGORY = foe.Category AND ol.OUTCOME_PREG_CATEGORY = pe.Category
WHERE (datediff(d,foe.EVENT_DATE, pe.EVENT_DATE) + 1) < ol.MIN_DAYS
;


with cteTargetPeople (person_id) as
(
  select distinct e.person_id
  from #PregnancyEvents e
  join #pregnancy_events pe on e.person_id = pe.person_id and e.event_id = pe.event_id
  where pe.category = 'LB'
)
select pe.PERSON_ID, pe.EVENT_ID
INTO #temp_PregnancyEvents
FROM #PregnancyEvents pe
join cteTargetPeople p on pe.person_id = p.person_id
left join #deletedEvents de on pe.person_id = de.person_id and pe.event_id = de.event_id
where de.person_id is null;

TRUNCATE TABLE #deletedEvents;
DROP TABLE #deletedEvents;

TRUNCATE TABLE #PregnancyEvents;
DROP TABLE #PregnancyEvents;

SELECT PERSON_ID, EVENT_ID
INTO #PregnancyEvents
from #temp_PregnancyEvents
;

TRUNCATE TABLE #temp_PregnancyEvents;
DROP TABLE #temp_PregnancyEvents;

TRUNCATE TABLE #FirstOutcomeEvent;
DROP TABLE #FirstOutcomeEvent;

END;

-- Cleanup tables used in Step 2.

TRUNCATE TABLE #PregnancyEvents;
DROP TABLE #PregnancyEvents;

TRUNCATE TABLE #FirstOutcomeEvent;
DROP TABLE #FirstOutcomeEvent;

-- Step 3. populate #ValidOutcomes with 'true' SB pregnancy outcome dates

with cteTargetPeople (person_id) as
(
  select distinct person_id
  from #pregnancy_events pe
  where pe.category = 'SB'
),
cteTargetCategory (category) as
(
  select first_preg_category as catgory from @target_database_schema.@tablestem_outcome_limit
  UNION
  select outcome_preg_category as category from @target_database_schema.@tablestem_outcome_limit
  UNION
  select 'AGP' as category
  UNION
  select 'PCONF' as category
)
SELECT pe.person_id, min(pe.EVENT_ID) as event_id
INTO #PregnancyEvents
from #pregnancy_events pe
join cteTargetPeople tp on pe.person_id = tp.person_id
join cteTargetCategory tc on tc.category = pe.category
group by pe.person_id, pe.category, pe.event_date, pe.gest_value
;

while (1=1)
BEGIN

with outcomeCodes (CATEGORY) as
(
	select distinct FIRST_PREG_CATEGORY from @target_database_schema.@tablestem_outcome_limit
	where first_preg_category='SB'
),
numberedOutcomeEvents AS
(
	SELECT p.EVENT_ID, p.PERSON_ID, p.Category, p.gest_value, p.EVENT_DATE,
	row_number() over (partition by p.PERSON_ID order by p.event_date, p.event_id) as rn
	FROM #pregnancy_events p
	JOIN #PregnancyEvents e on p.person_id = e.person_id and p.EVENT_ID = e.EVENT_ID
	JOIN outcomeCodes oc on p.CATEGORY = oc.CATEGORY
)
select PERSON_ID, EVENT_ID
INTO #FirstOutcomeEvent
FROM numberedOutcomeEvents
WHERE rn = 1;

if (select count(*) from #FirstOutcomeEvent) = 0
 break;

select distinct a.person_id, a.event_id
into #FirstOutcomeEventInv
from #FirstOutcomeEvent a
JOIN #pregnancy_events foe on foe.person_id = a.person_id and foe.EVENT_ID = a.EVENT_ID
JOIN #pregnancy_events sp on sp.person_id=a.person_id
where sp.category in ('AGP', 'PCONF') and datediff(dd,foe.EVENT_DATE,sp.event_date)>0
	and datediff(dd,foe.EVENT_DATE,sp.event_date)<=42 ;

with ctePriorOutcomes as
(select pe.person_id, pe.event_id,
case when pe.event_date <= foe.event_date then 1 else 0 end as prior
	FROM #ValidOutcomes e
	JOIN #pregnancy_events pe on pe.EVENT_ID = e.EVENT_ID and pe.person_id = e.person_id
	JOIN #FirstOutcomeEvent fo on fo.PERSON_ID = pe.PERSON_ID
	JOIN #pregnancy_events foe on foe.person_id = fo.person_id and foe.EVENT_ID = fo.EVENT_ID
),
cteInvalidOutcomes as
(
	select fo.person_id, fo.event_id
	FROM #ValidOutcomes e
	JOIN #pregnancy_events pe on pe.EVENT_ID = e.EVENT_ID and pe.person_id = e.person_id
	JOIN #FirstOutcomeEvent fo on fo.PERSON_ID = pe.PERSON_ID
	JOIN #pregnancy_events foe on foe.EVENT_ID = fo.EVENT_ID and foe.person_id = fo.person_id
	JOIN ctePriorOutcomes po on po.event_id=pe.event_id and po.person_id = pe.person_id
	JOIN @target_database_schema.@tablestem_outcome_limit o1 on o1.FIRST_PREG_CATEGORY = foe.Category AND o1.OUTCOME_PREG_CATEGORY = pe.Category
	JOIN @target_database_schema.@tablestem_outcome_limit o2 on o2.FIRST_PREG_CATEGORY = pe.Category AND o2.OUTCOME_PREG_CATEGORY = foe.Category
	WHERE (abs(datediff(d,foe.EVENT_DATE, pe.EVENT_DATE) + 1) < o2.MIN_DAYS and prior=1)
	  or (abs(datediff(d,foe.EVENT_DATE, pe.EVENT_DATE) + 1) < o1.MIN_DAYS and prior=0)
)
select a.person_id, a.event_id
INTO #temp_ValidOutcomes
from #FirstOutcomeEvent a
left join cteInvalidOutcomes b on a.person_id = b.person_id and a.event_id=b.event_id
left join #FirstOutcomeEventInv c on a.person_id = c.person_id and a.event_id=c.EVENT_ID
where b.event_id is null and c.EVENT_ID is null;


INSERT INTO #ValidOutcomes
select PERSON_ID, EVENT_ID from #temp_ValidOutcomes;

DROP TABLE #temp_ValidOutcomes;

with cteTargetPeople (person_id) as
(
  select distinct e.person_id
  from #PregnancyEvents e
  join #pregnancy_events pe on e.person_id = pe.person_id and e.event_id = pe.event_id
  where pe.category = 'SB'
)
select pe.PERSON_ID, pe.EVENT_ID
INTO #temp_PregnancyEvents
FROM #PregnancyEvents pe
join cteTargetPeople p on pe.person_id = p.person_id
left join #FirstOutcomeEvent de on pe.person_id = de.person_id and pe.event_id = de.event_id
where de.person_id is null;

TRUNCATE TABLE #PregnancyEvents;
DROP TABLE #PregnancyEvents;

SELECT PERSON_ID, EVENT_ID
INTO #PregnancyEvents
from #temp_PregnancyEvents
;

TRUNCATE TABLE #temp_PregnancyEvents;
DROP TABLE #temp_PregnancyEvents;

TRUNCATE TABLE #FirstOutcomeEvent;
DROP TABLE #FirstOutcomeEvent;

TRUNCATE TABLE #FirstOutcomeEventInv;
DROP TABLE #FirstOutcomeEventInv;

END
;

-- Cleanup temp tables from Step 3.

TRUNCATE TABLE #PregnancyEvents;
DROP TABLE #PregnancyEvents;

TRUNCATE TABLE #FirstOutcomeEvent;
DROP TABLE #FirstOutcomeEvent;


--Step 4 deleted trophoblastic disease

-- Step 5. populate #ValidOutcomes with 'true' ECT pregnancy outcome dates

with cteTargetPeople (person_id) as
(
  select distinct person_id
  from #pregnancy_events pe
  where pe.category = 'ECT'
),
cteTargetCategory (category) as
(
  select first_preg_category as catgory from @target_database_schema.@tablestem_outcome_limit
  UNION
  select outcome_preg_category as category from @target_database_schema.@tablestem_outcome_limit
  UNION
  select 'AGP' as category
  UNION
  select 'PCONF' as category
  UNION
  select 'ECT_SURG1' as category
  UNION
  select 'ECT_SURG2' as category
  UNION
  select 'MTX' as category
)
SELECT pe.person_id, min(pe.EVENT_ID) as event_id
INTO #PregnancyEvents
from #pregnancy_events pe
join cteTargetPeople tp on pe.person_id = tp.person_id
join cteTargetCategory tc on tc.category = pe.category
group by pe.person_id, pe.category, pe.event_date, pe.gest_value
;


while (1=1)
BEGIN

with outcomeCodes (CATEGORY) as
(
	select distinct FIRST_PREG_CATEGORY from @target_database_schema.@tablestem_outcome_limit
	where first_preg_category='ECT'
),
numberedOutcomeEvents AS
(
	SELECT p.EVENT_ID, p.PERSON_ID, p.Category, p.gest_value, p.EVENT_DATE,
	row_number() over (partition by p.PERSON_ID order by p.event_date, p.event_id) as rn
	FROM #pregnancy_events p
	JOIN #PregnancyEvents e on p.person_id = e.person_id and p.EVENT_ID = e.EVENT_ID
	JOIN outcomeCodes oc on p.CATEGORY = oc.CATEGORY
)
SELECT PERSON_ID, EVENT_ID
INTO #FirstOutcomeEvent
FROM numberedOutcomeEvents
WHERE rn = 1;

if (select count(*) from #FirstOutcomeEvent) = 0
 break;

-- validate ectopic pregnancy, surgery or MTX or disporop concept within 2 weeks

-- check if ECT has surgery within 2 weeks
select person_id, event_id, EPISODE_END_DATE_REVISED, date_difference
into #FirstOutcomeEventSurg1
from
(
  select distinct a.person_id, a.event_id,
    sp.event_date as EPISODE_END_DATE_REVISED, datediff(dd,foe.EVENT_DATE,sp.event_date) as date_difference,
    row_number() over (partition by a.person_id, a.event_id order by sp.event_date desc) as rn
  from #FirstOutcomeEvent a
  JOIN #pregnancy_events foe on foe.person_id = a.person_id and foe.EVENT_ID = a.EVENT_ID
  JOIN #pregnancy_events sp on sp.person_id=a.person_id
	where sp.category in ('ECT_SURG1','ECT_SURG2', 'MTX')
	  and datediff(dd,foe.EVENT_DATE,sp.event_date)>=0
	  and datediff(dd,foe.EVENT_DATE,sp.event_date)<=14
)  b
where rn=1 ;

-- check if ECT has surgery within 2 weeks for new outcome date- different concept code set
select person_id, event_id, EPISODE_END_DATE_REVISED, date_difference
into #FirstOutcomeEventSurg2
from
(
  select distinct a.person_id, a.event_id,
    sp.event_date as EPISODE_END_DATE_REVISED, datediff(dd,foe.EVENT_DATE,sp.event_date) as date_difference,
    row_number() over (partition by a.person_id, a.event_id order by sp.event_date desc) as rn
  from #FirstOutcomeEvent a
  JOIN #pregnancy_events foe on foe.person_id = a.person_id and foe.EVENT_ID = a.EVENT_ID
  JOIN #pregnancy_events sp on sp.person_id=a.person_id
	where sp.category in ('ECT_SURG1','MTX')
	  and datediff(dd,foe.EVENT_DATE,sp.event_date)>=0
	  and datediff(dd,foe.EVENT_DATE,sp.event_date)<=14
)  b
where rn=1 ;

-- if so update raw events file to reflect new date
UPDATE #pregnancy_events
SET #pregnancy_events.event_date = #FirstOutcomeEventSurg2.episode_end_date_revised
FROM #FirstOutcomeEventSurg2
WHERE  #FirstOutcomeEventSurg2.person_id=#pregnancy_events.person_id
  and #FirstOutcomeEventSurg2.event_id=#pregnancy_events.event_id;

-- check if ECT is a rule-out diagnosis if there are active preg codes up to 6 weeks after
select distinct a.person_id, a.event_id
into #FirstOutcomeEventInv
from #FirstOutcomeEvent a
JOIN #pregnancy_events foe on foe.person_id = a.person_id and foe.EVENT_ID = a.EVENT_ID
JOIN #pregnancy_events sp on sp.person_id=a.person_id
where sp.category in ('AGP', 'PCONF') and datediff(dd,foe.EVENT_DATE,sp.event_date)>0
	and datediff(dd,foe.EVENT_DATE,sp.event_date)<=42 ;

with ctePriorOutcomes as (
	select pe.person_id, pe.event_id,
		case when pe.event_date <= foe.event_date then 1 else 0 end as prior
	FROM #ValidOutcomes e
	JOIN #pregnancy_events pe on pe.EVENT_ID = e.EVENT_ID and pe.person_id = e.person_id
	JOIN #FirstOutcomeEvent fo on fo.PERSON_ID = pe.PERSON_ID
	JOIN #pregnancy_events foe on foe.person_id = fo.person_id and foe.EVENT_ID = fo.EVENT_ID
),
cteInvalidOutcomes as
(
	select fo.person_id, fo.event_id
	FROM #ValidOutcomes e
	JOIN #pregnancy_events pe on pe.EVENT_ID = e.EVENT_ID and pe.person_id = e.person_id
	JOIN #FirstOutcomeEvent fo on fo.PERSON_ID = pe.PERSON_ID
	JOIN #pregnancy_events foe on foe.EVENT_ID = fo.EVENT_ID and foe.person_id = fo.person_id
	JOIN ctePriorOutcomes po on po.event_id=pe.event_id and po.person_id = pe.person_id
	JOIN @target_database_schema.@tablestem_outcome_limit o1 on o1.FIRST_PREG_CATEGORY = foe.Category AND o1.OUTCOME_PREG_CATEGORY = pe.Category
	JOIN @target_database_schema.@tablestem_outcome_limit o2 on o2.FIRST_PREG_CATEGORY = pe.Category AND o2.OUTCOME_PREG_CATEGORY = foe.Category
	WHERE (abs(datediff(d,foe.EVENT_DATE, pe.EVENT_DATE) + 1) < o2.MIN_DAYS and prior=1)
	  or (abs(datediff(d,foe.EVENT_DATE, pe.EVENT_DATE) + 1) < o1.MIN_DAYS and prior=0)
)
select a.person_id, a.event_id
INTO #temp_ValidOutcomes
from #FirstOutcomeEvent a
left join cteInvalidOutcomes b on a.person_id = b.person_id and a.event_id=b.event_id
left join #FirstOutcomeEventInv c on a.person_id = c.person_id and a.event_id=c.EVENT_ID
left join #FirstOutcomeEventSurg1 d on a.person_id = d.person_id and a.event_id=d.event_id
where b.event_id is null and c.EVENT_ID is null and d.event_id is not null;

INSERT INTO #ValidOutcomes
select PERSON_ID, EVENT_ID from #temp_ValidOutcomes;

DROP TABLE #temp_ValidOutcomes;

with cteTargetPeople (person_id) as
(
  select distinct e.person_id
  from #PregnancyEvents e
  join #pregnancy_events pe on e.person_id = pe.person_id and e.event_id = pe.event_id
  where pe.category = 'ECT'
)
select pe.PERSON_ID, pe.EVENT_ID
INTO #temp_PregnancyEvents
FROM #PregnancyEvents pe
join cteTargetPeople p on pe.person_id = p.person_id
left join #FirstOutcomeEvent de on pe.person_id = de.person_id and pe.event_id = de.event_id
where de.person_id is null;

TRUNCATE TABLE #PregnancyEvents;
DROP TABLE #PregnancyEvents;

SELECT PERSON_ID, EVENT_ID
INTO #PregnancyEvents
from #temp_PregnancyEvents
;

TRUNCATE TABLE #temp_PregnancyEvents;
DROP TABLE #temp_PregnancyEvents;


TRUNCATE TABLE #FirstOutcomeEvent;
DROP TABLE #FirstOutcomeEvent;

TRUNCATE TABLE #FirstOutcomeEventInv;
DROP TABLE #FirstOutcomeEventInv;

TRUNCATE TABLE #FirstOutcomeEventSurg1;
DROP TABLE #FirstOutcomeEventSurg1;

TRUNCATE TABLE #FirstOutcomeEventSurg2;
DROP TABLE #FirstOutcomeEventSurg2;
END
;

-- Cleanup temp tables created in Step 5.
TRUNCATE TABLE #PregnancyEvents;
DROP TABLE #PregnancyEvents;

TRUNCATE TABLE #FirstOutcomeEvent;
DROP TABLE #FirstOutcomeEvent;


-- Step 6. populate #ValidOutcomes with 'true' AB (induced) pregnancy outcome dates

with cteTargetPeople (person_id) as
(
  select distinct person_id
  from #pregnancy_events pe
  where pe.category = 'AB'
),
cteTargetCategory (category) as
(
  select first_preg_category as catgory from @target_database_schema.@tablestem_outcome_limit
  UNION
  select outcome_preg_category as category from @target_database_schema.@tablestem_outcome_limit
  UNION
  select 'AGP' as category
  UNION
  select 'PCONF' as category
)
SELECT pe.person_id, min(pe.EVENT_ID) as event_id
INTO #PregnancyEvents
from #pregnancy_events pe
join cteTargetPeople tp on pe.person_id = tp.person_id
join cteTargetCategory tc on tc.category = pe.category
group by pe.person_id, pe.category, pe.event_date, pe.gest_value
;

while (1=1)
BEGIN


with outcomeCodes (CATEGORY) as
(
	select distinct FIRST_PREG_CATEGORY from @target_database_schema.@tablestem_outcome_limit
	where first_preg_category='AB'
),
numberedOutcomeEvents AS
(
	SELECT p.EVENT_ID, p.PERSON_ID, p.Category, p.gest_value, p.EVENT_DATE,
	row_number() over (partition by p.PERSON_ID order by p.event_date, p.event_id) as rn
	FROM #pregnancy_events p
	JOIN #PregnancyEvents e on p.person_id = e.person_id and p.EVENT_ID = e.EVENT_ID
	JOIN outcomeCodes oc on p.CATEGORY = oc.CATEGORY
)
SELECT PERSON_ID, EVENT_ID
INTO #FirstOutcomeEvent
FROM numberedOutcomeEvents
WHERE rn = 1;

if (select count(*) from #FirstOutcomeEvent) = 0
 break;

--check if AB has AB/SA procedure within 2 weeks
select person_id, event_id, EPISODE_END_DATE_REVISED, date_difference
into #FirstOutcomeEventSurg
from
(
  select distinct a.person_id, a.event_id,
    sp.event_date as EPISODE_END_DATE_REVISED, datediff(dd,foe.EVENT_DATE,sp.event_date) as date_difference,
    row_number() over (partition by a.person_id, a.event_id order by sp.event_date desc) as rn
  from #FirstOutcomeEvent a
  JOIN #pregnancy_events foe on foe.person_id = a.person_id and foe.EVENT_ID = a.EVENT_ID
  JOIN #pregnancy_events sp on sp.person_id=a.person_id
	where sp.category in ('SA', 'AB') and datediff(dd,foe.EVENT_DATE,sp.event_date)>=0
	and datediff(dd,foe.EVENT_DATE,sp.event_date)<=14
)  b
where rn=1 ;

--if so update raw events file to reflect new date
UPDATE #pregnancy_events
SET event_date = #FirstOutcomeEventSurg.episode_end_date_revised
FROM #FirstOutcomeEventSurg
WHERE #pregnancy_events.person_id = #FirstOutcomeEventSurg.person_id
  and #pregnancy_events.event_id = #FirstOutcomeEventSurg.event_id
;

select distinct a.person_id, a.event_id
into #FirstOutcomeEventInv
from #FirstOutcomeEvent a
JOIN #pregnancy_events foe on foe.person_id = a.person_id and foe.EVENT_ID = a.EVENT_ID
JOIN #pregnancy_events sp on sp.person_id=a.person_id
where sp.category in ('AGP', 'PCONF') and datediff(dd,foe.EVENT_DATE,sp.event_date)>0
	and datediff(dd,foe.EVENT_DATE,sp.event_date)<=42;

with ctePriorOutcomes as (
	select pe.person_id, pe.event_id,
		case when pe.event_date <= foe.event_date then 1 else 0 end as prior
	FROM #ValidOutcomes e
	JOIN #pregnancy_events pe on pe.EVENT_ID = e.EVENT_ID and pe.person_id = e.person_id
	JOIN #FirstOutcomeEvent fo on fo.PERSON_ID = pe.PERSON_ID
	JOIN #pregnancy_events foe on foe.person_id = fo.person_id and foe.EVENT_ID = fo.EVENT_ID
),
cteInvalidOutcomes as
(
	select fo.person_id, fo.event_id
	FROM #ValidOutcomes e
	JOIN #pregnancy_events pe on pe.EVENT_ID = e.EVENT_ID and pe.person_id = e.person_id
	JOIN #FirstOutcomeEvent fo on fo.PERSON_ID = pe.PERSON_ID
	JOIN #pregnancy_events foe on foe.EVENT_ID = fo.EVENT_ID and foe.person_id = fo.person_id
	JOIN ctePriorOutcomes po on po.event_id=pe.event_id and po.person_id = pe.person_id
	JOIN @target_database_schema.@tablestem_outcome_limit o1 on o1.FIRST_PREG_CATEGORY = foe.Category AND o1.OUTCOME_PREG_CATEGORY = pe.Category
	JOIN @target_database_schema.@tablestem_outcome_limit o2 on o2.FIRST_PREG_CATEGORY = pe.Category AND o2.OUTCOME_PREG_CATEGORY = foe.Category
	WHERE (abs(datediff(d,foe.EVENT_DATE, pe.EVENT_DATE) + 1) < o2.MIN_DAYS and prior=1)
	  or (abs(datediff(d,foe.EVENT_DATE, pe.EVENT_DATE) + 1) < o1.MIN_DAYS and prior=0)
)
select a.person_id, a.event_id
INTO #temp_ValidOutcomes
from #FirstOutcomeEvent a
left join cteInvalidOutcomes b on a.person_id = b.person_id and a.event_id=b.event_id
left join #FirstOutcomeEventInv c on a.person_id = c.person_id and a.event_id=c.EVENT_ID
where b.event_id is null and c.EVENT_ID is null;

INSERT INTO #ValidOutcomes (PERSON_ID, EVENT_ID)
select PERSON_ID, EVENT_ID from #temp_ValidOutcomes;

DROP TABLE #temp_ValidOutcomes;

with cteTargetPeople (person_id) as
(
  select distinct e.person_id
  from #PregnancyEvents e
  join #pregnancy_events pe on e.person_id = pe.person_id and e.event_id = pe.event_id
  where pe.category = 'AB'
)
select pe.PERSON_ID, pe.EVENT_ID
INTO #temp_PregnancyEvents
FROM #PregnancyEvents pe
join cteTargetPeople p on pe.person_id = p.person_id
left join #FirstOutcomeEvent de on pe.person_id = de.person_id and pe.event_id = de.event_id
where de.person_id is null;

TRUNCATE TABLE #PregnancyEvents;
DROP TABLE #PregnancyEvents;

SELECT PERSON_ID, EVENT_ID
INTO #PregnancyEvents
from #temp_PregnancyEvents
;

TRUNCATE TABLE #temp_PregnancyEvents;
DROP TABLE #temp_PregnancyEvents;


TRUNCATE TABLE #FirstOutcomeEvent;
DROP TABLE #FirstOutcomeEvent;

TRUNCATE TABLE #FirstOutcomeEventInv;
DROP TABLE #FirstOutcomeEventInv;

TRUNCATE TABLE #FirstOutcomeEventSurg;
DROP TABLE #FirstOutcomeEventSurg;

END
;

-- Cleanup Temp tables from Step 6.
TRUNCATE TABLE #PregnancyEvents;
DROP TABLE #PregnancyEvents;

TRUNCATE TABLE #FirstOutcomeEvent;
DROP TABLE #FirstOutcomeEvent;

-- Step 7. populate #ValidOutcomes with 'true' SA pregnancy outcome dates

with cteTargetPeople (person_id) as
(
  select distinct person_id
  from #pregnancy_events pe
  where pe.category = 'SA'
),
cteTargetCategory (category) as
(
  select first_preg_category as catgory from @target_database_schema.@tablestem_outcome_limit
  UNION
  select outcome_preg_category as category from @target_database_schema.@tablestem_outcome_limit
  UNION
  select 'AGP' as category
  UNION
  select 'PCONF' as category
)
SELECT pe.person_id, min(pe.EVENT_ID) as event_id
INTO #PregnancyEvents
from #pregnancy_events pe
join cteTargetPeople tp on pe.person_id = tp.person_id
join cteTargetCategory tc on tc.category = pe.category
group by pe.person_id, pe.category, pe.event_date, pe.gest_value
;

while (1=1)
BEGIN

with outcomeCodes (CATEGORY) as
(
	select distinct FIRST_PREG_CATEGORY from @target_database_schema.@tablestem_outcome_limit
	where first_preg_category='SA'
),
numberedOutcomeEvents AS
(
	SELECT p.EVENT_ID, p.PERSON_ID, p.Category, p.gest_value, p.EVENT_DATE,
	row_number() over (partition by p.PERSON_ID order by p.event_date, p.event_id) as rn
	FROM #pregnancy_events p
	JOIN #PregnancyEvents e on p.person_id = e.person_id and p.EVENT_ID = e.EVENT_ID
	JOIN outcomeCodes oc on p.CATEGORY = oc.CATEGORY
)
SELECT PERSON_ID, EVENT_ID
INTO #FirstOutcomeEvent
FROM numberedOutcomeEvents
WHERE rn = 1;

if (select count(*) from #FirstOutcomeEvent) = 0
 break;

--check if AB has AB/SA procedure within 2 weeks
select person_id, event_id, EPISODE_END_DATE_REVISED, date_difference
into #FirstOutcomeEventSurg
from
(
  select distinct a.person_id, a.event_id,
    sp.event_date as EPISODE_END_DATE_REVISED, datediff(dd,foe.EVENT_DATE,sp.event_date) as date_difference,
    row_number() over (partition by a.person_id, a.event_id order by sp.event_date desc) as rn
  from #FirstOutcomeEvent a
  JOIN #pregnancy_events foe on foe.person_id = a.person_id and foe.EVENT_ID = a.EVENT_ID
  JOIN #pregnancy_events sp on sp.person_id=a.person_id
	where sp.category in ('SA', 'AB') and datediff(dd,foe.EVENT_DATE,sp.event_date)>=0
	and datediff(dd,foe.EVENT_DATE,sp.event_date)<=14
)  b
where rn=1 ;

--if so update raw events file to reflect new date
UPDATE #pregnancy_events
SET event_date = #FirstOutcomeEventSurg.episode_end_date_revised
FROM #FirstOutcomeEventSurg
WHERE #pregnancy_events.person_id = #FirstOutcomeEventSurg.person_id
  and #pregnancy_events.event_id = #FirstOutcomeEventSurg.event_id
;


select distinct a.person_id, a.event_id
into #FirstOutcomeEventInv
from #FirstOutcomeEvent a
JOIN #pregnancy_events foe on foe.person_id = a.person_id and foe.EVENT_ID = a.EVENT_ID
JOIN #pregnancy_events sp on sp.person_id=a.person_id
where sp.category in ('AGP', 'PCONF') and datediff(dd,foe.EVENT_DATE,sp.event_date)>0
	and datediff(dd,foe.EVENT_DATE,sp.event_date)<=42;


with ctePriorOutcomes as (
	select pe.person_id, pe.event_id,
		case when pe.event_date <= foe.event_date then 1 else 0 end as prior
	FROM #ValidOutcomes e
	JOIN #pregnancy_events pe on pe.EVENT_ID = e.EVENT_ID and pe.person_id = e.person_id
	JOIN #FirstOutcomeEvent fo on fo.PERSON_ID = pe.PERSON_ID
	JOIN #pregnancy_events foe on foe.person_id = fo.person_id and foe.EVENT_ID = fo.EVENT_ID
),
cteInvalidOutcomes as
(
	select fo.person_id, fo.event_id
	FROM #ValidOutcomes e
	JOIN #pregnancy_events pe on pe.EVENT_ID = e.EVENT_ID and pe.person_id = e.person_id
	JOIN #FirstOutcomeEvent fo on fo.PERSON_ID = pe.PERSON_ID
	JOIN #pregnancy_events foe on foe.EVENT_ID = fo.EVENT_ID and foe.person_id = fo.person_id
	JOIN ctePriorOutcomes po on po.event_id=pe.event_id and po.person_id = pe.person_id
	JOIN @target_database_schema.@tablestem_outcome_limit o1 on o1.FIRST_PREG_CATEGORY = foe.Category AND o1.OUTCOME_PREG_CATEGORY = pe.Category
	JOIN @target_database_schema.@tablestem_outcome_limit o2 on o2.FIRST_PREG_CATEGORY = pe.Category AND o2.OUTCOME_PREG_CATEGORY = foe.Category
	WHERE (abs(datediff(d,foe.EVENT_DATE, pe.EVENT_DATE) + 1) < o2.MIN_DAYS and prior=1)
	  or (abs(datediff(d,foe.EVENT_DATE, pe.EVENT_DATE) + 1) < o1.MIN_DAYS and prior=0)
)
select a.person_id, a.event_id
INTO #temp_ValidOutcomes
from #FirstOutcomeEvent a
left join cteInvalidOutcomes b on a.person_id = b.person_id and a.event_id=b.event_id
left join #FirstOutcomeEventInv c on a.person_id = c.person_id and a.event_id=c.EVENT_ID
where b.event_id is null and c.EVENT_ID is null;

INSERT INTO #ValidOutcomes (PERSON_ID, EVENT_ID)
select PERSON_ID, EVENT_ID from #temp_ValidOutcomes;

DROP TABLE #temp_ValidOutcomes;

with cteTargetPeople (person_id) as
(
  select distinct e.person_id
  from #PregnancyEvents e
  join #pregnancy_events pe on e.person_id = pe.person_id and e.event_id = pe.event_id
  where pe.category = 'SA'
)
select pe.PERSON_ID, pe.EVENT_ID
INTO #temp_PregnancyEvents
FROM #PregnancyEvents pe
join cteTargetPeople p on pe.person_id = p.person_id
left join #FirstOutcomeEvent de on pe.person_id = de.person_id and pe.event_id = de.event_id
where de.person_id is null;

TRUNCATE TABLE #PregnancyEvents;
DROP TABLE #PregnancyEvents;

SELECT PERSON_ID, EVENT_ID
INTO #PregnancyEvents
from #temp_PregnancyEvents
;

TRUNCATE TABLE #temp_PregnancyEvents;
DROP TABLE #temp_PregnancyEvents;


TRUNCATE TABLE #FirstOutcomeEvent;
DROP TABLE #FirstOutcomeEvent;

TRUNCATE TABLE #FirstOutcomeEventInv;
DROP TABLE #FirstOutcomeEventInv;

TRUNCATE TABLE #FirstOutcomeEventSurg;
DROP TABLE #FirstOutcomeEventSurg;

END
;

-- Cleanup temp tables created in Step 7.
TRUNCATE TABLE #PregnancyEvents;
DROP TABLE #PregnancyEvents;

TRUNCATE TABLE #FirstOutcomeEvent;
DROP TABLE #FirstOutcomeEvent;


-- Step 8. populate #ValidOutcomes with 'true' DELIV pregnancy outcome dates

with cteTargetPeople (person_id) as
(
  select distinct person_id
  from #pregnancy_events pe
  where pe.category = 'DELIV'
),
cteTargetCategory (category) as
(
  select first_preg_category as catgory from @target_database_schema.@tablestem_outcome_limit
  UNION
  select outcome_preg_category as category from @target_database_schema.@tablestem_outcome_limit
  UNION
  select 'AGP' as category
  UNION
  select 'PCONF' as category
)
SELECT pe.person_id, min(pe.EVENT_ID) as event_id
INTO #PregnancyEvents
from #pregnancy_events pe
join cteTargetPeople tp on pe.person_id = tp.person_id
join cteTargetCategory tc on tc.category = pe.category
group by pe.person_id, pe.category, pe.event_date, pe.gest_value
;

while (1=1)
BEGIN

with outcomeCodes (CATEGORY) as
(
	select distinct FIRST_PREG_CATEGORY from @target_database_schema.@tablestem_outcome_limit
	where first_preg_category='DELIV'
),
numberedOutcomeEvents AS
(
	SELECT p.EVENT_ID, p.PERSON_ID, p.Category, p.gest_value, p.EVENT_DATE,
	row_number() over (partition by p.PERSON_ID order by p.event_date, p.event_id) as rn
	FROM #pregnancy_events p
	JOIN #PregnancyEvents e on p.person_id = e.person_id and p.EVENT_ID = e.EVENT_ID
	JOIN outcomeCodes oc on p.CATEGORY = oc.CATEGORY
)
SELECT PERSON_ID, EVENT_ID
INTO #FirstOutcomeEvent
FROM numberedOutcomeEvents
WHERE rn = 1;

if (select count(*) from #FirstOutcomeEvent) = 0
 break;

select distinct a.person_id, a.event_id
into #FirstOutcomeEventInv
from #FirstOutcomeEvent a
JOIN #pregnancy_events foe on foe.person_id = a.person_id and foe.EVENT_ID = a.EVENT_ID
JOIN #pregnancy_events sp on sp.person_id=a.person_id
where sp.category in ('AGP', 'PCONF') and datediff(dd,foe.EVENT_DATE,sp.event_date)>0
	and datediff(dd,foe.EVENT_DATE,sp.event_date)<=42 ;

with ctePriorOutcomes as (
	select pe.person_id, pe.event_id,
		case when pe.event_date <= foe.event_date then 1 else 0 end as prior
	FROM #ValidOutcomes e
	JOIN #pregnancy_events pe on pe.EVENT_ID = e.EVENT_ID and pe.person_id = e.person_id
	JOIN #FirstOutcomeEvent fo on fo.PERSON_ID = pe.PERSON_ID
	JOIN #pregnancy_events foe on foe.person_id = fo.person_id and foe.EVENT_ID = fo.EVENT_ID
),
cteInvalidOutcomes as
(
	select fo.person_id, fo.event_id
	FROM #ValidOutcomes e
	JOIN #pregnancy_events pe on pe.EVENT_ID = e.EVENT_ID and pe.person_id = e.person_id
	JOIN #FirstOutcomeEvent fo on fo.PERSON_ID = pe.PERSON_ID
	JOIN #pregnancy_events foe on foe.EVENT_ID = fo.EVENT_ID and foe.person_id = fo.person_id
	JOIN ctePriorOutcomes po on po.event_id=pe.event_id and po.person_id = pe.person_id
	JOIN @target_database_schema.@tablestem_outcome_limit o1 on o1.FIRST_PREG_CATEGORY = foe.Category AND o1.OUTCOME_PREG_CATEGORY = pe.Category
	JOIN @target_database_schema.@tablestem_outcome_limit o2 on o2.FIRST_PREG_CATEGORY = pe.Category AND o2.OUTCOME_PREG_CATEGORY = foe.Category
	WHERE (abs(datediff(d,foe.EVENT_DATE, pe.EVENT_DATE) + 1) < o2.MIN_DAYS and prior=1)
	  or (abs(datediff(d,foe.EVENT_DATE, pe.EVENT_DATE) + 1) < o1.MIN_DAYS and prior=0)
)
select a.person_id, a.event_id
INTO #temp_ValidOutcomes
from #FirstOutcomeEvent a
left join cteInvalidOutcomes b on a.person_id = b.person_id and a.event_id=b.event_id
left join #FirstOutcomeEventInv c on a.person_id = c.person_id and a.event_id=c.EVENT_ID
where b.event_id is null and c.EVENT_ID is null;

INSERT INTO #ValidOutcomes (PERSON_ID, EVENT_ID)
select PERSON_ID, EVENT_ID from #temp_ValidOutcomes;

DROP TABLE #temp_ValidOutcomes;

with cteTargetPeople (person_id) as
(
  select distinct e.person_id
  from #PregnancyEvents e
  join #pregnancy_events pe on e.person_id = pe.person_id and e.event_id = pe.event_id
  where pe.category = 'DELIV'
)
select pe.PERSON_ID, pe.EVENT_ID
INTO #temp_PregnancyEvents
FROM #PregnancyEvents pe
join cteTargetPeople p on pe.person_id = p.person_id
left join #FirstOutcomeEvent de on pe.person_id = de.person_id and pe.event_id = de.event_id
where de.person_id is null;

TRUNCATE TABLE #PregnancyEvents;
DROP TABLE #PregnancyEvents;

SELECT PERSON_ID, EVENT_ID
INTO #PregnancyEvents
from #temp_PregnancyEvents
;

TRUNCATE TABLE #temp_PregnancyEvents;
DROP TABLE #temp_PregnancyEvents;

TRUNCATE TABLE #FirstOutcomeEvent;
DROP TABLE #FirstOutcomeEvent;

TRUNCATE TABLE #FirstOutcomeEventInv;
DROP TABLE #FirstOutcomeEventInv;

END
;

-- Cleanup tables that were created in Step 8.

TRUNCATE TABLE #FirstOutcomeEvent;
DROP TABLE #FirstOutcomeEvent;

TRUNCATE TABLE #PregnancyEvents;
DROP TABLE #PregnancyEvents;

-- Step 9. Find Pregnancy Starts based on the outcome category.


with cteOutcomeEvents (PERSON_ID, EVENT_ID, CATEGORY, gest_value, EVENT_DATE) as
(
	select pe.PERSON_ID, pe.EVENT_ID, pe.Category, pe.gest_value, pe.EVENT_DATE
	FROM #pregnancy_events pe
    JOIN #ValidOutcomes o on pe.PERSON_ID = o.PERSON_ID and pe.EVENT_ID = o.EVENT_ID
),
ctePriorOutcomeDates (PERSON_ID, EVENT_ID, PRIOR_OUTCOME_DATE, prior_category) as
(
	select PERSON_ID, EVENT_ID, PRIOR_OUTCOME_DATE, prior_category
	FROM
	(
		select o.person_id, o.EVENT_ID, p.EVENT_DATE as PRIOR_OUTCOME_DATE, p.category as prior_category,
		row_number() over (partition by o.person_id, o.EVENT_ID order by p.event_date desc) as rn
		from cteOutcomeEvents o
		left join cteOutcomeEvents p on p.PERSON_ID = o.PERSON_ID and o.EVENT_DATE > p.EVENT_DATE
	) E
	where E.rn = 1
),
cteLMPStartDates (PERSON_ID, EVENT_ID, EPISODE_START_DATE, CATEGORY, DATE_RANK) as
(
	select PERSON_ID, EVENT_ID, EPISODE_START_DATE, Category, 1 as DATE_RANK
	from
	(
		select e.PERSON_ID, e.EVENT_ID as EVENT_ID, p.EVENT_DATE as EPISODE_START_DATE, p.Category,
			row_number() over (partition by e.person_id, e.event_id order by p.EVENT_DATE desc) as rn
		from cteOutcomeEvents e
		JOIN @target_database_schema.@tablestem_term_durations lb on e.Category = lb.CATEGORY
		JOIN ctePriorOutcomeDates pod on pod.person_id = e.person_id and pod.EVENT_ID = e.EVENT_ID
		JOIN #pregnancy_events p on e.PERSON_ID = p.PERSON_ID
		WHERE p.Category = 'LMP'
			and p.EVENT_DATE between
				case when dateadd(d, lb.retry , pod.PRIOR_OUTCOME_DATE) > dateadd(d, -1* lb.MAX_TERM, e.EVENT_DATE) then dateadd(d, lb.retry , pod.PRIOR_OUTCOME_DATE)
				else dateadd(d, -1* lb.MAX_TERM, e.EVENT_DATE) end
				and dateadd(d, -1* lb.MIN_TERM, e.EVENT_DATE)
	) Q
	where rn = 1
),
cteGestStartDates (PERSON_ID, EVENT_ID, EPISODE_START_DATE, CATEGORY, DATE_RANK) as
(
	select PERSON_ID, EVENT_ID, EPISODE_START_DATE, CATEGORY, 2 as DATE_RANK
	from
	(
		select e.PERSON_ID, e.EVENT_ID as EVENT_ID, dateadd(d,(-1 * p.gest_value) + 1, p.EVENT_DATE) as EPISODE_START_DATE, p.Category,
			row_number() over (partition by e.person_id, e.event_id order by p.EVENT_DATE desc) as rn
		from cteOutcomeEvents e
		JOIN @target_database_schema.@tablestem_term_durations lb on e.Category = lb.CATEGORY
		JOIN ctePriorOutcomeDates pod on pod.person_id = e.person_id and pod.EVENT_ID = e.EVENT_ID
		JOIN #pregnancy_events p on e.PERSON_ID = p.PERSON_ID
		where p.CATEGORY = 'GEST'
			and dateadd(d,(-1 * p.gest_value) + 1, p.EVENT_DATE) between
				case when dateadd(d, lb.retry , pod.PRIOR_OUTCOME_DATE) > dateadd(d, -1* lb.MAX_TERM, e.EVENT_DATE) then dateadd(d, lb.retry , pod.PRIOR_OUTCOME_DATE)
				else dateadd(d, -1* lb.MAX_TERM, e.EVENT_DATE) end
				and dateadd(d, -1* lb.MIN_TERM, e.EVENT_DATE)
	) Q
	where rn=1
),
cteOvulStartDates (person_id, EVENT_ID, EPISODE_START_DATE, CATEGORY, DATE_RANK) as
(
	select PERSON_ID, EVENT_ID, EPISODE_START_DATE, CATEGORY, 3 as DATE_RANK
	from
	(
		select e.PERSON_ID, e.EVENT_ID as EVENT_ID, dateadd(d,(-14) + 1, p.EVENT_DATE) as EPISODE_START_DATE, p.Category,
			row_number() over (partition by e.person_id, e.event_id order by p.EVENT_DATE) as rn
		from cteOutcomeEvents e
		JOIN @target_database_schema.@tablestem_term_durations lb on e.Category = lb.CATEGORY
		JOIN ctePriorOutcomeDates pod on pod.PERSON_ID = e.PERSON_ID and pod.EVENT_ID = e.EVENT_ID
		JOIN #pregnancy_events p on e.PERSON_ID = p.PERSON_ID
		where p.CATEGORY = 'OVUL'
			and dateadd(d,(-14) + 1, p.EVENT_DATE) between
				case when dateadd(d, lb.retry , pod.PRIOR_OUTCOME_DATE) > dateadd(d, -1* lb.MAX_TERM, e.EVENT_DATE) then dateadd(d, lb.retry , pod.PRIOR_OUTCOME_DATE)
				else dateadd(d, -1* lb.MAX_TERM, e.EVENT_DATE) end
				and dateadd(d, -1* lb.MIN_TERM, e.EVENT_DATE)
	) Q
	where rn=1
),
cteOvul2StartDates (PERSON_ID, EVENT_ID, EPISODE_START_DATE, CATEGORY, DATE_RANK) as
(
	select PERSON_ID, EVENT_ID, EPISODE_START_DATE, CATEGORY, 4 as DATE_RANK
	from
	(
		select e.PERSON_ID, e.EVENT_ID as EVENT_ID, dateadd(d,(-14) + 1, p.EVENT_DATE) as EPISODE_START_DATE, p.Category,
			row_number() over (partition by e.person_id, e.event_id order by p.EVENT_DATE) as rn
		from cteOutcomeEvents e
		JOIN @target_database_schema.@tablestem_term_durations lb on e.Category = lb.CATEGORY
		JOIN ctePriorOutcomeDates pod on pod.PERSON_ID = pod.EVENT_ID and pod.EVENT_ID = e.EVENT_ID
		JOIN #pregnancy_events p on e.PERSON_ID = p.PERSON_ID
		where p.CATEGORY = 'OVUL2'
			and dateadd(d,(-14) + 1, p.EVENT_DATE) between
				case when dateadd(d, lb.retry , pod.PRIOR_OUTCOME_DATE) > dateadd(d, -1* lb.MAX_TERM, e.EVENT_DATE) then dateadd(d, lb.retry , pod.PRIOR_OUTCOME_DATE)
				else dateadd(d, -1* lb.MAX_TERM, e.EVENT_DATE) end
				and dateadd(d, -1* lb.MIN_TERM, e.EVENT_DATE)
	) Q
	where rn=1
),
cteNuchalUltrasoundStartDates(PERSON_ID, EVENT_ID, EPISODE_START_DATE, CATEGORY, DATE_RANK) as
(
	select Q.PERSON_ID, Q.EVENT_ID, Q.EPISODE_START_DATE, Q.CATEGORY, 6 as DATE_RANK
	from
	(
		select e.person_id, e.EVENT_ID as EVENT_ID, dateadd(d,-89,p.EVENT_DATE) as EPISODE_START_DATE, p.Category,
			row_number() over (partition by e.person_id, e.event_id order by p.EVENT_DATE asc) as rn
		from cteOutcomeEvents e
		JOIN @target_database_schema.@tablestem_term_durations lb on e.Category = lb.CATEGORY
		JOIN ctePriorOutcomeDates pod on pod.PERSON_ID = e.PERSON_ID and pod.EVENT_ID = e.EVENT_ID
		JOIN #pregnancy_events p on e.PERSON_ID = p.PERSON_ID
		WHERE p.Category = 'NULS'
			and dateadd(d,-89,p.EVENT_DATE) between
				case when dateadd(d, lb.retry , pod.PRIOR_OUTCOME_DATE) > dateadd(d, -1* lb.MAX_TERM, e.EVENT_DATE) then dateadd(d, lb.retry , pod.PRIOR_OUTCOME_DATE)
				else dateadd(d, -1* lb.MAX_TERM, e.EVENT_DATE) end
				and dateadd(d, -1* lb.MIN_TERM, e.EVENT_DATE)
	) Q
	where Q.rn = 1
),
cteAFPStartDates(PERSON_ID, EVENT_ID, EPISODE_START_DATE, CATEGORY, DATE_RANK) as
(
	select Q.PERSON_ID, Q.EVENT_ID, Q.EPISODE_START_DATE, Q.CATEGORY, 7 as DATE_RANK
	from
	(
		select e.PERSON_ID, e.EVENT_ID as EVENT_ID, dateadd(d,-123,p.EVENT_DATE) as EPISODE_START_DATE, p.Category,
			row_number() over (partition by e.person_id, e.event_id order by p.EVENT_DATE asc) as rn
		from cteOutcomeEvents e
		JOIN @target_database_schema.@tablestem_term_durations lb on e.Category = lb.CATEGORY
		JOIN ctePriorOutcomeDates pod on pod.PERSON_ID = e.PERSON_ID and pod.EVENT_ID = e.EVENT_ID
		JOIN #pregnancy_events p on e.PERSON_ID = p.PERSON_ID
		WHERE p.Category = 'AFP'
			and dateadd(d,-123,p.EVENT_DATE) between
				case when dateadd(d, lb.retry , pod.PRIOR_OUTCOME_DATE) > dateadd(d, -1* lb.MAX_TERM, e.EVENT_DATE) then dateadd(d, lb.retry , pod.PRIOR_OUTCOME_DATE)
				else dateadd(d, -1* lb.MAX_TERM, e.EVENT_DATE) end
				and dateadd(d, -1* lb.MIN_TERM, e.EVENT_DATE)
	) Q
	where Q.rn = 1
),
cteAMENStartDates (PERSON_ID, EVENT_ID, EPISODE_START_DATE, CATEGORY, DATE_RANK) as
(
	select PERSON_ID, EVENT_ID, EPISODE_START_DATE, CATEGORY, 80 as DATE_RANK
	from
	(
		select e.PERSON_ID, e.EVENT_ID as EVENT_ID, dateadd(d,(-56) + 1, p.EVENT_DATE) as EPISODE_START_DATE, p.Category,
			row_number() over (partition by e.person_id, e.event_id order by p.EVENT_DATE) as rn
		from cteOutcomeEvents e
		JOIN @target_database_schema.@tablestem_term_durations lb on e.Category = lb.CATEGORY
		JOIN ctePriorOutcomeDates pod on pod.PERSON_ID = e.PERSON_ID and pod.EVENT_ID = e.EVENT_ID
		JOIN #pregnancy_events p on e.PERSON_ID = p.PERSON_ID
		where p.CATEGORY = 'AMEN'
			and dateadd(d,(-56) + 1, p.EVENT_DATE) between
				case when dateadd(d, lb.retry , pod.PRIOR_OUTCOME_DATE) > dateadd(d, -1* lb.MAX_TERM, e.EVENT_DATE) then dateadd(d, lb.retry , pod.PRIOR_OUTCOME_DATE)
				else dateadd(d, -1* lb.MAX_TERM, e.EVENT_DATE) end
				and dateadd(d, -1* lb.MIN_TERM, e.EVENT_DATE)
	) Q
	where rn=1
),
ctePOptumStartDates (PERSON_ID, EVENT_ID, EPISODE_START_DATE, CATEGORY, DATE_RANK) as
(
	select PERSON_ID, EVENT_ID, EPISODE_START_DATE, CATEGORY, 90 as DATE_RANK
	from
	(
		select e.PERSON_ID, e.EVENT_ID as EVENT_ID, dateadd(d,(-56) + 1, p.EVENT_DATE) as EPISODE_START_DATE, p.Category,
			row_number() over (partition by e.person_id, e.event_id order by p.EVENT_DATE) as rn
		from cteOutcomeEvents e
		JOIN @target_database_schema.@tablestem_term_durations lb on e.Category = lb.CATEGORY
		JOIN ctePriorOutcomeDates pod on pod.PERSON_ID = e.PERSON_ID and pod.EVENT_ID = e.EVENT_ID
		JOIN #pregnancy_events p on e.PERSON_ID = p.PERSON_ID
		where p.CATEGORY in  ('UP')
			and dateadd(d,(-56) + 1, p.EVENT_DATE) between
				case when dateadd(d, lb.retry , pod.PRIOR_OUTCOME_DATE) > dateadd(d, -1* lb.MAX_TERM, e.EVENT_DATE) then dateadd(d, lb.retry , pod.PRIOR_OUTCOME_DATE)
				else dateadd(d, -1* lb.MAX_TERM, e.EVENT_DATE) end
				and dateadd(d, -1* lb.MIN_TERM, e.EVENT_DATE)
	) Q
	where rn=1
),
ctePCONFStartDates (PERSON_ID, EVENT_ID, EPISODE_START_DATE, CATEGORY) as
(
	select PERSON_ID, EVENT_ID, EPISODE_START_DATE, CATEGORY
	from
	(
		select e.PERSON_ID, e.EVENT_ID as EVENT_ID, dateadd(d,(-56) + 1, p.EVENT_DATE) as EPISODE_START_DATE,
		  'PUSHBACK' as category,
			row_number() over (partition by e.person_id, e.event_id order by p.EVENT_DATE asc) as rn
		from cteOutcomeEvents e
		JOIN @target_database_schema.@tablestem_term_durations lb on e.Category = lb.CATEGORY
		JOIN ctePriorOutcomeDates pod on pod.PERSON_ID = e.PERSON_ID and pod.EVENT_ID = e.EVENT_ID
		JOIN #pregnancy_events p on e.PERSON_ID = p.PERSON_ID
		WHERE p.Category in  ('PCONF','AGP','PCOMP', 'TA')
			and dateadd(d,(-56) + 1, p.EVENT_DATE) between
				case when dateadd(d, lb.retry , pod.PRIOR_OUTCOME_DATE) > dateadd(d, -1* lb.MAX_TERM, e.EVENT_DATE) then dateadd(d, lb.retry , pod.PRIOR_OUTCOME_DATE)
				else dateadd(d, -1* lb.MAX_TERM, e.EVENT_DATE) end
				and dateadd(d, -1* lb.MIN_TERM, e.EVENT_DATE)
	) Q
	where rn = 1
),
cteCONTRAStartDates (PERSON_ID, EVENT_ID, EPISODE_START_DATE, CATEGORY) as
(
	select PERSON_ID, EVENT_ID, EPISODE_START_DATE, CATEGORY
	from
	(
		select e.PERSON_ID, e.EVENT_ID as EVENT_ID, p.EVENT_DATE as EPISODE_START_DATE,
		  'CONTRA' as category,
			row_number() over (partition by e.person_id, e.event_id order by p.EVENT_DATE desc) as rn
		from cteOutcomeEvents e
		JOIN @target_database_schema.@tablestem_term_durations lb on e.Category = lb.CATEGORY
		JOIN ctePriorOutcomeDates pod on pod.PERSON_ID = e.PERSON_ID and pod.EVENT_ID = e.EVENT_ID
		JOIN #pregnancy_events p on e.PERSON_ID = p.PERSON_ID
		WHERE p.Category in  ('CONTRA')
			and p.EVENT_DATE between
				case when dateadd(d, lb.retry , pod.PRIOR_OUTCOME_DATE) > dateadd(d, -1* lb.MAX_TERM, e.EVENT_DATE) then dateadd(d, lb.retry , pod.PRIOR_OUTCOME_DATE)
				else dateadd(d, -1* lb.MAX_TERM, e.EVENT_DATE) end
				and dateadd(d, -1* lb.MIN_TERM, e.EVENT_DATE)
	) Q
	where rn = 1
),
cteDefaultStartDates(PERSON_ID, EVENT_ID, EPISODE_START_DATE, CATEGORY, DATE_RANK) as
(
	select c.PERSON_ID, c.EVENT_ID, case when dateadd(d, lb.retry , pod.PRIOR_OUTCOME_DATE) > dateadd(d,(-1 * (
		case when PreCount > 0 then g.PreTerm
		when FullCount > 0 then g.FullTerm
		else g.NoData end)),EVENT_DATE) then dateadd(d, lb.retry , pod.PRIOR_OUTCOME_DATE)
		else  dateadd(d,(-1 * (
		case when PreCount > 0 then g.PreTerm
		when FullCount > 0 then g.FullTerm
		else g.NoData end)),EVENT_DATE) end as EPISODE_START_DATE,
		case when PreCount > 0 then 'PREM'
		      else 'DEFAULT' end as CATEGORY,
			 99 as date_rank

	FROM
	(
		select e.PERSON_ID, e.EVENT_ID, e.EVENT_DATE, e.CATEGORY,
			SUM(case when p.Category = 'PREM' then 1 else 0 end) as PreCount,
			SUM(case when p.Category = 'POSTT' then 1 else 0 end) as PostCount,
			SUM(case when p.Category = 'FT' then 1 else 0 end) as FullCount
		from cteOutcomeEvents e
		JOIN @target_database_schema.@tablestem_term_durations lb on e.Category = lb.CATEGORY
		JOIN ctePriorOutcomeDates pod on pod.PERSON_ID = e.PERSON_ID and pod.EVENT_ID = e.EVENT_ID
		JOIN #pregnancy_events p on e.PERSON_ID = p.PERSON_ID
		where p.EVENT_DATE between
			case when pod.PRIOR_OUTCOME_DATE > dateadd(d, -1* lb.MAX_TERM, e.EVENT_DATE) then pod.PRIOR_OUTCOME_DATE
			else dateadd(d, -1* lb.MAX_TERM, e.EVENT_DATE) end
			and dateadd(d,30,e.EVENT_DATE)
		GROUP BY e.PERSON_ID, e.EVENT_ID, e.EVENT_DATE, e.CATEGORY
	) C JOIN @target_database_schema.@tablestem_gest_est g on c.CATEGORY = g.CATEGORY
	full outer JOIN ctePriorOutcomeDates pod on pod.PERSON_ID = c.PERSON_ID and pod.EVENT_ID = c.EVENT_ID
	full outer JOIN @target_database_schema.@tablestem_term_durations lb on pod.prior_category = lb.CATEGORY
),
cteAllStarts(PERSON_ID, EVENT_ID, EPISODE_START_DATE, CATEGORY, DATE_RANK) as
(
	select PERSON_ID, EVENT_ID, EPISODE_START_DATE, CATEGORY, DATE_RANK from cteLMPStartDates
	UNION
	select PERSON_ID, EVENT_ID, EPISODE_START_DATE, CATEGORY, DATE_RANK from cteDefaultStartDates
	UNION
	select PERSON_ID, EVENT_ID, EPISODE_START_DATE, CATEGORY, DATE_RANK from cteGestStartDates
	UNION
	select PERSON_ID, EVENT_ID, EPISODE_START_DATE, CATEGORY, DATE_RANK from cteNuchalUltrasoundStartDates
	UNION
	select PERSON_ID, EVENT_ID, EPISODE_START_DATE, CATEGORY, DATE_RANK from cteAFPStartDates
	UNION
	select PERSON_ID, EVENT_ID, EPISODE_START_DATE, CATEGORY, DATE_RANK from cteOvulStartDates
	UNION
	select PERSON_ID, EVENT_ID, EPISODE_START_DATE, CATEGORY, DATE_RANK from cteOvul2StartDates
	UNION
	select PERSON_ID, EVENT_ID, EPISODE_START_DATE, CATEGORY, DATE_RANK from cteAMENStartDates
	UNION
	select PERSON_ID, EVENT_ID, EPISODE_START_DATE, CATEGORY, DATE_RANK from ctePOptumStartDates
	-- UNION CTEs together to collect all date selections based on individual rules for each category
),
cteBestStarts (PERSON_ID, EVENT_ID, EPISODE_START_DATE, CATEGORY, DATE_RANK) as
(
	select PERSON_ID, EVENT_ID, EPISODE_START_DATE, CATEGORY, DATE_RANK
	FROM
	(
		SELECT PERSON_ID, EVENT_ID, EPISODE_START_DATE, CATEGORY, DATE_RANK,
		ROW_NUMBER() OVER (PARTITION BY PERSON_ID, EVENT_ID ORDER BY DATE_RANK) as RN
		FROM cteAllStarts s
	) Q
	where Q.RN = 1
),
cteNewStarts (PERSON_ID, EVENT_ID, EPISODE_START_DATE, CATEGORY,DATE_RANK) as
(
	select bs.PERSON_ID,
    bs.EVENT_ID,
		case
		  when pc.episode_start_date is null and cc.episode_start_date is null then bs.episode_start_date
			when cc.episode_start_date is null and pc.EPISODE_START_DATE < bs.EPISODE_START_DATE then pc.EPISODE_START_DATE
		  when pc.episode_start_date is null and cc.EPISODE_START_DATE > bs.EPISODE_START_DATE then cc.EPISODE_START_DATE
			when pc.episode_start_date is not null and cc.episode_start_date is not null
			  and pc.EPISODE_START_DATE < bs.EPISODE_START_DATE and cc.EPISODE_START_DATE<  pc.EPISODE_START_DATE then pc.EPISODE_START_DATE
  		when pc.episode_start_date is not null and cc.episode_start_date is not null
  		  and pc.EPISODE_START_DATE < bs.EPISODE_START_DATE and cc.EPISODE_START_DATE>  pc.EPISODE_START_DATE then cc.EPISODE_START_DATE
			when pc.episode_start_date is not null and cc.episode_start_date is not null
			  and cc.EPISODE_START_DATE > bs.EPISODE_START_DATE and pc.episode_start_date>bs.EPISODE_START_DATE then cc.EPISODE_START_DATE
			else bs.episode_start_date
		end as episode_start_date,
    bs.CATEGORY+':REFINED' as CATEGORY,
    bs.DATE_RANK-1
	FROM cteBestStarts bs
	left outer join ctePCONFStartDates pc on bs.person_id = pc.person_id and bs.event_id = pc.event_id
	left outer join cteCONTRAStartDates cc on bs.person_id = cc.person_id and bs.event_id = cc.event_id
	where bs.date_rank > 7
)
select o.PERSON_ID, s.EPISODE_START_DATE, o.EVENT_DATE as EPISODE_END_DATE,s.CATEGORY as START_CATEGORY,
o.CATEGORY as OUTCOME_CATEGORY, s.DATE_RANK as rank
INTO #PregnancyEpisodes
from cteOutcomeEvents o
join (
  select * from cteAllStarts
  union
  select * from cteNewStarts
) s on o.person_id = s.person_id and o.EVENT_ID = s.EVENT_ID
;

/* save all possible starts here */

select person_id, episode_start_date, episode_end_date, start_category, outcome_category, rank
INTO #PregnancyEpisodesAllStarts
from #PregnancyEpisodes
;

/* choose first start in hierarchy per episode, female 12-55 only, episode within enrollment period */

select pe.PERSON_ID, pe.EPISODE_START_DATE, pe.EPISODE_END_DATE, pe.START_CATEGORY, pe.OUTCOME_CATEGORY,
row_number() over (partition by pe.person_id order by pe.Episode_start_date) as rn
into #PregnancyEpisodesObs
from
(
	select *
	FROM
	(
		SELECT *, ROW_NUMBER() OVER (PARTITION BY PERSON_ID, EPISODE_END_DATE ORDER BY RANK) as RN
		FROM #PregnancyEpisodes s
	) Q
	where Q.RN = 1
) pe
JOIN @cdm_database_schema.OBSERVATION_PERIOD op on op.PERSON_ID = pe.PERSON_ID
	and episode_end_date between op.OBSERVATION_PERIOD_START_DATE and op.OBSERVATION_PERIOD_END_DATE
	and pe.EPISODE_START_DATE>= op.observation_period_start_date
	join @cdm_database_schema.person p
	on pe.person_id=p.person_id
	where p.gender_concept_id = 8532 and year(pe.episode_start_date)-p.year_of_birth>=12
	and year(pe.episode_start_date)-p.year_of_birth<=55
;

/* verify that there are at least 2 pregnancy events for an outcome */

select f.PERSON_ID,f.EPISODE_START_DATE,f.EPISODE_END_DATE,f.START_CATEGORY,f.OUTCOME_CATEGORY,f.RN
into #PregnancyEpisodesTwoRec
from #PregnancyEpisodesObs f
join
(
	select *
	from
	(
		select person_id, rn, count(event_id) as tot_events
		from
		(
			select a.person_id, a.rn, b.event_id
			from #PregnancyEpisodesObs a
			join  #pregnancy_events b on a.person_id=b.person_id
			JOIN @target_database_schema.@tablestem_term_durations d on a.OUTCOME_CATEGORY=d.category
			where b.EVENT_DATE between dateadd(d,((-1 * d.MAX_TERM) + 1), a.EPISODE_END_DATE) and a.EPISODE_END_DATE
		) c
		group by person_id, rn
	) d
	where tot_events>=2
) e on e.person_id=f.person_id and e.rn=f.rn
;

/* create the phenotype */

delete from @target_database_schema.@tablestem_pregnancy_episodes where db_id = '@db_id';

insert into @target_database_schema.@tablestem_pregnancy_episodes
select '@db_id' as db_id,
  person_id as person_id,
  episode_start_date as episode_start_date,
  episode_end_date as episode_end_date,
  start_category as start_method, outcome_category as original_outcome,
	rn as episode,
	case when outcome_category in ('AB','SA') then 'SA/AB'
    when outcome_category in ('DELIV','LB') then 'LB/DELIV'
	  when outcome_category='SB' and datediff(dd,episode_start_date, episode_end_date)+1<140 then 'SA/AB'
	  when (outcome_category='SA' or outcome_category='AB') and datediff(dd,episode_start_date, episode_end_date)+1<140 then 'SA/AB'
	else outcome_category end as outcome,
	datediff(dd,episode_start_date, episode_end_date)+1 as episode_length
from #PregnancyEpisodesTwoRec
;

TRUNCATE TABLE #ValidOutcomes;
DROP TABLE #ValidOutcomes;

TRUNCATE TABLE #pregnancy_events;
DROP TABLE #pregnancy_events;

TRUNCATE TABLE #PregnancyEpisodes;
DROP TABLE #PregnancyEpisodes;

TRUNCATE TABLE #PregnancyEpisodesAllStarts;
DROP TABLE #PregnancyEpisodesAllStarts;

TRUNCATE TABLE #PregnancyEpisodesObs;
DROP TABLE #PregnancyEpisodesObs;

TRUNCATE TABLE #PregnancyEpisodesTwoRec;
DROP TABLE #PregnancyEpisodesTwoRec;
