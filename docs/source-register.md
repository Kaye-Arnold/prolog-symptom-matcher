# Source Evidence Register

This register connects every condition/symptom fact in
[`src/knowledge_base.pl`](../src/knowledge_base.pl) to a specific source page and
phrase. Pages were fetched and checked on **9 November 2026**. The short
quotations below support only the encoded term associations and qualifications;
they do not establish a diagnostic rule or a complete symptom profile.

## 1. WHO: Malaria

- **Page:** [Malaria - fact sheet](https://www.who.int/news-room/fact-sheets/detail/malaria)
- **Organisation:** World Health Organization
- **Page date shown:** 4 December 2025
- **Source ID:** `who_malaria`
- **Encoded profile size:** 10 canonical terms

Checked phrases:

> "The most common early symptoms of malaria are fever, headache and chills."

> "Severe symptoms include: extreme tiredness and fatigue; impaired
> consciousness; multiple convulsions; difficulty breathing; dark or bloody
> urine; jaundice (yellowing of the eyes and skin); abnormal bleeding."

| Canonical term | Stored qualification | Source phrase / mapping |
|---|---|---|
| `fever` | `plain` | "fever, headache and chills" |
| `chills` | `plain` | "fever, headache and chills" |
| `headache` | `plain` | "fever, headache and chills" |
| `fatigue` | `extreme` | "extreme tiredness and fatigue" |
| `confusion` | `impaired` | "impaired consciousness"; a vocabulary mapping |
| `seizures` | `multiple` | "multiple convulsions"; a vocabulary mapping |
| `breathing_difficulty` | `severe` | "difficulty breathing" in the severe-symptoms section |
| `dark_urine` | `severe` | "dark or bloody urine"; canonical term is a simplification |
| `jaundice` | `severe` | "jaundice (yellowing of the eyes and skin)" |
| `abnormal_bleeding` | `severe` | "abnormal bleeding" |

`severe` records the heading/context of the source list. The program does not
calculate severity or use these terms for triage, advice, or a separate warning.

## 2. WHO: Influenza (seasonal)

- **Page:** [Influenza (seasonal)](https://www.who.int/news-room/fact-sheets/detail/influenza-(seasonal))
- **Organisation:** World Health Organization
- **Page date shown:** 28 February 2025
- **Source ID:** `who_influenza`
- **Encoded profile size:** 7 canonical terms

Checked phrases:

> "Symptoms include: sudden onset of fever; cough (usually dry); headache;
> muscle and joint pain; severe malaise (feeling unwell); sore throat; runny
> nose."

The overview also says: "Symptoms of influenza include acute onset of fever,
cough, sore throat, body aches and fatigue."

| Canonical term | Stored qualification | Source phrase / mapping |
|---|---|---|
| `fever` | `sudden_onset` | "sudden onset of fever" |
| `cough` | `usually_dry` | "cough (usually dry)"; one fact only |
| `headache` | `plain` | "headache" |
| `body_aches` | `plain` | "muscle and joint pain"; canonical simplification |
| `fatigue` | `severe` | Overview says "fatigue"; detailed list says "severe malaise (feeling unwell)" |
| `sore_throat` | `plain` | "sore throat" |
| `runny_nose` | `plain` | "runny nose" |

`dry_cough` normalises to the same canonical `cough` used by the fact. It is not
stored as a second symptom and cannot increase the denominator or overlap count.
The `fatigue` mapping is an educational vocabulary simplification of the WHO
page's overview/detailed wording; it is not a claim that the terms are clinically
interchangeable in every context.

## 3. WHO: Measles

- **Page:** [Measles](https://www.who.int/news-room/fact-sheets/detail/measles)
- **Organisation:** World Health Organization
- **Page date shown:** 15 July 2026
- **Source ID:** `who_measles`
- **Encoded profile size:** 6 canonical terms

Checked phrases:

> "Symptoms include a high fever, cough, runny nose and a rash all over the
> body."

> "Early symptoms ... include: fever; running nose; cough; red and watery eyes;
> small white spots inside the cheeks."

> "A prominent rash is the most visible symptom."

| Canonical term | Stored qualification | Source phrase / mapping |
|---|---|---|
| `fever` | `high` | "a high fever" |
| `runny_nose` | `plain` | "running nose" / "runny nose" |
| `cough` | `plain` | "cough" |
| `red_watery_eyes` | `plain` | "red and watery eyes" |
| `white_spots_mouth` | `small_white` | "small white spots inside the cheeks" |
| `rash` | `prominent` | "A prominent rash" |

## 4. CDC: About Common Cold

- **Page:** [About Common Cold](https://www.cdc.gov/common-cold/about/index.html)
- **Organisation:** Centers for Disease Control and Prevention (United States)
- **Page date shown:** Updated and reviewed 19 February 2026
- **Source ID:** `cdc_cold`
- **Encoded profile size:** 8 canonical terms

Checked list:

> "Runny nose; Nasal congestion; Cough; Sneezing; Sore throat; Headache; Mild
> body aches; Fever (usually low grade in older children and adults)."

| Canonical term | Stored qualification | Source phrase / mapping |
|---|---|---|
| `runny_nose` | `plain` | "Runny nose" |
| `nasal_congestion` | `plain` | "Nasal congestion" |
| `cough` | `plain` | "Cough" |
| `sneezing` | `plain` | "Sneezing" |
| `sore_throat` | `plain` | "Sore throat" |
| `headache` | `plain` | "Headache" |
| `body_aches` | `mild` | "Mild body aches" |
| `fever` | `usually_low_grade` | The page qualifies this for older children and adults; age is not an input. |

## 5. What these pages do not support

- None of these pages supplies the program's exact fraction-ranking rule.
- No page supports inferring disease presence or absence from the fraction.
- No prevalence, probability, sensitivity, specificity, clinical threshold, or
  clinical validation is used or claimed.
- The association lists are deliberately incomplete. A missing term is only
  absent from this application list; it is not evidence of clinical absence.
- Source qualifiers are stored but not interpreted against user-entered degree,
  age, onset, duration, or history.
- The four-condition scope and the mapping of source vocabulary to canonical
  atoms are educational design choices, not a lecturer-approved medical model.

The machine-readable source metadata is in `source/5` facts, and every
`condition_symptom/4` fact carries a source ID. Regression tests check these
links and the required qualifications. No treatment or emergency instructions
from the source pages are reproduced by the application.
