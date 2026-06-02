# Data Playground
This repository contains various **data analysis projects, experiments, and practice work** involving real-world datasets. The goal of this repository is to explore different datasets, practice data analysis techniques, and develop skills in **SQL, Python, and data visualization**.

Each project focuses on extracting meaningful insights from data through cleaning, querying, and visualization.

---

## Repo Goals
Purpose of the repository:
- Practice **data analysis and data exploartion**
- Improve **SQL querying and database analysis**
- Work with **real-world datasets(mostly kaggle datasets)**
- Develop **Python-based data analysis**
- Build a portfolio of **data analysis projects**

---

## Technologies Used

The projects in this repository use different tools from the data analysis ecosystem:

- **SQL (SQLite / PostgreSQL)** - data querying and aggregation
- **Python** - data analysis and automation
- **Pandas** - data manipulation
- **Numpy** - numerical calculations
- **Matplotlib / Seaborn** - data visualization
- **Jupyter Notebooks** - exploratory analysis

---

## Repository Structure

```
data-playground
│
├── covid_analysis
│ ├── data
│ ├── sql
│ ├── notebooks
│ └── README.md
└── README.md
```

Each Project folder contains:
- dataset files
- SQL Queries
- Analysis notebooks
- Project specific Documentation (README)

---

## Projects
### Covid-19 Data Analysis

This project analyzes global COVID-19 data using **SQL and Python**

Topics explored include:

- infection rates across countries
- death percentages
- vaccination progress
- global pandemic trends

Project folder:
```
├── README.md
├── data
│   └── raw
│       ├── CovidDeaths.csv
│       └── CovidVaccinations.csv
├── requirements.txt
├── sql
│   ├── analysis.sql
│   ├── clean_nulls.sql
│   ├── cleanup.sql
│   ├── covid_analysis.db
│   └── schema.sql
└── visualizations
    ├── covid_dashboard.png
    ├── tableau
    │   ├── Tableau Table1.xlsx
    │   ├── Tableau Table2.xlsx
    │   ├── Tableau Table3.xlsx
    │   └── tableu table4.xlsx
    ├── tableau.sql
    └── tableu.csv
```
---
### Superstore Sales Analytics

This project analyzes US Superstore sales data using **Python and PostgreSQL**

Topics explored include:

- sales and revenue trends
- customer segment profiling
- product portfolio and profitability
- discount impact and regional performance

Project folder:
```
├── README.md
├── data
│   ├── raw
│   └── processed
├── guide.md
├── insights_summary.md
├── notebooks
│   ├── 00_cleaning.ipynb
│   ├── 01_eda.ipynb
│   └── 02_visualization.ipynb
├── reports
├── requirements.txt
└── sql
    ├── 01_schema.sql
    ├── 02_explore.sql
    ├── 03_sales_analysis.sql
    ├── 04_customer_analysis.sql
    └── 05_product_analysis.sql
```

---

## Future Projects
This repository will continue to grow with new data analysis project

- Spotify Tracks Analysis
- Economic Data Analysis
- Stock Market datasets
- Public Health Statistics
- Data Visualization Dashboards

---

## About Me

I am interested in **data analysis, software development, and problem solving**. This repository serves as a place to document my learning process and share projects built while practicing data analysis techniques.
