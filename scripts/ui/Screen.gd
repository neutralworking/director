class_name Screen
extends Control

signal request_push(screen_scene)
signal request_pop()

func _ready():
	# Ensure the screen fills the parent
	set_anchors_preset(Control.PRESET_FULL_RECT)

func on_enter():
	# Called when the screen becomes the active top screen
	pass

func on_exit():
	# Called when the screen is covered or popped
	pass
