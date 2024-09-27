CREATE TABLE #Codesets (
  codeset_id int NOT NULL,
  concept_id bigint NOT NULL
)
;

INSERT INTO #Codesets (codeset_id, concept_id)
SELECT 10 as codeset_id, c.concept_id FROM (select distinct I.concept_id FROM
( 
  select concept_id from @vocabulary_database_schema.CONCEPT where (concept_id in (443391,4180790,443390))
UNION  select c.concept_id
  from @vocabulary_database_schema.CONCEPT c
  join @vocabulary_database_schema.CONCEPT_ANCESTOR ca on c.concept_id = ca.descendant_concept_id
  WHERE c.invalid_reason is null
  and (ca.ancestor_concept_id in (443391,4180790,443390))

) I
LEFT JOIN
(
  select concept_id from @vocabulary_database_schema.CONCEPT where (concept_id in (36403128,36403152,36403091,36403134,36403095,36403093,36403139,36403109,36403059,36403070,36403044,36403006,36403020,36403009,36403010,36403042,36403036,36532149,36528941,36539536,36554371,36555799,36560540,36518886,36535609,36548319,37018876,40486168,36532259,36562794,36525026,36527707,36541841,36566840,36560584,36521973,36567869,36551281,36539283,36566994,36547508,36520412,36523693,36549720,36548476,36544256,4162276,4044013,4079274,434300,4300118,4311765,4311439,40480598,36403115,36521999,36566125,36552619,36539114,36531708,36520681,36530017,36542293,36526908,36517782,36552072,36537543,36518870,36522672,36555825,36534830,36561931,36536967,36517398,36565536,36403141,36402991,36527031,36542051,36535310,4201482,4312286,4311439,432571,4300118,4102373,36536380,44500772,36544131,36567154,36715914,36554700,36554163,36563124,36555226,36533543,36522591,36549728,36564168,36523786,36525590,36564902,36527029,36555749,36548262,36543551,36533943,36540290,36536131,36518688,36544117,36518886,36544109,36517981,36554998,36549720,36542290,36530017,36517934,42512293,42511838,36534830,36517916,36526512,36527540,36560584,36542180,36562722,36538790,36562593,36526276,36533965,4283611,4289245,4289090,4289246,4289247,4289091,4289092,4289248,4283612,4289093,4289249,4289094,4283613,4289095,36522104,36525455,4311322,36543690,36538573,36541104,4171274,44500676,36565939,36565623,36533664,4180792,438699,4196256,442174))
UNION  select c.concept_id
  from @vocabulary_database_schema.CONCEPT c
  join @vocabulary_database_schema.CONCEPT_ANCESTOR ca on c.concept_id = ca.descendant_concept_id
  WHERE c.invalid_reason is null
  and (ca.ancestor_concept_id in (36403128,36403152,36403091,36403134,36403095,36403093,36403139,36403109,36403059,36403070,36403044,36403006,36403020,36403009,36403010,36403042,36403036,36532149,36528941,36539536,36554371,36555799,36560540,36518886,36535609,36548319,37018876,40486168,36532259,36562794,36525026,36527707,36541841,36566840,36560584,36521973,36567869,36551281,36539283,36566994,36547508,36520412,36523693,36549720,36548476,36544256,4162276,4044013,4079274,434300,4300118,4311765,4311439,40480598,36403115,36521999,36566125,36552619,36539114,36531708,36520681,36530017,36542293,36526908,36517782,36552072,36537543,36518870,36522672,36555825,36534830,36561931,36536967,36517398,36565536,36403141,36402991,36527031,36542051,36535310,4201482,4312286,4311439,432571,4300118,4102373,36536380,44500772,36544131,36567154,36715914,36554700,36554163,36563124,36555226,36533543,36522591,36549728,36564168,36523786,36525590,36564902,36527029,36555749,36548262,36543551,36533943,36540290,36536131,36518688,36544117,36518886,36544109,36517981,36554998,36549720,36542290,36530017,36517934,42512293,42511838,36534830,36517916,36526512,36527540,36560584,36542180,36562722,36538790,36562593,36526276,36533965,4283611,4289245,4289090,4289246,4289247,4289091,4289092,4289248,4283612,4289093,4289249,4289094,4283613,4289095,36522104,36525455,4311322,36543690,36538573,36541104,4171274,44500676,36565939,36565623,36533664,4180792,438699,4196256,442174))

) E ON I.concept_id = E.concept_id
WHERE E.concept_id is null
) C UNION ALL 
SELECT 11 as codeset_id, c.concept_id FROM (select distinct I.concept_id FROM
( 
  select concept_id from @vocabulary_database_schema.CONCEPT where (concept_id in (2000809,2000810,2000811,2000832,2000833,2000834,2000835,2000836,2002750,2002751,2002762,2002763,2002764,2002765,2002766,2002768,2002769,2002770,2002969,2002984,2002985,2002986,2002987,2002990,2003002,2003003,2109040,2109041,2109042,2109043,2109044,2109045,2109046,2109047,2109048,2109049,2109056,2109065,2109066,2109068,2109069,2109071,2109074,2109151,2109152,2109153,2109155,2109156,2109160,2109161,2109166,2109206,2109207,2747019,2747020,2747021,2747022,2747023,2747024,2747025,2747026,2747027,2747028,2747030,2747032,2747034,2747036,2747038,2747059,2747060,2747061,2747062,2747063,2747064,2747065,2747066,2747067,2747068,2747266,2747267,2747268,2747269,2747270,2747271,2747272,2747273,2747274,2747275,2747276,2747277,2747278,2747279,2747280,2747281,2747282,2747283,2747284,2747285,2747286,2747287,2747288,2747289,2747290,2747291,2747292,2747293,2747294,2747295,2747296,2747297,2747298,2747299,2747300,2747301,2747302,2747303,2747304,2747305,2747306,2747307,2747309,2747311,2747313,2747315,2753172,2753173,2753174,2753175,2753176,2753177,2753368,2753369,2753370,2753371,2753372,2753373,2753374,2753375,2753376,2753377,2753378,2753379,2753380,2753381,2753386,2753387,2753388,2753389,2753390,2753391,2753392,2753393,2753394,2753395,2753396,2753397,2753398,2753399,2753400,2753401,2753402,2753403,2753404,2753405,3171111,3179339,4017464,4017466,4017469,4017602,4017608,4018022,4018024,4018274,4018279,4018281,4018283,4022438,4022910,4023552,4023553,4027552,4028033,4030387,4035031,4053102,4068146,4068147,4068996,4069103,4069714,4078310,4079713,4096461,4097307,4097958,4098879,4122647,4122805,4123402,4128860,4128861,4136779,4137288,4141243,4141244,4141259,4143174,4144203,4144204,4144205,4144721,4144723,4145225,4146034,4146036,4146632,4146633,4146634,4146636,4151121,4163366,4163975,4166855,4168531,4179797,4181781,4183332,4185981,4187629,4187917,4194372,4194416,4195151,4197728,4197729,4199951,4199952,4201948,4202561,4202562,4202563,4203139,4207467,4208945,4216867,4219780,4221568,4225427,4226983,4229775,4233085,4233412,4234933,4235749,4249151,4250893,4259115,4262950,4294869,4299772,4314569,4326904,4334487,37016852,37016994,37310744,37312778,37312779,37312780,37521056,37586031,37586032,37586033,40481893,40482769,40483732,40483733,40485319,40485422,40486934,40486935,40486940,40487481,40487521,40487953,40488424,40488438,40489970,40490977,40491370,42538033,42539745,42872470,43016392,43016393,43016394,43016398,43017215,43017216,43017217,43017218,44510653,44510657,44510660,44510664,44510667,44510673,44510675,44510680,44510681,44510683,44510689,44510691,44510693,44510695,44510696,44510697,44510699,44510807,44510826,44510832,44510833,44790503,44807783,44807784,44807785,44807786,44807787,44807788,44807793,44807794,44807795,44807796,44807797,44807798,44807800,44807801,44807802,44807803,44807804,44807805,44807806,44807809,44807924,44807925,44807929,44807930,44807933,44807934,44807936,44809615,44809616,44809617,44809619,44809642,44809643,44809644,44809645,44811323,44811330,44811428,44811437,44811442,44813904,44814047,46270677,46270922))

) I
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
  -- Begin Procedure Occurrence Criteria
select C.person_id, C.procedure_occurrence_id as event_id, C.start_date, C.end_date,
       C.visit_occurrence_id, C.start_date as sort_date
from 
(
  select po.person_id,po.procedure_occurrence_id,po.procedure_concept_id,po.visit_occurrence_id,po.quantity,po.procedure_date as start_date, DATEADD(day,1,po.procedure_date) as end_date 
  FROM @cdm_database_schema.PROCEDURE_OCCURRENCE po
JOIN #Codesets cs on (po.procedure_concept_id = cs.concept_id and cs.codeset_id = 11)
) C


-- End Procedure Occurrence Criteria

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
  INNER JOIN
  (
    -- Begin Correlated Criteria
select 0 as index_id, cc.person_id, cc.event_id
from (SELECT p.person_id, p.event_id 
FROM #qualified_events P
JOIN (
  -- Begin Condition Occurrence Criteria
SELECT C.person_id, C.condition_occurrence_id as event_id, C.start_date, C.end_date,
  C.visit_occurrence_id, C.start_date as sort_date
FROM 
(
  SELECT co.person_id,co.condition_occurrence_id,co.condition_concept_id,co.visit_occurrence_id,co.condition_start_date as start_date, COALESCE(co.condition_end_date, DATEADD(day,1,co.condition_start_date)) as end_date , row_number() over (PARTITION BY co.person_id ORDER BY co.condition_start_date, co.condition_occurrence_id) as ordinal
  FROM @cdm_database_schema.CONDITION_OCCURRENCE co
  JOIN #Codesets cs on (co.condition_concept_id = cs.concept_id and cs.codeset_id = 10)
) C

WHERE C.ordinal = 1
-- End Condition Occurrence Criteria

) A on A.person_id = P.person_id  AND A.START_DATE >= P.OP_START_DATE AND A.START_DATE <= P.OP_END_DATE AND A.START_DATE >= DATEADD(day,-365,P.START_DATE) AND A.START_DATE <= DATEADD(day,30,P.START_DATE) ) cc 
GROUP BY cc.person_id, cc.event_id
HAVING COUNT(cc.event_id) >= 1
-- End Correlated Criteria

  ) CQ on E.person_id = CQ.person_id and E.event_id = CQ.event_id
  GROUP BY E.person_id, E.event_id
  HAVING COUNT(index_id) = 1
) G
-- End Criteria Group
) AC on AC.person_id = pe.person_id AND AC.event_id = pe.event_id
) Results
;

SELECT inclusion_rule_id, person_id, event_id
INTO #inclusion_events
FROM (select inclusion_rule_id, person_id, event_id from #Inclusion_0) I;
TRUNCATE TABLE #Inclusion_0;
DROP TABLE #Inclusion_0;


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
{1 != 0}?{
  -- the matching group with all bits set ( POWER(2,# of inclusion rules) - 1 = inclusion_rule_mask
  WHERE (MG.inclusion_rule_mask = POWER(cast(2 as bigint),1)-1)
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
{1 != 0 & 1 != 0}?{

-- Create a temp table of inclusion rule rows for joining in the inclusion rule impact analysis

select cast(rule_sequence as int) as rule_sequence
into #inclusion_rules
from (
  SELECT CAST(0 as int) as rule_sequence
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
