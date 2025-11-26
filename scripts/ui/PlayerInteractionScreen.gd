extends Control

signal request_push(screen_scene)
signal request_pop()

@onready var player_name_label = $VBoxContainer/Header/PlayerName
@onready var back_button = $VBoxContainer/Header/BackButton
@onready var info_card = $VBoxContainer/ScrollContainer/VBoxContainer/InfoCard
@onready var morale_card = $VBoxContainer/ScrollContainer/VBoxContainer/MoraleCard
@onready var relationships_card = $VBoxContainer/ScrollContainer/VBoxContainer/RelationshipsCard
@onready var contract_card = $VBoxContainer/ScrollContainer/VBoxContainer/ContractCard
@onready var actions_container = $VBoxContainer/ActionsContainer

var current_player = null

func set_player(player):
	current_player = player
	_refresh_display()

func _refresh_display():
	if not current_player:
		return
	
	if player_name_label:
		player_name_label.text = current_player.character_name
	
	# Info Card
	var info_text = "%s • Age %d • #%d\n" % [
		current_player.position_on_field,
		current_player.age,
		current_player.shirt_number
	]
	
	if current_player.archetype:
		info_text += "Archetype: %s (%s)\n" % [current_player.archetype.name, current_player.archetype.mbti]
	
	if current_player.traits.size() > 0:
		info_text += "Traits: " + ", ".join(current_player.traits)
	
	if info_card and info_card.has_node("Content"):
		info_card.get_node("Content").text = info_text
	
	# Morale Card
	var morale_text = "Morale: %d/100 (%s)\n" % [
		current_player.morale,
		current_player.get_morale_status()
	]
	
	if current_player.character_data:
		var director_id = "director_1"  # TODO: Get actual director ID
		if current_player.character_data.relationships.has(director_id):
			var rel = current_player.character_data.relationships[director_id]
			morale_text += "Opinion of You: %+d" % rel.opinion
	
	if morale_card and morale_card.has_node("VBox/Content"):
		morale_card.get_node("VBox/Content").text = morale_text
	
	# Relationships Card
	var rel_text = "No significant relationships"
	if current_player.character_data and current_player.character_data.relationships.size() > 0:
		rel_text = ""
		for target_id in current_player.character_data.relationships:
			if target_id == "director_1":  # Skip director
				continue
			var rel = current_player.character_data.relationships[target_id]
			if abs(rel.opinion) >= 30:  # Only show strong opinions
				var emoji = "❤️" if rel.opinion > 0 else "💢"
				rel_text += "%s %s (%+d)\n" % [emoji, target_id, rel.opinion]
	
	if relationships_card and relationships_card.has_node("VBox/Content"):
		relationships_card.get_node("VBox/Content").text = rel_text
	
	# Contract Card
	var contract_text = "Squad Role: %s\n" % current_player.squad_role
	contract_text += "Playing Time: %s" % current_player.playing_time_expectation
	
	if current_player.interested_clubs.size() > 0:
		contract_text += "\n\n%d clubs interested" % current_player.interested_clubs.size()
	
	if contract_card and contract_card.has_node("VBox/Content"):
		contract_card.get_node("VBox/Content").text = contract_text

func _on_back_button_pressed():
	request_pop.emit()

func _on_discuss_happiness_pressed():
	# TODO: Show happiness dialog
	print("Discuss happiness with " + current_player.character_name)

func _on_set_goals_pressed():
	# TODO: Show goals dialog
	print("Set goals for " + current_player.character_name)

func _on_squad_role_pressed():
	# TODO: Show squad role dialog
	print("Discuss squad role with " + current_player.character_name)

func on_enter():
	_refresh_display()

func on_exit():
	pass
