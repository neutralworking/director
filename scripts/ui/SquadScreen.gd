extends Control

signal request_push(screen_scene)
signal request_pop()
signal player_selected(player)

@onready var player_list_container = $VBoxContainer/ScrollContainer/VBoxContainer
var character_manager

func _ready():
	character_manager = CharacterManager

func on_enter():
	_refresh_player_list()

func _refresh_player_list():
	# Clear existing items
	for child in player_list_container.get_children():
		child.queue_free()
	
	# Populate with players
	var players = character_manager.get_all_players()
	for player in players:
		var btn = Button.new()
		btn.text = "%s (%s) - %s" % [
			player.character_name,
			player.position_on_field,
			player.get_morale_status()
		]
		btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
		btn.pressed.connect(_on_player_selected.bind(player))
		player_list_container.add_child(btn)

func _on_player_selected(player):
	player_selected.emit(player)

func _on_back_button_pressed():
	request_pop.emit()

func on_exit():
	pass
