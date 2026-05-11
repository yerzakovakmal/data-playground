# 🛒 Superstore Sales — Data Analytics Portfolio Project
### A Complete Beginner-to-Intermediate Guide

> **Your Role:** Junior Data Analyst (learning by doing)
> **Mentor Role:** Senior Data Analyst (structure, hints, direction)
> **Rule:** You build. You interpret. You tell the story.

---

## 📋 Table of Contents

1. [Data Sources](#1-data-sources)
2. [Project Roadmap](#2-project-roadmap)
3. [Analysis Ideas & Questions](#3-analysis-ideas--questions)
4. [Tools & Technologies](#4-tools--technologies)
5. [Database Schema Design](#5-database-schema-design)
6. [Portfolio & Resume Preparation](#6-portfolio--resume-preparation)

---

## 1. Data Sources

### 🥇 Primary Source — Kaggle Superstore Dataset (Recommended)

**What it is:**
The Superstore Sales dataset is one of the most popular datasets for data analytics portfolios. Originally from Tableau's sample data, it's now freely available on Kaggle. No API or account needed — just download and go.

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
- Perfect for practicing joins (you'll split it into normalized tables)
- Employers recognize it — shows you understand classic analytics problems

**Limitations and cleaning issues:**
- Dates stored as strings — need conversion to `DATE` type
- Some products have negative profit (intentional — discounts can exceed margin)
- `Discount` is a decimal ratio (0.2 = 20%) — needs to be communicated clearly in charts
- City/State values are mostly clean, but a few edge cases exist

---

### 🥈 Alternative Source — Sample Superstore (Tableau's version)

**Where to find it:**
Tableau Desktop ships with this file. On macOS, look at:
```
~/Documents/My Tableau Repository/Datasources/
```

This is the same data — use Kaggle's version unless you already have Tableau.

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
   - **PostgreSQL** (Chris Kolkman) — for running SQL directly in VS Code
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

5. Initialize Git:
```bash
git init
echo "venv/\n*.pyc\n.env\ndata/raw/" > .gitignore
git add .
git commit -m "Initial project structure"
```

6. Create a new repo on GitHub and push:
```bash
git remote add origin https://github.com/YOUR_USERNAME/superstore-analysis.git
git branch -M main
git push -u origin main
```

**Beginner mistakes to avoid:**
- ❌ Working in the global Python environment — always activate `venv` first
- ❌ Committing your `data/raw/` folder — large CSVs don't belong on GitHub
- ❌ Skipping `.gitignore` — you'll accidentally commit junk files

**Final output of this phase:** A GitHub repository with clean folder structure and a basic README.

---

### Phase 2 — Data Loading & Inspection

**Objective:** Load the raw CSV and understand exactly what you're working with before touching anything.

**Skills practiced:** pandas basics, data profiling, VS Code + Jupyter workflow

**Your tasks:**

1. Place the downloaded CSV at `data/raw/superstore_raw.csv`

2. Open `notebooks/01_eda.ipynb` in VS Code (make sure your `venv` kernel is selected — bottom right of VS Code)

3. Run these inspection commands:

```python
import pandas as pd

df = pd.read_csv('../data/raw/superstore_raw.csv', encoding='latin-1')

print(df.shape)           # How many rows and columns?
print(df.dtypes)          # What type is each column?
print(df.head())          # What does the data look like?
print(df.isnull().sum())  # Any missing values?
print(df.duplicated().sum())  # Any duplicate rows?
```

4. Write a markdown cell answering these questions:
   - How many rows and columns does the dataset have?
   - Which columns have missing values, and how many?
   - What date range does the data cover?
   - What are the unique values in `Category`, `Segment`, and `Region`?

> **Note:** The encoding `'latin-1'` is often needed for this file. If you get a `UnicodeDecodeError`, that's why.

**Final output:** A notebook cell that prints a full profile of the raw data, with a written summary below it.

---

### Phase 3 — Data Cleaning

**Objective:** Fix data type issues and add derived columns so your SQL analysis is reliable.

**Skills practiced:** pandas type conversion, string cleaning, derived columns, saving processed data

**Your tasks:**

1. In your notebook, complete these cleaning steps:

| Problem | Fix |
|---------|-----|
| `Order Date` is a string | `pd.to_datetime(df['Order Date'])` |
| `Ship Date` is a string | `pd.to_datetime(df['Ship Date'])` |
| Column names have spaces | Rename to snake_case: `df.columns = df.columns.str.lower().str.replace(' ', '_')` |
| `postal_code` loads as float | `df['postal_code'] = df['postal_code'].astype(str)` |

2. Add these derived columns:

```python
# Shipping time in days
df['days_to_ship'] = (df['ship_date'] - df['order_date']).dt.days

# Order year and month for time-series queries
df['order_year']  = df['order_date'].dt.year
df['order_month'] = df['order_date'].dt.month

# Profit margin as a percentage
df['profit_margin'] = (df['profit'] / df['sales'] * 100).round(2)

# Flag unprofitable orders
df['is_unprofitable'] = df['profit'] < 0
```

3. Verify cleaning worked:

```python
print(df.dtypes)
print(df[['order_date', 'ship_date', 'days_to_ship', 'profit_margin']].head(10))
```

4. Save the clean version:

```python
df.to_csv('../data/processed/superstore_clean.csv', index=False)
print(f"Saved {len(df)} rows to processed/")
```

**Beginner mistakes to avoid:**
- ❌ Modifying the raw CSV — always save to `processed/`
- ❌ Not checking `df.dtypes` after conversion — silent type errors are hard to debug later
- ❌ Forgetting that `Discount` is a ratio — 0.2 means 20%, not 20

**Final output:** `data/processed/superstore_clean.csv` with correct types and at least 3 derived columns. Include a cleaning summary cell.

---

### Phase 4 — Database Design & Loading

**Objective:** Move your cleaned data into PostgreSQL with a normalized schema — this is the heart of the SQL portfolio project.

**Skills practiced:** Database normalization, SQL DDL, loading data from Python, psycopg2

**Step 4a — Start PostgreSQL (macOS)**

If you haven't installed PostgreSQL yet:
```bash
brew install postgresql@15
brew services start postgresql@15
```

Create your database:
```bash
psql postgres
CREATE DATABASE superstore_db;
\q
```

**Step 4b — Connect with VS Code**

In VS Code, open the SQLTools panel (left sidebar), click "Add New Connection", choose PostgreSQL, and fill in:
- Host: `localhost`
- Port: `5432`
- Database: `superstore_db`
- Username: your macOS username (no password needed for local)

**Step 4c — Create the schema**

Save this as `sql/01_schema.sql` and run it in VS Code's SQLTools:

```sql
-- DIMENSION: Customers
CREATE TABLE customers (
    customer_id   VARCHAR(20) PRIMARY KEY,
    customer_name VARCHAR(100),
    segment       VARCHAR(30)
);

-- DIMENSION: Locations
CREATE TABLE locations (
    location_id SERIAL PRIMARY KEY,
    city        VARCHAR(100),
    state       VARCHAR(100),
    region      VARCHAR(20),
    postal_code VARCHAR(10),
    country     VARCHAR(50)
);

-- DIMENSION: Products
CREATE TABLE products (
    product_id   VARCHAR(50) PRIMARY KEY,
    product_name TEXT,
    category     VARCHAR(50),
    sub_category VARCHAR(50)
);

-- FACT: Orders
CREATE TABLE orders (
    order_id       VARCHAR(30),
    order_date     DATE NOT NULL,
    ship_date      DATE,
    ship_mode      VARCHAR(30),
    customer_id    VARCHAR(20) REFERENCES customers(customer_id),
    location_id    INTEGER REFERENCES locations(location_id),
    product_id     VARCHAR(50) REFERENCES products(product_id),
    sales          NUMERIC(12, 2),
    quantity       INTEGER,
    discount       NUMERIC(5, 4),
    profit         NUMERIC(12, 2),
    days_to_ship   INTEGER,
    profit_margin  NUMERIC(8, 2),
    is_unprofitable BOOLEAN,
    PRIMARY KEY (order_id, product_id)
);
```

**Step 4d — Load data from Python**

```python
from sqlalchemy import create_engine
import pandas as pd

df = pd.read_csv('../data/processed/superstore_clean.csv')
engine = create_engine('postgresql://localhost/superstore_db')

# Load dimension tables first (to satisfy foreign keys)
customers = df[['customer_id', 'customer_name', 'segment']].drop_duplicates()
customers.to_sql('customers', engine, if_exists='append', index=False)

products = df[['product_id', 'product_name', 'category', 'sub_category']].drop_duplicates()
products.to_sql('products', engine, if_exists='append', index=False)

# Locations need a surrogate key — handled in Python
locations = df[['city', 'state', 'region', 'postal_code', 'country']].drop_duplicates().reset_index(drop=True)
locations.index += 1  # start at 1
locations.index.name = 'location_id'
locations.to_sql('locations', engine, if_exists='append')

# Merge location_id back to main df for orders table
df = df.merge(locations.reset_index(), on=['city', 'state', 'region', 'postal_code', 'country'])
orders_cols = ['order_id', 'order_date', 'ship_date', 'ship_mode', 'customer_id',
               'location_id', 'product_id', 'sales', 'quantity', 'discount',
               'profit', 'days_to_ship', 'profit_margin', 'is_unprofitable']
df[orders_cols].to_sql('orders', engine, if_exists='append', index=False)

print("All tables loaded.")
```

**Step 4e — Verify the load**

In VS Code's SQLTools, run:
```sql
SELECT COUNT(*) FROM orders;
SELECT COUNT(*) FROM customers;
SELECT COUNT(*) FROM products;
SELECT COUNT(*) FROM locations;
```

**Final output:** A running PostgreSQL database with 4 tables and all 9,994 rows loaded.

---

### Phase 5 — Exploratory Data Analysis (EDA)

**Objective:** Understand distributions and patterns in the data before running targeted SQL queries.

**Skills practiced:** pandas describe, matplotlib histograms, bar charts, written observations

**Your tasks:**

1. In `notebooks/01_eda.ipynb`, run these checks:

```python
df = pd.read_csv('../data/processed/superstore_clean.csv')

print(df.describe())
print(df['category'].value_counts())
print(df['region'].value_counts())
print(df['segment'].value_counts())
print(df['ship_mode'].value_counts())
```

2. Build these charts using **matplotlib** (no Plotly needed for EDA):

```python
import matplotlib.pyplot as plt
import matplotlib.ticker as mticker

# Chart 1: Sales distribution by category
fig, ax = plt.subplots(figsize=(8, 5))
df.groupby('category')['sales'].sum().sort_values().plot(kind='barh', ax=ax, color='steelblue')
ax.set_title('Total Sales by Category')
ax.set_xlabel('Sales (USD)')
ax.xaxis.set_major_formatter(mticker.FuncFormatter(lambda x, _: f'${x:,.0f}'))
plt.tight_layout()
plt.savefig('../reports/eda_category_sales.png', dpi=150)
plt.show()
```

3. Build at least 5 EDA charts:
   - Histogram of `profit` (note the negative tail)
   - Bar chart of average `profit_margin` by `category`
   - Bar chart of orders by `region`
   - Box plot of `days_to_ship` by `ship_mode`
   - Scatter plot of `sales` vs `profit` (colored by `category`)

4. After each chart, write a markdown cell answering: *"What does this tell me?"*

**Beginner mistakes to avoid:**
- ❌ Skipping EDA and writing SQL immediately — you'll query the wrong things
- ❌ Not saving charts as PNGs — you'll need them for your README
- ❌ Ignoring negative profits — they're one of the most interesting stories in this dataset

**Final output:** A Jupyter notebook with 5+ charts, each with a written observation cell.

---

### Phase 6 — SQL Analysis

**Objective:** Answer specific business questions using SQL against your PostgreSQL database.

**Skills practiced:** GROUP BY, HAVING, JOINs, window functions, CTEs, date functions

Write each query block into its corresponding `.sql` file. Comment every query with the business question it answers.

---

**`sql/02_explore.sql` — Basic exploration**

```sql
-- How many unique customers, orders, and products do we have?
SELECT
    COUNT(DISTINCT customer_id) AS unique_customers,
    COUNT(DISTINCT order_id)    AS unique_orders,
    COUNT(DISTINCT product_id)  AS unique_products
FROM orders;

-- What is the overall profit margin?
SELECT
    ROUND(SUM(profit) / NULLIF(SUM(sales), 0) * 100, 2) AS overall_profit_margin_pct
FROM orders;

-- Date range of the dataset
SELECT MIN(order_date), MAX(order_date) FROM orders;
```

---

**`sql/03_sales_analysis.sql` — Sales & profit patterns**

```sql
-- Q1: Which category drives the most revenue vs. the most profit?
SELECT
    p.category,
    ROUND(SUM(o.sales), 2)  AS total_sales,
    ROUND(SUM(o.profit), 2) AS total_profit,
    ROUND(SUM(o.profit) / NULLIF(SUM(o.sales), 0) * 100, 2) AS profit_margin_pct
FROM orders o
JOIN products p USING (product_id)
GROUP BY p.category
ORDER BY total_sales DESC;

-- Q2: Which sub-categories are unprofitable on average?
SELECT
    p.sub_category,
    ROUND(AVG(o.profit_margin), 2) AS avg_margin,
    COUNT(*) FILTER (WHERE o.is_unprofitable) AS unprofitable_orders,
    COUNT(*) AS total_orders
FROM orders o
JOIN products p USING (product_id)
GROUP BY p.sub_category
HAVING AVG(o.profit_margin) < 0
ORDER BY avg_margin;

-- Q3: How does discount level affect profitability?
-- Hint: Use CASE to bucket discounts
SELECT
    CASE
        WHEN discount = 0       THEN 'No discount'
        WHEN discount <= 0.10   THEN '1–10%'
        WHEN discount <= 0.20   THEN '11–20%'
        WHEN discount <= 0.40   THEN '21–40%'
        ELSE                         '40%+'
    END AS discount_bucket,
    COUNT(*) AS orders,
    ROUND(AVG(profit_margin), 2) AS avg_profit_margin
FROM orders
GROUP BY 1
ORDER BY MIN(discount);

-- Q4: Monthly revenue trend — is the business growing?
SELECT
    DATE_TRUNC('month', order_date) AS month,
    ROUND(SUM(sales), 2)            AS monthly_sales
FROM orders
GROUP BY 1
ORDER BY 1;
```

---

**`sql/04_customer_analysis.sql` — Customer behavior**

```sql
-- Q5: Which customer segment is most valuable?
SELECT
    c.segment,
    COUNT(DISTINCT o.order_id)  AS orders,
    ROUND(SUM(o.sales), 2)      AS total_sales,
    ROUND(SUM(o.profit), 2)     AS total_profit,
    ROUND(AVG(o.sales), 2)      AS avg_order_value
FROM orders o
JOIN customers c USING (customer_id)
GROUP BY c.segment
ORDER BY total_profit DESC;

-- Q6: Top 10 customers by total profit contributed
SELECT
    c.customer_name,
    c.segment,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(o.profit), 2)    AS total_profit
FROM orders o
JOIN customers c USING (customer_id)
GROUP BY c.customer_id, c.customer_name, c.segment
ORDER BY total_profit DESC
LIMIT 10;

-- Q7: Customer ranking using a window function
-- Rank customers within each segment by their total profit contribution
WITH customer_profit AS (
    SELECT
        c.customer_id,
        c.customer_name,
        c.segment,
        ROUND(SUM(o.profit), 2) AS total_profit
    FROM orders o
    JOIN customers c USING (customer_id)
    GROUP BY c.customer_id, c.customer_name, c.segment
)
SELECT
    segment,
    customer_name,
    total_profit,
    RANK() OVER (PARTITION BY segment ORDER BY total_profit DESC) AS rank_in_segment
FROM customer_profit
WHERE rank_in_segment <= 3;
```

---

**`sql/05_product_analysis.sql` — Product insights**

```sql
-- Q8: Top 10 most profitable individual products
SELECT
    p.product_name,
    p.category,
    ROUND(SUM(o.profit), 2) AS total_profit,
    COUNT(*) AS times_ordered
FROM orders o
JOIN products p USING (product_id)
GROUP BY p.product_id, p.product_name, p.category
ORDER BY total_profit DESC
LIMIT 10;

-- Q9: Worst 10 products — biggest profit destroyers
SELECT
    p.product_name,
    p.category,
    ROUND(SUM(o.profit), 2) AS total_profit
FROM orders o
JOIN products p USING (product_id)
GROUP BY p.product_id, p.product_name, p.category
ORDER BY total_profit
LIMIT 10;

-- Q10: Regional performance comparison
SELECT
    l.region,
    ROUND(SUM(o.sales), 2)  AS total_sales,
    ROUND(SUM(o.profit), 2) AS total_profit,
    ROUND(AVG(o.profit_margin), 2) AS avg_margin
FROM orders o
JOIN locations l USING (location_id)
GROUP BY l.region
ORDER BY total_profit DESC;
```

**Beginner mistakes to avoid:**
- ❌ Using `SELECT *` in analytical queries — always name your columns
- ❌ Dividing by zero — always wrap denominators in `NULLIF(..., 0)`
- ❌ Forgetting `HAVING` when filtering on aggregated values (can't use `WHERE` on `SUM()`)

**Final output:** 5 SQL files with 10+ well-commented queries.

---

### Phase 7 — Visualization

**Objective:** Turn your SQL results into clear charts that tell a business story.

**Skills practiced:** matplotlib, seaborn, chart selection, annotation, storytelling with data

**Your tasks:**

In `notebooks/02_visualization.ipynb`, build one chart per key finding. Use matplotlib (with seaborn for styling):

```python
import matplotlib.pyplot as plt
import seaborn as sns
import pandas as pd
from sqlalchemy import create_engine

engine = create_engine('postgresql://localhost/superstore_db')
sns.set_theme(style='whitegrid', palette='muted')
```

**Chart 1: Profit margin by category (horizontal bar)**
```python
df = pd.read_sql("""
    SELECT p.category,
           ROUND(SUM(o.profit)/NULLIF(SUM(o.sales),0)*100, 2) AS profit_margin_pct
    FROM orders o JOIN products p USING (product_id)
    GROUP BY p.category ORDER BY profit_margin_pct
""", engine)

fig, ax = plt.subplots(figsize=(8, 4))
bars = ax.barh(df['category'], df['profit_margin_pct'], color=['#e74c3c', '#f39c12', '#2ecc71'])
ax.set_title('Technology Outperforms — Furniture Barely Breaks Even', fontsize=13, fontweight='bold')
ax.set_xlabel('Profit Margin (%)')
ax.axvline(0, color='black', linewidth=0.8)
for bar, val in zip(bars, df['profit_margin_pct']):
    ax.text(val + 0.2, bar.get_y() + bar.get_height()/2, f'{val}%', va='center')
plt.tight_layout()
plt.savefig('../reports/chart_margin_by_category.png', dpi=150)
```

**Chart standards to apply to every chart:**
- Title states the **finding**, not just the topic
  - ❌ "Profit by Region"
  - ✅ "West Region Drives 37% of Total Profit Despite 22% of Orders"
- Axes are labeled with units
- Bar charts are sorted by value
- Consistent color palette throughout all charts

**Final output:** 5–6 charts saved as PNGs in `reports/`, ready for your README.

---

### Phase 8 — Insight Generation & Presentation

**Objective:** Write structured findings that a non-technical stakeholder can understand and act on.

**Your tasks:**

1. Write `reports/insights_summary.md` with at least 5 findings using this structure:

```
FINDING: Furniture is the least profitable category despite being the second-highest in sales.
EVIDENCE: Furniture generates 31% of total sales but only 6% of total profit, with a margin of 2.5%.
SO WHAT: The company should review high-discount furniture SKUs and consider tightening discount policy
         for this category — especially Tables, which has a negative average profit margin of –8.6%.
```

2. Update your `README.md`:

```markdown
# 🛒 Superstore Sales — Data Analytics Project

## Overview
End-to-end SQL analytics project on 4 years of US retail sales data (9,994 orders).
Covers data cleaning, PostgreSQL schema design, 10+ SQL queries, and matplotlib visualizations
to uncover profitability drivers and customer segment insights.

## Key Findings
- Technology accounts for 50% of total profit on only 36% of revenue
- High discounts (>40%) reliably produce negative profit margins — a structural business risk
- The Corporate segment generates 32% of profit from only 30% of orders — the most efficient segment

## Tech Stack
Python · pandas · PostgreSQL · SQLAlchemy · Matplotlib · Seaborn · Jupyter Notebook

## How to Run
```bash
pip install -r requirements.txt
# Set up PostgreSQL and run sql/01_schema.sql
jupyter notebook notebooks/
```

## Data Source
Kaggle — Superstore Dataset (Sample Superstore, originally from Tableau)
```

---

## 3. Analysis Ideas & Questions

### Q1 — Which categories and sub-categories are most/least profitable?

**Why it matters:** The most-sold category is not always the most profitable. This reveals where discounts are eroding margin.

**Suggested chart:** Horizontal bar chart — profit margin % by sub-category, colored red/green by positive/negative.

---

### Q2 — How do discounts affect profitability?

**Why it matters:** This dataset has a well-known pattern — discounts above 20% tend to destroy profit. Quantifying this is a strong analytical finding.

**Suggested chart:** Bar chart — avg profit margin by discount bucket. The trend should be clearly negative.

---

### Q3 — Which customer segments drive the most value?

**Why it matters:** Not all customers are equal. If Corporate customers order less often but generate more profit per order, that changes sales strategy.

**Suggested chart:** Grouped bar — orders, revenue, profit side by side by segment.

---

### Q4 — How is revenue trending over time?

**Why it matters:** Identifies whether the business is growing, seasonal, or stagnating — and shows you can do time-series analysis.

**Suggested chart:** Line chart — monthly sales from 2014–2018 with year-over-year annotation.

---

### Q5 — Which regions are most profitable, and why?

**Why it matters:** Geographic analysis shows spatial thinking and connects SQL to business geography.

**Suggested chart:** Horizontal bar chart — profit by region, with average margin annotated.

---

### Q6 — Which products are profit destroyers?

**Why it matters:** Identifying the specific SKUs with persistent negative profit is high-value analysis for a retail business.

**Suggested chart:** Table with color encoding — bottom 10 products by total profit.

---

### Q7 — How long does shipping take, and does it affect satisfaction?

**Why it matters:** Shipping time can be connected to ship mode and region — this is operational analysis.

**Suggested chart:** Box plot — days to ship by ship mode (Standard Class vs. First Class, etc.).

---

## 4. Tools & Technologies

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

## 5. Database Schema Design

### Why Normalize the Data?

The raw CSV is a single flat file — every row repeats "John Smith, Consumer, West, Technology" even if John has 50 orders. Normalizing means:
- No duplicate data — customer name lives in one place
- Cleaner SQL — you join to get what you need
- Demonstrates you understand how production databases actually work

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
│ product_id  │◄─────────┤ order_id (PK)            │
│ product_name│          │ product_id (FK)          │
│ category    │          │ customer_id (FK)         │
│ sub_category│          │ location_id (FK)         │
└─────────────┘          │ order_date               │
                         │ ship_date                │
┌─────────────┐          │ sales, quantity          │
│  locations  │          │ discount, profit         │
│─────────────│          │ profit_margin            │
│ location_id │◄─────────┤ days_to_ship             │
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
| Composite PK on orders `(order_id, product_id)` | One order can have multiple products — this is correct |

---

## 6. Portfolio & Resume Preparation

### Resume Bullet Points (STAR Format)

```
• Designed and implemented a normalized 4-table PostgreSQL star schema from a 
  9,994-row retail dataset, loading data programmatically via SQLAlchemy.

• Wrote 10+ analytical SQL queries using window functions (RANK, PARTITION BY),
  CTEs, and multi-table JOINs to identify that discounts above 20% reliably 
  produce negative profit margins — a structural business risk.

• Discovered that Furniture, despite being the second-highest sales category, 
  contributes only 6% of total profit due to aggressive discounting on Tables 
  and Bookcases.

• Built 6 publication-quality matplotlib/seaborn charts and wrote a structured 
  insight summary following the Finding → Evidence → So What format.
```

### Interview Talking Points

**"Tell me about a data project you've worked on."**

1. **Context:** "I analyzed 4 years of retail sales data for a US superstore — 9,994 orders across furniture, office supplies, and technology."
2. **Challenge:** "The data came as a flat CSV, so I normalized it into a star schema with dimension tables for customers, products, and locations."
3. **What you did:** "I wrote SQL queries using window functions to rank customers by segment and used CTEs to analyze how discount levels affect profit margins."
4. **Result:** "I found that any discount above 20% produced a negative average profit margin — and identified the specific sub-categories where this was worst. That's an immediately actionable business insight."
5. **What you learned:** "I learned that the most interesting findings are often not what sells most, but what costs most — negative profit from discounting is a silent margin leak."

---

> 💡 **Final Mentor Advice:** Every interviewer has seen bar charts. What they haven't seen is a candidate who can look at a flat CSV and say *"this discount policy is destroying profit, and here are the three sub-categories where the damage is worst."* Write the insight summary carefully. That's what gets you the job.

---

*Data Source: Kaggle — Superstore Dataset (originally Sample Superstore, Tableau)*
*Project Type: Portfolio / Learning Project*
*Level: Beginner to Intermediate*
*Stack: Python · pandas · PostgreSQL · SQLAlchemy · Matplotlib · Seaborn · Jupyter · VS Code (macOS)*