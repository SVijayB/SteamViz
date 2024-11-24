import os
import csv
import time
import json

# Path to your JSON file
json_file_path = "data/730/data.json"
output_file = "steam_data.csv"


# Convert UNIX timestamp to "MM/DD/YY" format
def timestamp_to_date(unix_time):
    return time.strftime("%D", time.localtime(unix_time / 1000))


# Write data to CSV
with open(output_file, mode="w", newline="", encoding="utf-8") as file:
    writer = csv.writer(file)
    writer.writerow(
        [
            "appid",
            "date",
            "Avg players (month)",
            "Max players (month)",
            "Price",
            "Positive Reviews",
            "Negative Reviews",
        ]
    )

    # Load JSON data
    with open(json_file_path, "r", encoding="utf-8") as f:
        data = json.load(f)

    # Initialize values
    appid = "cs2"  # Set appid manually or extract it dynamically
    price = None
    positive_reviews, negative_reviews = None, None
    monthly_data = {}

    # Parse JSON data
    for chart in data:
        for series in chart["series"]:
            name = series["name"]
            if name == "Players":
                for point in series["data"]:
                    timestamp, players = point
                    date = timestamp_to_date(timestamp)
                    if date not in monthly_data:
                        monthly_data[date] = {
                            "avg_players": 0,
                            "max_players": 0,
                            "player_count": 0,
                        }
                    if players is not None:
                        monthly_data[date]["avg_players"] += players
                        monthly_data[date]["player_count"] += 1
                        monthly_data[date]["max_players"] = max(
                            players, monthly_data[date]["max_players"]
                        )
            elif name == "Final price":
                price = series["data"][-1]["y"]  # Use the most recent price
            elif name == "Positive reviews":
                positive_reviews = sum(filter(None, series["data"]))
            elif name == "Negative reviews":
                negative_reviews = sum(filter(None, series["data"]))

    # Calculate average players and write rows to CSV
    for date, stats in monthly_data.items():
        avg_players = (
            stats["avg_players"] / stats["player_count"]
            if stats["player_count"] > 0
            else 0
        )
        writer.writerow(
            [
                appid,
                date,
                avg_players,
                stats.get("max_players", 0),
                price,
                positive_reviews,
                negative_reviews,
            ]
        )
