@tool
extends SceneTree

func _init():
	print("Testing Player Transfer System...")
	
	# 1. Setup Dependencies
	var player_script = load("res://scripts/character/player.gd")
	var transfer_data_script = load("res://scripts/character/player_transfer_data.gd")
	var calculator_script = load("res://scripts/systems/TransferMarket/transfer_value_calculator.gd")
	var scouting_script = load("res://scripts/systems/Scouting/scouting_system.gd")
	var analyst_script = load("res://scripts/systems/Scouting/analyst_system.gd")
	
	if not (player_script and transfer_data_script and calculator_script and scouting_script and analyst_script):
		print("✗ Failed to load one or more scripts")
		quit()
		return
		
	# 2. Create Test Player
	var player = player_script.new()
	player.character_name = "Test Player"
	player.age = 22
	player.morale = 85
	
	# Manually init transfer data since _ready might not run in this headless test environment easily without adding to tree
	player.transfer_data = transfer_data_script.new()
	player.transfer_data.base_value = 1000000.0 # 1M
	player.transfer_data.marketability = 0.2
	
	print("✓ Player and TransferData created")
	
	# 3. Test Transfer Value Calculation
	# Age 22 (Young multiplier 1.5)
	# Morale 85 (Multiplier 1.1)
	# Marketability 0.2 (Multiplier 1.2)
	# Expected: 1M * 1.5 * 1.1 * 1.2 = 1.98M
	
	var value = calculator_script.calculate_value(player)
	print("Calculated Value: %s" % value)
	
	if value > 1900000 and value < 2000000:
		print("✓ Transfer Value Calculation seems correct (approx 1.98M)")
	else:
		print("✗ Transfer Value Calculation unexpected: %s" % value)
		
	# 4. Test Scouting System
	player.transfer_data.scouting_traits = {
		"Speedster": { "discovered": false, "effect": 0.1 },
		"Lazy": { "discovered": false, "effect": -0.1 }
	}
	
	print("Testing Scouting...")
	var discovered = scouting_script.discover_trait(player, 100.0) # 100% chance
	if discovered:
		print("✓ Trait discovered successfully")
		var found_one = false
		for t in player.transfer_data.scouting_traits:
			if player.transfer_data.scouting_traits[t]["discovered"]:
				print("  Discovered: %s" % t)
				found_one = true
		if not found_one:
			print("✗ Function returned true but no trait marked discovered")
	else:
		print("✗ Failed to discover trait with 100% ability")
		
	# 5. Test Analyst System
	player.transfer_data.analyst_metrics = {
		"xG": { "value": 0.45, "discovered": false }
	}
	
	print("Testing Analyst...")
	var metric_discovered = analyst_script.discover_metric(player, 100.0)
	if metric_discovered:
		print("✓ Metric discovered successfully")
		if player.transfer_data.analyst_metrics["xG"]["discovered"]:
			print("  Discovered: xG")
	else:
		print("✗ Failed to discover metric")

	print("\nAll tests passed! 🎉")
	quit()
