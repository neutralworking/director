class_name InboxManager
extends Node

signal event_triggered(event: GameEvent, context: Object)

# This function receives a request to spawn an event
func trigger_event(event_res: GameEvent, context: Object = null) -> void:
	# 1. Check if event is valid/conditions met
	# (Optional: Check trigger_conditions here if not checked by caller)
	
	# 2. Emit signal to UI to display the inbox item
	event_triggered.emit(event_res, context)

# Called by UI when user clicks an option
func resolve_event_option(option: EventOption, context: Object, director: DirectorProfile) -> void:
	print("Resolving Option: %s" % option.text)
	
	# Execute all configured effects
	if option.effects:
		for effect in option.effects:
			if effect:
				effect.execute(context, director)
		
	# Log to history or cleanup (TODO)
