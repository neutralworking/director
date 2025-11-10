
```gdscript
extends Resource
class_name PlayerData

# Basic Info
var name: String
var position: String
var secondary_positions: Array[String]
var age: int
var nationality: String
var overall_rating: int

# Overview Data
var key_strengths: Array[String]
var current_form: String
var contract_status: String
var injury_status: String
var market_value: String

# Scout Report
var playing_style: String
var traits: Array[String]
var strengths: Array[String]
var weaknesses: Array[String]
var scout_rating: float
var scout_notes: String

# Analyst Report
var current_season: Dictionary = {
	"games": 0,
	"goals": 0,
	"assists": 0,
	"pass_accuracy": 0,
	"shots_per_game": 0.0,
	"shots_on_target": 0,
	"tackles": 0
}
var career_stats: Dictionary = {
	"total_games": 0,
	"total_goals": 0,
	"total_assists": 0,
	"goals_per_game": 0.0
}
var trend: String
var recent_seasons: Array[Dictionary]
var key_metrics: Dictionary = {}

# Coach Report
var personality: String
var work_rate: float
var leadership: float
var tactical_fit: String
var morale: String
var attitude: String
var training_performance: float
var coach_recommendation: String

# Medical Report
var fitness_level: int
var condition: String
var current_injuries: Array[Dictionary]
var injury_history: Array[Dictionary]
var injury_proneness: String
var physical_attributes: Dictionary = {}

# PLO Report
var happiness: int
var manager_relationship: int
var teammate_relationship: int
var fan_relationship: int
var concerns: Array[String]
var recent_conversations: Array[Dictionary]
var morale_trend: String

# Contract
var start_date: String
var end_date: String
var weekly_wage: String
var release_clause: String
var promises: Array[Dictionary]
var bonuses: Array[String]
var contract_status_detail: String

# Transfer
var transfer_market_value: String
var value_history: Array[Dictionary]
var interested_clubs: Array[Dictionary]
var transfer_status: String
var asking_price: String
var recent_bids: Array[Dictionary]

# History
var career_timeline: Array[Dictionary]
var achievements: Array[String]
var international_country: String
var international_caps: int
var international_goals: int
var milestones: Array[String]

func _init(p_name: String = "", p_position: String = "") -> void:
	name = p_name
	position = p_position
	overall_rating = 75
	age = 25
	nationality = "Brazil"
```