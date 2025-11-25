class_name ScreenManager
extends Control

var screen_stack: Array = []

func push_screen(screen_instance):
	if screen_stack.size() > 0:
		screen_stack.back().on_exit()
		screen_stack.back().visible = false
	
	add_child(screen_instance)
	screen_stack.append(screen_instance)
	screen_instance.request_push.connect(push_screen)
	screen_instance.request_pop.connect(pop_screen)
	screen_instance.on_enter()

func pop_screen():
	if screen_stack.size() <= 1:
		return # Don't pop the last screen (root)
		
	var active_screen = screen_stack.pop_back()
	active_screen.on_exit()
	active_screen.queue_free()
	
	if screen_stack.size() > 0:
		var new_active = screen_stack.back()
		new_active.visible = true
		new_active.on_enter()

func go_home():
	while screen_stack.size() > 1:
		pop_screen()
