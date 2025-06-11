DROP TABLE IF EXISTS spotify_daily;
DROP TABLE IF EXISTS spotify_volatility;
DROP TABLE IF EXISTS spotify_trend_duration;
DROP TABLE IF EXISTS spotify_volatility_by_country;

CREATE TABLE spotify_daily (
    spotify_id TEXT,
    song_name TEXT,
    artists TEXT,
    country TEXT,
    snapshot_date DATE,
    daily_rank INT,
    daily_movement INT,
    weekly_movement INT,
    popularity INT,
    is_global BOOLEAN,
    week_start DATE,
    year INT,
	PRIMARY KEY (spotify_id, snapshot_date, country)
);
CREATE TABLE spotify_volatility (
	spotify_id TEXT PRIMARY KEY,
	song_name TEXT,
	volatility_score INT
);
CREATE TABLE spotify_trend_duration(
	spotify_id TEXT PRIMARY KEY,
	song_name TEXT,
	first_appearance DATE,
	last_appearance DATE,
	days_in_chart INT,
	trend_duration INT
);
CREATE TABLE spotify_volatility_by_country(
	country TEXT,
	volatility_score_by_country FLOAT
);