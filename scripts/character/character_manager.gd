extends Node

# class_name CharacterManager

const ArchetypeDataConst = preload("res://scripts/character/archetype.gd")

var archetypes: Dictionary = {}  # Cache: archetype_id -> ArchetypeData
var beliefs: Dictionary = {}     # Cache: belief_id -> belief info
var players: Array = []          # List of active Player nodes

func get_all_players() -> Array:
	return players

func generate_random_player():
	var player_script = load("res://scripts/character/player.gd")
	var new_player = player_script.new()
	
	var player_id = "player_" + str(players.size())
	new_player.character_name = "Player " + str(randi() % 1000)
	new_player.position_on_field = ["GK", "DEF", "MID", "FWD"].pick_random()
	new_player.age = randi_range(18, 35)
	new_player.shirt_number = (players.size() % 99) + 1
	new_player.morale = randi_range(60, 90)
	
	# Initialize character_data for relationships
	var CharacterDataScript = load("res://scripts/character/character_data.gd")
	new_player.character_data = CharacterDataScript.new(player_id, new_player.character_name)
	
	# Pick random archetype
	if archetypes.size() > 0:
		new_player.archetype_id = archetypes.keys().pick_random()
		new_player.archetype = get_archetype(new_player.archetype_id)
		if new_player.archetype:
			new_player._generate_traits_from_archetype()
	
	players.append(new_player)
	return new_player

func generate_initial_squad(count: int = 20):
	for i in range(count):
		generate_random_player()


func _ready() -> void:
	load_archetypes()
	load_beliefs()

func load_archetypes() -> void:
	var file = FileAccess.open("res://data/archetypes.json", FileAccess.READ)
	if file == null:
		push_error("Could not load archetypes.json")
		return
	
	var json = JSON.parse_string(file.get_as_text())
	if json == null:
		push_error("JSON parse failed")
		return
	
	# Parse each archetype from JSON into ArchetypeData resources
	for archetype_dict in json["archetypes"]:
		var archetype = ArchetypeDataConst.new()
		archetype.id = archetype_dict["id"]
		archetype.name = archetype_dict["name"]
		archetype.mbti = archetype_dict["mbti"]
		archetype.faction_belief = archetype_dict["faction_belief"]
		archetype.summary = archetype_dict["flavor"]["summary"]
		archetype.vibe = archetype_dict["flavor"]["vibe"]
		
		# Match engine weights
		var weights = archetype_dict["match_engine_weights"]
		archetype.tempo = weights["tempo"]
		archetype.risk_tolerance = weights["risk_tolerance"]
		archetype.expressiveness = weights["expressiveness"]
		archetype.work_rate = weights["work_rate"]
		archetype.tactical_discipline = weights["tactical_discipline"]
		
		# Management traits
		var mgmt = archetype_dict["management_traits"]
		archetype.loyalty = mgmt["loyalty"]
		archetype.professionalism = mgmt["professionalism"]
		archetype.controversy = mgmt["controversy"]
		archetype.ambition = mgmt["ambition"]
		
		# Chemistry
		var chem = archetype_dict["chemistry"]
		archetype.conflicts_with = PackedStringArray(chem["conflicts_with"])
		archetype.synergizes_with = PackedStringArray(chem["synergizes_with"])
		
		archetype.player_examples = PackedStringArray(archetype_dict["player_examples"])
		
		# Store in cache
		archetypes[archetype.id] = archetype

func load_beliefs() -> void:
	var file = FileAccess.open("res://data/archetypes.json", FileAccess.READ)
	if file == null:
		return
	
	var json = JSON.parse_string(file.get_as_text())
	for belief_dict in json["global_definitions"]["beliefs"]:
		beliefs[belief_dict["id"]] = {
			"name": belief_dict["name"],
			"motto": belief_dict["motto"],
			"description": belief_dict["description"]
		}

func get_archetype(archetype_id: String):
	if archetype_id not in archetypes:
		push_error("Archetype not found: " + archetype_id)
		return null
	return archetypes[archetype_id]

func get_belief(belief_id: String) -> Dictionary:
	if belief_id not in beliefs:
		push_error("Belief not found: " + belief_id)
		return {}
	return beliefs[belief_id]
