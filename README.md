# Spotify Chart Analysis

This project analyzes global Spotify chart data to uncover trends in song retention, repeat appearances, volatility, and country-level synchronization with global hits.

Built with SQL, Python, and Power BI, this dashboard showcases data modeling, transformation, and storytelling — ideal for demonstrating end-to-end analytics skills.

---

## 🛠 Tech Stack

- **PostgreSQL** – schema design, indexing, and analytical views
- **Python (pandas + SQLAlchemy)** – for data cleaning and database upload
- **Power BI** – for visualizing KPIs, map overlays, and time-based trends
- **Jupyter Notebooks** – for cleaning, transforming, and uploading data

---

## 📁 Folder Structure
```spotify-chart-analysis/
  ├── notebooks/ # Jupyter notebooks for data cleaning & feature engineering
  ├── powerbi/ # Power BI dashboard file (.pbix)
  ├── sql/ # SQL DDLs, indexes, and analytical views
```
---

## 📊 Dashboard Features

- 🌍 **Volatility Map** – highlights which countries experience the most chart shifts
- 📈 **Turnover Line Chart** – tracks the % of new songs entering weekly
- 🔁 **Repeat Ratio Bar Chart** – shows countries with frequent re-entries
- 🔗 **Country Sync Score** – how aligned each country is with global top 10
- 📌 **KPI Cards** – Global average retention, peak turnover, total unique songs

---

## 🧮 SQL Overview (`/sql/`)

### Tables:
- `spotify_daily`
- `spotify_volatility`
- `spotify_trend_duration`
- `spotify_volatility_by_country`

### Views:
- `vw_weekly_chart_turnover`
- `vw_country_retention_score`
- `vw_repeat_appearance_ratio`
- `vw_country_sync_score`
- `top_avg_songs_by_country`
- `longest_trending_songs`

---

## 🧼 Data Processing (Python Notebook)

Handled in `notebooks/01_data_load_and_clean.ipynb`:

- Loads and cleans raw Spotify chart data
- Standardizes column types and names
- Adds `country_short` for cleaner visuals
- Uploads to PostgreSQL using:

```python
from sqlalchemy import create_engine
import pandas as pd

engine = create_engine("postgresql://username:password@localhost:5432/spotify")

cleaned_df.to_sql("spotify_daily", con=engine, index=False, if_exists="append", method="multi")
```
🔄 Ensure tables are truncated beforehand to avoid duplication.

---

📈 Power BI Dashboard
📍 File: powerbi/spotify-powerbi.pbix

- Connected directly to SQL views for modular performance

- Cool-toned dark theme for visual clarity

- Map, line, bar, and donut visuals with synced filters

🔍 Sample Insights
🔁 Ireland has the highest repeat hit ratio

🔗 Australia is most aligned with global hits

⚡ July 2024 showed the highest chart turnover (39%)

---

🚀 How to Run
1. Set up a PostgreSQL database

2. Run SQL scripts from /sql/:
  ```
  01_create_tables.sql
  02_create_indexes.sql
  04_create_views.sql
```

3. Open and run notebooks/01_data_load_and_clean.ipynb

4. Open spotify-powerbi.pbix in Power BI Desktop

5. Refresh and explore the dashboard

---

👤 Author
```
Saif Almurqi
📫 cssaif.o@gmail.com
🔗 www.linkedin.com/in/saif-m-m
```
---

## 🏷 Tags

`#PowerBI` `#SQL` `#SpotifyAnalytics` `#DataAnalytics` `#PortfolioProject`
