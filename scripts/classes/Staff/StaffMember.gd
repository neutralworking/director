extends Node

class_name StaffMember

var name: String
var type: String
var attributes: Dictionary
var weighted_attributes: Dictionary

func _init(p_name: String, p_type: String):
    name = p_name
    type = p_type
    attributes = {
        "man_management": 0, "motivation": 0, "determination": 0,
        "discipline": 0, "communication": 0, "adaptability": 0,
        "mental": 0, "experience": 0, "tactical_knowledge": 0,
        "youth_development": 0, "player_knowledge": 0, "coaching": 0,
        "leadership": 0
    }
    weighted_attributes = {}

func get_weighted_attribute(attribute: String) -> float:
    var base_value = attributes.get(attribute, 0)
    var weight = weighted_attributes.get(attribute, 1.0)
    return base_value * weight

func set_weighted_attributes(weights: Dictionary):
    weighted_attributes = weights