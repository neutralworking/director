extends Control

signal request_push(screen_scene)
signal request_pop()

signal squad_requested
signal inbox_requested
signal profile_requested
signal coach_requested
signal league_requested
signal continue_requested

func _on_continue_button_pressed():
	continue_requested.emit()

func _on_squad_button_pressed():
	squad_requested.emit()

func _on_inbox_button_pressed():
	inbox_requested.emit()

func _on_profile_button_pressed():
	profile_requested.emit()

func _on_coach_button_pressed():
	coach_requested.emit()

func _on_league_button_pressed():
	league_requested.emit()

func on_enter():
	update_inbox_status()

func on_exit():
	pass

func update_inbox_status():
	var inbox_system = get_node_or_null("/root/Main/InboxSystem")
	if inbox_system:
		var unread_count = inbox_system.get_unread_count()
		var inbox_btn = $VBoxContainer/InboxButton
		if unread_count > 0:
			inbox_btn.text = "Inbox (%d)" % unread_count
			inbox_btn.modulate = Color(1, 0.8, 0.2) # Highlight color (Gold)
		else:
			inbox_btn.text = "Inbox"
			inbox_btn.modulate = Color(1, 1, 1) # Normal color
