CREATE TABLE #Codesets (
  codeset_id int NOT NULL,
  concept_id bigint NOT NULL
)
;

INSERT INTO #Codesets (codeset_id, concept_id)
SELECT 0 as codeset_id, c.concept_id FROM (select distinct I.concept_id FROM
( 
  select concept_id from @vocabulary_database_schema.CONCEPT where concept_id in (9201)
UNION  select c.concept_id
  from @vocabulary_database_schema.CONCEPT c
  join @vocabulary_database_schema.CONCEPT_ANCESTOR ca on c.concept_id = ca.descendant_concept_id
  and ca.ancestor_concept_id in (9201)
  and c.invalid_reason is null

) I
) C UNION ALL 
SELECT 43 as codeset_id, c.concept_id FROM (select distinct I.concept_id FROM
( 
  select concept_id from @vocabulary_database_schema.CONCEPT where concept_id in (262,9203)
UNION  select c.concept_id
  from @vocabulary_database_schema.CONCEPT c
  join @vocabulary_database_schema.CONCEPT_ANCESTOR ca on c.concept_id = ca.descendant_concept_id
  and ca.ancestor_concept_id in (262,9203)
  and c.invalid_reason is null

) I
) C UNION ALL 
SELECT 81 as codeset_id, c.concept_id FROM (select distinct I.concept_id FROM
( 
  select concept_id from @vocabulary_database_schema.CONCEPT where concept_id in (313217)
UNION  select c.concept_id
  from @vocabulary_database_schema.CONCEPT c
  join @vocabulary_database_schema.CONCEPT_ANCESTOR ca on c.concept_id = ca.descendant_concept_id
  and ca.ancestor_concept_id in (313217)
  and c.invalid_reason is null

) I
) C UNION ALL 
SELECT 85 as codeset_id, c.concept_id FROM (select distinct I.concept_id FROM
( 
  select concept_id from @vocabulary_database_schema.CONCEPT where concept_id in (2002187,2729943,2730416,2729923,2730209,2730169,2730456,2729963,2730436,2730189,2730476,2729949,2730422,2729929,2730215,2730175,2730462,2729969,2730442,2730195,2730668,2729952,2730425,2729932,2730218,2730178,2730465,2729972,2730445,2730198,2730671,2729946,2730419,2729926,2730212,2730172,2730459,2729966,2730439,2730192,2730665,2729942,2730415,2729922,2730208,2730168,2730455,2729962,2730435,2730188,2730475,2729948,2730421,2729928,2730214,2730174,2730461,2729968,2730441,2730194,2730667,2729951,2730424,2729931,2730217,2730177,2730464,2729971,2730444,2730197,2730670,2729945,2730418,2729925,2730211,2730171,2730458,2729965,2730438,2730191,2730664,2729954,2730427,2729934,2730220,2730180,2730467,2729974,2730447,2730200,2730673,2729953,2730426,2729933,2730219,2730179,2730466,2729973,2730446,2730199,2730672,2729941,2730414,2729921,2730207,2730167,2730454,2729961,2730434,2730187,2730474,2729947,2730420,2729927,2730213,2730173,2730460,2729967,2730440,2730193,2730666,2729950,2730423,2729930,2730216,2730176,2730463,2729970,2730443,2730196,2730669,2729944,2730417,2729924,2730210,2730170,2730457,2729964,2730437,2730190,2730663,2735223,2735420,2735221,2735227,2735222,2735228,2735225,2735422,2735224,2735421,2735226,2735423,2727323,2727307,2726917,2727339,2726933,2727329,2727313,2726923,2727345,2726939,2727320,2727304,2726914,2727336,2726930,2727326,2727310,2726920,2727342,2726936,2727333,2727317,2726927,2727349,2726943,2727322,2727306,2726916,2727338,2726932,2727328,2727312,2726922,2727344,2726938,2727319,2727303,2726913,2727335,2726929,2727325,2727309,2726919,2727341,2726935,2727331,2727315,2726925,2727347,2726941,2727332,2727316,2726926,2727348,2726942,2727321,2727305,2726915,2727337,2726931,2727327,2727311,2726921,2727343,2726937,2727318,2727302,2726912,2727334,2726928,2727324,2727308,2726918,2727340,2726934,2727330,2727314,2726924,2727346,2726940,2727618,2727617,2727620,2727619,2727621,2734546,2734552,2734544,2734550,2734545,2734551,2734548,2734554,2734547,2734553,2734549,2734555,2727352,2727836,2727384,2727368,2727400,2727358,2727842,2727390,2727374,2727406,2727849,2727833,2727381,2727365,2727397,2727355,2727839,2727387,2727371,2727403,2727362,2727846,2727394,2727378,2727410,2727351,2727835,2727383,2727367,2727399,2727357,2727841,2727389,2727373,2727405,2727848,2727832,2727380,2727364,2727396,2727354,2727838,2727386,2727370,2727402,2727360,2727844,2727392,2727376,2727408,2727361,2727845,2727393,2727377,2727409,2727350,2727834,2727382,2727366,2727398,2727356,2727840,2727388,2727372,2727404,2727847,2727831,2727379,2727363,2727395,2727353,2727837,2727385,2727369,2727401,2727359,2727843,2727391,2727375,2727407,2734060,2734066,2734058,2734064,2734059,2734065,2734062,2734068,2734061,2734067,2734063,2734069,2734295,2734301,2734293,2734299,2734294,2734300,2734297,2734303,2734296,2734302,2734298,2734304,2727436,2727432,2727444,2727440,2727448,2727435,2727431,2727443,2727439,2727447,2727438,2727434,2727446,2727442,2727450,2727437,2727433,2727445,2727441,2727449,2734084,2734090,2734082,2734088,2734083,2734089,2734086,2734092,2734085,2734091,2734087,2734093,2734319,2734325,2734317,2734323,2734318,2734324,2734321,2734327,2734320,2734326,2734322,2734328,2727635,2727633,2727639,2727637,2727641,2731688,2732163,2731668,2731955,2731915,2732203,2731708,2732183,2731935,2732412,2731687,2732162,2731667,2731954,2731914,2732202,2731707,2732182,2731934,2732411,2731686,2732161,2731666,2731953,2731913,2732201,2731706,2732181,2731933,2732410,2735929,2735935,2735927,2735933,2735928,2735934,2735931,2735937,2735930,2735936,2735932,2735938,2727658,2727657,2727660,2727659,2727661,2729777,2730019,2729766,2730008,2729986,2730229,2729788,2730030,2729997,2730240,2729776,2730018,2729765,2730007,2729985,2730228,2729787,2730029,2729996,2730239,2729775,2730017,2729764,2730006,2729984,2730227,2729786,2730028,2729995,2730238,2735953,2735959,2735951,2735957,2735952,2735958,2735955,2735961,2735954,2735960,2735956,2735962,2734594,2734789,2734592,2734787,2734593,2734788,2734596,2734791,2734595,2734790,2734597,2734792,2734831,2734837,2734829,2734835,2734830,2734836,2734833,2734839,2734832,2734838,2734834,2734840,2730531,2730763,2730522,2730754,2730736,2730781,2730727,2730772,2730745,2730977,2730535,2730767,2730526,2730758,2730740,2730785,2730731,2730776,2730749,2730981,2730530,2730762,2730521,2730753,2730735,2730780,2730726,2730771,2730744,2730976,2730536,2730768,2730527,2730759,2730741,2730786,2730732,2730777,2730750,2730982,2730537,2730769,2730528,2730760,2730742,2730787,2730733,2730778,2730751,2730983,2730533,2730765,2730524,2730756,2730738,2730783,2730729,2730774,2730747,2730979,2730532,2730764,2730523,2730755,2730737,2730782,2730728,2730773,2730746,2730978,2730534,2730766,2730525,2730757,2730739,2730784,2730730,2730775,2730748,2730980,2730529,2730761,2730520,2730752,2730734,2730779,2730538,2730770,2730743,2730788,2736186,2736192,2736184,2736190,2736185,2736191,2736188,2736194,2736187,2736193,2736189,2736195,43015480,43015495,43015477,43015492,43015486,43015501,43015483,43015498,43015489,43015504,43015481,43015496,43015478,43015493,43015487,43015502,43015484,43015499,43015490,43015505,43015482,43015497,43015479,43015494,43015488,43015503,43015485,43015500,43015491,43015506,2736443,2736449,2736441,2736447,2736442,2736448,2736445,2736451,2736444,2736450,2736446,2736452,2734343,2734540,2734341,2734538,2734342,2734539,2734536,2734542,2734344,2734541,2734537,2734543,2727648,2727647,2727650,2727649,2727651,2732922,2733166,2732911,2732966,2732944,2733188,2732933,2733177,2732955,2733199,2732921,2733165,2732910,2732965,2732943,2733187,2732932,2733176,2732954,2733198,2732920,2733164,2732909,2732964,2732942,2733186,2732931,2733175,2732953,2733197,2734570,2734576,2734568,2734574,2734569,2734575,2734572,2734578,2734571,2734577,2734573,2734579,43015420,43015435,43015417,43015432,43015426,43015441,43015423,43015438,43015429,43015444,43015421,43015436,43015418,43015433,43015427,43015442,43015424,43015439,43015430,43015445,43015422,43015437,43015419,43015434,43015428,43015443,43015425,43015440,43015431,43015446,2731225,2731250,2731036,2731245,2731235,2731260,2731230,2731255,2731240,2731265,2731226,2731251,2731037,2731246,2731236,2731261,2731231,2731256,2731241,2731266,2731227,2731252,2731038,2731247,2731237,2731262,2731232,2731257,2731242,2731267,2731224,2731249,2731035,2731244,2731234,2731259,2731229,2731254,2731239,2731264,2731223,2731248,2731034,2731243,2731233,2731258,2731228,2731253,2731238,2731263,2727609,2727607,2727613,2727611,2727615,2727610,2727608,2727614,2727612,2727616,2736210,2736216,2736208,2736214,2736209,2736215,2736212,2736218,2736211,2736217,2736213,2736219,2727057,2727039,2727093,2727075,2727738,2727063,2727045,2727726,2727081,2727744,2727054,2727036,2727090,2727072,2727735,2727060,2727042,2727096,2727078,2727741,2727067,2727049,2727730,2727085,2727748,2727056,2727038,2727092,2727074,2727737,2727062,2727044,2727098,2727080,2727743,2727053,2727035,2727089,2727071,2727734,2727059,2727041,2727095,2727077,2727740,2727065,2727047,2727728,2727083,2727746,2727066,2727048,2727729,2727084,2727747,2727055,2727037,2727091,2727073,2727736,2727061,2727043,2727097,2727079,2727742,2727052,2727034,2727088,2727070,2727733,2727058,2727040,2727094,2727076,2727739,2727064,2727046,2727727,2727082,2727745,2727463,2727461,2727467,2727465,2727469,2727464,2727462,2727468,2727466,2727470,2734807,2734813,2734805,2734811,2734806,2734812,2734809,2734815,2734808,2734814,2734810,2734816,2727772,2727756,2727804,2727788,2727820,2727778,2727762,2727810,2727794,2727826,2727769,2727753,2727801,2727785,2727817,2727775,2727759,2727807,2727791,2727823,2727782,2727766,2727814,2727798,2727830,2727771,2727755,2727803,2727787,2727819,2727777,2727761,2727809,2727793,2727825,2727768,2727752,2727800,2727784,2727816,2727774,2727758,2727806,2727790,2727822,2727780,2727764,2727812,2727796,2727828,2727781,2727765,2727813,2727797,2727829,2727770,2727754,2727802,2727786,2727818,2727776,2727760,2727808,2727792,2727824,2727767,2727751,2727799,2727783,2727815,2727773,2727757,2727805,2727789,2727821,2727779,2727763,2727811,2727795,2727827,2734048,2734054,2734046,2734052,2734047,2734053,2734050,2734056,2734049,2734055,2734051,2734057,2734283,2734289,2734094,2734287,2734282,2734288,2734285,2734291,2734284,2734290,2734286,2734292,2727418,2727414,2727426,2727422,2727430,2727416,2727412,2727424,2727420,2727428,2727415,2727411,2727423,2727419,2727427,2727417,2727413,2727425,2727421,2727429,2734072,2734078,2734070,2734076,2734071,2734077,2734074,2734080,2734073,2734079,2734075,2734081,2734307,2734313,2734305,2734311,2734306,2734312,2734309,2734315,2734308,2734314,2734310,2734316,2727625,2727623,2727629,2727627,2727631,2730928,2731214,2730721,2731194,2730968,2731443,2730948,2731423,2731174,2731463,2730927,2731213,2730720,2731193,2730967,2731442,2730947,2731422,2731173,2731462,2730926,2731212,2730719,2731192,2730966,2731441,2730946,2731421,2731172,2731461,2735727,2735733,2735725,2735731,2735726,2735732,2735729,2735735,2735728,2735734,2735730,2735926,2727653,2727652,2727655,2727654,2727656,2733410,2733465,2733210,2733454,2733432,2729744,2733421,2729733,2733443,2729755,2733220,2733464,2733209,2733453,2733431,2729743,2733420,2729732,2733442,2729754,2733219,2733463,2733208,2733452,2733430,2729742,2733419,2729731,2733441,2729753,2735941,2735947,2735939,2735945,2735940,2735946,2735943,2735949,2735942,2735948,2735944,2735950,2734582,2734588,2734580,2734586,2734581,2734587,2734584,2734590,2734583,2734589,2734585,2734591,2734819,2734825,2734817,2734823,2734818,2734824,2734821,2734827,2734820,2734826,2734822,2734828,2730254,2730486,2730245,2730477,2730272,2730504,2730263,2730495,2730281,2730513,2730258,2730490,2730249,2730481,2730276,2730508,2730267,2730499,2730285,2730517,2730253,2730485,2730244,2730289,2730271,2730503,2730262,2730494,2730280,2730512,2730259,2730491,2730250,2730482,2730277,2730509,2730268,2730500,2730286,2730518,2730260,2730492,2730251,2730483,2730278,2730510,2730269,2730501,2730287,2730519,2730256,2730488,2730247,2730479,2730274,2730506,2730265,2730497,2730283,2730515,2730255,2730487,2730246,2730478,2730273,2730505,2730264,2730496,2730282,2730514,2730257,2730489,2730248,2730480,2730275,2730507,2730266,2730498,2730284,2730516,2730252,2730484,2730243,2730288,2730270,2730502,2730261,2730493,2730279,2730511,2736174,2736180,2735987,2736178,2736173,2736179,2736176,2736182,2736175,2736181,2736177,2736183,43015450,43015465,43015447,43015462,43015456,43015471,43015453,43015468,43015459,43015474,43015451,43015466,43015448,43015463,43015457,43015472,43015454,43015469,43015460,43015475,43015452,43015467,43015449,43015464,43015458,43015473,43015455,43015470,43015461,43015476,2736431,2736437,2736429,2736435,2736430,2736436,2736433,2736439,2736432,2736438,2736434,2736440,2734331,2734337,2734329,2734335,2734330,2734336,2734333,2734339,2734332,2734338,2734334,2734340,2735965,2735971,2735963,2735969,2735964,2735970,2735967,2735973,2735966,2735972,2735968,2735974,2727643,2727642,2727645,2727644,2727646,2732434,2732678,2732423,2732667,2732456,2732700,2732445,2732689,2732467,2732711,2732433,2732677,2732422,2732666,2732455,2732699,2732444,2732688,2732466,2732710,2732432,2732676,2732421,2732665,2732454,2732698,2732443,2732687,2732465,2732709,2734558,2734564,2734556,2734562,2734557,2734563,2734560,2734566,2734559,2734565,2734561,2734567,43015390,43015405,43015387,43015402,43015396,43015411,43015393,43015408,43015399,43015414,43015391,43015406,43015388,43015403,43015397,43015412,43015394,43015409,43015400,43015415,43015392,43015407,43015389,43015404,43015398,43015413,43015395,43015410,43015401,43015416,2730991,2731016,2730986,2731011,2731001,2731026,2730996,2731021,2731006,2731031,2730992,2731017,2730987,2731012,2731002,2731027,2730997,2731022,2731007,2731032,2730993,2731018,2730988,2731013,2731003,2731028,2730998,2731023,2731008,2731033,2730990,2731015,2730985,2731010,2731000,2731025,2730995,2731020,2731005,2731030,2730989,2731014,2730984,2731009,2730999,2731024,2730994,2731019,2731004,2731029,2727474,2727472,2727604,2727602,2727606,2727473,2727471,2727603,2727601,2727605,2736198,2736204,2736196,2736202,2736197,2736203,2736200,2736206,2736199,2736205,2736201,2736207,2726967,2726949,2727003,2726985,2727021,2726973,2726955,2727009,2726991,2727027,2726964,2726946,2727000,2726982,2727018,2726970,2726952,2727006,2726988,2727024,2726977,2726959,2727013,2726995,2727031,2726966,2726948,2727002,2726984,2727020,2726972,2726954,2727008,2726990,2727026,2726963,2726945,2726999,2726981,2727017,2726969,2726951,2727005,2726987,2727023,2726975,2726957,2727011,2726993,2727029,2726976,2726958,2727012,2726994,2727030,2726965,2726947,2727001,2726983,2727019,2726971,2726953,2727007,2726989,2727025,2726962,2726944,2726998,2726980,2727016,2726968,2726950,2727004,2726986,2727022,2726974,2726956,2727010,2726992,2727028,2727454,2727452,2727458,2727456,2727460,2727453,2727451,2727457,2727455,2727459,2734795,2734801,2734793,2734799,2734794,2734800,2734797,2734803,2734796,2734802,2734798,2734804,2002191)

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
JOIN #Codesets cs on (po.procedure_concept_id = cs.concept_id and cs.codeset_id = 85)
) C


-- End Procedure Occurrence Criteria

UNION ALL
-- Begin Procedure Occurrence Criteria
select C.person_id, C.procedure_occurrence_id as event_id, C.start_date, C.end_date,
       C.visit_occurrence_id, C.start_date as sort_date
from 
(
  select po.person_id,po.procedure_occurrence_id,po.procedure_concept_id,po.visit_occurrence_id,po.quantity,po.procedure_date as start_date, DATEADD(day,1,po.procedure_date) as end_date 
  FROM @cdm_database_schema.PROCEDURE_OCCURRENCE po
JOIN #Codesets cns on (po.procedure_source_concept_id = cns.concept_id and cns.codeset_id = 85)
) C


-- End Procedure Occurrence Criteria

  ) E
	JOIN @cdm_database_schema.observation_period OP on E.person_id = OP.person_id and E.start_date >=  OP.observation_period_start_date and E.start_date <= op.observation_period_end_date
  WHERE DATEADD(day,0,OP.OBSERVATION_PERIOD_START_DATE) <= E.START_DATE AND DATEADD(day,0,E.START_DATE) <= OP.OBSERVATION_PERIOD_END_DATE
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
    -- Begin Demographic Criteria
SELECT 0 as index_id, e.person_id, e.event_id
FROM #qualified_events E
JOIN @cdm_database_schema.PERSON P ON P.PERSON_ID = E.PERSON_ID
WHERE YEAR(E.start_date) - P.year_of_birth >= 18
GROUP BY e.person_id, e.event_id
-- End Demographic Criteria

  ) CQ on E.person_id = CQ.person_id and E.event_id = CQ.event_id
  GROUP BY E.person_id, E.event_id
  HAVING COUNT(index_id) = 1
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
select 0 as index_id, cc.person_id, cc.event_id
from (SELECT p.person_id, p.event_id 
FROM #qualified_events P
JOIN (
  select PE.person_id, PE.event_id, PE.start_date, PE.end_date, PE.visit_occurrence_id, PE.sort_date FROM (
-- Begin Visit Occurrence Criteria
select C.person_id, C.visit_occurrence_id as event_id, C.start_date, C.end_date,
       C.visit_occurrence_id, C.start_date as sort_date
from 
(
  select vo.person_id,vo.visit_occurrence_id,vo.visit_concept_id,vo.visit_start_date as start_date, vo.visit_end_date as end_date 
  FROM @cdm_database_schema.VISIT_OCCURRENCE vo
JOIN #Codesets cs on (vo.visit_concept_id = cs.concept_id and cs.codeset_id = 0)
) C


-- End Visit Occurrence Criteria

) PE
JOIN (
-- Begin Criteria Group
select 0 as index_id, person_id, event_id
FROM
(
  select E.person_id, E.event_id 
  FROM (SELECT Q.person_id, Q.event_id, Q.start_date, Q.end_date, Q.visit_occurrence_id, OP.observation_period_start_date as op_start_date, OP.observation_period_end_date as op_end_date
FROM (-- Begin Visit Occurrence Criteria
select C.person_id, C.visit_occurrence_id as event_id, C.start_date, C.end_date,
       C.visit_occurrence_id, C.start_date as sort_date
from 
(
  select vo.person_id,vo.visit_occurrence_id,vo.visit_concept_id,vo.visit_start_date as start_date, vo.visit_end_date as end_date 
  FROM @cdm_database_schema.VISIT_OCCURRENCE vo
JOIN #Codesets cs on (vo.visit_concept_id = cs.concept_id and cs.codeset_id = 0)
) C


-- End Visit Occurrence Criteria
) Q
JOIN @cdm_database_schema.OBSERVATION_PERIOD OP on Q.person_id = OP.person_id 
  and OP.observation_period_start_date <= Q.start_date and OP.observation_period_end_date >= Q.start_date
) E
  INNER JOIN
  (
    -- Begin Correlated Criteria
select 0 as index_id, p.person_id, p.event_id
from (SELECT Q.person_id, Q.event_id, Q.start_date, Q.end_date, Q.visit_occurrence_id, OP.observation_period_start_date as op_start_date, OP.observation_period_end_date as op_end_date
FROM (-- Begin Visit Occurrence Criteria
select C.person_id, C.visit_occurrence_id as event_id, C.start_date, C.end_date,
       C.visit_occurrence_id, C.start_date as sort_date
from 
(
  select vo.person_id,vo.visit_occurrence_id,vo.visit_concept_id,vo.visit_start_date as start_date, vo.visit_end_date as end_date 
  FROM @cdm_database_schema.VISIT_OCCURRENCE vo
JOIN #Codesets cs on (vo.visit_concept_id = cs.concept_id and cs.codeset_id = 0)
) C


-- End Visit Occurrence Criteria
) Q
JOIN @cdm_database_schema.OBSERVATION_PERIOD OP on Q.person_id = OP.person_id 
  and OP.observation_period_start_date <= Q.start_date and OP.observation_period_end_date >= Q.start_date
) p
LEFT JOIN (
SELECT p.person_id, p.event_id 
FROM (SELECT Q.person_id, Q.event_id, Q.start_date, Q.end_date, Q.visit_occurrence_id, OP.observation_period_start_date as op_start_date, OP.observation_period_end_date as op_end_date
FROM (-- Begin Visit Occurrence Criteria
select C.person_id, C.visit_occurrence_id as event_id, C.start_date, C.end_date,
       C.visit_occurrence_id, C.start_date as sort_date
from 
(
  select vo.person_id,vo.visit_occurrence_id,vo.visit_concept_id,vo.visit_start_date as start_date, vo.visit_end_date as end_date 
  FROM @cdm_database_schema.VISIT_OCCURRENCE vo
JOIN #Codesets cs on (vo.visit_concept_id = cs.concept_id and cs.codeset_id = 0)
) C


-- End Visit Occurrence Criteria
) Q
JOIN @cdm_database_schema.OBSERVATION_PERIOD OP on Q.person_id = OP.person_id 
  and OP.observation_period_start_date <= Q.start_date and OP.observation_period_end_date >= Q.start_date
) P
JOIN (
  -- Begin Visit Occurrence Criteria
select C.person_id, C.visit_occurrence_id as event_id, C.start_date, C.end_date,
       C.visit_occurrence_id, C.start_date as sort_date
from 
(
  select vo.person_id,vo.visit_occurrence_id,vo.visit_concept_id,vo.visit_start_date as start_date, vo.visit_end_date as end_date 
  FROM @cdm_database_schema.VISIT_OCCURRENCE vo
JOIN #Codesets cs on (vo.visit_concept_id = cs.concept_id and cs.codeset_id = 43)
) C


-- End Visit Occurrence Criteria

) A on A.person_id = P.person_id  AND A.START_DATE >= P.OP_START_DATE AND A.START_DATE <= P.OP_END_DATE AND A.START_DATE >= DATEADD(day,-2,P.START_DATE) AND A.START_DATE <= DATEADD(day,0,P.START_DATE) ) cc on p.person_id = cc.person_id and p.event_id = cc.event_id
GROUP BY p.person_id, p.event_id
HAVING COUNT(cc.event_id) = 0
-- End Correlated Criteria

  ) CQ on E.person_id = CQ.person_id and E.event_id = CQ.event_id
  GROUP BY E.person_id, E.event_id
  HAVING COUNT(index_id) = 1
) G
-- End Criteria Group
) AC on AC.person_id = pe.person_id and AC.event_id = pe.event_id

) A on A.person_id = P.person_id  AND A.START_DATE >= P.OP_START_DATE AND A.START_DATE <= P.OP_END_DATE AND A.START_DATE >= DATEADD(day,-1,P.START_DATE) AND A.START_DATE <= DATEADD(day,0,P.START_DATE) AND A.END_DATE >= DATEADD(day,1,P.START_DATE) AND A.END_DATE <= P.OP_END_DATE ) cc 
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
  SELECT co.person_id,co.condition_occurrence_id,co.condition_concept_id,co.visit_occurrence_id,co.condition_start_date as start_date, COALESCE(co.condition_end_date, DATEADD(day,1,co.condition_start_date)) as end_date 
  FROM @cdm_database_schema.CONDITION_OCCURRENCE co
  JOIN #Codesets cs on (co.condition_concept_id = cs.concept_id and cs.codeset_id = 81)
) C


-- End Condition Occurrence Criteria

) A on A.person_id = P.person_id  AND A.START_DATE >= P.OP_START_DATE AND A.START_DATE <= P.OP_END_DATE AND A.START_DATE >= DATEADD(day,0,P.START_DATE) AND A.START_DATE <= DATEADD(day,14,P.START_DATE) ) cc 
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

select 3 as inclusion_rule_id, person_id, event_id
INTO #Inclusion_3
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
SELECT C.person_id, C.condition_occurrence_id as event_id, C.start_date, C.end_date,
  C.visit_occurrence_id, C.start_date as sort_date
FROM 
(
  SELECT co.person_id,co.condition_occurrence_id,co.condition_concept_id,co.visit_occurrence_id,co.condition_start_date as start_date, COALESCE(co.condition_end_date, DATEADD(day,1,co.condition_start_date)) as end_date 
  FROM @cdm_database_schema.CONDITION_OCCURRENCE co
  JOIN #Codesets cs on (co.condition_concept_id = cs.concept_id and cs.codeset_id = 81)
) C


-- End Condition Occurrence Criteria

) A on A.person_id = P.person_id  AND A.START_DATE >= P.OP_START_DATE AND A.START_DATE <= P.OP_END_DATE AND A.START_DATE >= P.OP_START_DATE AND A.START_DATE <= DATEADD(day,-1,P.START_DATE) ) cc on p.person_id = cc.person_id and p.event_id = cc.event_id
GROUP BY p.person_id, p.event_id
HAVING COUNT(cc.event_id) = 0
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
FROM (select inclusion_rule_id, person_id, event_id from #Inclusion_0
UNION ALL
select inclusion_rule_id, person_id, event_id from #Inclusion_1
UNION ALL
select inclusion_rule_id, person_id, event_id from #Inclusion_2
UNION ALL
select inclusion_rule_id, person_id, event_id from #Inclusion_3) I;
TRUNCATE TABLE #Inclusion_0;
DROP TABLE #Inclusion_0;

TRUNCATE TABLE #Inclusion_1;
DROP TABLE #Inclusion_1;

TRUNCATE TABLE #Inclusion_2;
DROP TABLE #Inclusion_2;

TRUNCATE TABLE #Inclusion_3;
DROP TABLE #Inclusion_3;


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
{4 != 0}?{
  -- the matching group with all bits set ( POWER(2,# of inclusion rules) - 1 = inclusion_rule_mask
  WHERE (MG.inclusion_rule_mask = POWER(cast(2 as bigint),4)-1)
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
{1 != 0 & 4 != 0}?{

-- Create a temp table of inclusion rule rows for joining in the inclusion rule impact analysis

select cast(rule_sequence as int) as rule_sequence
into #inclusion_rules
from (
  SELECT CAST(0 as int) as rule_sequence UNION ALL SELECT CAST(1 as int) as rule_sequence UNION ALL SELECT CAST(2 as int) as rule_sequence UNION ALL SELECT CAST(3 as int) as rule_sequence
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
