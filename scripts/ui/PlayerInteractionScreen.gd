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
var is_own_player: bool = true  # Default to own player for now

func set_player(player, is_users_player: bool = true):
	current_player = player
	is_own_player = is_users_player
	# Only refresh if the node is ready
	if is_node_ready():
		_refresh_display()

func _ready():
	# If player was set before _ready, refresh now
	if current_player:
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
		info_text += "Traits: " + ", ".join(current_player.traits) + "\n"

	# Scouting & Analyst Data
	if current_player.transfer_data:
		var discovered_traits = []
		for t in current_player.transfer_data.scouting_traits:
			if current_player.transfer_data.scouting_traits[t].get("discovered", false):
				discovered_traits.append(t)
		
		if discovered_traits.size() > 0:
			info_text += "Scouted Traits: " + ", ".join(discovered_traits) + "\n"
			
		var discovered_metrics = []
		for m in current_player.transfer_data.analyst_metrics:
			if current_player.transfer_data.analyst_metrics[m].get("discovered", false):
				var val = current_player.transfer_data.analyst_metrics[m].get("value", 0)
				discovered_metrics.append("%s: %.2f" % [m, val])
				
		if discovered_metrics.size() > 0:
			info_text += "Metrics: " + ", ".join(discovered_metrics) + "\n"
	
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
	
	# Transfer Value
	if current_player.transfer_data:
		var calc_script = load("res://scripts/systems/TransferMarket/transfer_value_calculator.gd")
		if calc_script:
			var val = calc_script.calculate_value(current_player)
			# Format as currency (e.g. $1.5M)
			var val_str = "$%.1fM" % (val / 1000000.0)
			if val < 1000000:
				val_str = "$%dK" % (val / 1000.0)
			contract_text += "\nEst. Value: %s" % val_str
	
	if current_player.interested_clubs.size() > 0:
		contract_text += "\n\n%d clubs interested" % current_player.interested_clubs.size()
	
	if contract_card and contract_card.has_node("VBox/Content"):
		contract_card.get_node("VBox/Content").text = contract_text
	
	# Update Action Buttons
	_update_action_buttons()

func _update_action_buttons():
	# Safety check - ensure container exists
	if not actions_container:
		return
		
	# Clear existing action buttons
	for child in actions_container.get_children():
		child.queue_free()
	
	if is_own_player:
		# Own player actions
		var discuss_btn = Button.new()
		discuss_btn.text = "💬 Discuss Happiness"
		discuss_btn.pressed.connect(_on_discuss_happiness_pressed)
		actions_container.add_child(discuss_btn)
		
		var goals_btn = Button.new()
		goals_btn.text = "📈 Set Goals"
		goals_btn.pressed.connect(_on_set_goals_pressed)
		actions_container.add_child(goals_btn)
		
		var role_btn = Button.new()
		role_btn.text = "🎯 Discuss Squad Role"
		role_btn.pressed.connect(_on_squad_role_pressed)
		actions_container.add_child(role_btn)
	else:
		# Other team's player actions
		var offer_btn = Button.new()
		offer_btn.text = "💰 Make Offer"
		offer_btn.pressed.connect(_on_make_offer_pressed)
		actions_container.add_child(offer_btn)
		
		var agent_btn = Button.new()
		agent_btn.text = "🤝 Contact Agent"
		agent_btn.pressed.connect(_on_contact_agent_pressed)
		actions_container.add_child(agent_btn)
		
		var compare_btn = Button.new()
		compare_btn.text = "📊 Compare"
		compare_btn.pressed.connect(_on_compare_pressed)
		actions_container.add_child(compare_btn)
		
		var scout_btn = Button.new()
		scout_btn.text = "🔍 Scout"
		scout_btn.pressed.connect(_on_scout_pressed)
		actions_container.add_child(scout_btn)

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

func _on_make_offer_pressed():
	# Get the selling club (need to find which club owns this player)
	var selling_club = _find_player_club(current_player)
	if not selling_club:
		print("Error: Could not find player's club")
		return
		
	var transfer_screen = load("res://scenes/ui/TransferOfferScreen.tscn").instantiate()
	transfer_screen.set_transfer_context(current_player, selling_club)
	request_push.emit(transfer_screen)

func _find_player_club(player):
	# Search all clubs in the league to find which one owns this player
	if not LeagueManager.active_league:
		return null
		
	for club in LeagueManager.active_league.clubs:
		if club.squad.has(player):
			return club
	return null

func _on_contact_agent_pressed():
	# TODO: Show agent contact dialog
	print("Contacting agent for " + current_player.character_name)

func _on_compare_pressed():
	# TODO: Show comparison screen
	print("Compare " + current_player.character_name)

func _on_scout_pressed():
	# TODO: Show scouting assignment dialog
	print("Scouting " + current_player.character_name)

func on_enter():
	_refresh_display()

func on_exit():
	pass
