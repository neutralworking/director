class_name Club
extends Resource

@export var name: String
@export var reputation: int = 5000 # 0-10000
@export var budget: int = 1000000
@export var squad: Array = [] # Array of Player objects
@export var color_primary: Color = Color.BLUE
@export var color_secondary: Color = Color.WHITE

# Transfer market attributes
@export var philosophy: String = "Balanced"  # "Academy", "Win Now", "Balanced"
@export var squad_needs: Dictionary = {}  # position -> priority (1-10)
@export var rival_clubs: Array = []  # Array of club names
@export var financial_strength: int = 5  # 1-10 scale

func _init(p_name: String = "", p_reputation: int = 5000):
	name = p_name
	reputation = p_reputation
	squad = []
	_init_default_needs()

func _init_default_needs():
	# Default: moderate need for all positions
	squad_needs = {
		"GK": 5,
		"CB": 5,
		"LB": 5,
		"RB": 5,
		"CDM": 5,
		"CM": 5,
		"CAM": 5,
		"LW": 5,
		"RW": 5,
		"ST": 5
	}
