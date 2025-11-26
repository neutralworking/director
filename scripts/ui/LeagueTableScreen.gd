extends Control

signal request_push(screen_scene)
signal request_pop()
signal club_selected(club)
signal back_requested()

@onready var club_list_container = $VBoxContainer/ScrollContainer/VBoxContainer
@onready var title_label = $VBoxContainer/Header/Title

func _ready():
	_refresh_display()

func _refresh_display():
	# Clear existing items
	for child in club_list_container.get_children():
		child.queue_free()
		
	if LeagueManager.active_league == null:
		LeagueManager.generate_test_league()
		
	title_label.text = LeagueManager.active_league.name
	
	var clubs = LeagueManager.active_league.get_clubs_sorted_by_name()
	
	for club in clubs:
		var btn = Button.new()
		btn.text = "%s (Rep: %d)" % [club.name, club.reputation]
		btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
		btn.pressed.connect(func(): club_selected.emit(club))
		club_list_container.add_child(btn)

func _on_back_button_pressed():
	back_requested.emit()

func on_enter():
	_refresh_display()

func on_exit():
	pass
