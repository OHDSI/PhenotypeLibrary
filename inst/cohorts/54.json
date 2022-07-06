{
	"cdmVersionRange" : ">=5.0.0",
	"PrimaryCriteria" : {
		"CriteriaList" : [
			{
				"ConditionOccurrence" : {
					"CodesetId" : 4,
					"ConditionTypeExclude" : false
				}
			}
		],
		"ObservationWindow" : {
			"PriorDays" : 0,
			"PostDays" : 0
		},
		"PrimaryCriteriaLimit" : {
			"Type" : "All"
		}
	},
	"ConceptSets" : [
		{
			"id" : 4,
			"name" : "Febrile seizure and unspecified seizure ",
			"expression" : {
				"items" : [
					{
						"concept" : {
							"CONCEPT_ID" : 444413,
							"CONCEPT_NAME" : "Febrile convulsion",
							"STANDARD_CONCEPT" : "S",
							"STANDARD_CONCEPT_CAPTION" : "Standard",
							"INVALID_REASON" : "V",
							"INVALID_REASON_CAPTION" : "Valid",
							"CONCEPT_CODE" : "41497008",
							"DOMAIN_ID" : "Condition",
							"VOCABULARY_ID" : "SNOMED",
							"CONCEPT_CLASS_ID" : "Clinical Finding"
						},
						"isExcluded" : false,
						"includeDescendants" : true,
						"includeMapped" : false
					},
					{
						"concept" : {
							"CONCEPT_ID" : 377091,
							"CONCEPT_NAME" : "Seizure",
							"STANDARD_CONCEPT" : "S",
							"STANDARD_CONCEPT_CAPTION" : "Standard",
							"INVALID_REASON" : "V",
							"INVALID_REASON_CAPTION" : "Valid",
							"CONCEPT_CODE" : "91175000",
							"DOMAIN_ID" : "Condition",
							"VOCABULARY_ID" : "SNOMED",
							"CONCEPT_CLASS_ID" : "Clinical Finding"
						},
						"isExcluded" : false,
						"includeDescendants" : false,
						"includeMapped" : false
					}
				]
			}
		},
		{
			"id" : 6,
			"name" : "Febrile seizure",
			"expression" : {
				"items" : [
					{
						"concept" : {
							"CONCEPT_ID" : 444413,
							"CONCEPT_NAME" : "Febrile convulsion",
							"STANDARD_CONCEPT" : "S",
							"STANDARD_CONCEPT_CAPTION" : "Standard",
							"INVALID_REASON" : "V",
							"INVALID_REASON_CAPTION" : "Valid",
							"CONCEPT_CODE" : "41497008",
							"DOMAIN_ID" : "Condition",
							"VOCABULARY_ID" : "SNOMED",
							"CONCEPT_CLASS_ID" : "Clinical Finding"
						},
						"isExcluded" : false,
						"includeDescendants" : true,
						"includeMapped" : false
					}
				]
			}
		}
	],
	"QualifiedLimit" : {
		"Type" : "First"
	},
	"ExpressionLimit" : {
		"Type" : "All"
	},
	"InclusionRules" : [
		{
			"name" : "Has febrile seizure diagnosis ",
			"expression" : {
				"Type" : "ALL",
				"CriteriaList" : [
					{
						"Criteria" : {
							"ConditionOccurrence" : {
								"CodesetId" : 6,
								"ConditionTypeExclude" : false
							}
						},
						"StartWindow" : {
							"Start" : {
								"Days" : 0,
								"Coeff" : -1
							},
							"End" : {
								"Days" : 42,
								"Coeff" : 1
							},
							"UseIndexEnd" : false,
							"UseEventEnd" : false
						},
						"RestrictVisit" : false,
						"IgnoreObservationPeriod" : false,
						"Occurrence" : {
							"Type" : 2,
							"Count" : 1,
							"IsDistinct" : false
						}
					}
				],
				"DemographicCriteriaList" : [],
				"Groups" : []
			}
		},
		{
			"name" : "has no events in prior 'clean window' - 42 days",
			"expression" : {
				"Type" : "ALL",
				"CriteriaList" : [
					{
						"Criteria" : {
							"ConditionOccurrence" : {
								"CorrelatedCriteria" : {
									"Type" : "ALL",
									"CriteriaList" : [
										{
											"Criteria" : {
												"ConditionOccurrence" : {
													"CodesetId" : 6,
													"ConditionTypeExclude" : false
												}
											},
											"StartWindow" : {
												"Start" : {
													"Days" : 0,
													"Coeff" : 1
												},
												"End" : {
													"Days" : 42,
													"Coeff" : 1
												},
												"UseIndexEnd" : false,
												"UseEventEnd" : false
											},
											"RestrictVisit" : false,
											"IgnoreObservationPeriod" : false,
											"Occurrence" : {
												"Type" : 2,
												"Count" : 1,
												"IsDistinct" : false
											}
										}
									],
									"DemographicCriteriaList" : [],
									"Groups" : []
								},
								"CodesetId" : 4,
								"ConditionTypeExclude" : false
							}
						},
						"StartWindow" : {
							"Start" : {
								"Days" : 42,
								"Coeff" : -1
							},
							"End" : {
								"Days" : 1,
								"Coeff" : -1
							},
							"UseIndexEnd" : false,
							"UseEventEnd" : false
						},
						"RestrictVisit" : false,
						"IgnoreObservationPeriod" : true,
						"Occurrence" : {
							"Type" : 0,
							"Count" : 0,
							"IsDistinct" : false
						}
					}
				],
				"DemographicCriteriaList" : [],
				"Groups" : []
			}
		}
	],
	"EndStrategy" : {
		"DateOffset" : {
			"DateField" : "StartDate",
			"Offset" : 1
		}
	},
	"CensoringCriteria" : [],
	"CollapseSettings" : {
		"CollapseType" : "ERA",
		"EraPad" : 0
	},
	"CensorWindow" : {}
}