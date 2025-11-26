class_name PlayerTransferData
extends Resource

# Base financial data
@export var base_value: float = 100000.0
@export var marketability: float = 0.5 # 0.0 to 1.0

# Discovery data
# Dictionary of trait_name: { "discovered": bool, "effect": float }
@export var scouting_traits: Dictionary = {}

# Dictionary of metric_name: { "value": float, "discovered": bool }
@export var analyst_metrics: Dictionary = {}

# Hidden issues that can trigger
# Array of Strings, e.g. ["Injury Prone", "Bad Influence", "Homesick"]
@export var latent_issues: Array = []

# Relationship data
@export var agent_id: String = ""

func _init():
	scouting_traits = {}
	analyst_metrics = {}
	latent_issues = []
