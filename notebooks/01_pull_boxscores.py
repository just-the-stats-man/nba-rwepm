from nba_api.stats.endpoints import leaguegamefinder
import pandas as pd
import os
os.system('cls' if os.name == 'nt' else 'clear')


# 2024-25 = "2024-25"; change if needed
games = leaguegamefinder.LeagueGameFinder(season_nullable="2024-25").get_data_frames()[0]
print(games.head())
games.to_csv("data/boxscores_sample.csv", index=False)
print("Saved -> data/boxscores_sample.csv")
