class_name RelationshipData
extends Resource

@export var opinion: int = 0
@export var knowledge_level: float = 0.0
@export var history: Array = [] # Array of event strings or dictionaries
@export var modifiers: Array = [] # CK3-style opinion modifiers: [{reason: String, value: int, date: String}]

func _init(p_opinion: int = 0):
	opinion = p_opinion
