library(tidyverse)
library(hoopR)
library(arrow)
library(lubridate)
library(janitor)

seasons <- 2025L  # adjust / vectorize later

# Load player box scores from hoopR
bx <- hoopR::load_nba_player_box(seasons = seasons)

# Inspect once if needed:
# colnames(bx)

df <- bx |>
  transmute(
    season,
    game_id,
    season_type,
    game_date,
    athlete_id,
    athlete_display_name,
    team_id,
    team_abbreviation,
    opponent_team_id,
    opponent_team_abbreviation,
    minutes = as.numeric(minutes),
    points,
    assists,
    steals,
    blocks,
    turnovers,
    offensive_rebounds,
    defensive_rebounds,
    fouls,
    plus_minus,
    fgm  = field_goals_made,
    fga  = field_goals_attempted,
    fg3m = three_point_field_goals_made,
    fg3a = three_point_field_goals_attempted,
    ftm  = free_throws_made,
    fta  = free_throws_attempted
  ) |>
  mutate(
    # True shooting: pts / (2 * FGA + 0.88 * FTA)
    ts = if_else(
      (2 * fga + 0.88 * fta) > 0,
      points / (2 * fga + 0.88 * fta),
      NA_real_
    )
  )

dir.create("data/processed", showWarnings = FALSE, recursive = TRUE)
arrow::write_parquet(df, "data/processed/player_box_2025.parquet")

message("Saved -> data/processed/player_box_2025.parquet")