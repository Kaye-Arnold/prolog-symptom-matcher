/*
   Symptom Matcher knowledge base.

   This is a bounded educational list of source-linked condition/symptom
   associations. The facts are not a complete clinical profile and are not
   diagnostic rules. Qualifications reproduce the source wording where kept;
   the reasoning layer does not interpret severity, onset, or degree.
*/

:- module(symptom_kb,
          [ symptom/1,
            symptom_alias/2,
            condition/1,
            condition_name/2,
            condition_symptom/4,
            source/5,
            source_date/2,
            source_url/2,
            disclaimer/1
          ]).

/* Canonical terms used by the matching rules. */
symptom(fever).
symptom(chills).
symptom(headache).
symptom(fatigue).
symptom(confusion).
symptom(seizures).
symptom(breathing_difficulty).
symptom(dark_urine).
symptom(jaundice).
symptom(abnormal_bleeding).
symptom(cough).
symptom(sore_throat).
symptom(runny_nose).
symptom(nasal_congestion).
symptom(sneezing).
symptom(body_aches).
symptom(rash).
symptom(red_watery_eyes).
symptom(white_spots_mouth).

/* A dry cough is an alias for cough, not a second feature. */
symptom_alias(high_temperature, fever).
symptom_alias(temperature, fever).
symptom_alias(feverish, fever).
symptom_alias(shivering, chills).
symptom_alias(shivers, chills).
symptom_alias(head_pain, headache).
symptom_alias(tired, fatigue).
symptom_alias(tiredness, fatigue).
symptom_alias(exhaustion, fatigue).
symptom_alias(weakness, fatigue).
symptom_alias(disorientation, confusion).
symptom_alias(fits, seizures).
symptom_alias(convulsions, seizures).
symptom_alias(shortness_of_breath, breathing_difficulty).
symptom_alias(difficulty_breathing, breathing_difficulty).
symptom_alias(breathlessness, breathing_difficulty).
symptom_alias(blood_in_urine, dark_urine).
symptom_alias(yellow_eyes, jaundice).
symptom_alias(yellow_skin, jaundice).
symptom_alias(bleeding, abnormal_bleeding).
symptom_alias(dry_cough, cough).
symptom_alias(coughing, cough).
symptom_alias(throat_pain, sore_throat).
symptom_alias(painful_throat, sore_throat).
symptom_alias(running_nose, runny_nose).
symptom_alias(blocked_nose, nasal_congestion).
symptom_alias(stuffy_nose, nasal_congestion).
symptom_alias(sneezes, sneezing).
symptom_alias(muscle_pain, body_aches).
symptom_alias(muscle_aches, body_aches).
symptom_alias(joint_pain, body_aches).
symptom_alias(aches, body_aches).
symptom_alias(skin_rash, rash).
symptom_alias(spots, rash).
symptom_alias(red_eyes, red_watery_eyes).
symptom_alias(watery_eyes, red_watery_eyes).
symptom_alias(white_spots, white_spots_mouth).
symptom_alias(white_spots_inside_cheeks, white_spots_mouth).

condition(malaria).
condition(influenza).
condition(measles).
condition(common_cold).

condition_name(malaria, 'Malaria').
condition_name(influenza, 'Seasonal influenza').
condition_name(measles, 'Measles').
condition_name(common_cold, 'Common cold').

/*
   condition_symptom(Condition, CanonicalSymptom, Qualification, SourceId).
   `plain` means that the source list does not qualify that individual term.
   The malaria facts marked `severe` occur in a source section titled
   "Severe symptoms include". Source IDs are defined by source/5 below.
*/

/* WHO malaria fact sheet: early and severe symptoms. */
condition_symptom(malaria, fever, plain, who_malaria).
condition_symptom(malaria, chills, plain, who_malaria).
condition_symptom(malaria, headache, plain, who_malaria).
condition_symptom(malaria, fatigue, extreme, who_malaria).
condition_symptom(malaria, confusion, impaired, who_malaria).
condition_symptom(malaria, seizures, multiple, who_malaria).
condition_symptom(malaria, breathing_difficulty, severe, who_malaria).
condition_symptom(malaria, dark_urine, severe, who_malaria).
condition_symptom(malaria, jaundice, severe, who_malaria).
condition_symptom(malaria, abnormal_bleeding, severe, who_malaria).

/* WHO seasonal influenza fact sheet: seven canonical features. */
condition_symptom(influenza, fever, sudden_onset, who_influenza).
condition_symptom(influenza, cough, usually_dry, who_influenza).
condition_symptom(influenza, headache, plain, who_influenza).
condition_symptom(influenza, body_aches, plain, who_influenza).
condition_symptom(influenza, fatigue, severe, who_influenza).
condition_symptom(influenza, sore_throat, plain, who_influenza).
condition_symptom(influenza, runny_nose, plain, who_influenza).

/* WHO measles fact sheet. */
condition_symptom(measles, fever, high, who_measles).
condition_symptom(measles, runny_nose, plain, who_measles).
condition_symptom(measles, cough, plain, who_measles).
condition_symptom(measles, red_watery_eyes, plain, who_measles).
condition_symptom(measles, white_spots_mouth, small_white, who_measles).
condition_symptom(measles, rash, prominent, who_measles).

/* CDC About Common Cold page. */
condition_symptom(common_cold, runny_nose, plain, cdc_cold).
condition_symptom(common_cold, nasal_congestion, plain, cdc_cold).
condition_symptom(common_cold, cough, plain, cdc_cold).
condition_symptom(common_cold, sneezing, plain, cdc_cold).
condition_symptom(common_cold, sore_throat, plain, cdc_cold).
condition_symptom(common_cold, headache, plain, cdc_cold).
condition_symptom(common_cold, body_aches, mild, cdc_cold).
condition_symptom(common_cold, fever, usually_low_grade, cdc_cold).

/* Page title, organisation, canonical URL, and displayed page date. */
source(who_malaria, 'WHO', 'Malaria - fact sheet',
       'https://www.who.int/news-room/fact-sheets/detail/malaria',
       '2025-12-04').
source(who_influenza, 'WHO', 'Influenza (seasonal) - fact sheet',
       'https://www.who.int/news-room/fact-sheets/detail/influenza-(seasonal)',
       '2025-02-28').
source(who_measles, 'WHO', 'Measles - fact sheet',
       'https://www.who.int/news-room/fact-sheets/detail/measles',
       '2026-07-15').
source(cdc_cold, 'CDC', 'About Common Cold',
       'https://www.cdc.gov/common-cold/about/index.html',
       '2026-02-19').

source_date(Id, Date) :- source(Id, _, _, _, Date).
source_url(Id, Url) :- source(Id, _, _, Url, _).

disclaimer('Educational comparison only: this program compares typed terms with a limited source-linked list. It cannot determine whether a condition is present or absent, and it does not provide diagnoses, probabilities, treatment, urgency or emergency guidance.').
