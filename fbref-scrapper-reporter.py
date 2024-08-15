import requests
from bs4 import BeautifulSoup
import re

def get_fbref_url(player_name):
    # Normalize player name for search URL
    player_name_formatted = player_name.lower().replace(' ', '-')
    return f"https://fbref.com/en/players/{player_name_formatted}/scout/365_m1/"

def fetch_scouting_report(player_name):
    url = get_fbref_url(player_name)
    response = requests.get(url)
    
    if response.status_code != 200:
        print(f"Failed to retrieve data for {player_name}")
        return None
    
    return response.content

def parse_scouting_report(html_content):
    soup = BeautifulSoup(html_content, 'html.parser')
    
    # Dictionary to store attribute percentiles
    attributes = {}
    
    # Extract relevant data from the table
    tables = soup.find_all('table')
    for table in tables:
        if "Scouting Report" in table.text:
            rows = table.find_all('tr')
            for row in rows:
                columns = row.find_all('td')
                if len(columns) > 0:
                    stat_name = columns[0].text.strip()
                    percentile = columns[-1].text.strip()
                    # Store in attributes dictionary
                    attributes[stat_name] = int(percentile)
    
    return attributes

def calculate_attribute_rating(percentile):
    if percentile >= 90:
        return 'Excellent'
    elif percentile >= 70:
        return 'Good'
    elif percentile >= 50:
        return 'Average'
    elif percentile >= 30:
        return 'Poor'
    else:
        return 'Terrible'

def generate_player_metrics(attributes):
    player_metrics = {}
    # Example mapping based on the provided table
    mapping = {
        "Goals": "Finishing",
        "Assists": "Vision",
        "Dribbles Completed": "Dribbling",
        "Tackles": "Tackling",
        "Interceptions": "Anticipation",
        "Pass Completion %": "Passing Accuracy",
        "Aerial Duels Won": "Aerial Duels",
        "Touches": "Ball Control"
        # Add more mappings based on your attributes and the scouting report
    }
    
    for stat, attribute in mapping.items():
        if stat in attributes:
            percentile = attributes[stat]
            rating = calculate_attribute_rating(percentile)
            player_metrics[attribute] = rating
    
    return player_metrics

def main():
    player_name = input("Enter the player's name: ")
    
    html_content = fetch_scouting_report(player_name)
    
    if html_content:
        attributes = parse_scouting_report(html_content)
        player_metrics = generate_player_metrics(attributes)
        
        print(f"Player Metrics for {player_name}:")
        for attribute, rating in player_metrics.items():
            print(f"{attribute}: {rating}")

if __name__ == "__main__":
    main()
