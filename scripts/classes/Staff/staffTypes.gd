class_name HeadCoach
extends StaffMember

func _init(p_name: String).(p_name, "Head Coach"):
    attributes["technical_coaching"] = 0
    attributes["tactical_coaching"] = 0
    attributes["attacking_coaching"] = 0
    attributes["defending_coaching"] = 0
    attributes["fitness_coaching"] = 0
    attributes["mental_coaching"] = 0
    
    set_weighted_attributes({
        "tactical_knowledge": 1.5,
        "man_management": 1.5,
        "leadership": 1.5,
        "tactical_coaching": 1.3,
        "motivation": 1.2
    })

class_name ChiefScout
extends StaffMember

func _init(p_name: String).(p_name, "Chief Scout"):
    attributes["judging_player_ability"] = 0
    attributes["judging_player_potential"] = 0
    attributes["player_recruitment"] = 0
    attributes["data_analysis"] = 0
    
    set_weighted_attributes({
        "judging_player_ability": 1.5,
        "judging_player_potential": 1.5,
        "player_recruitment": 1.3,
        "leadership": 1.2
    })

# Add more specific staff type classes as needed