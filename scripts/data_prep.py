import datetime
import json
import time
from collections import defaultdict
from pprint import pprint

json_file_path = r"data/cs2/730.json"
output_file = r"temp/steam_data.csv"


def extract_monthly_price_data(data):
    price_monthly_data = defaultdict(lambda: {"total_price": 0, "count": 0})
    for entry in data["data"]:
        month_year = time.strftime("%b-%y", time.localtime(entry["x"] / 1000))
        price_monthly_data[month_year]["total_price"] += entry["y"]
        price_monthly_data[month_year]["count"] += 1

    result = {}
    for month, data in price_monthly_data.items():
        result[month] = {"final_price": round(data["total_price"] / data["count"], 2)}
    return result


def extract_monthly_player_data(data):
    players_monthly_data = defaultdict(
        lambda: {"avg_players": 0, "count": 1, "max_players": 0}
    )
    result = {}
    for entry in data[0]["data"]:
        month_year = time.strftime("%b-%y", time.localtime(entry[0] / 1000))
        entry[1] = 0 if entry[1] == None else entry[1]
        players_monthly_data[month_year]["max_players"] = (
            entry[1]
            if entry[1] > players_monthly_data[month_year]["max_players"]
            else players_monthly_data[month_year]["max_players"]
        )

    for entry in data[1]["data"]:
        month_year = time.strftime("%b-%y", time.localtime(entry[0] / 1000))
        players_monthly_data[month_year]["avg_players"] += entry[1]
        players_monthly_data[month_year]["count"] += 1

    for month, data in players_monthly_data.items():
        result[month] = {
            "avg_players": data["avg_players"] / data["count"],
            "max_players": data["max_players"],
        }
    return result


def extract_monthly_reviews_data(data, start_date):
    start_date = datetime.datetime.strptime(start_date, "%Y-%m-%d")
    monthly_data = defaultdict(lambda: {"positive": 0, "negative": 0, "count": 0})
    positive_reviews = data[0]["data"]
    negative_reviews = data[1]["data"]

    for i in range(len(positive_reviews)):
        current_date = start_date + datetime.timedelta(days=i)
        month_key = current_date.strftime("%b-%y")

        if positive_reviews[i] is not None:
            monthly_data[month_key]["positive"] += positive_reviews[i]
            monthly_data[month_key]["count"] += 1

        if negative_reviews[i] is not None:
            monthly_data[month_key]["negative"] += abs(negative_reviews[i])

    result = {}
    for month, data in monthly_data.items():
        if data["count"] > 0:
            result[month] = {
                "avg_positive": round(data["positive"] / data["count"], 2),
                "avg_negative": round(data["negative"] / data["count"], 2),
                "total_positive_reviews": data["positive"],
                "total_negative_reviews": data["negative"],
            }

    return result


if __name__ == "__main__":
    with open(json_file_path, "r") as file:
        json_data = json.load(file)

    for entry in json_data:
        type = entry["series"][0]["name"]
        if type == "Final price":
            print(extract_monthly_price_data(entry["series"][0]))
        if type == "Players":
            print(extract_monthly_player_data(entry["series"]))
        if type == "Positive reviews":
            print(extract_monthly_reviews_data(entry["series"], "2015-05-13"))
    print("Done")
