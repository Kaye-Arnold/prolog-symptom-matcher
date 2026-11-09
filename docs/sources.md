# Source Register

**Status:** Four exact public-health pages were retrieved and checked on 9 November
2026. The facts used by the application are listed with their source IDs in
[`source-register.md`](source-register.md) and as `source/5` plus
`condition_symptom/4` facts in `src/knowledge_base.pl`.

| Source ID | Exact page title / organization | URL | Page date shown | Accessed | Supports |
|---|---|---|---|---|---|
| `who_malaria` | Malaria / World Health Organization | <https://www.who.int/news-room/fact-sheets/detail/malaria> | 4 December 2025 | 9 November 2026 | Early fever, chills, headache; listed severe symptoms and their source wording. |
| `who_influenza` | Influenza (seasonal) / World Health Organization | <https://www.who.int/news-room/fact-sheets/detail/influenza-(seasonal)> | 28 February 2025 | 9 November 2026 | Sudden-onset fever, cough (usually dry), headache, muscle/joint pain, severe malaise, sore throat, runny nose. |
| `who_measles` | Measles / World Health Organization | <https://www.who.int/news-room/fact-sheets/detail/measles> | 15 July 2026 | 9 November 2026 | High fever, cough, runny nose, red/watery eyes, small white spots inside cheeks, prominent rash. |
| `cdc_cold` | About Common Cold / Centers for Disease Control and Prevention | <https://www.cdc.gov/common-cold/about/index.html> | Updated and reviewed 19 February 2026 | 9 November 2026 | Runny nose, congestion, cough, sneezing, sore throat, headache, mild body aches, fever usually low grade in older children and adults. |

## Evidence and limits

- See [`source-register.md`](source-register.md) for short quoted phrases and
  per-feature mappings. The report keeps the limits and simplifications explicit.
- These pages describe symptoms; they do not support the application's ranking
  rule or any inference about an individual. No prevalence data, clinical
  threshold, diagnosis rule, probability, treatment, or urgency logic is encoded.
- The four-condition vocabulary is a bounded educational design choice. It is
  not exhaustive, and its formal scope approval remains pending.
- `dry_cough` is a vocabulary alias for canonical `cough`, not a second influenza
  fact. The influenza fact stores `usually_dry` once, as supported by WHO.
- `usually_low_grade` is retained as a source qualifier that applies to older
  children and adults on the CDC page. Age is not an input to the program.
- A source-backed relationship is represented as a limited association, not as
  a necessary or sufficient condition.

Do not add a new condition/symptom fact until its exact source page, page date,
access date, supporting phrase, mapping, and simplification (if any) are recorded
here and in the detailed register.
