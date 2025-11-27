extends SceneTree

func _init():
	test_inbox_system()
	quit()

func test_inbox_system():
	print("Testing Inbox System...")
	
	# 1. Load the event
	var event_path = "res://data/events/evt_journalist_leak.tres"
	if not FileAccess.file_exists(event_path):
		print("Event file not found. Please run event_generator.gd first.")
		return

	var event = load(event_path) as GameEvent
	if not event:
		print("Failed to load event.")
		return
		
	print("Loaded Event: %s" % event.title)
	print("Options: %d" % event.options.size())
	
	# 2. Mock Director and Context
	var director = DirectorProfile.new()
	# We need to mock the context (PlayerEntity)
	# Since PlayerEntity might be complex, we'll use a generic Object or a mock if possible.
	# For this test, we'll just check if the effects *would* run.
	
	# 3. Trigger Event via Manager
	# Since InboxManager is an Autoload, we might not have it in this SceneTree script environment easily 
	# without running the full game loop or manually instantiating it.
	var manager = InboxManager.new()
	
	# Connect signal
	manager.event_triggered.connect(_on_event_triggered)
	
	print("Triggering event...")
	manager.trigger_event(event, null)
	
	# 4. Resolve Option
	var option = event.options[0]
	print("Selecting Option: %s" % option.text)
	manager.resolve_event_option(option, null, director)
	
	print("Test Complete.")

func _on_event_triggered(event, context):
	print("Signal Received: Event Triggered - %s" % event.title)
