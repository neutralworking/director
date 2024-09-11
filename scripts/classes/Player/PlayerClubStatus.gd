extends Node

# Enumerate the different squad statuses
enum SquadStatus {
    UNTOUCHABLE,
    CORE,
    ROTATION,
    DEVELOPMENT,
    LOAN,
    SELL,
    INJURED,
    SUSPENDED,
    UNREGISTERED,
    UTILITY
}

# Dictionary to map squad statuses with their descriptions and potential effects
var squad_statuses = {
    SquadStatus.UNTOUCHABLE: {
        "description": "Essential to the team, not available for transfer.",
        "transfer_status": "Not for sale",
        "importance": 100
    },
    SquadStatus.CORE: {
        "description": "Important player but could be sold for the right price.",
        "transfer_status": "Available for high offers",
        "importance": 90
    },
    SquadStatus.ROTATION: {
        "description": "Regular squad member but not essential, could be sold if a good offer comes in.",
        "transfer_status": "Available",
        "importance": 75
    },
    SquadStatus.DEVELOPMENT: {
        "description": "Young players or those with potential, likely to stay unless loaned.",
        "transfer_status": "Loan or retain",
        "importance": 65
    },
    SquadStatus.LOAN: {
        "description": "Players who would benefit from temporary experience elsewhere.",
        "transfer_status": "Loan",
        "importance": 50
    },
    SquadStatus.SELL: {
        "description": "Available for transfer, not in long-term plans.",
        "transfer_status": "Actively seeking transfer",
        "importance": 30
    },
    SquadStatus.INJURED: {
        "description": "Player is injured and cannot participate until recovered.",
        "transfer_status": "Unavailable",
        "importance": 20
    },
    SquadStatus.SUSPENDED: {
        "description": "Player is suspended and cannot play until the suspension is lifted.",
        "transfer_status": "Unavailable",
        "importance": 20
    },
    SquadStatus.UNREGISTERED: {
        "description": "Player is not registered for the competition.",
        "transfer_status": "Available for loan or sale",
        "importance": 10
    },
    SquadStatus.UTILITY: {
        "description": "Versatile player who can fill multiple roles but may not be first choice in any specific position.",
        "transfer_status": "Available if necessary",
        "importance": 60
    }
}

# Function to get the squad status description
func get_squad_status_description(status: SquadStatus) -> String:
    return squad_statuses[status]["description"]

# Function to get the squad status transfer status
func get_squad_status_transfer_status(status: SquadStatus) -> String:
    return squad_statuses[status]["transfer_status"]

# Function to get the squad status importance
func get_squad_status_importance(status: SquadStatus) -> int:
    return squad_statuses[status]["importance"]

# Example function to calculate the squad value contribution based on squad status
func calculate_squad_value_contribution(player_status: SquadStatus) -> int:
    # Importance of the player's status can be used to adjust their contribution to the overall squad value
    var base_value = 100
    var status_importance = get_squad_status_importance(player_status)
    return base_value * (status_importance / 100.0)

# Function to print all squad statuses for debugging
func print_squad_statuses():
    for status in SquadStatus.values():
        print("Status: ", status, ", Description: ", get_squad_status_description(status),
              ", Transfer Status: ", get_squad_status_transfer_status(status),
              ", Importance: ", get_squad_status_importance(status))