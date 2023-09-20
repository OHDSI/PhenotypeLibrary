CREATE TABLE #Codesets (
  codeset_id int NOT NULL,
  concept_id bigint NOT NULL
)
;

INSERT INTO #Codesets (codeset_id, concept_id)
SELECT 3 as codeset_id, c.concept_id FROM (select distinct I.concept_id FROM
( 
  select concept_id from @vocabulary_database_schema.CONCEPT where concept_id in (36558447,36542645,36557132,36518465,36555908,36532893,36529793,36539611,36554231,36563434,36524507,36553857,36522964,36528383,36547074,36550422,36534614,36557152,36534051,36546447,36555551,36549328,36541764,36555420,36549710,44500019,44500410,44500863,44501634,44500874,44502935,36529078,44503086,44499501,44500411,44500245,44502529,36524553,36546337,36556767,44500059,36556262,36529455,36552724,36552772,36551689,44499436,36522002,36535150,36547484,36518315,44500353,44501009,36548040,36565190,36541062,36536908,36553700,44500060,36566260,36538847,44501800,44502946,44502705,44502947,44502776,44499892,36566477,44501639,44499893,44499550,44500141,44500596,44501083,44498956,44501728,44500416,44500792,44500026,36556699,44501440,44501798,44501145,44503020,44500198,4110575,36565411,36562519,36519060,36567436,36523630,36527745,36560775,36543319,36559272,36522763,36518156,36542446,36538960,36560731,36559392,44499480,36536873,36548322,36547476,36567536,36543160,36549206,36557668,36518243,44499865,36539064,36533090,44502074,36565653,36539283,36542051,36566994,36547508,36520412,36523693,36549720,36542290,36548476,36544256,36521999,36521726,44500640,44500018,36553127,36556197,36536335,36552518,36540380,36548330,36521414,36538727,36540503,36560788,36544782,36540392,42512946,44502874,36537698,36566228,36558147,36543573,36519246,36529294,36567725,36545562,36546634,36552278,36565009,36531547,36558278,36550771,36528217,36535318,36537464,36522380,36560734,36565088,36555713,36556087,36561054,36566374,36519781,36525988,36522394,36524857,36517381,36543543,36557600,36536450,36558939,36524969,36560037,36534477,36558539,36530653,36530931,36545613,36565751,36535494,36524885,36542371,36565587,36531202,36520266,36562617,36556759,36544152,36548145,36529046,36541312,36535559,36548737,36529639,36543469,36553110,36521098,36526783,36531149,36557202,36565575,36531073,36521548,36531685,36562766,36529222,36525852,36558010,36549033,36524678,1553191,36403011,42512863,36552870,36520575,36532404,36531969,36557469,36536398,36564211,36544279,36549877,36550353,36521492,36545148,36545386,36531137,36542980,36566533,36551676,36528898,36543940,36559942,36520130,36563654,36536660,36566497,36540131,36561239,36518296,36547920,36531042,36524169,36557064,36522104,36539158,36554404,36552986,36545083,36522099,36546777,36517757,36561692,36558419,36528298,36550790,36525949,36531645,36527191,36540812,36540732,36529355,36537537,36520077,36531094,36535590,36539402,36549071,36563818,36538646,36556972,36561086,36522561,36530057,44500738,36530655,36564477,36526950,36517666,36527461,36554357,44500461,44502115,36534873,36531004,42512414,36531875,36519642,36561723,36546355,36537969,36528392,36522214,36555932,36530988,36526752,36567435,36563922,42512903,42512762,42512897,42511614,42512140,42511879,42512553,42512189,42511613,42511881,42512948,42512830,44499512,44501020,44501649,44500256,44501088,44500736,36542547,44500037,44501148,44502709,44502112,44501952,44501804,44502707,44499511,44499921,44503091,36545379,44502951,44500071,44502029,44502395,44498960,44499747,44501018,36539571,36524523,36521082,36544470,36527693,36557186,36565089,36555022,36556793,36539431,36519395,36563756,36529349,36540509,36541244,36550650,36517840,36565948,36559749,36527779,36524866,36563181,36549340,36521918,36541030,1553226,36524683,36566070,44501142,36548971,44502175,36546604,36549436,44500138,36525823,44500648,36528154,36534597,36525312,36522630,36519514,36532476,36524271,36523103,36536938,36536825,36545794,36531112,36545535,36560294,36525001,36541474,36553253,36533218,36540046,36518112,36518519,36536625,36535195,36549571,36565794,36533966,36562620,36530536,36532339,36544906,36544368,36519550,36519612,36557375,36544212,36528818,36537155,36560559,36550073,36538038,36541753,36529077,36533185,36531080,36526290,36560139,36524360,36542877,36549367,36531329,36552602,36713361,36715911,42872396,37208245,36717495,37016239,36715912,433143,4247719,432837,197500,441800,438979,438699,74582,436635,437798,432257,36715890,36554145,36552072,36559888,36537543,36518870,36522672,36555825,36534830,36517916,36561931,36536967,36517398,36530154,36549405,36539813,36538316,36526627,36543599,44501787,36517290,36553482,44500642,36534141,36560403,36548695,36554550,42512063,42511855,42512255,42512100,42512435,42512621,36561333,42512292,42512512,42512076,44502544,44499559,44503025,44500506,44501412,44503026,36533326,44502879,44502397,44503028,44500304,44503027,36525509,36517899,36526187,36549964,36542597,36544807,36549748,36539924,36552163,36529934,36554217,36529289,36533942,36526140,36520143,36567087,36519910,36519232,36566786,36557736,36564665,36566061,36526727,36554686,36554160,36537912,36538264,36532897,36537403,36561147,36530903,36543448,36533759,36534338,36567224,36523401,36557257,36532842,36551623,36536791,36558792,36557603,36526294,36518244,36521279,36525556,36565914,36534919,36555203,36537994,36554714,36565644,36520141,36545571,36554324,36552920,44500431,36562334,36560344,36551710,36552408,36527041,36565162,36548553,36525304,36522062,36542895,36543425,36525603,36520534,36521183,36540801,36564730,36553691,36517455,36564964,36524240,36548674,36517193,36524701,36523116,36547294,36545206,36543530,36532660,44502807,36520299,36555648,36528604,36542595,36549227,44502263,44502264,44500982,36531259,36561688,36558052,36521670,36517247,36545686,36546236,36531376,36548251,36561219,36548515,36545257,36546914,36557362,36533572,36525772,36523276,36521119,36563886,36555534,36531401,36545669,36532773,36533849,36562674,36563996,36547289,36539862,36524266,36554114,36526725,36540554,36538007,36566885,36519990,44500195,36540621,36518490,44502441,44501880,36555650,36552866,44500724,36530925,36537978,36560108,36559489,36526362,36534066,44501720,36521028,44501850,36568264,36568049,36568046,36568349,36568145,36568113,36550053,36568192,36568103,36568035,36568126,36568095,36526512,36524297,36520999,36534160,36542327,36521018,36530672,36539812,36552671,36566220,36555955,36555879,36552799,36566833,36518724,44499547,36528574,44499548,36549738,36567493,44499966,36554294,44503088,36518497,44500502,443382,443383,443381,443390,443391,443384,4322376,4256776,603311,603310,435754,4089661,608070,35624316,35624314,79740,4200514,80045,4246125,4307687,40487050,4180792,4180790,4184850,4184849,4312001,764981,4308015,4312240,4181344,4095430,37018661,37018659,37018665,438090,36549133,36524657,37016240,37016237,36557461,36561659,36541150,36520829,36533114,4112730,44499930,36525049,4289091,4289090,4289092,4309574,36716620,4170421,36565176,4289245,4289247,4289246,36528352,36565308,36716972,36716975,36565382,36561397,443396,36521495,36533946,36562573,607409,607424,36562648,36538064,36562748,44500977,36550477,36538280,40481902,44500118,36533499,4310858,36541702,608069,36554146,36562304,4196256,4196264,36551275,436348,36563626,36522659,36543282,36522868,36535198,4311480,44501181,36517992,36567229,36550796,36559081,4180791,36550943,36518308,4180911,195482,36547058,36542921,36555229,36522458,36683301,4201482,36544071,44502570,4283611,36544141,36523658,4201618,36683531,36552451,36544372,36544324,36564829,36532149,37018673,44502130,36527351,36543690,44502405,36531478,36552041,40484156,36547935,36535776,44502351,36541013,36561698,36533386,36528366,36530984,36543695,36527986,36531184,36548113,36520820,36531299,36524117,36522425,36517800,36544156,36539303,36533201,36549024,44502940,44501524,44499890,36538991,36523302,36552722,36520099,44499504,44501495,44500413,36562328,36562377,36550349,44502717,44499654,36536658,36521693,36539545,36532105,36540242,44500655,36561654,36523927,36551546,36559932,36542672,36519618,36536724,36539328,36517480,36543825,36540894,36556784,36541105,36559504,36557136,36559903,36535623,36528720,36517913,36557689,36525408,36549607,36542114,36534456,36522352,36565894,36559232,42512689,42512838,1553182,42512700,42512803,1553312,44504421,44502094,36538491,1553487,44504343,44504337,36561605,44504380,36518316,44502398,44499565,44501415,36524059,36540653,36545664,44499754,44501660,44503097,36561240,44500082,36557933,36518448,36542121,36564204,36518916,36543954,36562813,36567508,36565790,36558313,36543602,36545158,44502326,44501400,44499722,40492937,4207182,4116240,4149847,4193165,4207183,4115028,4193872,4151260,4193871,36564935,36534455,36531573,36525830,36525291,36530070,36535018,36539890,36536333,36533511,36524229,36545002,36534368,36567934,36539322,36517991,36537785,36520709,36560970,36567442,36544338,36567564,36554334,36541351,36563488,36534602,36553697,36548401,36567938,36527398,36567284,36529981,36559065,36534469,36560599,36524579,36555110,36531345,36555504,36537069,36537267,44499427,36554547,36553758,36522738,44502613,36523463,36557364,36557178,36525678,36525747,36557918,4003675,3184757,36542610,36527926,36527200,36543626,36560218,36545127,36545459,36546090,36562779,36530062,36545582,36562295,36563627,36530354,36531858,36531237,36565099,36532303,36548777,36565239,36533777,36550429,36517733,36534151,36533370,36549970,36567883,36535243,36534307,36567046,4177238,36519818,36715921,36535747,443398,4180780,4313335,40489405,192836,440037,36553517,36537207,44499714,36554254,44500574,44500119,36521175,36554078,44501701,44501390,44501248,36540067,36540055,36540163,36540270,36523926,36523427,36557029,35608090,36558416,36542091,36558650,36542910,36545296,36544811,36528573,36531072,36547642,36547702,42512558,36565117,42512658,36551433,36518729,36567392,36552548,36551929,36537300,36555850,36540747,36557189,36562464,36564952,36549291,36550281,36550972)

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
  -- Begin Condition Occurrence Criteria
SELECT C.person_id, C.condition_occurrence_id as event_id, C.start_date, C.end_date,
  C.visit_occurrence_id, C.start_date as sort_date
FROM 
(
  SELECT co.person_id,co.condition_occurrence_id,co.condition_concept_id,co.visit_occurrence_id,co.condition_start_date as start_date, COALESCE(co.condition_end_date, DATEADD(day,1,co.condition_start_date)) as end_date , row_number() over (PARTITION BY co.person_id ORDER BY co.condition_start_date, co.condition_occurrence_id) as ordinal
  FROM @cdm_database_schema.CONDITION_OCCURRENCE co
  JOIN #Codesets cs on (co.condition_concept_id = cs.concept_id and cs.codeset_id = 3)
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
