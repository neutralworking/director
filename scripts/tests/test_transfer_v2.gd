@tool
extends SceneTree

func _init():
	print("Testing Transfer System V2 (Real-World Scenarios)...")
	
	# Load scripts
	var club_script = load("res://scripts/classes/Club.gd")
	var player_script = load("res://scripts/character/player.gd")
	var transfer_data_script = load("res://scripts/character/player_transfer_data.gd")
	var offer_script = load("res://scripts/systems/TransferMarket/transfer_offer.gd")
	var evaluator_script = load("res://scripts/systems/TransferMarket/club_transfer_evaluator.gd")
	
	if not (club_script and player_script and offer_script and evaluator_script):
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

	# Case 1: The "Isak" (Unwilling Seller vs Forced Move)
	print("\n=== Case 1: Unwilling Seller (Isak) ===")
	var isak = create_player.call("Isak", 23, "ST", 50000000.0)
	isak.squad_role = "Star"
	isak.happiness = 20 # Unhappy
	isak.is_forcing_move = true
	
	var newcastle = club_script.new("Newcastle", 8000)
	newcastle.financial_strength = 9 # Rich
	newcastle.philosophy = "Win Now"
	
	var val_forced = evaluator_script.evaluate_player_value_for_club(isak, newcastle)
	
	# Compare with happy Isak
	isak.is_forcing_move = false
	isak.happiness = 100
	var val_happy = evaluator_script.evaluate_player_value_for_club(isak, newcastle)
	
	print("Happy Isak Value: $%.1fM" % (val_happy / 1000000.0))
	print("Forced Move Isak Value: $%.1fM" % (val_forced / 1000000.0))
	
	if val_happy > val_forced:
		print("✓ Forced move reduces valuation (Leverage lost)")
	else:
		print("✗ Forced move logic failed")

	# Case 2: The "Wirtz" (Tier Gap / Stepping Stone)
	print("\n=== Case 2: Tier Gap (Wirtz) ===")
	var wirtz = create_player.call("Wirtz", 20, "CAM", 60000000.0)
	
	var leverkusen = club_script.new("Leverkusen", 7500)
	var liverpool = club_script.new("Liverpool", 9600) # Huge gap
	
	# Create dummy offer to trigger evaluate_offer logic
	var offer_wirtz = offer_script.new()
	offer_wirtz.base_fee = 80000000.0
	
	var eval_wirtz = evaluator_script.evaluate_offer(offer_wirtz, wirtz, leverkusen, liverpool)
	var club_val_wirtz = eval_wirtz.club_valuation
	
	print("Base Value: $60.0M")
	print("Seller Valuation (Tier Gap): $%.1fM" % (club_val_wirtz / 1000000.0))
	
	if club_val_wirtz > 60000000.0 * 1.3:
		print("✓ High potential premium applied for tier gap")
	else:
		print("✗ Tier gap premium missing")

	# Case 3: The "Ekitiké" (Striker & Form Premium)
	print("\n=== Case 3: Striker & Form (Ekitike) ===")
	var ekitike = create_player.call("Ekitike", 20, "ST", 20000000.0)
	ekitike.recent_form = {"goals": 18} # On fire
	
	var frankfurt = club_script.new("Frankfurt", 7000)
	
	var val_ekitike = evaluator_script.evaluate_player_value_for_club(ekitike, frankfurt)
	
	print("Base Value: $20.0M")
	print("Valuation (Striker + Form): $%.1fM" % (val_ekitike / 1000000.0))
	
	# Expected: Base * 1.25 (Striker) * 1.2 (Form) = ~1.5x
	if val_ekitike > 20000000.0 * 1.4:
		print("✓ Striker and form premiums applied")
	else:
		print("✗ Premiums missing")

	# Case 4: The "Sesko" (Freak Factor)
	print("\n=== Case 4: Freak Factor (Sesko) ===")
	var sesko = create_player.call("Sesko", 20, "ST", 30000000.0)
	sesko.physical_profile = "Powerhouse"
	
	var leipzig = club_script.new("Leipzig", 7500)
	var val_sesko = evaluator_script.evaluate_player_value_for_club(sesko, leipzig)
	
	print("Base Value: $30.0M")
	print("Valuation (Powerhouse): $%.1fM" % (val_sesko / 1000000.0))
	
	if val_sesko > 30000000.0 * 1.1:
		print("✓ Physical premium applied")
	else:
		print("✗ Physical premium missing")

	# Case 5: The "Mbeumo" (League Tax)
	print("\n=== Case 5: League Tax (Mbeumo) ===")
	var mbeumo = create_player.call("Mbeumo", 24, "RW", 40000000.0)
	
	var brentford = club_script.new("Brentford", 7200) # PL level
	var man_utd = club_script.new("Man Utd", 8500) # PL level
	
	var offer_mbeumo = offer_script.new()
	offer_mbeumo.base_fee = 50000000.0
	
	var eval_mbeumo = evaluator_script.evaluate_offer(offer_mbeumo, mbeumo, brentford, man_utd)
	
	print("Base Value: $40.0M")
	print("Valuation (PL Tax): $%.1fM" % (eval_mbeumo.club_valuation / 1000000.0))
	
	if eval_mbeumo.club_valuation > 40000000.0 * 1.2:
		print("✓ League tax applied")
	else:
		print("✗ League tax missing")

	# Case 6: The "Eze" (Release Clause)
	print("\n=== Case 6: Release Clause (Eze) ===")
	var eze = create_player.call("Eze", 25, "CAM", 50000000.0)
	eze.transfer_data.release_clause = 60000000.0
	
	var palace = club_script.new("Palace", 7000)
	var arsenal = club_script.new("Arsenal", 8500)
	
	# Offer matching clause
	var offer_clause = offer_script.new()
	offer_clause.base_fee = 60000000.0
	
	var eval_clause = evaluator_script.evaluate_offer(offer_clause, eze, palace, arsenal)
	
	print("Release Clause: $60.0M")
	print("Offer: $60.0M")
	print("Response: %s (0=Accept)" % eval_clause.response)
	print("Meets Clause: %s" % eval_clause.meets_release_clause)
	
	if eval_clause.response == 0 and eval_clause.meets_release_clause:
		print("✓ Release clause forced acceptance")
	else:
		print("✗ Release clause logic failed")

	print("\n=== All V2 Tests Complete ===")
	quit()
