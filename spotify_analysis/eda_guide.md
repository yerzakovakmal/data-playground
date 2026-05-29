# Spotify Tracks Exploratory Data Analysis (EDA) Workshop
### 🎓 Mentor Guide: Understanding Your Raw Data Before Cleaning

Before applying any transformations, sanitization, or normalization, a data analyst must conduct **Exploratory Data Analysis (EDA)**. This stage is about observation. We investigate data types, inspect distributions, count missing information, and identify anomalies or duplicates.

This guide provides a hands-on workbook to perform EDA on your raw Spotify dataset. Like your main guide, it uses **unrelated code examples** and **fill-in-the-gap exercises** so you can learn by doing.

---

## 🛠️ Step 1: Initial Dataset Inspection

We start by verifying the shape of the dataset, looking at a random sample of rows, and checking the column types to see what Pandas inferred during the CSV import.

### 📋 Concepts & Generic Syntax
* **Checking types and shapes**: Use `.shape` (rows, columns) and `.info()` (data types, memory usage, non-null counts).
* **Sampling rows**: Instead of always looking at the first 5 rows with `.head()`, use `.sample(n)` to get a randomized slice.
* **Generic Example (Unrelated customer log inspection)**:
  ```python
  import pandas as pd
  logs = pd.read_csv("customer_clicks.csv")
  
  # Shape of logs
  print(f"Log entries: {logs.shape[0]}, Columns: {logs.shape[1]}")
  
  # Sample 3 random rows
  print(logs.sample(3))
  
  # Inspect schema types
  logs.info()
  ```

#### ✏️ Fill-in-the-Gap Exercise (Jupyter Notebook):
```python
import pandas as pd

# TODO: Load your raw CSV file 'data/raw/spotify_tracks.csv'
df = None

# TODO: Print the tuple representing the number of rows and columns in the raw dataset
print("Dataset Shape:")
print(None)

# TODO: Fetch a random sample of 5 rows from the DataFrame to see diverse values
print("\nRandom Dataset Sample:")
print(None)

# TODO: Run the method that prints a concise summary of the columns, non-null counts, and memory usage
print("\nDataFrame Info:")
# df. ...
```

---

## 🔍 Step 2: Descriptive Summary Statistics

We calculate summary metrics for numerical values (mean, standard deviation, quartiles) and count frequencies of categorical variables to understand the distribution of tracks.

### 📋 Concepts & Generic Syntax
* **Numeric Summaries**: `.describe()` computes basic statistical metrics for all numeric columns.
* **Categorical Summaries**: `.value_counts()` lists distinct categories and their frequency counts.
* **Generic Example (Unrelated real estate list summary)**:
  ```python
  # Get metrics for numerical columns (like price, square_feet)
  print(properties.describe())
  
  # Get counts for categorical column (like property_type)
  print(properties['property_type'].value_counts())
  ```

#### ✏️ Fill-in-the-Gap Exercise (Jupyter Notebook):
```python
# TODO: Generate descriptive statistics (mean, min, max, std dev) for all numerical audio features in 'df'
print("Numerical Descriptive Statistics:")
print(None)

# TODO: Count the number of tracks per genre to see if the dataset is balanced across categories
print("\nTracks per Genre:")
# print(df['...']. ... )

# TODO: Check the distribution of the boolean 'explicit' column
print("\nExplicit Track Counts:")
# print(df['...']. ... )
```

---

## 🚨 Step 3: Spotting Nulls, Duplicates, and Anomalies

Before we clean the dataset, we must map out *exactly* what is broken. We check for missing rows, total row duplicates, and duplicate track IDs.

### 📋 Concepts & Generic Syntax
* **Counting Nulls**: `df.isnull().sum()`
* **Finding Duplicate Rows**: `df.duplicated().sum()`
* **Finding Duplicate Primary Keys**: Even if rows are not completely identical, a specific ID column may have duplicates. Use `df['id_column'].duplicated().sum()`.
* **Generic Example (Unrelated orders dataset check)**:
  ```python
  # Count missing values
  print(orders.isnull().sum())
  
  # Count exact row duplicates
  print(orders.duplicated().sum())
  
  # Count duplicate order IDs (keys)
  print(orders['order_id'].duplicated().sum())
  ```

#### ✏️ Fill-in-the-Gap Exercise (Jupyter Notebook):
```python
# TODO: Calculate the total number of missing (null) values in each column
print("Missing values per column:")
print(None)

# TODO: Calculate the total number of completely identical rows across all columns
print("\nTotal duplicate rows:")
print(None)

# TODO: Count how many times the same 'track_id' is repeated in the raw dataset
# (This represents the duplicate track ID challenge we discussed in the main guide)
print("\nRepeated 'track_id' count:")
# print(df['...']. ... )
```

---

## 📈 Step 4: Visualizing Distributions and Outliers

Visual EDA allows you to spot outliers, skewness, and multi-modal distributions that numerical summaries might hide.

### 📊 Plot 1: Popularity Distribution Histogram
* **Concept**: Graph the distribution of popularity scores using Seaborn's `histplot` with a kernel density estimate (`kde=True`) to understand user rating behaviors.
* **Generic Syntax Example**:
  ```python
  import seaborn as sns
  import matplotlib.pyplot as plt
  
  # Plot a histogram with a smooth density curve
  sns.histplot(df['price'], kde=True, color='blue')
  plt.title("Price Distribution")
  plt.show()
  ```

#### ✏️ Fill-in-the-Gap Exercise (Jupyter Notebook):
```python
import matplotlib.pyplot as plt
import seaborn as sns

# TODO: Set a Seaborn plotting theme (e.g. style="whitegrid")
sns.set_theme(style=None)

plt.figure(figsize=(10, 5))
# TODO: Plot the distribution of the 'popularity' column. Enable the KDE line.
# sns.histplot(x=None, kde=None, color="purple")

plt.title("Distribution of Track Popularity Scores", fontsize=12, fontweight='bold')
plt.xlabel("Popularity Score (0-100)")
plt.ylabel("Count")
plt.show()
```

---

### 📊 Plot 2: Spotting Audio Feature Outliers (Boxplots)
* **Concept**: A boxplot shows the median, quartiles, and individual outlier points (points beyond the whiskers). This helps identify anomalous entries or extreme values before database constraints reject them.
* **Generic Syntax Example**:
  ```python
  # Show the spread of values for a variable to spot points beyond the whiskers
  sns.boxplot(y=df['duration'], color='green')
  plt.show()
  ```

#### ✏️ Fill-in-the-Gap Exercise (Jupyter Notebook):
```python
plt.figure(figsize=(10, 4))
# TODO: Draw a horizontal boxplot using Seaborn to visualize outliers in the 'tempo' column
# sns.boxplot(x=None, color="teal")

plt.title("Inspecting Track Tempo (BPM) Outliers", fontsize=12, fontweight='bold')
plt.xlabel("Tempo (Beats Per Minute)")
plt.show()
```

---

### 📊 Plot 3: Exploring Relationships (Tempo vs. Loudness)
* **Concept**: A scatter plot mapping two continuous variables highlights clusters or trends (e.g., do faster tracks tend to be louder?).
* **Generic Syntax Example**:
  ```python
  # Check relation between size and weight
  sns.scatterplot(x="size", y="weight", data=df, alpha=0.5)
  ```

#### ✏️ Fill-in-the-Gap Exercise (Jupyter Notebook):
```python
plt.figure(figsize=(10, 6))
# TODO: Create a scatter plot of 'tempo' on the x-axis and 'loudness' on the y-axis. Set alpha to 0.4 for transparency.
# sns.scatterplot(x=None, y=None, data=None, alpha=None)

plt.title("Relationship Profile: Tempo vs. Loudness", fontsize=12, fontweight='bold')
plt.xlabel("Tempo (BPM)")
plt.ylabel("Loudness (dB)")
plt.grid(True, linestyle="--", alpha=0.5)
plt.show()
```

---

## 📝 Mentoring Notes: EDA Findings Checklist
After running your EDA cells, write down your observations:
- [ ] **Data Types**: Are there any numeric fields imported as strings/objects that need casting?
- [ ] **Nulls**: Which columns contain missing values, and what is your plan for them (drop vs. fill)?
- [ ] **Repeated Keys**: How many unique track IDs exist, and what does this imply for your relational schema primary keys?
- [ ] **Outliers**: Do you see tempo or duration values of `0` that represent invalid audio records?
