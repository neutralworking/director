class_name League
extends Resource

@export var name: String = "Premier League"
@export var clubs: Array = [] # Array of Club objects

func _init(p_name: String = "Premier League"):
	name = p_name
	clubs = []

func get_clubs_sorted_by_name() -> Array:
	var sorted_clubs = clubs.duplicate()
	sorted_clubs.sort_custom(func(a, b): return a.name < b.name)
	return sorted_clubs
