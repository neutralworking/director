class_name CharacterData
extends Resource

@export var id: String
@export var name: String
@export var attributes: Dictionary = {}
@export var relationships: Dictionary = {} # Dictionary of CharacterID -> Relationship

func _init(p_id: String = "", p_name: String = ""):
	id = p_id
	name = p_name
