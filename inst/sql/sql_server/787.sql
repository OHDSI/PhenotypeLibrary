CREATE TABLE #Codesets (
  codeset_id int NOT NULL,
  concept_id bigint NOT NULL
)
;

INSERT INTO #Codesets (codeset_id, concept_id)
SELECT 7 as codeset_id, c.concept_id FROM (select distinct I.concept_id FROM
( 
  select concept_id from @vocabulary_database_schema.CONCEPT where concept_id in (4201621,4201020,443388,443399,36684857)
UNION  select c.concept_id
  from @vocabulary_database_schema.CONCEPT c
  join @vocabulary_database_schema.CONCEPT_ANCESTOR ca on c.concept_id = ca.descendant_concept_id
  and ca.ancestor_concept_id in (4201621,4201020,443388,443399,36684857)
  and c.invalid_reason is null

) I
LEFT JOIN
(
  select concept_id from @vocabulary_database_schema.CONCEPT where concept_id in (254591,44501059,36560318,36543337,36563684,36518396,36520293,36523843,44502938,44501408,44503017,44501264,44502106,36532214,44500865,44502936,44502772,36556766,44500726,36529335,36525369,36561063,36546119,36542395,36538112,36522061,36549716,36716499,36716500,37397538,36532707,36545645,36542792,36562917,36560870,36560866,4100540,36549665,37111619,36562844,44504617,36557947,36564097,36527209,44503537,36550921,36524261,36560935,36526440,44502426,36519531,36545324,36539299,36552502,36550225,36538432,36553379,36539178,36533557,36524452,36564894,36526943,45768927,42511197,44501104,36520456,36542373,36540740,36524303,4111807,36518535,36526200,44500614,1553574,36556168,36550124,36548258,36554657,36544401,36521072,36525541,36528931,36543365,36544299,44500666,42511714,36518085,36532368,36567179,36562795,36563562,36519172,44504619,36567811,36528497,36558075,36558320,36533160,36533303,36536486,36520883,36527417,36562007,36561629,36524077,36537230,36559186,36531433,36562727,44501791,42511836,4198434,254583,44502142,36529395,36537547,36533461,36563157,36562643,36545323,36533542,36529954,36528948,36546822,44501916,44499941,36560737,44503531,36538201,36551506,36561320,44500278,36531087,36547997,36538769,36543471,44500325,36566005,36529611,36520389,36562882,36519385,36519385,44500647,36524580,36545575,36547617,44503114,44501591,36517590,36557068,44502404,36552458,44500885,36534332,36526173,36557406,36534648,36563681,36546924,36542025,36528608,36532851,36559148,36517346,36522054,36518628,36540186,36559870,44502199,36562406,36526098,36522773,36554435,36526633,36563139,44499410,36518613,44502589,36555975,40489468,36565504,36520252,36536689,36529621,36548325,36549830,36519168,36531839,44501740,36549254,36553640,36550205,36560498,36549871,36525917,36567080,36523869,36565300,36533054,36542851,36560310,36529884,36551173,36536089,36528052,36563690,36561391,36564548,42512943,36547241,36527572,36558801,36528098,44499571,36518505,36543774,36527832,36517443,36525269,36566358,36559656,36550051,36552762,36533190,36523285,42512146,36561406,44500693,36535296,36568015,36554958,36539951,36537461,36541339,36533230,36532469,36557631,36537925,36537885,36556287,44499907,36540203,36520209,36528949,36548254,36563971,36556317,36532111,36547041,36555210,44500896,44498975,36521849,36557572,36546205,44501807,42511847,42512748,42511773,42512188,42512429,36519672,36560792,40391740,36561198,36568076,36530883,36531963,44500809,36523412,36538057,36530722,36538858,36556267,36538987,36538582,765056,36567102,36537905,36535304,36535826,36521578,36540537,36528207,36522077,44499670,36529848,36525709,36556937,36527749,36521607,36548230,36553448,36553442,36529954,36539726,36538201,36551142,36566005,1553457,36561424,36557330,44500710,36554873,36519544,36549209,36567131,36552276,36536407,36567225,36533500,36559103,36561652,44503111,36526380,42512777,44501421,36552471,36540284,36526449,36517187,36529500,36566445,36544421,36558216,42512206,36524541,36562938,36519369,36545575,36543749,36523825,36535241,36566494,40492020,40490998,36563234,36555444,36526085,36520928,36537701,36539830,36523821,36550415,36543707,36547246,36541243,36560409,36548320,36565014,36530632,36560811,36554171,36564140,36565831,36526879,36563602,36534967,36555957,36559237,36538506,36534701,36523848,44501318,36551461,36551114,36561068,36528907,36560585,36524770,44499830,36518572,42511947,36556675,36559568,36567958,36538959,36522433,36527884,36521860,36523887,42512093,42512186,42512479,42512795,36531808,36543925,36559704,36530558,36540571,36543150,36550060,36562787,42512923,36530501,36542314,36540387,36563719,36548390,36522697,36536890,36524776,45769035,45768923,44499947,44501560,44499623,36517425,44500086,36529368,36551720,36557323,44502045,44501966,36545565,36518822,36560847,36566443,36565732,36540926,36546138,36552050,36551518,36525197,44501810,44501360,36534059,44500514,36546568,36537680,36542818,36550994,44500895,44501593,36538384,36556587,44502131,36544925,36559545,44499931,36543198,36564528,36538912,36518482,36526133,36564406,36565366,36546625,36546742,36554343,36530898,36518168,36544100,42512800,42511869,42512038,42511724,42511824,42511643,36403149,42512747,42512286,42512532,42512028,36403081,36530431,36564925,36518010,36556919,36532026,44503034,36555472,36532834,3654297,3654352,36523318,36517535,36562473,36540164,36555661,36518438,36521556,36553116,36567431,36518412,36551466,36532094,36540562,36550669,36558542,36556619,36517796,36533365,36521683,36549271,36550031,36542618,36565196,36524497,36535563,36520446,36531818,36555652,36526210,36537874,36564176,36529299,36520980,36537594,36554446,36533290,36523730,36403024,36554251,44500330,36542611,36549983,36542388,36529430,36531470,36530198,44499863,36564825,36523415,36533756,36556242,36529186,36517990,42512088,42511865,42512079,42511815,36530085,36548457,36565708,36519134,44500480,44500048,44501388,36531398,36533051,36535188,44499730,36520546,44501617,36525474,36567702,36556039,36547447,44498992,36549098,36551030,44501096,36517751,36542740,36545668,36520427,36559981,36531667,36546808,44500933,36550952,36537376,36544341,36559841,44501493,36562353,36556230,36553679,36567001,36530476,36543016,36532626,36528602,36547527,36558235,36551292,36529590,36556496,44503150,44499502,44501887)
UNION  select c.concept_id
  from @vocabulary_database_schema.CONCEPT c
  join @vocabulary_database_schema.CONCEPT_ANCESTOR ca on c.concept_id = ca.descendant_concept_id
  and ca.ancestor_concept_id in (254591,44501059,36560318,36543337,36563684,36518396,36520293,36523843,44502938,44501408,44503017,44501264,44502106,36532214,44500865,44502936,44502772,36556766,44500726,36529335,36525369,36561063,36546119,36542395,36538112,36522061,36549716,36716499,36716500,37397538,36532707,36545645,36542792,36562917,36560870,36560866,4100540,36549665,37111619,36562844,44504617,36557947,36564097,36527209,44503537,36550921,36524261,36560935,36526440,44502426,36519531,36545324,36539299,36552502,36550225,36538432,36553379,36539178,36533557,36524452,36564894,36526943,45768927,42511197,44501104,36520456,36542373,36540740,36524303,4111807,36518535,36526200,44500614,1553574,36556168,36550124,36548258,36554657,36544401,36521072,36525541,36528931,36543365,36544299,44500666,42511714,36518085,36532368,36567179,36562795,36563562,36519172,44504619,36567811,36528497,36558075,36558320,36533160,36533303,36536486,36520883,36527417,36562007,36561629,36524077,36537230,36559186,36531433,36562727,44501791,42511836,4198434,254583,44502142,36529395,36537547,36533461,36563157,36562643,36545323,36533542,36529954,36528948,36546822,44501916,44499941,36560737,44503531,36538201,36551506,36561320,44500278,36531087,36547997,36538769,36543471,44500325,36566005,36529611,36520389,36562882,36519385,36519385,44500647,36524580,36545575,36547617,44503114,44501591,36517590,36557068,44502404,36552458,44500885,36534332,36526173,36557406,36534648,36563681,36546924,36542025,36528608,36532851,36559148,36517346,36522054,36518628,36540186,36559870,44502199,36562406,36526098,36522773,36554435,36526633,36563139,44499410,36518613,44502589,36555975,40489468,36565504,36520252,36536689,36529621,36548325,36549830,36519168,36531839,44501740,36549254,36553640,36550205,36560498,36549871,36525917,36567080,36523869,36565300,36533054,36542851,36560310,36529884,36551173,36536089,36528052,36563690,36561391,36564548,42512943,36547241,36527572,36558801,36528098,44499571,36518505,36543774,36527832,36517443,36525269,36566358,36559656,36550051,36552762,36533190,36523285,42512146,36561406,44500693,36535296,36568015,36554958,36539951,36537461,36541339,36533230,36532469,36557631,36537925,36537885,36556287,44499907,36540203,36520209,36528949,36548254,36563971,36556317,36532111,36547041,36555210,44500896,44498975,36521849,36557572,36546205,44501807,42511847,42512748,42511773,42512188,42512429,36519672,36560792,40391740,36561198,36568076,36530883,36531963,44500809,36523412,36538057,36530722,36538858,36556267,36538987,36538582,765056,36567102,36537905,36535304,36535826,36521578,36540537,36528207,36522077,44499670,36529848,36525709,36556937,36527749,36521607,36548230,36553448,36553442,36529954,36539726,36538201,36551142,36566005,1553457,36561424,36557330,44500710,36554873,36519544,36549209,36567131,36552276,36536407,36567225,36533500,36559103,36561652,44503111,36526380,42512777,44501421,36552471,36540284,36526449,36517187,36529500,36566445,36544421,36558216,42512206,36524541,36562938,36519369,36545575,36543749,36523825,36535241,36566494,40492020,40490998,36563234,36555444,36526085,36520928,36537701,36539830,36523821,36550415,36543707,36547246,36541243,36560409,36548320,36565014,36530632,36560811,36554171,36564140,36565831,36526879,36563602,36534967,36555957,36559237,36538506,36534701,36523848,44501318,36551461,36551114,36561068,36528907,36560585,36524770,44499830,36518572,42511947,36556675,36559568,36567958,36538959,36522433,36527884,36521860,36523887,42512093,42512186,42512479,42512795,36531808,36543925,36559704,36530558,36540571,36543150,36550060,36562787,42512923,36530501,36542314,36540387,36563719,36548390,36522697,36536890,36524776,45769035,45768923,44499947,44501560,44499623,36517425,44500086,36529368,36551720,36557323,44502045,44501966,36545565,36518822,36560847,36566443,36565732,36540926,36546138,36552050,36551518,36525197,44501810,44501360,36534059,44500514,36546568,36537680,36542818,36550994,44500895,44501593,36538384,36556587,44502131,36544925,36559545,44499931,36543198,36564528,36538912,36518482,36526133,36564406,36565366,36546625,36546742,36554343,36530898,36518168,36544100,42512800,42511869,42512038,42511724,42511824,42511643,36403149,42512747,42512286,42512532,42512028,36403081,36530431,36564925,36518010,36556919,36532026,44503034,36555472,36532834,3654297,3654352,36523318,36517535,36562473,36540164,36555661,36518438,36521556,36553116,36567431,36518412,36551466,36532094,36540562,36550669,36558542,36556619,36517796,36533365,36521683,36549271,36550031,36542618,36565196,36524497,36535563,36520446,36531818,36555652,36526210,36537874,36564176,36529299,36520980,36537594,36554446,36533290,36523730,36403024,36554251,44500330,36542611,36549983,36542388,36529430,36531470,36530198,44499863,36564825,36523415,36533756,36556242,36529186,36517990,42512088,42511865,42512079,42511815,36530085,36548457,36565708,36519134,44500480,44500048,44501388,36531398,36533051,36535188,44499730,36520546,44501617,36525474,36567702,36556039,36547447,44498992,36549098,36551030,44501096,36517751,36542740,36545668,36520427,36559981,36531667,36546808,44500933,36550952,36537376,36544341,36559841,44501493,36562353,36556230,36553679,36567001,36530476,36543016,36532626,36528602,36547527,36558235,36551292,36529590,36556496,44503150,44499502,44501887)
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
  JOIN #Codesets cs on (co.condition_concept_id = cs.concept_id and cs.codeset_id = 7)
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
