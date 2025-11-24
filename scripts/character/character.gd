# Create an AutoLoad (Singleton) so CharacterManager is always available:
# Go to Project → Project Settings → Autoload
# Add res://scripts/character/character_manager.gd as CharacterManager




extends Node

class_name Player

@export var character_name: String = "Unknown"
@export var archetype_id: String  # e.g., "istp_ninja"
@export var position_on_field: String  # e.g., "CM", "ST"
@export var shirt_number: int = 1

var archetype: ArchetypeData
var character_manager: CharacterManager

func _ready() -> void:
	character_manager = get_tree().root.get_child(0).get_node("CharacterManager")
	if character_manager == null:
		push_error("CharacterManager not found in scene")
		return
	
	load_archetype()

func load_archetype() -> void:
	archetype = character_manager.get_archetype(archetype_id)
	if archetype == null:
		push_error("Failed to load archetype: " + archetype_id)

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

func has_chemistry_conflict(other_player: Player) -> bool:
	"""
	Check if this player conflicts with another.
	Used for dressing room morale calculations.
	"""
	if other_player.archetype == null:
		return false
	return other_player.archetype_id in archetype.conflicts_with

func has_chemistry_synergy(other_player: Player) -> bool:
	return other_player.archetype_id in archetype.synergizes_with
