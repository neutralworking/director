SquadValue

extends Node

# Slot weights and values
var slots = {
    "LB1": 90,
    "LB2": 75,
    "LCB1": 85,
    "LCB2": 70,
    "LCB3": 65,
    "RB1": 90,
    "RB2": 75,
    # Add more slots as needed
}

var weighting_factors = {
    "LB1": 1.0,
    "LB2": 0.8,
    "LCB1": 1.0,
    "LCB2": 0.7,
    "LCB3": 0.5,
    "RB1": 1.0,
    "RB2": 0.8,
    # Add corresponding weighting factors
}

# Calculate the Slot Influence Score (SIS)
func calculate_slot_influence_score(player_slots: Array) -> float:
    var sis = 0.0
    
    for slot in player_slots:
        if slots.has(slot) and weighting_factors.has(slot):
            sis += slots[slot] * weighting_factors[slot]
    
    # Normalize SIS by dividing by 1000
    return sis / 1000.0

# Calculate the Adjusted Transfer Value (ATV)
func calculate_adjusted_transfer_value(base_transfer_value: float, player_slots: Array) -> float:
    var sis = calculate_slot_influence_score(player_slots)
    var atv = base_transfer_value * (1 + sis)
    return atv

# Example usage:
func _ready():
    var timber_base_value = 38.0  # In million euros
    var timber_slots = ["LB2", "LCB3"]
    
    var timber_adjusted_value = calculate_adjusted_transfer_value(timber_base_value, timber_slots)
    print("Jurrien Timber's Adjusted Transfer Value: €", timber_adjusted_value, " million")