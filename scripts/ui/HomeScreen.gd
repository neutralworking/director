extends Control

signal request_push(screen_scene)
signal request_pop()

signal squad_requested
signal inbox_requested
signal profile_requested
signal coach_requested
signal league_requested

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
	pass

func on_exit():
	pass
