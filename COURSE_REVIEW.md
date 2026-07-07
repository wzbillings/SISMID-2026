# Course Review

## Executive Summary

This repository has the core of a strong, practical SISMID module: it emphasizes reproducible R work, uses a small set of epidemiology-flavored datasets repeatedly, and has a sensible programming arc from Quarto to loops, functions, functional programming, formulas, bootstrapping, and simulation.

The main risk before teaching is not lack of material. The risk is overload, uneven polish, and disconnected source organization. The schedule currently asks learners to cover too many conceptual moves in too little time, especially on days 1 and 2. Several files are clearly student-facing, while others look like instructor scratch files, copied material from other courses, generated site output, or advanced optional modules that have not been fully integrated.

Critical fixes before teaching are: verify the Quarto site renders cleanly; fix missing or case-sensitive image paths; repair executable code bugs in `modules/power-sim.qmd`, `modules/Module06-S3-lm-formulas.qmd`, and exercise files; decide what is actually in scope for the 2.5-day course; remove or mark obsolete/disconnected files; and give learners more structured practice checkpoints before the capstone-style Exercise 2.

## Repository Map

- `_quarto.yml`: Defines the Quarto website, sidebar, render targets, and global HTML/revealjs settings. It excludes `day1/`, `day2/`, and `GIS/` from rendering.
- `README.qmd` and `README.md`: Repository/course overview, prerequisites, module content, file structure, license, and acknowledgements. `README.md` is generated from `README.qmd`.
- `index.qmd`: Website welcome page with prerequisites and instructor bios.
- `schedule.qmd`: Three-day course schedule, currently broad and partly tentative.
- `references.qmd` and `SISMID-Module.bib`: Course resource page and main bibliography.
- `modules/Module00-Welcome.qmd`: Welcome slides, course framing, resources, setup check.
- `modules/Module01-Quarto.qmd`: Introductory Quarto slide deck.
- `modules/Module02-StatReview.qmd`: Inferential statistics and modeling review using QCRC and a remote neonatal hypothermia dataset.
- `modules/Module03-Iteration.qmd`: Iteration, loops, vectorization, and measles examples.
- `modules/Module04-Functions.qmd`: Function syntax, arguments, debugging, and refactoring loops into functions.
- `modules/Module05-FunctionalProgramming.qmd`: Base R `*apply()` workflow, anonymous functions, `split`, and repeated modeling.
- `modules/Module06-S3-lm-formulas.qmd`: S3 concepts, formulas, model methods, and a QCRC logistic regression exercise.
- `modules/bootstrapping.qmd`: Bootstrap concepts, hand-written bootstrap, `boot`, and confidence intervals.
- `modules/Arrow.qmd`: Short Arrow/parquet deck using a very large Seattle library checkout dataset.
- `modules/sample-size.qmd`: Long `pwrss` package demonstration for many power/sample-size designs.
- `modules/power-sim.qmd`: Power analysis and power simulation deck.
- `modules/ODEs-optim.qmd`: Advanced functional programming applications with `optim()`, likelihood examples, `deSolve`, SIR/SIRS models, and ODE parameter fitting.
- `modules/linear-models.qmd`: Advanced GLM case study outline, currently incomplete.
- `modules/Walkthrough2.qmd`: Very short data science walkthrough pointing to a Quarto/R paper repository.
- `modules/quarto/markdown.qmd`: Markdown reference content displayed inside the Quarto module.
- `exercises/Exercise1.qmd`: Day-one QCRC lab for tests, regression, and `if` statements.
- `exercises/Exercise2.qmd`: Day-two capstone-style report prompt using QCRC.
- `day1/`: Excluded day-one notes/scripts, including a duplicate/variant of Exercise 1 and iteration/function notes.
- `day2/`: Excluded day-two notes/scripts, including bootstrapping, functional programming, gtsummary, useful packages, Arrow duplicate, and a worked Exercise 2 document.
- `GIS/`: Excluded GIS lessons and data, including an embedded nested R project.
- `docs/` and `_freeze/`: Generated Quarto outputs/caches. Useful for deployment, but not primary source learning materials.
- `data/` and `data/raw-data/`: Course datasets and data-generation scripts.
- `images/`: Static assets used by slides/site.

## Strengths

- The course has a strong practical identity: R programming for infectious disease modeling, not generic R in isolation.
- Modules 3-6 form a coherent programming progression: repetitive code -> loops/vectorization -> functions -> apply-style functional programming -> formulas/S3.
- Reusing QCRC, measles, birthweight, and SIR-type examples reduces dataset churn and can help adult learners focus on transferable programming patterns.
- Many decks include "You try it" prompts, hints, and solutions, which is exactly the right direction for adult learners in a short intensive course.
- The bootstrapping and power-simulation materials connect programming mechanics to statistical reasoning in a way that is useful for researchers.
- The capstone-style Exercise 2 asks for a real deliverable: a concise report with a research question, model, descriptive table, interpretation, and optional extensions.
- The tone is approachable and often reassuring, which matters for learners who arrive with heterogeneous R confidence.

## Placeholders, TODOs, and Incomplete Content

- Resolved after this review: the learner-facing bootstrapping, power-simulation,
  and ODE/optimization titles no longer use placeholder module numbering.
- `modules/Module04-Functions.qmd:11` says "After module XX".
- `modules/linear-models.qmd:45` has `# stuff here`; `modules/linear-models.qmd:53-61` are code-comment placeholders for deviance and negative binomial modeling. This file should not be student-facing as-is.
- `_quarto.yml:69` lists "Disease mapping" with no `href`.
- `schedule.qmd:27` mentions "Data science walkthrough 1", but the repository only has `modules/Walkthrough2.qmd`.
- `schedule.qmd:41` says "Power (maybe power simulation), catch-up time", and `schedule.qmd:51` and `schedule.qmd:53` say "Review or advanced topics". These are planning placeholders, not learner-facing schedule commitments.
- `modules/bootstrapping.qmd:322` has "No solution typed up" for the logistic regression bootstrap exercise. That is acceptable only if clearly marked as optional/live coding.
- `modules/ODEs-optim.qmd:574` has "No solution typed out" for the environmental pathogen ODE problem. This should be optional/advanced or supplied with a solution key.
- `day2/cool_packages.R:102` has a TODO for a failing `xtable` call. The file is also disconnected from the course arc.
- `data/raw-data/city-cases-gen.R:235` has a TODO in a data-generation script.
- `references.qmd:9` says to download the zip from GitHub, while `Module00-Welcome.qmd:43` says Course Resources contains download links for all data, exercises, and slides. That promise is not currently met.
- `modules/references.bib` has a duplicated BibTeX key `abrahms2016`.

## Organization and Sequencing Issues

- Day 1 is overloaded. `schedule.qmd:19-25` puts Modules 0, 1, 2, 3, and 4 plus Exercise 1 into one full day. That means learners must absorb Quarto, statistical review, loops/vectorization, functions, and a lab before consolidation.
- Day 2 is also overloaded. `schedule.qmd:35-43` puts functional programming, useful packages, S3/formulas, Arrow, power, Exercise 2, and a walkthrough into one day. That is too many shifts in abstraction for a mixed-experience group.
- Exercise 2 asks learners to synthesize table-making, GLMs, Quarto report structure, bootstrapping, and power. Earlier modules do not yet provide enough scaffolded practice combining these components.
- `modules/Module06-S3-lm-formulas.qmd` introduces S3/OOP before learners have much practice with formulas and GLM outputs. The most practical value is formula/model-method literacy; the S3 theory should be compressed or moved after formula use.
- Arrow is in the main module list, but it is not needed for Exercise 2 or the main modeling arc. It is a useful professional topic, but it competes with higher-priority learner needs in a short course.
- `modules/sample-size.qmd` is a broad `pwrss` reference deck rather than a course-integrated lesson. It should not precede or compete with `modules/power-sim.qmd` unless shortened substantially.
- `modules/ODEs-optim.qmd` combines maximum likelihood, constrained optimization, zero inflation, numerical ODE solving, SIR/SIRS, and ODE parameter fitting. That is excellent advanced material, but too much for the core track.
- The `GIS/` directory is excluded from the main site but referenced conceptually as "Disease mapping". It reads like a separate course/lab and should either be integrated deliberately or removed from the current course surface.

## Content and Flow Review

- `modules/Module00-Welcome.qmd` sets a welcoming tone and asks learner interests, which is good. It should also include a concrete "what we will definitely cover" versus "optional if time" list, because the current course scope is broad.
- `modules/Module01-Quarto.qmd` covers useful Quarto mechanics, but several screenshots are missing or incorrectly referenced. It also has little active practice. Adult learners need to render a tiny document, break/fix a chunk option, and add one inline result.
- `modules/Module02-StatReview.qmd` is useful but dense. It covers one-sample t-test, two-sample t-test, paired t-test, ANOVA, Tukey, correlation, simple linear regression, multiple regression, and logistic regression. That is a lot for one review block. It should be reframed as "statistical model selection and R syntax refresher" with a one-page decision table.
- `modules/Module02-StatReview.qmd:39` imports a remote Kaggle dataset at render/runtime. That adds network fragility. Bundle a small copy or remove the paired t-test remote dependency.
- `modules/Module02-StatReview.qmd:441` says logistic regression betas are "useless" and must be exponentiated. This is memorable but too strong: log-odds coefficients are meaningful on the model scale, while odds ratios are usually easier to interpret. Rephrase to avoid teaching a false absolute.
- `modules/Module03-Iteration.qmd` is one of the stronger decks. It gradually unfolds loops and compares loops to vectorization. The measles walkthrough is useful, but warnings from all-missing countries should be handled explicitly if they occur.
- `modules/Module04-Functions.qmd` has good practical examples and a direct bridge from loops to functions. It should fix typos and consider softening "get in the habit of explicit returns"; idiomatic R often uses implicit returns, so the better advice is "use explicit returns when it improves clarity."
- `modules/Module05-FunctionalProgramming.qmd` is well aligned with Module 4. The learning goal says learners will use `purrr`, but the module only mentions `purrr` in the summary. Either add a small `purrr::map()` comparison or remove that objective.
- `modules/Module06-S3-lm-formulas.qmd` has a good practical aim, but some technical claims need correction. `modules/Module06-S3-lm-formulas.qmd:116` says if an object has an S3 class, then it is a list. That is false for common S3 objects such as factors and dates. This could confuse learners badly.
- `modules/Module06-S3-lm-formulas.qmd:287` uses `median(qcrc$d_dimer, na.rm = FALSE)` immediately after discussing imputation. If there are missing values, the median will be `NA` and the imputation will fail. This should be `na.rm = TRUE`.
- `modules/bootstrapping.qmd` is conceptually strong and nicely grounded in an epidemiologic measure. The risk-ratio exercise has a likely bug: `modules/bootstrapping.qmd:171` builds a table using `birthwt$smoke` for columns when the exercise is about hypertension and low birthweight. It should likely use `birthwt$low`.
- `modules/power-sim.qmd` has high pedagogical value but needs technical repair before teaching. `modules/power-sim.qmd:86` and `modules/power-sim.qmd:102` contain invalid `power.t.test(,` calls. `modules/power-sim.qmd:357` and `modules/power-sim.qmd:401` define `N_sim` but use global `N_sims` inside the function. `modules/power-sim.qmd:320` and `modules/power-sim.qmd:411` pass `conf.level = alpha` to `t.test()`, which is conceptually wrong even if p-values are unaffected.
- `modules/power-sim.qmd:523-528` describes `beta_1 = 1.5` as if exposed individuals have log-odds "1.5x" baseline. In logistic regression, the log-odds increase by 1.5 and the odds ratio is `exp(1.5)`.
- `modules/Arrow.qmd` is concise and practical, but it depends on a 41-million-row file and all code is `eval: false`. It functions as a demonstration, not a hands-on lesson. For this course, use a small parquet example learners can actually run.
- `modules/sample-size.qmd` is too broad and reference-like. It reads as a tour of `pwrss` functions rather than a lesson with a narrative, decisions, and practice. It should be compressed into a focused sample-size planning module or moved to optional reference.
- `modules/ODEs-optim.qmd` is engaging and relevant to infectious disease modeling, but it stacks many advanced ideas. It should be split into "maximum likelihood with `optim()`" and "ODE solving with `deSolve`", with ODE parameter fitting as optional.
- `modules/linear-models.qmd` has a fun simulated case-study premise, but the fictional disease/exposure names may distract from limited workshop time. More importantly, the code sections are incomplete.
- `modules/Walkthrough2.qmd` is too short to serve as a standalone module. It could be a 10-minute instructor story or be expanded into a guided tour with prompts.

## Hands-on Practice and Assessment Gaps

- Add a setup check before Module 1: learners render a tiny Quarto document, load `here`, read QCRC, and confirm package versions.
- Add a "stop and predict" slide before running code in Modules 3-6. For adult learners, prediction prompts help convert passive code reading into active reasoning.
- Add short formative checkpoints at the end of each core module:
  - Quarto: render a report with one plot and one inline statistic.
  - Statistics review: choose the right test/model for 4 mini-scenarios.
  - Iteration: convert copied code into a loop, then identify when vectorization is better.
  - Functions: write a function with arguments, defaults, and a simple input check.
  - Functional programming: replace a loop with `lapply()` and combine outputs.
  - Formulas/S3: fit a model and extract/interpet coefficients, confidence intervals, and predictions.
  - Bootstrapping: write the statistic function first, then bootstrap it.
  - Power simulation: identify assumptions, simulate data, test, summarize rejections.
- Add "faded examples" before Exercise 2. The current capstone is good, but learners need a partially completed Quarto report where they fill in the model, table, interpretation, and limitations.
- Provide solution keys separately from student-facing prompts. Several current decks reveal solutions immediately after prompts, which is useful for live slides but weak as independent exercises.
- Add discussion prompts around interpretation:
  - What assumptions did the model make?
  - What would make this estimate causal or non-causal?
  - Which missing-data choice did we make, and how could it affect results?
  - What would you report to a collaborator?
- Add a lightweight rubric for Exercise 2: research question, data cleaning, table, model, interpretation, reproducibility, and limitations.

## Pacing and Time Allocation

The course has about 17.5 contact hours: two 9 AM-5 PM days plus one 9 AM-12:30 PM half day, with breaks/lunch reducing active instruction time.

Recommended core allocation:

- Welcome, setup, and Quarto: 90 minutes. Learners must leave with a working render.
- Statistical/modeling review: 90 minutes. Focus on model syntax and interpretation, not a full intro statistics recap.
- Iteration and vectorization: 90 minutes.
- Functions: 120 minutes including practice.
- Exercise 1 and debrief: 90 minutes.
- Functional programming: 90 minutes.
- Formulas, model objects, and extracting results: 75 minutes. Compress S3 theory.
- Bootstrapping: 90 minutes.
- Power simulation: 90 minutes, if bootstrapping lands well. Otherwise make it optional.
- Exercise 2/report work time: at least 150 minutes split across day 2 and day 3.
- Advanced topics carousel: 60-90 minutes on day 3, selected by learner vote.

Material that should not be in the required core unless time is abundant: Arrow at large scale, the full `sample-size.qmd` deck, GIS, advanced linear monsters, ODE parameter fitting, and the full S3/OOP theory section.

## Recommended Reorganization

Suggested course arc:

1. Welcome, setup, Quarto essentials, and "how this course works".
2. QCRC mini-analysis as a motivating example: read data, clean names, fit a simple model, render a tiny report.
3. Iteration and vectorization with measles data.
4. Functions as a way to make iteration readable.
5. Exercise 1: refactor and extend an analysis.
6. Functional programming with `lapply()`/`sapply()` and repeated models.
7. Formulas and model objects: practical extraction and reporting first, S3 terminology second.
8. Bootstrapping as a programming/statistics integration module.
9. Power simulation as the second integration module.
10. Exercise 2 capstone report, with structured work time and debrief.
11. Optional advanced topics chosen by interest: Arrow, `optim()`, `deSolve`, GIS, sample-size package tour, or advanced GLMs.

## Recommended Additions

- A `setup.qmd` or first exercise that verifies R, RStudio/Positron, Quarto, package installation, working directory, and data access.
- A single "course datasets" page documenting QCRC, measles, birthweight, city-cases, SIR-observed, and GIS data: source, purpose, key variables, and where used.
- A learner-facing "what to do when code errors" checklist.
- A model-reporting cheat sheet: `summary()`, `coef()`, `confint()`, `exp()`, `predict()`, and when each is used.
- A one-page "loops/functions/apply decision guide".
- Exercise 2 starter template with headings, setup chunk, data import, and TODO markers.
- Instructor solution files, separate from student prompts.
- Short debrief slides after each exercise with common mistakes and interpretation points.
- A rendered downloadable zip or explicit download links for exercises/data/slides, matching the promise in Module 00.

## Material to Cut, Compress, or Make Optional

- Make `modules/sample-size.qmd` optional/reference unless it is rebuilt around one realistic planning problem.
- Make `modules/Arrow.qmd` optional or convert it to a small runnable example.
- Make `modules/ODEs-optim.qmd` optional advanced material, or split it and teach only one half.
- Remove `modules/linear-models.qmd` from the sidebar until the placeholder code is complete.
- Remove or clearly label `day1/` and `day2/` files as instructor notes. They currently create confusion because they duplicate student-facing exercises and modules.
- Move `GIS/` out of the main course or integrate it properly as an optional day-three lab with correct paths and links.
- Compress S3 theory in Module 6. Keep enough for learners to understand method dispatch, then focus on formulas and model outputs.
- Remove or rewrite copied-context language from GIS files, such as DATA-530, "rest of the semester", and RAM instructions.

## Prioritized Action Plan

### Critical Before Teaching

1. Run a clean Quarto render in a fresh environment and fix all render errors.
2. Fix missing/case-sensitive image paths:
   - `modules/Module01-Quarto.qmd:7`, `:51`, `:73`, `:111`, `:117`, `:139` reference images that are not present under `modules/images/` or `docs/modules/images/`.
   - `index.qmd:40` references `zane.jpg`, but source image is `images/zane.JPG`.
   - `modules/Module03-Iteration.qmd:250` references `hadley-tweet.png`, but source is `images/hadley-tweet.PNG`.
   - `modules/power-sim.qmd:67` references `gpower.png`, but source is `images/gpower.PNG`.
   - `modules/ODEs-optim.qmd:480` references `SIRS.png`, but source is `images/SIRS.PNG`.
3. Repair executable bugs in `modules/power-sim.qmd`, especially invalid `power.t.test(,` calls and the `N_sim`/`N_sims` mismatch.
4. Fix `modules/Module06-S3-lm-formulas.qmd:287` so median imputation actually uses `na.rm = TRUE`.
5. Fix or remove incomplete files from navigation: `modules/linear-models.qmd`, `_quarto.yml:69` Disease mapping, and schedule references to missing/undefined walkthroughs.
6. Decide the required course scope and mark optional/advanced materials explicitly.
7. Consolidate Exercise 1 and Exercise 2 sources so there is one student-facing version and one solution/instructor version.

### High-Value Improvements

1. Add formative checkpoints and debriefs to every core module.
2. Add a starter template and rubric for Exercise 2.
3. Rebuild the schedule around fewer required topics and more work time.
4. Convert remote or huge-data dependencies into local, small, runnable examples.
5. Add a datasets page and a troubleshooting/setup page.
6. Align learning objectives with what is actually assessed in exercises.

### Optional Polish

1. Fix typos and informal wording where it reduces credibility or clarity: examples include "Prerequisities", "statments", "arugment", "elipsis", "exponeniate", "contigency", "boostrap", "Causian", "remdesivisir", "odss", "chuck", and "ande".
2. Standardize terms: Quarto rather than RMarkdown when appropriate; "RStudio" rather than "R Studio"; `apply` family versus functional programming.
3. Add alt text/captions for instructional images.
4. Update resource links, especially old R4DS URL and duplicated Springer PDF links in `references.qmd:34-35`.
5. Clarify generated versus source directories in the README.

### Advanced / End-of-Course Options

1. `optim()` likelihood estimation using mosquito pooling.
2. SIR/SIRS solving with `deSolve`.
3. Power simulation for logistic regression.
4. Arrow/parquet for large data workflows.
5. GIS mapping lab, if corrected and reframed for SISMID.
6. Advanced GLMs, overdispersion, negative binomial models, random effects, and splines.

## File-by-File Notes

### `_quarto.yml`

- Good: sidebar gives a clear course website structure.
- Issue: `render` excludes `day1/`, `day2/`, and `GIS/`, but those folders contain substantial learning materials. This is fine only if they are explicitly instructor notes or optional local labs.
- Issue: `_quarto.yml:69` has "Disease mapping" without an `href`.
- Issue: site navigation includes incomplete/advanced materials (`sample-size`, `power-sim`, `linear-models`) alongside polished core modules, which makes the course look more complete than it is.

### `README.qmd` / `README.md`

- Good: clear course summary and prerequisites.
- Issue: README says modules each have their own folder with an `index.qmd` and separate slides, but the actual structure is mostly flat `modules/*.qmd`.
- Issue: module content mentions RMarkdown, S3/S4, ODEs, and `optim()`, but current core site is Quarto-focused and only really teaches S3. Align the list to actual teaching commitments.
- Issue: prerequisite/version text is date-sensitive. Verify R and Quarto recommendations shortly before teaching.

### `index.qmd`

- Good: gives learners install instructions and instructor context.
- Issue: "Prerequisities" typo in heading.
- Issue: `index.qmd:40` image case mismatch (`zane.jpg` versus `images/zane.JPG`) can break on case-sensitive systems.
- Improvement: add a short "Before class checklist" and a link to a setup check file.

### `schedule.qmd`

- Good: shows the full workshop time envelope and breaks.
- Issue: current topic blocks are too broad and crowded.
- Issue: tentative labels ("maybe", "Review or advanced topics") should be replaced with a stable plan plus optional topic menu.
- Improvement: include explicit exercise/debrief blocks and capstone work time.

### `references.qmd`

- Good: useful free resources.
- Issue: the "Data and Exercise downloads" section only points to the GitHub repo zip. It does not provide direct downloads for data, exercises, or slides.
- Issue: R jargon and R vs Stata link to the same Springer PDF.
- Improvement: group resources by use case: getting unstuck, R syntax, data visualization, epidemiology, infectious disease modeling, Quarto.

### `modules/Module00-Welcome.qmd`

- Good: learner introductions and interest check are strong adult-learning moves.
- Issue: says Course Resources contains data/exercise/slide downloads, which is not currently true.
- Improvement: add "core topics" versus "possible advanced topics" to reduce anxiety about the long topic list.

### `modules/Module01-Quarto.qmd`

- Good: covers chunks, YAML, chunk labels, options, inline code, figures, and tables.
- Critical issue: image paths appear broken. The deck references `images/quarto-dark-bg.jpeg`, `images/28-fig28.png`, `images/28-quarto-visual-editor.png`, `images/28-chunk-label.png`, `images/quarto-chunk-nav.png`, and `images/28-chunk-options.png`, but those files are not in the source image listing.
- Improvement: add a live mini-exercise: create a `.qmd`, add one code chunk, inline `nrow()`, and render.

### `modules/Module02-StatReview.qmd`

- Good: connects statistical test choice to actual R functions.
- Issue: too many tests/models for one review session.
- Issue: remote Kaggle import is fragile.
- Issue: logistic regression language should be more precise about log-odds versus odds ratios.
- Improvement: add a decision table and make learners choose tests before seeing code.

### `modules/Module03-Iteration.qmd`

- Good: strong gradual reveal of loop anatomy, vectorization, and a realistic measles loop.
- Issue: case-sensitive image filename risk for `hadley-tweet`.
- Issue: possible warnings from all-missing summaries should be anticipated instructionally.
- Improvement: add a debugging checkpoint where learners inspect one iteration manually before writing the full loop.

### `modules/Module04-Functions.qmd`

- Good: practical, approachable function-writing arc.
- Issue: placeholder module-number text, typo in "argument defaults", and misspelling "ellipsis".
- Issue: advice about explicit `return()` should be nuanced.
- Improvement: add a small input validation example such as stopping when `K <= 0` or country code is absent.

### `modules/Module05-FunctionalProgramming.qmd`

- Good: builds directly from Module 4 and uses the same measles/QCRC contexts.
- Issue: title lacks a space: "FunctionalProgramming".
- Issue: learning objective promises `purrr`, but content does not teach it.
- Improvement: either add a small `purrr::map()` comparison or keep the module purely base R and update objectives.

### `modules/Module06-S3-lm-formulas.qmd`

- Good: valuable goal of demystifying model objects, formulas, and methods.
- Critical issue: incorrect S3 statement at `:116`.
- Critical issue: median imputation bug at `:287`.
- Issue: learning objective about vectorization is copied from Module 3 and does not fit the module.
- Improvement: lead with formulas/model outputs, then use S3 terminology to explain why `summary()`, `coef()`, and `confint()` work.

### `modules/bootstrapping.qmd`

- Good: strong integration of programming and statistical inference.
- Resolved after this review: the bootstrapping source title no longer uses placeholder module numbering.
- Issue: hypertension risk-ratio exercise appears to table hypertension against smoking rather than low birthweight.
- Issue: final logistic regression bootstrap exercise has no solution.
- Improvement: add a diagram/checklist for bootstrap workflow: statistic function -> resample -> repeat -> summarize.

### `modules/Arrow.qmd`

- Good: concise explanation of why Arrow/parquet matters.
- Issue: the very large Seattle dataset and `eval: false` code make it a demo rather than a learner exercise.
- Improvement: provide a small local CSV/parquet pair so learners can actually run `open_dataset()`, `collect()`, and `write_dataset()`.

### `modules/sample-size.qmd`

- Good: broad coverage of `pwrss`.
- Issue: far too long and not sufficiently tied to course datasets or decisions.
- Issue: likely copied/package-demo flow with many examples but little learner task structure.
- Recommendation: move to optional reference or rebuild around one or two study-planning cases.

### `modules/power-sim.qmd`

- Good: excellent conceptual fit for "programming for modeling".
- Critical issue: invalid code at `:86` and `:102`.
- Critical issue: `N_sim` argument ignored in favor of global `N_sims`.
- Issue: `conf.level = alpha` should be removed or changed to `1 - alpha`.
- Issue: logistic effect-size interpretation needs correction.
- Improvement: split analytic power, curves, t-test simulation, and logistic simulation into clearer time-boxed sections.

### `modules/ODEs-optim.qmd`

- Good: highly relevant advanced content with strong examples.
- Resolved after this review: the old combined ODE/optimization deck was split
  into a core ODE lesson plus optional advanced material.
- Issue: combines too many advanced concepts for the core sequence.
- Issue: no solution for environmental pathogen ODE exercise.
- Improvement: make it an optional day-three module, or split into `optim()` and `deSolve`.

### `modules/linear-models.qmd`

- Good: intends to cover overdispersion, negative binomial, interactions, random effects, splines, and Bayesian models.
- Critical issue: placeholder code makes it incomplete.
- Recommendation: remove from sidebar until finished, or label as instructor discussion outline.

### `modules/Walkthrough2.qmd`

- Good: could be a useful real-world reproducibility demonstration.
- Issue: too short to stand alone.
- Improvement: add 3-5 prompts: where is the analysis script, where are models fit, how is the paper rendered, what parts are reproducible?

### `modules/quarto/markdown.qmd`

- Good: useful embedded Markdown reference.
- Issue: references `quarto.png`, but that image was not found in source.
- Improvement: either include the image or remove the image example.

### `exercises/Exercise1.qmd`

- Good: practical QCRC lab with common statistical procedures.
- Issue: introduction says learners will practice iteration with `for` loops and `apply`, but the exercise stops at `if` statements.
- Issue: several typos reduce polish: "chuck", "odss", "ande".
- Issue: no solutions or scaffold for learners who get stuck.
- Improvement: add a final loop/function mini-task or remove iteration/apply from the introduction.

### `exercises/Exercise2.qmd`

- Good: strong capstone report prompt.
- Issue: too open-ended without a starter template or rubric.
- Issue: asks for GLM, table one, other analyses, and interpretation in one jump. That is appropriate as a capstone only if learners have structured work time and support.
- Improvement: provide a Quarto skeleton and a checklist for "minimum viable report".

### `day1/ex1.qmd`

- Issue: excluded from render and duplicates `exercises/Exercise1.qmd`.
- Issue: after `clean_names()`, later code still uses original names such as `Died`, `Age`, and `ICU_LOS`, so chunks will fail.
- Recommendation: treat as an obsolete solution draft unless cleaned and renamed as an instructor key.

### `day1/iteration-notes.qmd` and `day1/day1-script.R`

- Good: useful instructor notes for loops/functions/debugging.
- Issue: not integrated into site and includes long sleeps/manual notes unsuitable for polished learner content.
- Recommendation: mine the best examples into Modules 3-4 or label as instructor notes.

### `day2/functional-programming-notes.R`

- Good: reinforces Module 5 with additional examples.
- Issue: script format is less learner-friendly than a guided worksheet.
- Recommendation: convert selected examples into a short optional practice file.

### `day2/bootstrapping-notes.R`

- Good: clear commented script that supports the bootstrapping module.
- Issue: excluded from render; duplicates slide content.
- Recommendation: use as an instructor live-coding script or convert to a learner worksheet.

### `day2/gtsummary-notes.R`

- Good: potentially useful for Exercise 2.
- Issue: not currently surfaced before the capstone prompt.
- Recommendation: turn into a short "making Table 1/Table 2" handout or integrate before Exercise 2.

### `day2/cool_packages.R`

- Issue: disconnected examples using `mtcars`, PISA Likert data, `sjPlot`, `table1`, etc.
- Recommendation: remove from learner-facing materials or rewrite as a curated optional packages page tied to course tasks.

### `day2/zane-alex-exercise2.qmd`

- Good: shows the shape of a worked report.
- Critical issue: `sex = factor(Female) |> relevel(ref = "Female")` likely fails unless `Female` already has a level named "Female".
- Issue: introduction lists variables not used in the model.
- Issue: Discussion section is empty.
- Recommendation: fix and use as a solution exemplar only after Exercise 2, not as the main prompt.

### Excluded duplicate Arrow deck in `day2/`

- Issue: duplicate/older version of `modules/Arrow.qmd`.
- Recommendation: remove, archive, or mark as obsolete.

### `GIS/basic_gis.qmd`

- Good: detailed GIS lab with examples and practice tasks.
- Issue: clearly copied from another context: DATA-530, "rest of the semester", RAM instructions, and ArcGIS course references.
- Issue: path assumptions use `data/example/...`, but from the main project root the data live under `GIS/data/example/...`.
- Issue: excluded from main render.
- Recommendation: keep as optional only after path/context cleanup, or move to a separate GIS course repo.

### `GIS/data_operations.qmd`

- Good: useful spatial data operations lesson around John Snow data.
- Issue: links to `[lab](#lab)` but no lab section was found in the file.
- Issue: table join objective links to `#tablejoin`, but the heading will likely generate `#table-join` unless manually anchored.
- Issue: same path/context concerns as `basic_gis.qmd`.
- Recommendation: finish the lab section and integrate only if disease mapping is a real course objective.

### `docs/` and `_freeze/`

- These are generated outputs/caches. They should not be reviewed as source teaching content, but they reveal likely broken rendered assets in Module 01.
- Recommendation: document that source edits happen in `.qmd` files, not `docs/` or `_freeze/`, unless updating deployment output deliberately.

### `data/` and `data/raw-data/`

- Good: course has real local datasets.
- Issue: raw data scripts are not explained for learners.
- Issue: `data/raw-data/city-cases-gen.R` has a TODO.
- Recommendation: add a short dataset README and keep raw-data scripts out of the main learner path unless teaching data provenance.
