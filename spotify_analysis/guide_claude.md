# Spotify Tracks — Data Analyst Portfolio Project
### Mentor Guide by Claude

---

## What You're Working With

You have **114,000 Spotify tracks** across **114 genres** (exactly 1,000 tracks per genre), with 21 columns covering track metadata and Spotify's audio feature scores. Here's what each column means in plain language:

| Column | Type | What it means |
|---|---|---|
| `track_id` | string | Spotify's unique ID — note: 24,259 duplicates exist (same song in multiple genres) |
| `artists` | string | Artist name(s), separated by `;` for collaborations |
| `album_name` | string | Album the track belongs to |
| `track_name` | string | Song title |
| `popularity` | int 0–100 | Spotify's current popularity score (higher = more listened to recently) |
| `duration_ms` | int | Track length in milliseconds |
| `explicit` | bool | Whether the track has explicit content (~8.6% of tracks) |
| `danceability` | float 0–1 | How suitable for dancing (rhythm, beat strength, regularity) |
| `energy` | float 0–1 | Perceived intensity and activity |
| `key` | int 0–11 | Musical key (0=C, 1=C#, 2=D, …) |
| `loudness` | float (dB) | Average loudness, typically –60 to 0 dB |
| `mode` | int 0 or 1 | 1 = Major key, 0 = Minor key |
| `speechiness` | float 0–1 | Presence of spoken words (>0.66 = likely spoken word/podcast) |
| `acousticness` | float 0–1 | Confidence that track is acoustic |
| `instrumentalness` | float 0–1 | Predicts whether a track has no vocals (>0.5 = likely instrumental) |
| `liveness` | float 0–1 | Probability that the track was recorded live (>0.8 = very likely live) |
| `valence` | float 0–1 | Musical positiveness (1 = happy/euphoric, 0 = sad/angry) |
| `tempo` | float | Estimated BPM (beats per minute) |
| `time_signature` | int | Estimated meter (beats per bar, usually 3 or 4) |
| `track_genre` | string | Genre label assigned by Spotify |

**Key data facts to keep in mind throughout the project:**
- There are only 3 null values (one each in `artists`, `album_name`, `track_name`) — trivial to handle
- The duplicate `track_id` issue is intentional: a song can appear in multiple genre buckets. You will need to decide at each analysis stage whether to deduplicate or not, and document that decision
- Popularity skews low (mean ~33, median ~35) — most tracks are obscure; superstars pull the max to 100

---

## Project Structure

Organize your GitHub repository like this before writing a single line of analysis code:

```
spotify-tracks-analysis/
│
├── data/
│   └── spotify_tracks.csv          # raw data, never modified
│
├── notebooks/
│   ├── 01_data_cleaning.ipynb
│   ├── 02_eda.ipynb
│   ├── 03_genre_analysis.ipynb
│   ├── 04_audio_features.ipynb
│   └── 05_popularity_analysis.ipynb
│
├── sql/
│   ├── schema.sql
│   ├── cleaning_queries.sql
│   └── analysis_queries.sql
│
├── visuals/                         # exported charts (PNG/SVG)
│
├── requirements.txt
└── README.md
```

The README is what recruiters see first. Write it last, but plan for it now: it should have a project summary, the questions you set out to answer, key findings with embedded visuals, and instructions to reproduce your work.

---

## Phase 0 — Project Setup (Before Any Analysis)

**Goal:** Get your environment clean and reproducible.

**Your tasks:**

1. Create a Python virtual environment for this project. Pin your library versions in `requirements.txt` so anyone cloning your repo gets the same setup.

2. Initialize a Git repository immediately. Commit your raw data and folder structure as your first commit. From this point on, commit after each meaningful step — recruiters look at commit history to gauge work ethic.

3. Set up PostgreSQL. Create a dedicated database (e.g., `spotify_analysis`) and a schema. Your `schema.sql` file should define the `tracks` table with appropriate types. Think about what data type makes sense for each column — for example, `popularity` should be a `SMALLINT`, not `TEXT`. `explicit` is a boolean. `key` and `mode` could be `SMALLINT`. Getting types right is a signal of professional care.

4. Write a Python script (or a cell at the top of notebook 01) that loads the CSV and inserts it into PostgreSQL using `psycopg2` or `sqlalchemy`. This bridges your Python and SQL workflow.

---

## Phase 1 — Data Cleaning (Notebook 01)

**Goal:** Produce a clean, trusted dataset. Document every decision.

This is where many students rush. Don't. Data cleaning decisions shape every downstream result. Your notebook should read like a lab report: here's what I found, here's what I decided, here's why.

**Your tasks:**

**1. Handle the index column**
The `Unnamed: 0` column is just a row index from when the CSV was exported. Drop it. It carries no information.

**2. Handle null values**
There are 3 nulls — one each in `artists`, `album_name`, `track_name`. Inspect those specific rows. Are they the same row? Different rows? What does the rest of the row look like? Based on what you find, decide: drop those rows, or fill with a placeholder like `"Unknown"`. Document your reasoning.

**3. Handle duplicate track IDs**
This is the most important cleaning decision in the whole project. Run `value_counts()` on `track_id` to see how many times the most-duplicated tracks appear. A track appearing in multiple genres is *intentional* (it's how the dataset was built). Do NOT blindly deduplicate.

Instead, create two versions of your clean data:
- `tracks_full` — all 114,000 rows, keeping duplicates. Use this for genre-level analysis.
- `tracks_deduped` — one row per `track_id`, keeping the row with the highest popularity if there are ties. Use this for track-level analysis (e.g., "what are the most popular songs overall").

Document this clearly in your notebook with a markdown cell explaining the choice.

**4. Engineer new columns**
Add these derived columns now — you'll need them repeatedly later:
- `duration_min`: convert `duration_ms` to minutes (just divide by 60,000). Much more readable in charts.
- `is_live`: boolean, True where `liveness > 0.8`
- `is_instrumental`: boolean, True where `instrumentalness > 0.5`
- `is_spoken_word`: boolean, True where `speechiness > 0.66`
- `key_name`: map the integer key (0–11) to actual note names (C, C#, D, D#, E, F, F#, G, G#, A, A#, B)
- `mode_name`: map 0→"Minor", 1→"Major"

**5. Validate ranges**
For each audio feature (danceability, energy, acousticness, etc.), check that values fall within their expected 0–1 range. For `loudness`, check whether any values are suspiciously extreme. For `tempo`, check for zeros or implausible values. Print a summary table of min/max for all numeric columns. If you find outliers, decide whether they are data errors or genuine edge cases (e.g., a track with 0 BPM might be an ambient drone piece).

**6. Write your clean data to PostgreSQL**
After cleaning, write `tracks_full` and `tracks_deduped` as separate tables. From this point, your SQL analysis runs against these clean tables.

---

## Phase 2 — Exploratory Data Analysis (Notebook 02)

**Goal:** Get a broad understanding of the data's shape, distributions, and surprising facts. No deep genre-specific analysis yet — that comes in Phase 3.

**Your tasks:**

**1. Popularity distribution**
Plot the distribution of `popularity`. What shape is it? Notice that a large number of tracks have popularity = 0. Is that real? (Yes — most tracks on Spotify have almost no plays.) This is worth calling out explicitly in your notebook as an insight.

Then plot the distribution *excluding* tracks with popularity = 0. How does the shape change? This is a deliberate analytical choice worth documenting.

**2. Audio features overview**
Create a single figure showing the distribution of all 8 main audio features (danceability, energy, speechiness, acousticness, instrumentalness, liveness, valence, tempo) as subplots. Use a 2×4 or 4×2 grid. This gives you and your reader an immediate sense of how each feature is distributed across all music.

Note patterns: is any feature heavily right-skewed? Near-zero for most tracks? This single figure is one of the most compelling things you can put in your README.

**3. Correlation heatmap**
Compute the Pearson correlation matrix for all numeric audio features plus popularity. Plot it as a heatmap with annotations. Look for:
- Strong positive correlations (e.g., energy and loudness tend to move together — can you see it?)
- Negative correlations (e.g., acousticness and energy)
- Which features correlate with popularity? (Spoiler: probably less than you'd expect)

**4. Explicit vs. non-explicit**
Compare the mean popularity of explicit vs. non-explicit tracks. Also compare their mean energy and danceability. Is there a meaningful difference? Use a grouped bar chart.

**5. Mode (Major vs. Minor)**
Do tracks in a major key tend to be happier (higher valence)? Compare valence distributions by mode using a box plot or violin plot. Then check: do major-key tracks have higher popularity?

**6. Time signature analysis**
What fraction of tracks are in 4/4 time vs. others? Plot a bar chart of time signature counts. What genres might skew toward 3/4?

**7. The zero-popularity phenomenon**
Count exactly how many tracks have popularity = 0. What percentage is that? Break it down by genre — are some genres dominated by zero-popularity tracks? This tells you something about how Spotify's algorithm treats certain music categories.

---

## Phase 3 — Genre Analysis (Notebook 03 + SQL)

**Goal:** Understand how genres differ from each other musically and commercially. This is the richest analysis section.

**Your tasks:**

**1. Genre popularity rankings (SQL)**
Write a SQL query that computes the average, median, and standard deviation of popularity for each genre, ordered by average popularity descending. Export the result and plot the top 20 and bottom 20 genres as horizontal bar charts. Which genres dominate Spotify? Which are essentially invisible?

**2. Audio fingerprint by genre (SQL + Python)**
Write a SQL query that computes the mean of all audio features grouped by genre. Export this as a dataframe. Then:
- Create a heatmap where rows are genres and columns are audio features, normalized so you can compare features on a common scale. This reveals each genre's "audio fingerprint."
- Pick 6 contrasting genres (e.g., classical, hip-hop, metal, acoustic, dance, ambient) and plot a radar/spider chart showing their feature profiles side by side.

**3. Genre clustering**
Use the genre-level audio feature means you computed above. Apply K-Means clustering (k=5 or 6) to group genres that sound similar. Then visualize the clusters using PCA to reduce to 2 dimensions and plot with genre labels. Color by cluster.

This is an impressive addition to your portfolio because it goes beyond description into unsupervised ML — but it's grounded in your EDA work, which makes it credible.

**4. Explicit content by genre (SQL)**
Write a SQL query computing the percentage of explicit tracks per genre. Which genres are the most explicit? Plot as a horizontal bar chart, top 20. (Expect hip-hop and rap to dominate — but see if anything surprises you.)

**5. Energy vs. Valence scatterplot by genre**
Pick 6–8 genres. Plot a scatterplot of energy vs. valence, with each genre as a different color. Add a 2D density overlay or just use `alpha` transparency. Do genres cluster in the energy-valence space? This is one of the most visually interesting charts in the whole project.

---

## Phase 4 — Audio Feature Deep Dive (Notebook 04)

**Goal:** Analyze the audio features themselves — not just how genres differ, but what the features reveal about music at large.

**Your tasks:**

**1. Tempo distribution by genre**
What is the BPM distribution across the full dataset? Plot it. Then create box plots of tempo by genre for a curated selection of genres (electronic, classical, jazz, metal, hip-hop, country). Are tempo differences between genres meaningful?

**2. Danceability vs. Tempo**
Is faster always more danceable? Plot a scatterplot. You might expect a relationship but the data may surprise you. Color points by genre (sampled subset for readability).

**3. Acousticness vs. Energy**
These two features should be inversely related — electric instruments produce more energy. Plot a scatterplot, fit a regression line (use `seaborn.regplot`), and report the correlation.

**4. Loudness trends**
Loudness is measured in dB relative to a reference. Compare loudness distributions across genres. Which genres are the loudest? Plot box plots for the top 10 and bottom 10 genres by median loudness.

**5. The "happy-sounding but sad-feeling" paradox**
Some genres use major keys (mode=1, which sounds "happy") but have low valence (emotional content is dark or melancholic). Identify tracks and/or genres where mode=1 but valence < 0.3. What are they? This is a great narrative insight for your README.

**6. Instrumentalness analysis**
What fraction of each genre is truly instrumental (instrumentalness > 0.5)? Which genres are most likely to have vocal-free tracks? Plot and interpret.

---

## Phase 5 — Popularity Analysis (Notebook 05)

**Goal:** Answer the central business question: what makes a track popular on Spotify?

**Your tasks:**

**1. Correlation between audio features and popularity**
You already computed this in Phase 2, but now dig deeper. Create a ranked bar chart showing which audio features have the highest absolute correlation with popularity. The results will probably be humbling — Spotify's popularity is hard to predict from audio features alone, and that is itself an insight worth stating.

**2. Popularity by duration**
Do shorter songs perform better? Create a scatter plot of `duration_min` vs. `popularity`. Add a smoothed trend line. Is there a sweet spot for song length?

**3. Top tracks per genre (SQL)**
Write a SQL query that retrieves the top 5 most popular tracks per genre using a window function (`RANK() OVER (PARTITION BY track_genre ORDER BY popularity DESC)`). Export and display as a formatted table. This is a great SQL portfolio piece — window functions are a signal of intermediate-to-advanced SQL skill.

**4. Artists with the most top-100 popularity tracks**
Using `tracks_deduped`, filter for tracks with popularity ≥ 80. Which artists appear most often? Handle the multi-artist case: the `artists` column uses `;` as a separator, so you'll need to split and explode it. Plot top 20 artists.

**5. Popularity prediction attempt**
Build a simple linear regression model (scikit-learn `LinearRegression`) using audio features as input and popularity as target. Report R² and interpret it honestly. A low R² is not a failure — it is a finding. In your README, write something like: "Audio features alone explain only X% of popularity variance, suggesting that social factors, playlist placement, and artist notoriety are the dominant drivers of streaming success." That's a real analyst conclusion.

Optionally, try a Random Forest and compare. Plot feature importances.

---

## SQL Exercises (sql/ folder)

Keep your SQL in `.sql` files, not just inside notebooks. Recruiters and hiring managers often look at SQL separately. Write clean, commented queries.

**Queries to write:**

1. Genre summary table: average of all audio features + count of tracks + average popularity, ordered by popularity
2. Top 10 most popular tracks overall (deduplicated)
3. Most popular track per genre (window function)
4. Genres with the highest percentage of explicit content
5. Tracks where `speechiness > 0.66` (likely podcasts or spoken word) — what genres do they fall in?
6. Artists appearing in more than 5 genres
7. Loudest and quietest genre by median loudness
8. Average track duration by genre, ordered descending

---

## README Structure (Write This Last)

Your README is your project's front page. Structure it like this:

**1. Project Title and One-Line Description**
"An exploratory analysis of 114,000 Spotify tracks across 114 genres, examining audio features, genre fingerprints, and the drivers of streaming popularity."

**2. Key Questions Answered** (use bullet points)
- Which genres dominate Spotify by popularity?
- What audio features distinguish genres from each other?
- Do audio characteristics predict popularity?
- How does explicit content correlate with genre and popularity?

**3. Key Findings** (3–5 bullet points with numbers)
Each bullet should be one concrete finding with a supporting stat. Example: "Classical and ambient genres have near-zero median popularity on Spotify despite strong musical identity, suggesting the platform's algorithm favors mainstream consumption patterns."

**4. Visual Gallery** (embed 4–6 of your best charts)

**5. Tech Stack**
PostgreSQL, Python, pandas, seaborn, matplotlib, scikit-learn, Jupyter Notebook.

**6. How to Reproduce**
Step-by-step instructions: clone, create venv, install requirements, set up PostgreSQL, run notebooks in order.

---

## Mindset Notes

**On the duplicates:** Don't treat them as a problem to eliminate — treat them as a structural property of the dataset to understand and manage. Document in every notebook whether you're using `tracks_full` or `tracks_deduped` and why.

**On surprising findings:** If the data shows something you didn't expect (e.g., audio features barely predict popularity), say so clearly. Data analysts who hide inconvenient results look like they don't understand what analysis is for. Analysts who explain unexpected results look like they know what they're doing.

**On SQL vs. Python:** Use SQL for aggregations, filtering, rankings, and joining. Use Python for visualization, feature engineering, and machine learning. Never do a GROUP BY in pandas when you can do it in SQL first. This division shows you know the right tool for each job.

**On commit discipline:** Commit after each notebook is complete. Write meaningful commit messages like `"Add genre clustering with K-Means and PCA visualization"` not `"update"`.

Good luck, Akmal. This is a strong dataset for a portfolio project — 114 genres gives you enough breadth to find genuinely interesting patterns. Take your time on the EDA; that's where the real storytelling happens.