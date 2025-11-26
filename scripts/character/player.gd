extends Node

class_name Player

@export var character_name: String = "Unknown"
@export var archetype_id: String  # e.g., "istp_ninja"
@export var position_on_field: String  # e.g., "CM", "ST"
@export var shirt_number: int = 1
@export var age: int = 22

# Interaction System Properties
var morale: int = 75  # 0-100
var traits: Array = []  # Auto-generated from archetype
var goals: Dictionary = {}  # {type: String, target: int, current: int}
var interested_clubs: Array = []
var squad_role: String = "Rotation"  # Starter/Rotation/Backup/Youth
var playing_time_expectation: String = "Regular"  # Guaranteed/Regular/Rotation/Backup

var archetype # : ArchetypeData
var character_manager # : CharacterManager
var character_data # : CharacterData # The relationship/personality data
var transfer_data # : PlayerTransferData # Transfer market specific data

func _ready() -> void:
	character_manager = get_tree().root.get_child(0).get_node("CharacterManager")
	if character_manager == null:
		push_error("CharacterManager not found in scene")
		return
	
	load_archetype()
	
	# Initialize transfer data if not already present
	if transfer_data == null:
		var transfer_data_script = load("res://scripts/character/player_transfer_data.gd")
		if transfer_data_script:
			transfer_data = transfer_data_script.new()

func load_archetype() -> void:
	archetype = character_manager.get_archetype(archetype_id)
	if archetype == null:
		push_error("Failed to load archetype: " + archetype_id)
	else:
		_generate_traits_from_archetype()

func get_action_weight(action: String) -> float:
	"""
	Called by MatchEngine during simulation.
	Example: match_engine.get_player_action_weight(player, "try_killer_pass")
	Returns a probability weight (0.0-1.0) based on archetype.
	"""
	match action:
		"pass_safe":
			return 1.0 - archetype.risk_tolerance  # Safe passers avoid risk
		"pass_killer":
			return archetype.risk_tolerance * archetype.tempo  # Risk + Speed = Killer passes
		"dribble":
			return archetype.expressiveness * archetype.tempo
		"press":
			return archetype.work_rate
		"hold_position":
			return archetype.tactical_discipline
	return 0.5

func has_chemistry_conflict(other_player) -> bool:
	"""
	Check if this player conflicts with another.
	Used for dressing room morale calculations.
	"""
	if other_player.archetype == null:
		return false
	return other_player.archetype_id in archetype.conflicts_with

func has_chemistry_synergy(other_player) -> bool:
	return other_player.archetype_id in archetype.synergizes_with

func _generate_traits_from_archetype() -> void:
	traits = []
	
	# Generate traits based on archetype attributes
	if archetype.loyalty > 0.7:
		traits.append("Loyal")
	elif archetype.loyalty < 0.3:
		traits.append("Mercenary")
	
	if archetype.professionalism > 0.7:
		traits.append("Professional")
	
	if archetype.controversy > 0.6:
		traits.append("Controversial")
	
	if archetype.ambition > 0.7:
		traits.append("Ambitious")
	elif archetype.ambition < 0.3:
		traits.append("Content")
	
	if archetype.work_rate > 0.7:
		traits.append("Hard Worker")
	
	if archetype.risk_tolerance > 0.7:
		traits.append("Risk Taker")
	elif archetype.risk_tolerance < 0.3:
		traits.append("Cautious")
	
	# Add MBTI-based flavor trait
	match archetype.mbti:
		"ISTP":
			traits.append("Cool-Headed")
		"ENFP":
			traits.append("Enthusiastic")
		"INTJ":
			traits.append("Strategic")
		"ESFP":
			traits.append("Showman")

func get_morale_status() -> String:
	if morale >= 90:
		return "Ecstatic"
	elif morale >= 75:
		return "Happy"
	elif morale >= 60:
		return "Content"
	elif morale >= 40:
		return "Unhappy"
	elif morale >= 20:
		return "Very Unhappy"
	else:
		return "Miserable"
