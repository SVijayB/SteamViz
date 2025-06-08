import pandas as pd

# Load the main CSV
df = pd.read_csv(
    r"D:\CS\GitHub\SteamViz\data\data514\main.csv", encoding="unicode_escape"
)

# GAME table
game_cols = [
    "appid",
    "name",
    "type",
    "required_age",
    "is_free",
    "short_description",
    "capsule_image",
    "release_date",
    "platforms",
    "metacritic_score",
    "movies",
]
df[game_cols].drop_duplicates(subset=["appid"]).to_csv("GAME.csv", index=False)

# SYSTEMREQUIREMENTS table
systemreq_cols = ["appid", "simplified_os", "os", "cpu", "gpu", "ram_gb", "storage_gb"]
df[systemreq_cols].drop_duplicates().to_csv("SYSTEMREQUIREMENTS.csv", index=False)

# COMPANIES table
companies_cols = ["appid", "developers", "publishers"]
df[companies_cols].drop_duplicates().to_csv("COMPANIES.csv", index=False)

# CATEGORIES table
categories_cols = [
    "appid",
    "categories",
]  # Note: If multiple categories per game, you may need to explode this
df[categories_cols].drop_duplicates().to_csv("CATEGORIES.csv", index=False)

print("Done splitting files!")
