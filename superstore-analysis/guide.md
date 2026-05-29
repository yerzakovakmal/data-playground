# 🛒 Superstore Sales — Data Analytics Portfolio Project
### A Complete Beginner-to-Intermediate Guide

> **Your Role:** Junior Data Analyst (learning by doing)
> **Mentor Role:** Senior Data Analyst (structure, hints, direction)
> **Rule:** You build. You interpret. You tell the story.

---

## 📋 Table of Contents

1. [Data Sources](#1-data-sources)
2. [Project Roadmap](#2-project-roadmap)
3. [SQL Guidance](#3-sql-guidance)
4. [Exploratory Data Analysis](#4-exploratory-data-analysis)
5. [Analysis Questions](#5-analysis-questions)
6. [Tools & Technologies](#6-tools--technologies)
7. [Database Schema Design](#7-database-schema-design)
8. [Portfolio & Resume Preparation](#8-portfolio--resume-preparation)

---

## 1. Data Sources

### 🥇 Primary Source — Kaggle Superstore Dataset (Recommended)

**What it is:**
The Superstore Sales dataset is one of the most popular datasets for data analytics portfolios. Originally from Tableau's sample data, it's freely available on Kaggle. No API needed — just download and go.

**Download link:**
```
https://www.kaggle.com/datasets/vivek468/superstore-dataset-final
```
> You'll need a free Kaggle account to download.

**What it contains:**

| Column | Description |
|--------|-------------|
| `Order ID` | Unique order identifier |
| `Order Date` | Date the order was placed |
| `Ship Date` | Date the order was shipped |
| `Ship Mode` | Shipping class (Standard, Second Class, etc.) |
| `Customer ID` | Unique customer identifier |
| `Customer Name` | Full name of customer |
| `Segment` | Customer segment (Consumer, Corporate, Home Office) |
| `Country / City / State` | Geographic breakdowns |
| `Region` | US region (East, West, Central, South) |
| `Product ID` | Unique product identifier |
| `Category` | Product category (Furniture, Office Supplies, Technology) |
| `Sub-Category` | More granular product type |
| `Product Name` | Full product name |
| `Sales` | Revenue from the order line |
| `Quantity` | Units ordered |
| `Discount` | Discount applied (0.0–1.0) |
| `Profit` | Profit from the order line |

**Why it's great for a first SQL project:**
- Single CSV file — no API, no scraping, no merging
- Clean enough to load immediately, messy enough to practice on
- Business context is intuitive — sales, profit, customers
- Perfect for practicing JOINs (you'll split it into normalized tables)
- Employers recognize it — shows you understand classic analytics problems

**Limitations and cleaning issues:**
- Dates stored as strings — need conversion to `DATE` type
- Some products have negative profit (intentional — discounts can exceed margin)
- `Discount` is a decimal ratio (0.2 = 20%) — communicate this clearly in charts
- City/State values are mostly clean but have a few edge cases

---

### ✅ Recommendation

> Download from Kaggle. Save the raw file as `data/raw/superstore_raw.csv` and never edit it. All your work goes on a processed copy.

---

## 2. Project Roadmap

### Overview

```
Phase 1 → Setup
Phase 2 → Data Loading & Inspection
Phase 3 → Data Cleaning
Phase 4 → Database Design & Loading
Phase 5 → Exploratory Data Analysis (EDA)
Phase 6 → SQL Analysis
Phase 7 → Visualization
Phase 8 → Insight Generation & Presentation
```

---

### Phase 1 — Project Setup

**Objective:** Build a professional folder structure before writing a single line of analysis code.

**Skills practiced:** Project organization, Git, environment management, VS Code setup

**Your tasks:**

1. Create this folder structure:

```
superstore-analysis/
├── data/
│   ├── raw/              # Original CSV — never edit this
│   └── processed/        # Cleaned version
├── sql/
│   ├── 01_schema.sql
│   ├── 02_explore.sql
│   ├── 03_sales_analysis.sql
│   ├── 04_customer_analysis.sql
│   └── 05_product_analysis.sql
├── notebooks/
│   ├── 01_eda.ipynb
│   └── 02_visualization.ipynb
├── reports/
│   └── insights_summary.md
├── requirements.txt
└── README.md
```

2. Open VS Code and install these extensions:
   - **Python** (Microsoft)
   - **Jupyter** (Microsoft)
   - **SQLTools** + **SQLTools PostgreSQL/Cockroach Driver**

3. Create your Python virtual environment:
```bash
cd superstore-analysis
python3 -m venv venv
source venv/bin/activate
```

4. Install dependencies:
```bash
pip install pandas psycopg2-binary sqlalchemy matplotlib seaborn jupyter python-dotenv
pip freeze > requirements.txt
```

5. Initialize Git and push to GitHub:
```bash
git init
echo "venv/\n*.pyc\n.env\ndata/raw/" > .gitignore
git add .
git commit -m "Initial project structure"
```

**Beginner mistakes to avoid:**
- ❌ Working in the global Python environment — always activate `venv` first
- ❌ Committing your `data/raw/` folder — large CSVs don't belong on GitHub
- ❌ Skipping `.gitignore` — you'll accidentally commit junk files

**Final output:** A GitHub repository with clean folder structure and a basic README.

---

### Phase 2 — Data Loading & Inspection

**Objective:** Load the raw CSV and understand what you're working with before touching anything.

**Skills practiced:** pandas basics, data profiling, VS Code + Jupyter workflow

**Your tasks:**
1. Place the downloaded CSV at `data/raw/superstore_raw.csv`
2. Open `notebooks/01_eda.ipynb` in VS Code — make sure your `venv` kernel is selected (bottom right)
3. Load the file with `pd.read_csv()` — you may need `encoding='latin-1'`
4. Run `.shape`, `.dtypes`, `.head()`, `.isnull().sum()`, `.duplicated().sum()`
5. Write a markdown cell answering:
   - How many rows and columns?
   - Which columns have nulls?
   - What date range does the data cover?
   - What are the unique values of `Category`, `Segment`, `Region`?

**Final output:** A profiled overview of the raw data with written observations.

---

### Phase 3 — Data Cleaning

**Objective:** Fix data type issues and add derived columns so your analysis is reliable.

**Skills practiced:** pandas type conversion, derived columns, saving processed data

**Your tasks:**
1. Convert `Order Date` and `Ship Date` from strings to dates using `pd.to_datetime()`
2. Rename all columns to snake_case (lowercase, spaces → underscores)
3. Fix `postal_code` — it loads as float; convert to string
4. Add these derived columns:
   - `days_to_ship` — difference in days between ship date and order date
   - `order_year` and `order_month` — extracted from order date
   - `profit_margin` — profit divided by sales, as a percentage
   - `is_unprofitable` — boolean flag where profit < 0
5. Save to `data/processed/superstore_clean.csv`

**Beginner mistakes to avoid:**
- ❌ Modifying the raw CSV — always save to `processed/`
- ❌ Forgetting that `Discount` is a ratio — 0.2 means 20%
- ❌ Not checking `.dtypes` after conversion

**Final output:** A clean CSV with properly typed columns and derived columns. Include a cleaning summary cell.

---

### Phase 4 — Database Design & Loading

**Objective:** Move your cleaned data into PostgreSQL with a normalized schema.

**Skills practiced:** SQL DDL, normalization, loading from Python

**Start PostgreSQL on macOS:**
```bash
brew install postgresql@15
brew services start postgresql@15
psql postgres
# Inside psql: CREATE DATABASE superstore_db;
```

**Connect VS Code:** Open SQLTools panel → Add New Connection → PostgreSQL → `localhost:5432 / superstore_db`

**Your tasks:**
1. Design and create 4 tables in `sql/01_schema.sql` (see Section 7 for the schema design)
2. Load dimension tables first (customers, products, locations), then orders
3. Use SQLAlchemy's `df.to_sql()` to load from Python
4. Verify row counts match your CSV

**Beginner mistakes to avoid:**
- ❌ Loading the fact table before dimension tables — foreign key errors will stop you
- ❌ Using `FLOAT` for price/profit — use `NUMERIC` to avoid rounding errors

**Final output:** A running PostgreSQL database with 4 tables and all rows loaded.

---

### Phase 5 — Exploratory Data Analysis

*See Section 4 — Exploratory Data Analysis for full EDA guidance.*

---

### Phase 6 — SQL Analysis

*See Section 3 — SQL Guidance for hints on each analytical question.*

---

### Phase 7 — Visualization

**Objective:** Turn your SQL results into clear charts that tell a business story.

**Your tasks:**
1. Query PostgreSQL using SQLAlchemy + `pd.read_sql()`
2. Apply `sns.set_theme(style='whitegrid')` for consistent styling
3. Build one chart per key finding — aim for 5–6 total
4. Save every chart as a PNG in `reports/`

**Chart title rule — every title states the FINDING, not the topic:**
- ❌ "Profit by Category"
- ✅ "Technology Earns 3× the Margin of Furniture"

**Beginner mistakes to avoid:**
- ❌ Leaving bar charts unsorted — always sort by value
- ❌ Missing axis labels — always include units (USD, %, days)
- ❌ Pie charts with more than 5 slices

---

### Phase 8 — Insight Generation & Presentation

**Your tasks:**
1. Write `reports/insights_summary.md` with at least 5 findings:
```
FINDING: [One sentence stating the fact]
EVIDENCE: [Specific numbers that support it]
SO WHAT: [Why it matters — implication or recommendation]
```
2. Update `README.md` with overview, screenshot, how to run, and 3 key findings

---

## 3. SQL Guidance

Practice SQL like a junior analyst on a real retail dataset. For every task: read the concept, understand the logic, then write the query yourself.

---

### 3.1 — Database Creation

**Concept:** Before writing any queries, you need a database container for your tables.

**What to do:** Create a database named `superstore_db`

**Hint:** Use `CREATE DATABASE` in your terminal via `psql`, then connect to it in VS Code's SQLTools before running any `CREATE TABLE` statements.

---

### 3.2 — Table Design

**Concept:** The raw CSV is one flat file. In a real database, you split repeated data into separate tables — this is called normalization. Each table represents one "thing."

**What to do — create four tables:**

**Table: `customers`**
- Stores: a unique customer identifier, full name, and segment
- Hint: which column in the CSV is already a unique customer ID? Use that as your primary key.
- Hint: use `VARCHAR(20)` for short IDs, `VARCHAR(100)` for names

**Table: `products`**
- Stores: product identifier, product name, category, sub-category
- Hint: product names are long — which data type handles unlimited text length?

**Table: `locations`**
- This table doesn't exist in the CSV — you're extracting geographic columns into their own table
- Stores: city, state, region, postal code, country
- Hint: there's no natural location ID in the CSV, so generate one using `SERIAL PRIMARY KEY`

**Table: `orders`**
- This is your fact table — every row is one transaction line
- Stores: order ID, ship mode, dates, foreign keys to the 3 tables above, and numeric measures (sales, quantity, discount, profit, derived columns)
- Hint: one order ID can appear multiple times (one per product), so `(order_id, product_id)` together form the primary key — this is a composite primary key

**Data type reference:**

| Data | Type to use |
|------|-------------|
| Money / decimals | `NUMERIC(12, 2)` |
| Short IDs / codes | `VARCHAR(50)` |
| Long text | `TEXT` |
| Dates | `DATE` |
| True/False | `BOOLEAN` |
| Whole numbers | `INTEGER` |

---

### 3.3 — Data Import

**Concept:** You load your cleaned CSV into PostgreSQL using Python. Order matters — load referenced tables before the table that references them.

**Loading order:**
1. `customers`
2. `products`
3. `locations`
4. `orders` (references all three above)

**Hints:**
- Use `sqlalchemy.create_engine()` to connect
- Use `df.to_sql(table_name, engine, if_exists='append', index=False)` to load
- After loading, run `SELECT COUNT(*)` on each table to verify

---

### 3.4 — SELECT Queries (Basic Exploration)

**Concept:** Before complex analysis, get comfortable reading your data. These are warm-up queries.

**Task A — Dataset summary:** How many unique customers, orders, and products exist?
- Logic: count distinct values, not total rows
- Hint: what keyword do you add inside `COUNT()` to remove duplicates?

**Task B — Overall profit margin:** What is total profit as a percentage of total sales?
- Logic: `SUM(profit) / SUM(sales) × 100`
- Hint: what happens if `SUM(sales)` is zero? Protect against division-by-zero

**Task C — Date range:** What is the earliest and latest order date in the dataset?
- Hint: `MIN()` and `MAX()` work on date columns

---

### 3.5 — GROUP BY and Aggregations

**Concept:** `GROUP BY` splits your data into groups and calculates a summary per group. This is the most-used pattern in analytics SQL.

**Task A — Sales and profit by category:**
- Logic: one row per category, with summed sales and profit
- Hint: `category` lives in `products`, but `profit` lives in `orders` — you need a JOIN

**Task B — Average profit margin by sub-category, worst to best:**
- Logic: average the `profit_margin` column you created during cleaning
- Hint: ascending or descending sort shows "worst first"?

**Task C — Order count by region:**
- Logic: count orders grouped by region
- Hint: `region` lives in `locations` — you need to join it to `orders`

---

### 3.6 — Filtering with WHERE and HAVING

**Concept:** Two different filters. Use the wrong one and you'll get an error or a wrong answer.

```
WHERE  → filters rows  → runs BEFORE GROUP BY
HAVING → filters groups → runs AFTER GROUP BY, can filter on aggregated values
```

**Task A — Sub-categories with negative average margin:**
- Are you filtering on a raw column or an aggregated one?
- Hint: use `HAVING AVG(...) < 0`

**Task B — Orders placed in 2017 with negative profit:**
- Are you filtering on raw row values?
- Hint: use `WHERE` with a date range condition AND a profit condition

**Task C — States with 100+ orders AND over $10K total profit:**
- Both conditions are on aggregated values
- Hint: you can chain multiple conditions in `HAVING` with `AND`

---

### 3.7 — JOINs

**Concept:** Your 4 tables need to be connected when a query needs columns from more than one. `JOIN` (inner join) only keeps rows that match in both tables.

**How the tables connect:**
```
orders.customer_id  → customers.customer_id
orders.product_id   → products.product_id
orders.location_id  → locations.location_id
```

**Task A — Total profit by category** (orders + products)
- Hint: join on the column both tables share

**Task B — Total sales by region** (orders + locations)
- Hint: join on `location_id`

**Task C — Top 10 customers by total profit** (orders + customers)
- Hint: join, group by customer, sort descending, limit to 10

**Task D — Profit margin by category AND region** (3-table join)
- Hint: start from `orders`, join `products`, then join `locations`
- Hint: use table aliases (e.g. `FROM orders o JOIN products p ON ...`) to keep queries readable

---

### 3.8 — Window Functions (Intermediate)

**Concept:** Window functions calculate something across a set of rows without collapsing them like `GROUP BY` does. You get the aggregated value added alongside each original row.

**Two to learn first:**
- `RANK() OVER (PARTITION BY ... ORDER BY ...)` — rank rows within a group
- `SUM() OVER (PARTITION BY ...)` — group total kept on every row

**Task A — Rank customers within their segment by total profit:**
- Logic: every customer gets a rank, but the ranking restarts for each segment
- Hint: `PARTITION BY segment` resets the counter; `ORDER BY total_profit DESC` puts highest first
- Hint: aggregate customer totals in a CTE first, then apply the window function on top

**Task B — Each sub-category's share of total sales:**
- Logic: `sub-category sales / grand total sales × 100`
- Hint: `SUM(sales) OVER ()` with no `PARTITION BY` gives the grand total across all rows

**What is a CTE?**
A CTE (Common Table Expression) is a temporary named result set you define at the top of a query using `WITH name AS (...)`. It makes complex queries readable by breaking them into named steps. Structure only — fill in the logic yourself:

```sql
-- Structure hint only:
WITH your_step_name AS (
    -- write your first aggregation here
)
SELECT ...
FROM your_step_name
-- then apply window functions or further filtering here
```

---

## 4. Exploratory Data Analysis

EDA is not about making pretty charts — it's about asking questions before you know the answers. Do this before SQL analysis. EDA tells you what's worth investigating.

---

### 4.1 — Sales vs. Profit by Category

**Why it matters:** The highest-selling category is not always the most profitable. This mismatch is the central story in this dataset.

**Chart type:** Two horizontal bar charts side by side — one for sales, one for profit

**Suggested titles:**
- "Technology leads in both sales and profit"
- "Furniture generates strong revenue but weak profit"

**Axis labels:** X: Total Sales/Profit (USD) · Y: Category

**Insights to look for:**
- Does the ranking of categories stay the same between sales and profit?
- Which category has the biggest gap between its sales rank and profit rank?

**Possible misleading interpretation:** High sales does not mean high profit. Always compare both — the gap between them is the story.

---

### 4.2 — Profit Distribution (Histogram)

**Why it matters:** Profit has a negative tail — some orders genuinely lose money. The shape of this distribution reveals the scale of the discount problem.

**Chart type:** Histogram

**Suggested title:** "Most orders are profitable — but a meaningful loss-making tail exists"

**Axis labels:** X: Profit (USD) · Y: Number of Orders

**Insights to look for:**
- Where is the peak of the distribution?
- Roughly what percentage of orders fall below zero?
- Are the negative values deep outliers or clustered just below zero?

**Possible misleading interpretation:** The negative values are not data errors — they are real orders where discounts exceeded margin. Do not remove them.

---

### 4.3 — Profit Margin by Sub-Category

**Why it matters:** Sub-category analysis reveals exactly which product lines are dragging down overall profitability. This is where actionable findings live.

**Chart type:** Horizontal bar chart, sorted worst to best, colored red/green by sign

**Suggested title:** "Tables and Bookcases lose money on average — every sale makes things worse"

**Axis labels:** X: Average Profit Margin (%) · Y: Sub-Category

**Insights to look for:**
- Which sub-categories have negative margins?
- Is there a pattern — are multiple Furniture sub-categories struggling?
- Does any Technology sub-category underperform?

**Possible misleading interpretation:** A sub-category with only a few orders may show a misleadingly extreme margin. Consider noting sample size alongside the chart.

---

### 4.4 — Monthly Revenue Trend

**Why it matters:** Time-series analysis shows whether the business is growing, seasonal, or flat — and tests whether you can correctly work with date columns.

**Chart type:** Line chart

**Suggested title:** "Revenue grows year-over-year with a Q4 seasonal spike"

**Axis labels:** X: Month (YYYY-MM) · Y: Total Sales (USD)

**Insights to look for:**
- Is there a clear upward trend year-over-year?
- Is there a seasonal peak? (Many retail businesses spike in Q4)
- Any sudden drops that might indicate missing data?

**Possible misleading interpretation:** Month-to-month noise can obscure the trend. Consider overlaying a 3-month rolling average to show the underlying direction more clearly.

---

### 4.5 — Discount vs. Profit Margin (Scatter Plot)

**Why it matters:** This is the single most revealing chart in the dataset. It directly visualizes the relationship between discounting and profitability.

**Chart type:** Scatter plot

**Suggested title:** "Discounts above 20% consistently produce negative profit margins"

**Axis labels:** X: Discount (%) · Y: Profit Margin (%)

**Insights to look for:**
- At what discount level does margin reliably turn negative?
- Is the relationship linear, or does it accelerate at high discounts?
- Are there any orders with high discounts that are still profitable? (Outliers tell a story too)

**Possible misleading interpretation:** Individual outliers exist at every discount level. The story is in the overall trend — consider adding a trend line. Don't let a few profitable high-discount orders distract from the pattern.

---

### 4.6 — Days to Ship by Ship Mode (Box Plot)

**Why it matters:** Different shipping options promise different speeds. This chart checks whether the data reflects that — and reveals how consistent each mode is.

**Chart type:** Box plot

**Suggested title:** "Standard Class takes 2–3× longer than First Class, with much higher variance"

**Axis labels:** X: Ship Mode · Y: Days to Ship

**Insights to look for:**
- Do medians differ as expected across modes?
- Which mode has the most inconsistent delivery times (widest interquartile range)?
- Are there outliers — orders that took unusually long under any mode?

**Possible misleading interpretation:** Box plots show medians, not averages. If outliers are extreme, the median and mean will differ significantly — don't claim one when you mean the other.

---

### 4.7 — Orders by Region

**Why it matters:** Geographic analysis shows where the business is concentrated and where opportunity may be underleveraged.

**Chart type:** Horizontal bar chart

**Suggested title:** "West and East account for 60% of all orders"

**Axis labels:** X: Number of Orders · Y: Region

**Insights to look for:**
- Does order volume correlate with profitability? (Make a second chart for profit by region)
- Is any region dramatically smaller than the others?

**Possible misleading interpretation:** Order count is not profit. A smaller region with higher profit per order may be more strategically valuable than a larger one.

---

## 5. Analysis Questions

These are the business questions to answer by the end of Phase 6, ordered from basic to complex.

| # | Question | Skills Required |
|---|----------|----------------|
| Q1 | Which category drives the most revenue vs. profit? | GROUP BY, JOIN, aggregation |
| Q2 | Which sub-categories are unprofitable on average? | GROUP BY, HAVING, JOIN |
| Q3 | How does discount level affect profitability? | CASE, GROUP BY, aggregation |
| Q4 | What is the monthly revenue trend — is the business growing? | DATE functions, GROUP BY |
| Q5 | Which customer segment is most valuable? | JOIN, GROUP BY, multiple metrics |
| Q6 | Who are the top 10 customers by total profit? | JOIN, GROUP BY, ORDER BY, LIMIT |
| Q7 | How do customers rank within their segment by profit? | Window function, CTE, RANK |
| Q8 | Which are the 10 most profitable individual products? | JOIN, GROUP BY, ORDER BY |
| Q9 | Which 10 products destroy the most profit? | Same as Q8, sorted ascending |
| Q10 | How does each region perform on sales and margin? | JOIN, GROUP BY, multiple metrics |

---

## 6. Tools & Technologies

| Tool | Why It's Useful | Which Phase |
|------|----------------|-------------|
| **Python** | Data loading, cleaning, automation | All phases |
| **pandas** | DataFrame manipulation and transformation | Phases 2–4 |
| **psycopg2 / SQLAlchemy** | Python ↔ PostgreSQL bridge | Phase 4 |
| **PostgreSQL** | Store normalized data, run analytical SQL | Phases 4–6 |
| **VS Code + SQLTools** | Write and run SQL without leaving your editor | Phases 4–6 |
| **Jupyter Notebook** | Combine code + charts + notes | Phases 5–7 |
| **matplotlib / seaborn** | Build clean, professional charts | Phases 5–7 |
| **Git / GitHub** | Version control + portfolio hosting | All phases |

---

## 7. Database Schema Design

### Why Normalize?

The raw CSV repeats "John Smith, Consumer, West, Technology" on every row John appears in. Normalization stores it once and references it everywhere — cleaner SQL, no redundancy, and it shows employers you understand real database design.

### Schema (Star Schema)

```
              ┌─────────────┐
              │  customers  │
              │─────────────│
              │ customer_id │◄──┐
              │ name        │   │
              │ segment     │   │
              └─────────────┘   │
                                │
┌─────────────┐          ┌──────┴──────────────────┐
│  products   │          │         orders           │
│─────────────│          │──────────────────────────│
│ product_id  │◄─────────┤ order_id (composite PK)  │
│ product_name│          │ product_id (FK)          │
│ category    │          │ customer_id (FK)         │
│ sub_category│          │ location_id (FK)         │
└─────────────┘          │ order_date, ship_date    │
                         │ sales, quantity          │
┌─────────────┐          │ discount, profit         │
│  locations  │          │ profit_margin            │
│─────────────│          │ days_to_ship             │
│ location_id │◄─────────┤ is_unprofitable          │
│ city, state │          └──────────────────────────┘
│ region      │
│ postal_code │
└─────────────┘
```

### Key Design Decisions

| Decision | Reason |
|----------|--------|
| Separate `customers` table | Avoids repeating name + segment on every order row |
| Separate `locations` table | City/State/Region are repeated — normalize them out |
| `orders` as fact table | Every row is a transaction line — the center of analysis |
| `NUMERIC` not `FLOAT` for money | Prevents floating-point rounding errors on financial data |
| Composite PK `(order_id, product_id)` | One order can contain multiple products — both together are unique |

---

## 8. Portfolio & Resume Preparation

### Resume Bullet Points (STAR Format)

```
• Designed and implemented a normalized 4-table PostgreSQL star schema from a
  9,994-row retail dataset, loading data programmatically via SQLAlchemy.

• Wrote 10+ analytical SQL queries using window functions (RANK, PARTITION BY),
  CTEs, and multi-table JOINs to identify that discounts above 20% reliably
  produce negative profit margins — a structural business risk.

• Discovered that Furniture, despite being the second-highest revenue category,
  contributes only 6% of total profit due to aggressive discounting on Tables
  and Bookcases.

• Built 6 publication-quality matplotlib/seaborn charts and wrote a structured
  insight summary following the Finding → Evidence → So What format.
```

### How to Talk About It in Interviews

**"Tell me about a data project you've worked on."**

1. **Context:** "I analyzed 4 years of US retail data — 9,994 orders across furniture, office supplies, and technology."
2. **Challenge:** "The data came as a flat CSV, so I normalized it into a star schema with dimension tables for customers, products, and locations."
3. **What you did:** "I wrote SQL with window functions to rank customers by segment, and used CTEs to analyze how discount levels affect profit margin."
4. **Result:** "I found that any discount above 20% produced a negative average profit margin — and identified the sub-categories where this was worst."
5. **What you learned:** "The most interesting findings are not what sells most, but what costs most — discount-driven margin destruction is invisible without SQL."

---

> 💡 **Final Mentor Advice:** Every interviewer has seen bar charts. What they haven't seen is someone who can look at a flat CSV and say *"this discount policy is destroying profit, and here are the three sub-categories where the damage is worst."* Write the insight summary carefully. That's what gets you the job.

---

*Data Source: Kaggle — Superstore Dataset (originally Sample Superstore by Tableau)*
*Project Type: Portfolio / Learning Project*
*Level: Beginner to Intermediate*
*Stack: Python · pandas · PostgreSQL · SQLAlchemy · Matplotlib · Seaborn · Jupyter · VS Code (macOS)*