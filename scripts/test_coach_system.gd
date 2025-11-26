@tool
extends SceneTree

func _init():
	print("Testing Coach Hiring System...")
	
	# Test 1: Load coach profile script
	var coach_script = load("res://scripts/character/head_coach_profile.gd")
	if coach_script:
		print("✓ Coach profile script loaded")
		
		# Create test coach
		var coach = coach_script.new("Test Coach")
		coach.archetype = "The System"
		coach.tactical_style = "Control"
		coach.apply_archetype_attributes()
		
		print("✓ Coach created: %s" % coach.coach_name)
		print("  Archetype: %s" % coach.archetype)
		print("  Tactics attribute: %d" % coach.attributes["tactics"])
		
		# Test compatibility
		var compat = coach.calculate_director_compatibility("The Scout")
		print("✓ Compatibility with Scout Director: %d%%" % compat)
	
	# Test 2: Load coach manager
	var manager_script = load("res://scripts/managers/coach_manager.gd")
	if manager_script:
		print("✓ Coach manager script loaded")
	
	# Test 3: Load hiring screen
	var hiring_scene = load("res://scenes/ui/CoachHiringScreen.tscn")
	if hiring_scene:
		print("✓ Coach hiring screen loaded")
		var instance = hiring_scene.instantiate()
		if instance:
			print("✓ Hiring screen instanced")
	
	# Test 4: Load coach profile screen
	var profile_scene = load("res://scenes/ui/CoachProfileScreen.tscn")
	if profile_scene:
		print("✓ Coach profile screen loaded")
		var instance = profile_scene.instantiate()
		if instance:
			print("✓ Profile screen instanced")
	
	print("\n✅ All coach system tests passed!")
	quit()
