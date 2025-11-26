@tool
extends SceneTree

func _init():
	print("Testing League System...")
	
	# Test that the classes can be loaded
	var club_script = load("res://scripts/classes/Club.gd")
	var league_script = load("res://scripts/classes/League.gd")
	
	if not (club_script and league_script):
		print("✗ Failed to load Club/League scripts")
		quit()
		return
		
	print("✓ Club and League classes loaded")
	
	# Test Club creation
	var test_club = club_script.new("Test FC", 7500)
	print("✓ Club created: %s (Rep: %d)" % [test_club.name, test_club.reputation])
	
	# Test League creation
	var test_league = league_script.new("Test League")
	test_league.clubs.append(test_club)
	print("✓ League created: %s with %d clubs" % [test_league.name, test_league.clubs.size()])
	
	# Test sorting
	var club2 = club_script.new("Alpha FC", 6000)
	test_league.clubs.append(club2)
	var sorted = test_league.get_clubs_sorted_by_name()
	if sorted[0].name == "Alpha FC":
		print("✓ Sorting works correctly")
	else:
		print("✗ Sorting failed")
	
	print("\nLeague System Verification Complete")
	print("Note: Full integration test requires running the actual game with LeagueManager autoload")
	quit()
