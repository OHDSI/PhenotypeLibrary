CREATE TABLE #Codesets (
  codeset_id int NOT NULL,
  concept_id bigint NOT NULL
)
;

INSERT INTO #Codesets (codeset_id, concept_id)
SELECT 4 as codeset_id, c.concept_id FROM (select distinct I.concept_id FROM
( 
  select concept_id from @vocabulary_database_schema.CONCEPT where concept_id in (4181345,4246127)
UNION  select c.concept_id
  from @vocabulary_database_schema.CONCEPT c
  join @vocabulary_database_schema.CONCEPT_ANCESTOR ca on c.concept_id = ca.descendant_concept_id
  and ca.ancestor_concept_id in (4181345,4246127)
  and c.invalid_reason is null

) I
LEFT JOIN
(
  select concept_id from @vocabulary_database_schema.CONCEPT where concept_id in (198700,600665,4115271,4200888,4312024,4311638,4312024,4312024,4311634,4313079,4196255,198700,600665,4115271,4200888,36521689,44502636,36532040,36529420,36538687,36551790,36528621,36564786,36555172,36535122,36550032,36559574,36559442,36531355,36539606,36521053,36525598,36529112,44503128,36521226,42512962,44500087,36544858,36561278,36545804,36544840,36543968,36519663,36558684,44501369,42511777,36538879,36546042,36555636,36548271,36567359,36536519,36521021,36534582,36537486,36559373,36545311,36561290,1553251,1553145,1553587,42512754,1553479,36555334,36558805,36557418,36553745,36527682,36522357,36520935,36517352,36567073,36524120,36560072,36525529,36562508,36546103,36555449,36534409,36529343,36521269,36559488,36526861,36548493,36527178,36529920,36540760,36519541,36517952,36557057,36546259,36544142,36531869,36554537,36560121,36547334,36549050,36524187,36561392,36562396,36560509,36543157,36553085,44503572,36532824,36546470,36517817,36567844,36537609,36543279,36520825,36529681,36527818,36543050,44500382,4001172,36525785,36526989,36543953,36546626,36563470,36537433,36553064,36528694,36567534,36547973,36566526,36530547,36566463,36530110,36548920,36524503,36534414,36538921,36517524,36537262,36544167,36548883,36544196,36527838,36567505,36561238,36545698,36523934,36530345,36532489,36553300,36554548,36553915,36534566,36538907,36545401,36537696,36532456,36530242,36519137,36563974,36560449,36557935,36553983,36542215,36559578,36520014,36545232,36552859,36524875,36540553,36552881,36565589,36550494,36529103,36517541,36542216,36539359,36540253,36556417,36537071,36533573,36524704,36548072,36536227,36541090,36520031,36561958,36565005,36537391,36558150,36523314,36540871,36561018,36523700,36533918,36550491,36556573,36540570,36523009,36561445,36528763,36556206,36554481,36547679,36551152,36564844,36548056,36545657,36527614,36544866,36549235,36530297,36564642,36552168,36534576,36566276,36563750,36553422,36536971,36560219,36544940,36541790,36526970,36522376,36533853,36522469,36559844,36539771,36566075,36523375,36555465,36520175,36564895,36523991,36542460,36528097,36517413,36567145,36530005,36518931,36536207,36528963,36536337,36558613,36521997,36519727,36530589,36520578,36518238,36534034,36523572,36528002,36564843,36545740,36525238,36537740,36524663,36555569,36557402,36565569,36552232,36558322,36519969,36524114,44502763,36544291,36568004,36563137,36565096,36537431,36521846,36561992,36548418,36550367,36550504,36562628,42511886,36548976,36555660,36542122,36548516,36565189,36561660,36529169,36549586,42512422,36555863,36524692,36539604,36531555,36529303,36555089,36520532,36541541,36520981,36530004,36556134,36552291,36554702,36564996,36550923,36543278,36546523,36548996,36523558,36562623,36553782,36555246,36566829,36535237,36562991,36563309,36532983,36564399,36555514,36543331,36523501,36530072,36535744,44501293,36555716,36561945,36539973,36533496,36562758,36555001,36539632,36538169,42512769,36542236,36533300,36548052,36546478,36567784,36567370,36537441,36535427,36563454,36535597,36549202,36530569,36556854,36564780,36528549,36548767,36542676,36558206,36532480,36531172,36557379,36562805,36545822,36544580,36541908,36558555,36555854,36544577,36541357,36550538,36533699,36530336,36534063,42512261,36526979,36559869,36557243,36552795,36534193,36530615,36559605,36522012,36536296,36557842,36560134,36540959,36556161,36529135,36550338,36524820,36547434,36537306,36532898,44499619,36551991,36523441,36565527,36554857,36527087,36537048,36525429,36545483,36563849,36564955,36559443,36528061,36556399,36530450,36547225,36518734,36525410,36545097,36537904,36530599,36517421,36561907,36547852,36543332,44501724,36543032,36518547,36554286,44502278,36551943,36557810,36519671,36521386,44500062,36556955,36565664,44500646,42512137,44500135,36529741,36567898,36567982,36566904,36553878,36555158,36527055,36526980,36402490,36562729,36534224,36521660,36556778,36548643,36525154,36524843,36567816,36530286,36552366,36552675,36562547,44502851,36564628,36529093,36561388,36540819,36537337,36520572,36537152,36551472,36525032,36558076,36564910,36527254,36535584,36541983,36560733,36544200,36517604,36563604,36564208,36554099,36542622,36546984,36522685,36550278,36520774,36534498,36567111,36517596,37399544,37116589,37116591,37116586,37116588,42538835,36517351,42512775,42512073,36536015,36544032,44502321,36525687,44500894,36539995,36527610,36529644,36518187,36565042,36522239,36517307,36532931,36566685,36531736,36539097,36546425,36556574,36542243,36536579,36539192,36533809,36548513,36527149,36550852,36534186,36538933,36530541,36546100,36559277,36551456,36518825,36528458,36532063,36547880,36520983,36562636,36561403,36537425,36547353,36565285,36567663,36547643,36522311,36557900,36530627,36558462,36544696,36563979,36545635,36567772,36539630,36551945,36559651,36540608,36525513,36550356,36566973,36564402,36521517,36553287,44501121,36557162,36548509,36550742,36529472,36520331,36524532,36524484,36554712,36533172,36546684,36558038,36536942,36545508,36525271,36563539,36539394,36567890,36520139,36523019,36531778,36403030,36553565,36531664,36547395,36563825,36553955,36542339,36550960,36545201,36541272,36522475,36527814,36520675,36567051,36563861,36519839,36526568,36561512,36522276,36525166,36561935,36559677,36554284,36530280,36519609,36546952,36543893,36547421,36529505,36564682,36556711,36536746,36559528,36550037,36535793,36524699,36563931,36543637,36555296,36547448,36560680,36529602,36529010,36524023,36519080,36541534,36530401,36534985,36562821,36565351,36556080,36534822,36534501,36549232,36517998,36535313,36525763,36545464,36542036,36523036,36552372,36521797,36559150,36522899,36554076,36560567,36534227,36547272,36549441,36533541,36559208,36560422,36530107,36566150,36563868,36540106,36527252,36524302,44501155,36556289,36527937,36525881,36565335,36562853,36527551,36521120,36538558,36543822,36531393,36536893)
UNION  select c.concept_id
  from @vocabulary_database_schema.CONCEPT c
  join @vocabulary_database_schema.CONCEPT_ANCESTOR ca on c.concept_id = ca.descendant_concept_id
  and ca.ancestor_concept_id in (198700,600665,4115271,4200888,4312024,4311638,4312024,4312024,4311634,4313079,4196255,198700,600665,4115271,4200888,36521689,44502636,36532040,36529420,36538687,36551790,36528621,36564786,36555172,36535122,36550032,36559574,36559442,36531355,36539606,36521053,36525598,36529112,44503128,36521226,42512962,44500087,36544858,36561278,36545804,36544840,36543968,36519663,36558684,44501369,42511777,36538879,36546042,36555636,36548271,36567359,36536519,36521021,36534582,36537486,36559373,36545311,36561290,1553251,1553145,1553587,42512754,1553479,36555334,36558805,36557418,36553745,36527682,36522357,36520935,36517352,36567073,36524120,36560072,36525529,36562508,36546103,36555449,36534409,36529343,36521269,36559488,36526861,36548493,36527178,36529920,36540760,36519541,36517952,36557057,36546259,36544142,36531869,36554537,36560121,36547334,36549050,36524187,36561392,36562396,36560509,36543157,36553085,44503572,36532824,36546470,36517817,36567844,36537609,36543279,36520825,36529681,36527818,36543050,44500382,4001172,36525785,36526989,36543953,36546626,36563470,36537433,36553064,36528694,36567534,36547973,36566526,36530547,36566463,36530110,36548920,36524503,36534414,36538921,36517524,36537262,36544167,36548883,36544196,36527838,36567505,36561238,36545698,36523934,36530345,36532489,36553300,36554548,36553915,36534566,36538907,36545401,36537696,36532456,36530242,36519137,36563974,36560449,36557935,36553983,36542215,36559578,36520014,36545232,36552859,36524875,36540553,36552881,36565589,36550494,36529103,36517541,36542216,36539359,36540253,36556417,36537071,36533573,36524704,36548072,36536227,36541090,36520031,36561958,36565005,36537391,36558150,36523314,36540871,36561018,36523700,36533918,36550491,36556573,36540570,36523009,36561445,36528763,36556206,36554481,36547679,36551152,36564844,36548056,36545657,36527614,36544866,36549235,36530297,36564642,36552168,36534576,36566276,36563750,36553422,36536971,36560219,36544940,36541790,36526970,36522376,36533853,36522469,36559844,36539771,36566075,36523375,36555465,36520175,36564895,36523991,36542460,36528097,36517413,36567145,36530005,36518931,36536207,36528963,36536337,36558613,36521997,36519727,36530589,36520578,36518238,36534034,36523572,36528002,36564843,36545740,36525238,36537740,36524663,36555569,36557402,36565569,36552232,36558322,36519969,36524114,44502763,36544291,36568004,36563137,36565096,36537431,36521846,36561992,36548418,36550367,36550504,36562628,42511886,36548976,36555660,36542122,36548516,36565189,36561660,36529169,36549586,42512422,36555863,36524692,36539604,36531555,36529303,36555089,36520532,36541541,36520981,36530004,36556134,36552291,36554702,36564996,36550923,36543278,36546523,36548996,36523558,36562623,36553782,36555246,36566829,36535237,36562991,36563309,36532983,36564399,36555514,36543331,36523501,36530072,36535744,44501293,36555716,36561945,36539973,36533496,36562758,36555001,36539632,36538169,42512769,36542236,36533300,36548052,36546478,36567784,36567370,36537441,36535427,36563454,36535597,36549202,36530569,36556854,36564780,36528549,36548767,36542676,36558206,36532480,36531172,36557379,36562805,36545822,36544580,36541908,36558555,36555854,36544577,36541357,36550538,36533699,36530336,36534063,42512261,36526979,36559869,36557243,36552795,36534193,36530615,36559605,36522012,36536296,36557842,36560134,36540959,36556161,36529135,36550338,36524820,36547434,36537306,36532898,44499619,36551991,36523441,36565527,36554857,36527087,36537048,36525429,36545483,36563849,36564955,36559443,36528061,36556399,36530450,36547225,36518734,36525410,36545097,36537904,36530599,36517421,36561907,36547852,36543332,44501724,36543032,36518547,36554286,44502278,36551943,36557810,36519671,36521386,44500062,36556955,36565664,44500646,42512137,44500135,36529741,36567898,36567982,36566904,36553878,36555158,36527055,36526980,36402490,36562729,36534224,36521660,36556778,36548643,36525154,36524843,36567816,36530286,36552366,36552675,36562547,44502851,36564628,36529093,36561388,36540819,36537337,36520572,36537152,36551472,36525032,36558076,36564910,36527254,36535584,36541983,36560733,36544200,36517604,36563604,36564208,36554099,36542622,36546984,36522685,36550278,36520774,36534498,36567111,36517596,37399544,37116589,37116591,37116586,37116588,42538835,36517351,42512775,42512073,36536015,36544032,44502321,36525687,44500894,36539995,36527610,36529644,36518187,36565042,36522239,36517307,36532931,36566685,36531736,36539097,36546425,36556574,36542243,36536579,36539192,36533809,36548513,36527149,36550852,36534186,36538933,36530541,36546100,36559277,36551456,36518825,36528458,36532063,36547880,36520983,36562636,36561403,36537425,36547353,36565285,36567663,36547643,36522311,36557900,36530627,36558462,36544696,36563979,36545635,36567772,36539630,36551945,36559651,36540608,36525513,36550356,36566973,36564402,36521517,36553287,44501121,36557162,36548509,36550742,36529472,36520331,36524532,36524484,36554712,36533172,36546684,36558038,36536942,36545508,36525271,36563539,36539394,36567890,36520139,36523019,36531778,36403030,36553565,36531664,36547395,36563825,36553955,36542339,36550960,36545201,36541272,36522475,36527814,36520675,36567051,36563861,36519839,36526568,36561512,36522276,36525166,36561935,36559677,36554284,36530280,36519609,36546952,36543893,36547421,36529505,36564682,36556711,36536746,36559528,36550037,36535793,36524699,36563931,36543637,36555296,36547448,36560680,36529602,36529010,36524023,36519080,36541534,36530401,36534985,36562821,36565351,36556080,36534822,36534501,36549232,36517998,36535313,36525763,36545464,36542036,36523036,36552372,36521797,36559150,36522899,36554076,36560567,36534227,36547272,36549441,36533541,36559208,36560422,36530107,36566150,36563868,36540106,36527252,36524302,44501155,36556289,36527937,36525881,36565335,36562853,36527551,36521120,36538558,36543822,36531393,36536893)
  and c.invalid_reason is null

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
  -- Begin Condition Occurrence Criteria
SELECT C.person_id, C.condition_occurrence_id as event_id, C.start_date, C.end_date,
  C.visit_occurrence_id, C.start_date as sort_date
FROM 
(
  SELECT co.person_id,co.condition_occurrence_id,co.condition_concept_id,co.visit_occurrence_id,co.condition_start_date as start_date, COALESCE(co.condition_end_date, DATEADD(day,1,co.condition_start_date)) as end_date , row_number() over (PARTITION BY co.person_id ORDER BY co.condition_start_date, co.condition_occurrence_id) as ordinal
  FROM @cdm_database_schema.CONDITION_OCCURRENCE co
  JOIN #Codesets cs on (co.condition_concept_id = cs.concept_id and cs.codeset_id = 4)
) C

WHERE C.ordinal = 1
-- End Condition Occurrence Criteria

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
{0 != 0}?{
  -- the matching group with all bits set ( POWER(2,# of inclusion rules) - 1 = inclusion_rule_mask
  WHERE (MG.inclusion_rule_mask = POWER(cast(2 as bigint),0)-1)
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
        , SUM(event_type) OVER (PARTITION BY person_id ORDER BY event_date, event_type ROWS UNBOUNDED PRECEDING) AS interval_status
      FROM
      (
        SELECT
          person_id
          , start_date AS event_date
          , -1 AS event_type
        FROM #cohort_rows

        UNION ALL


        SELECT
          person_id
          , DATEADD(day,0,end_date) as end_date
          , 1 AS event_type
        FROM #cohort_rows
      ) RAWDATA
    ) e
    WHERE interval_status = 0
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

{1 != 0}?{
-- BEGIN: Censored Stats

delete from @results_database_schema.cohort_censor_stats where cohort_definition_id = @target_cohort_id;

-- END: Censored Stats
}
{1 != 0 & 0 != 0}?{

CREATE TABLE #inclusion_rules (rule_sequence int);

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
