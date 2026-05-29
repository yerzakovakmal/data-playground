#!/usr/bin/env python3
import os
import urllib.request

URL = "https://huggingface.co/datasets/maharshipandya/spotify-tracks-dataset/resolve/main/dataset.csv"
OUT_DIR = "/Users/akmalyerzakov/projects/github/data-playground/spotify_analysis/data/raw"
OUT_FILE = os.path.join(OUT_DIR, "spotify_tracks.csv")

def main():
    print(f"Creating directory: {OUT_DIR}")
    os.makedirs(OUT_DIR, exist_ok=True)
    
    print(f"Downloading raw Spotify tracks CSV from HuggingFace...")
    print(f"Source URL: {URL}")
    print(f"Destination: {OUT_FILE}")
    
    try:
        req = urllib.request.Request(URL, headers={'User-Agent': 'Mozilla/5.0'})
        with urllib.request.urlopen(req) as response:
            with open(OUT_FILE, 'wb') as out_f:
                out_f.write(response.read())
        print("Download completed successfully!")
    except Exception as e:
        print(f"Error downloading dataset: {e}")

if __name__ == "__main__":
    main()
