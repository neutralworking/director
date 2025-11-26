class_name Club
extends Resource

@export var name: String
@export var reputation: int = 5000 # 0-10000
@export var budget: int = 1000000
@export var squad: Array = [] # Array of Player objects
@export var color_primary: Color = Color.BLUE
@export var color_secondary: Color = Color.WHITE

func _init(p_name: String = "", p_reputation: int = 5000):
	name = p_name
	reputation = p_reputation
	squad = []
