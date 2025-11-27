@tool
extends SceneTree

func _init():
	print("Testing Inbox System...")
	
	# Load scripts dynamically to avoid parse errors during test setup
	var inbox_system_script = load("res://scripts/systems/inbox_system.gd")
	var inbox_message_script = load("res://scripts/systems/inbox_message.gd")
	var time_system_script = load("res://scripts/TimeProgressionSystem.gd")
	
	if not (inbox_system_script and inbox_message_script and time_system_script):
		print("✗ Failed to load scripts")
		quit()
		return

	# Setup mock environment
	var root = Node.new()
	get_root().add_child(root)
	
	var time_system = time_system_script.new()
	time_system.name = "TimeProgressionSystem"
	root.add_child(time_system)
	
	var inbox_system = inbox_system_script.new()
	inbox_system.name = "InboxSystem"
	root.add_child(inbox_system)
	
	# Test 1: Add Message
	print("\n=== Test 1: Add Message ===")
	var msg = inbox_system.add_message("Test Title", "Test Body", "INFO")
	
	if msg and msg.title == "Test Title":
		print("✓ Message added successfully")
	else:
		print("✗ Failed to add message")
		
	# Test 2: Unread Count
	print("\n=== Test 2: Unread Count ===")
	var count = inbox_system.get_unread_count()
	if count == 1:
		print("✓ Unread count correct (1)")
	else:
		print("✗ Unread count incorrect: %d" % count)
		
	# Test 3: Mark as Read
	print("\n=== Test 3: Mark as Read ===")
	inbox_system.mark_as_read(msg)
	if msg.read == true:
		print("✓ Message marked as read")
	else:
		print("✗ Failed to mark as read")
		
	count = inbox_system.get_unread_count()
	if count == 0:
		print("✓ Unread count updated (0)")
	else:
		print("✗ Unread count not updated")

	print("\n=== Inbox System Tests Complete ===")
	quit()
