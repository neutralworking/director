extends Control

signal request_push(screen_scene)
signal request_pop()
signal player_selected(player)
signal back_requested()

@onready var player_list_container = $VBoxContainer/ScrollContainer/VBoxContainer
@onready var title_label = $VBoxContainer/Header/Title

var current_club # : Club

func set_club(club):
	current_club = club
	# Only refresh if the node is ready, otherwise wait for _ready to call it
	if is_node_ready():
		_refresh_display()

func _refresh_display():
	if not current_club:
		return
	
	# Safety check - ensure nodes exist
	if not title_label or not player_list_container:
		return
		
	title_label.text = current_club.name + " Squad"
	
	# Clear existing items
	for child in player_list_container.get_children():
		child.queue_free()
		
	for player in current_club.squad:
		var btn = Button.new()
		var val_str = "?"
		if player.transfer_data:
			var calc_script = load("res://scripts/systems/TransferMarket/transfer_value_calculator.gd")
			if calc_script:
				var val = calc_script.calculate_value(player)
				if val >= 1000000:
					val_str = "$%.1fM" % (val / 1000000.0)
				else:
					val_str = "$%dK" % (val / 1000.0)
					
		btn.text = "%s (%s) - %s" % [player.character_name, player.position_on_field, val_str]
		btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
		btn.pressed.connect(func(): 
			# Player is not from user's club (we're viewing another club's squad)
			player_selected.emit(player)
		)
		player_list_container.add_child(btn)

func _on_back_button_pressed():
	back_requested.emit()

func _ready():
	# If club was set before _ready, refresh now
	if current_club:
		_refresh_display()

func on_enter():
	_refresh_display()

func on_exit():
	pass
