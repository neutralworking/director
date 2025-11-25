extends Control

signal request_push(screen_scene)
signal request_pop()

signal squad_requested
signal inbox_requested

func _on_squad_button_pressed():
	squad_requested.emit()

func _on_inbox_button_pressed():
	inbox_requested.emit()

func on_enter():
	pass

func on_exit():
	pass
