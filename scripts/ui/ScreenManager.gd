
class_name ScreenManager
extends Control

var screen_stack: Array = []
var current_screen: Node = null

func push_screen(screen_scene):
	# Hide current screen if exists
	if not screen_stack.is_empty():
		screen_stack.back().visible = false
		if screen_stack.back().has_method("on_exit"):
			screen_stack.back().on_exit()
	
	add_child(screen_scene)
	screen_stack.append(screen_scene)
	current_screen = screen_scene
	screen_scene.request_push.connect(push_screen)
	screen_scene.request_pop.connect(pop_screen)
	screen_scene.on_enter()

func pop_screen():
	if screen_stack.size() <= 1:
		return # Don't pop the last screen (root)
		
	var active_screen = screen_stack.pop_back()
	active_screen.on_exit() # Call on_exit for the screen being removed
	active_screen.queue_free()
	
	# Show new top screen
	if not screen_stack.is_empty():
		var top_screen = screen_stack.back()
		top_screen.visible = true
		current_screen = top_screen # Update current_screen
		if top_screen.has_method("on_enter"):
			top_screen.on_enter()
	else:
		current_screen = null # No screens left, set current_screen to null

func go_home():
	while screen_stack.size() > 1:
		pop_screen()

