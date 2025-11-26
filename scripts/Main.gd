# Main.gd
extends Node

# Game State
var current_date := {"year": 2025, "month": 10, "day": 29, "hour": 9}

# Node references (Godot 4+)
@onready var dof_manager = $DOFManager
@onready var time_system = $TimeProgressionSystem
@onready var event_system = $EventQueueSystem

func _ready():
	print("Main._ready() called!")
	# Initialize game
	_schedule_initial_events()
	
	# Initialize UI
	_setup_ui()
	
	# Generate Squad
	CharacterManager.generate_initial_squad(25)

	print("Director of Football - Game Started!")
	print("Welcome! Use the buttons to advance time and manage your club.")

func _setup_ui():
	print("Setting up UI...")
	
	# Create ScreenManager
	var screen_manager = load("res://scripts/ui/ScreenManager.gd").new()
	screen_manager.name = "ScreenManager"
	screen_manager.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(screen_manager)
	print("ScreenManager created")
	
	# Load Screens
	var home_scene = load("res://scenes/ui/HomeScreen.tscn").instantiate()
	var squad_scene = load("res://scenes/ui/SquadScreen.tscn").instantiate()
	var profile_scene = load("res://scenes/ui/DirectorProfileScreen.tscn").instantiate()
	var coach_scene = load("res://scenes/ui/CoachProfileScreen.tscn").instantiate()
	print("Screens loaded")
	
	# Connect Signals
	home_scene.squad_requested.connect(func(): 
		screen_manager.push_screen(squad_scene)
		squad_scene.on_enter()  # Refresh player list
	)
	
	home_scene.profile_requested.connect(func():
		screen_manager.push_screen(profile_scene)
		profile_scene.on_enter()  # Refresh profile
	)
	
	home_scene.coach_requested.connect(func():
		screen_manager.push_screen(coach_scene)
		coach_scene.on_enter()  # Refresh coach info
	)
	
	squad_scene.player_selected.connect(func(player):
		var player_screen = load("res://scenes/ui/PlayerInteractionScreen.tscn").instantiate()
		player_screen.set_player(player)
		screen_manager.push_screen(player_screen)
	)
	
	# Push Home Screen
	screen_manager.push_screen(home_scene)
	print("Home screen pushed, UI setup complete")


func _on_time_advance_requested(days: int, hours: int):
	advance_time(days, hours)

func _on_skip_to_event_requested():
	skip_to_next_event()

func _on_menu_requested(menu_type: String):
	_open_menu(menu_type)

func advance_time(days := 0, hours := 0):
	current_date["hour"] += hours
	while current_date["hour"] >= 24:
		current_date["hour"] -= 24
		current_date["day"] += 1
	
	current_date["day"] += days
	
	while current_date["day"] > 30:
		current_date["day"] -= 30
		current_date["month"] += 1
	
	while current_date["month"] > 12:
		current_date["month"] -= 12
		current_date["year"] += 1

	await _handle_current_events()
	_update_hud()

func skip_to_next_event():
	var next_event = event_system.get_next_event(current_date)
	if next_event:
		current_date = next_event["date"].duplicate()
		await _handle_current_events()
		_update_hud()
	else:
		_show_message("No upcoming events scheduled.")

func _handle_current_events():
	var current_events = event_system.get_events(current_date)
	if current_events.size() == 0:
		return

	# main_hud.set_buttons_enabled(false)  # Old UI removed

	for event in current_events:
		await _process_event(event)

	# main_hud.set_buttons_enabled(true)  # Old UI removed

func _process_event(event: Dictionary):
	print("Processing event: ", event["type"])
	match event["type"]:
		event_system.EventType.MATCH:
			await _handle_match_event(event["data"])
		event_system.EventType.TRANSFER:
			await _handle_transfer_event(event["data"])
		event_system.EventType.CONTRACT:
			await _handle_contract_event(event["data"])
		event_system.EventType.MEETING:
			await _handle_meeting_event(event["data"])

func _handle_match_event(data: Dictionary):
	_show_message("MATCH: vs " + data.get("vs", "Unknown Opponent"))
	await get_tree().create_timer(1.0).timeout

func _handle_transfer_event(data: Dictionary):
	_show_message("TRANSFER: " + data.get("description", "Transfer event"))
	await get_tree().create_timer(1.0).timeout

func _handle_contract_event(data: Dictionary):
	_show_message("CONTRACT: " + data.get("player", "Player") + " contract expires soon")
	await get_tree().create_timer(1.0).timeout

func _handle_meeting_event(data: Dictionary):
	_show_message("MEETING: " + data.get("subject", "Meeting scheduled"))
	await get_tree().create_timer(1.0).timeout

func _schedule_initial_events():
	event_system.schedule_event(
		{"year": 2025, "month": 10, "day": 30, "hour": 18}, 
		event_system.EventType.MATCH, 
		{"vs": "Rival FC", "competition": "League"}
	)
	event_system.schedule_event(
		{"year": 2025, "month": 10, "day": 31, "hour": 10}, 
		event_system.EventType.MEETING, 
		{"subject": "Chairman Budget Review", "attendee": "Chairman"}
	)
	event_system.schedule_event(
		{"year": 2025, "month": 11, "day": 2, "hour": 14}, 
		event_system.EventType.CONTRACT, 
		{"player": "John Smith", "action": "renewal"}
	)

func _update_hud():
	var date_string = "Date: %02d/%02d/%d %02d:00" % [
		current_date["day"], 
		current_date["month"], 
		current_date["year"], 
		current_date["hour"]
	]
	# main_hud.update_date_display(date_string)  # Old UI removed
	var events_text = "Upcoming Events:\n"
	var next_events = []
	var temp_date = current_date.duplicate()
	for i in range(3):
		var next_event = event_system.get_next_event(temp_date)
		if not next_event:
			break
		var event_text = "%s: %s on %02d/%02d %02d:00" % [
			_get_event_type_name(next_event["type"]),
			_get_event_description(next_event),
			next_event["date"]["day"],
			next_event["date"]["month"],
			next_event["date"]["hour"]
		]
		next_events.append(event_text)
		temp_date = next_event["date"].duplicate()
		temp_date["hour"] += 1
	
	if next_events.size() > 0:
		events_text += "\n".join(next_events)

	else:
		events_text += "No events scheduled"
	# main_hud.update_events_display(events_text)  # Old UI removed

func _get_event_type_name(event_type: int) -> String:
	match event_type:
		event_system.EventType.MATCH: return "MATCH"
		event_system.EventType.TRANSFER: return "TRANSFER"
		event_system.EventType.CONTRACT: return "CONTRACT"
		event_system.EventType.MEETING: return "MEETING"
		_: return "EVENT"

func _get_event_description(event: Dictionary) -> String:
	var data = event.get("data", {})
	match event["type"]:
		event_system.EventType.MATCH:
			return "vs " + data.get("vs", "TBD")
		event_system.EventType.TRANSFER:
			return data.get("description", "Transfer")
		event_system.EventType.CONTRACT:
			return data.get("player", "Player") + " contract"
		event_system.EventType.MEETING:
			return data.get("subject", "Meeting")
		_:
			return "Unknown"

func _open_menu(menu_type: String):
	match menu_type:
		"squad":
			_show_message("Opening Squad screen... (not implemented yet)")
		"transfers":
			_show_message("Opening Transfer Market... (not implemented yet)")
		"contracts":
			_show_message("Opening Contracts screen... (not implemented yet)")
		"meetings":
			_show_message("Opening Meetings screen... (not implemented yet)")

func _show_message(message: String):
	print("GAME: " + message)
