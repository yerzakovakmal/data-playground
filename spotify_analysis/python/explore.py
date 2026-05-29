import pandas as pd

csv_path = "data/raw/spotify_tracks.csv"

df = pd.read_csv(csv_path)

print(df.head())