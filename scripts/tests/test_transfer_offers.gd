@tool
extends SceneTree

func _init():
	print("Testing Transfer Offer System...")
	
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
	
	# Test 1: Club-specific valuations
	print("\n=== Test 1: Club Philosophy Impact ===")
	
	var young_player = player_script.new()
	young_player.character_name = "Young Prospect"
	young_player.age = 21
	young_player.position_on_field = "ST"
	young_player.transfer_data = transfer_data_script.new()
	young_player.transfer_data.base_value = 10000000.0
	
	var academy_club = club_script.new("Academy FC", 7000)
	academy_club.philosophy = "Academy"
	
	var win_now_club = club_script.new("Win Now FC", 8000)
	win_now_club.philosophy = "Win Now"
	
	var academy_val = evaluator_script.evaluate_player_value_for_club(young_player, academy_club)
	var win_now_val = evaluator_script.evaluate_player_value_for_club(young_player, win_now_club)
	
	print("Young player (21yo) base value: $%.1fM" % (young_player.transfer_data.base_value / 1000000.0))
	print("Academy club valuation: $%.1fM (should be higher)" % (academy_val / 1000000.0))
	print("Win Now club valuation: $%.1fM (should be lower)" % (win_now_val / 1000000.0))
	
	if academy_val > win_now_val:
		print("✓ Philosophy impact correct")
	else:
		print("✗ Philosophy impact incorrect")
	
	# Test 2: Rivalry multiplier
	print("\n=== Test 2: Rival Club Premium ===")
	
	var selling_club = club_script.new("Club A", 8000)
	selling_club.rival_clubs = ["Club B"]
	
	var rival_club = club_script.new("Club B", 8000)
	var normal_club = club_script.new("Club C", 8000)
	
	var rivalry_mult = evaluator_script.get_rivalry_multiplier(selling_club, rival_club)
	var normal_mult = evaluator_script.get_rivalry_multiplier(selling_club, normal_club)
	
	print("Rivalry multiplier: %.1f (should be 2.0)" % rivalry_mult)
	print("Normal multiplier: %.1f (should be 1.0)" % normal_mult)
	
	if rivalry_mult == 2.0 and normal_mult == 1.0:
		print("✓ Rivalry multiplier correct")
	else:
		print("✗ Rivalry multiplier incorrect")
	
	# Test 3: Installment valuation
	print("\n=== Test 3: Installment Time-Value Discount ===")
	
	var offer_immediate = offer_script.new()
	offer_immediate.base_fee = 10000000.0
	offer_immediate.payment_immediate = true
	
	var offer_3yr = offer_script.new()
	offer_3yr.base_fee = 10000000.0
	offer_3yr.payment_immediate = false
	offer_3yr.installments = [
		{"amount": 3333333.0, "years": 1},
		{"amount": 3333333.0, "years": 2},
		{"amount": 3333334.0, "years": 3}
	]
	
	var immediate_val = evaluator_script.calculate_installment_value(offer_immediate)
	var installment_val = evaluator_script.calculate_installment_value(offer_3yr)
	
	print("Immediate payment value: $%.1fM" % (immediate_val / 1000000.0))
	print("3-year installment value: $%.1fM (should be ~85%% = $8.5M)" % (installment_val / 1000000.0))
	
	if installment_val < immediate_val and installment_val > immediate_val * 0.8:
		print("✓ Installment discount correct")
	else:
		print("✗ Installment discount incorrect")
	
	# Test 4: Auto-accept/reject thresholds
	print("\n=== Test 4: Auto-Accept/Reject Logic ===")
	
	var test_player = player_script.new()
	test_player.age = 25
	test_player.position_on_field = "CM"
	test_player.transfer_data = transfer_data_script.new()
	test_player.transfer_data.base_value = 10000000.0
	
	var test_club = club_script.new("Test Club", 7000)
	test_club.philosophy = "Balanced"
	
	# Test auto-accept (2.5× value)
	var high_offer = offer_script.new()
	high_offer.base_fee = 25000000.0
	var high_eval = evaluator_script.evaluate_offer(high_offer, test_player, test_club, test_club)
	print("High offer (2.5× value) response: %d (0=accept, 1=reject, 2=negotiate)" % high_eval.response)
	
	# Test auto-reject (30% value)
	var low_offer = offer_script.new()
	low_offer.base_fee = 3000000.0
	var low_eval = evaluator_script.evaluate_offer(low_offer, test_player, test_club, test_club)
	print("Low offer (30%% value) response: %d, damage_rel: %s" % [low_eval.response, low_eval.damage_relationship])
	
	# Test negotiate (80% value)
	var mid_offer = offer_script.new()
	mid_offer.base_fee = 8000000.0
	var mid_eval = evaluator_script.evaluate_offer(mid_offer, test_player, test_club, test_club)
	print("Mid offer (80%% value) response: %d" % mid_eval.response)
	
	if high_eval.response == 0 and low_eval.response == 1 and mid_eval.response == 2:
		print("✓ Auto-decision logic correct")
	else:
		print("✗ Auto-decision logic incorrect")
	
	print("\n=== All Tests Complete ===")
	quit()
