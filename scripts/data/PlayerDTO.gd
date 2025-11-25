class_name PlayerDTO
extends RefCounted

var uid: int
var full_name: String
var age: int
var position: String
var role_archetype: String # e.g. "Deep Lying Playmaker"
var foot: String
var ca: int # Current Ability (Hidden internal score 1-200)
var pa: int # Potential Ability

# Detailed stats map
var attributes: Dictionary = {} 

func get_average_rating() -> int:
	if attributes.is_empty(): return 0
	return int(attributes.values().reduce(func(sum, val): return sum + val, 0) / attributes.size())
