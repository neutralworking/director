@tool
extends SceneTree

func _init():
	print("Testing Transfer System V3 (Research-Based Valuation)...")
	
	# Load scripts
	var club_script = load("res://scripts/classes/Club.gd")
	var player_script = load("res://scripts/character/player.gd")
	var transfer_data_script = load("res://scripts/character/player_transfer_data.gd")
	var evaluator_script = load("res://scripts/systems/TransferMarket/club_transfer_evaluator.gd")
	
	if not (club_script and player_script and evaluator_script):
		print("✗ Failed to load scripts")
		quit()
		return

	# Helper to create player
	var create_player = func(name, age, pos, val):
		var p = player_script.new()
		p.character_name = name
		p.age = age
		p.position_on_field = pos
		p.transfer_data = transfer_data_script.new()
		p.transfer_data.base_value = val
		return p

	var club_a = club_script.new("Club A", 8000)
	var club_b = club_script.new("Club B", 8000)

	# Test 1: Contract Length Impact
	print("\n=== Test 1: Contract Length Impact ===")
	var p_long = create_player.call("Long Contract", 25, "CM", 20000000.0)
	p_long.transfer_data.contract_years_remaining = 4
	
	var p_short = create_player.call("Short Contract", 25, "CM", 20000000.0)
	p_short.transfer_data.contract_years_remaining = 1
	
	var val_long = evaluator_script.evaluate_player_value_for_club(p_long, club_a)
	var val_short = evaluator_script.evaluate_player_value_for_club(p_short, club_a)
	
	print("4 Years Remaining Value: $%.1fM" % (val_long / 1000000.0))
	print("1 Year Remaining Value: $%.1fM" % (val_short / 1000000.0))
	
	if val_long > val_short * 2.0:
		print("✓ Contract length significantly impacts value")
	else:
		print("✗ Contract length impact too small")

	# Test 2: Homegrown Premium
	print("\n=== Test 2: Homegrown Premium ===")
	var p_hg = create_player.call("Homegrown Hero", 24, "RB", 30000000.0)
	p_hg.transfer_data.is_homegrown = true
	
	var p_foreign = create_player.call("Foreign Star", 24, "RB", 30000000.0)
	p_foreign.transfer_data.is_homegrown = false
	
	var val_hg = evaluator_script.evaluate_player_value_for_club(p_hg, club_a)
	var val_foreign = evaluator_script.evaluate_player_value_for_club(p_foreign, club_a)
	
	print("Homegrown Value: $%.1fM" % (val_hg / 1000000.0))
	print("Foreign Value: $%.1fM" % (val_foreign / 1000000.0))
	
	if val_hg > val_foreign:
		print("✓ Homegrown premium applied")
	else:
		print("✗ Homegrown premium missing")

	# Test 3: Commercial Value
	print("\n=== Test 3: Commercial Value ===")
	var p_star = create_player.call("Superstar", 28, "LW", 50000000.0)
	p_star.transfer_data.marketability = 0.9
	
	var p_normal = create_player.call("Normal Player", 28, "LW", 50000000.0)
	p_normal.transfer_data.marketability = 0.5
	
	var val_star = evaluator_script.evaluate_player_value_for_club(p_star, club_a)
	var val_normal = evaluator_script.evaluate_player_value_for_club(p_normal, club_a)
	
	print("Superstar Value: $%.1fM" % (val_star / 1000000.0))
	print("Normal Value: $%.1fM" % (val_normal / 1000000.0))
	
	if val_star > val_normal:
		print("✓ Commercial premium applied")
	else:
		print("✗ Commercial premium missing")

	# Test 4: Injury Risk
	print("\n=== Test 4: Injury Risk ===")
	var p_glass = create_player.call("Glass Cannon", 26, "ST", 40000000.0)
	p_glass.transfer_data.injury_susceptibility = 0.8
	
	var p_robust = create_player.call("Iron Man", 26, "ST", 40000000.0)
	p_robust.transfer_data.injury_susceptibility = 0.1
	
	var val_glass = evaluator_script.evaluate_player_value_for_club(p_glass, club_a)
	var val_robust = evaluator_script.evaluate_player_value_for_club(p_robust, club_a)
	
	print("Injury Prone Value: $%.1fM" % (val_glass / 1000000.0))
	print("Robust Value: $%.1fM" % (val_robust / 1000000.0))
	
	if val_glass < val_robust:
		print("✓ Injury risk discount applied")
	else:
		print("✗ Injury risk discount missing")

	print("\n=== All V3 Tests Complete ===")
	quit()
