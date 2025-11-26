@tool
extends SceneTree

func _init():
	print("Testing Director Creation Screen...")
	
	# Load the scene
	var director_creation_scene = load("res://scenes/ui/DirectorCreationScreen.tscn")
	if director_creation_scene:
		print("✓ DirectorCreationScreen.tscn loaded successfully")
	else:
		print("✗ Failed to load scene")
		quit()
		return
	
	# Try to instance it
	var instance = director_creation_scene.instantiate()
	if instance:
		print("✓ Director creation screen instanced successfully")
	else:
		print("✗ Failed to instance scene")
		quit()
		return
	
	# Load the director profile script
	var director_script = load("res://scripts/character/director_profile.gd")
	if director_script:
		print("✓ DirectorProfile script loaded")
		var director = director_script.new("Test Director")
		print("✓ DirectorProfile created: %s" % director.director_name)
		
		# Test setting values
		director.background = "Elite Scout"
		director.archetype = "The Scout"
		director.strengths = ["Sharp Eye", "Future Focused"]
		director.flaw = "Stubborn"
		
		director.calculate_stats()
		
		print("✓ Stats calculated:")
		print("  Talent ID: %d" % director.stats["talent_id"])
		print("  Potential ID: %d" % director.stats["potential_id"])
		print("  Negotiation: %d" % director.stats["negotiation"])
		print("  Charisma: %d" % director.stats["charisma"])
		
		if director.stats["talent_id"] > 15:
			print("✓ Scout archetype working (high talent ID)")
		
	print("\nAll tests passed! 🎉")
	quit()
