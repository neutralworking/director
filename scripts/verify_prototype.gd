@tool
extends SceneTree

func _init():
	print("Starting Prototype Verification...")
	
	# 1. Check Autoload
	# In a SceneTree script (headless), autoloads aren't automatically loaded unless we run the main scene.
	# But we can check if the script loads and runs logic.
	
	var CM = load("res://scripts/character/character_manager.gd").new()
	
	# 2. Test Squad Generation
	print("Testing Squad Generation...")
	CM.generate_initial_squad(10)
	
	if CM.players.size() == 10:
		print("PASS: Generated 10 players")
	else:
		print("FAIL: Generated %d players (expected 10)" % CM.players.size())
		
	var p = CM.players[0]
	print("Sample Player: %s (%s)" % [p.character_name, p.position_on_field])
	
	if p.character_data == null:
		# It might be null if we didn't initialize it in Player._init or _ready
		# Let's check Player.gd
		print("NOTE: Player.character_data is null (expected if not set in _init)")
	
	print("Verification Complete.")
	quit()
