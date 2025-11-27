extends Node

# Evaluates player value from a club's perspective and assesses transfer offers

enum OfferResponse {
	AUTO_ACCEPT,
	AUTO_REJECT,
	NEGOTIATE
}

# Evaluate player value for a specific club
static func evaluate_player_value_for_club(player, club) -> float:
	# Get base value from TransferValueCalculator
	var calc_script = load("res://scripts/systems/TransferMarket/transfer_value_calculator.gd")
	if not calc_script or not player.transfer_data:
		return 0.0
		
	var base_value = calc_script.calculate_value(player)
	var multiplier = 1.0
	
	# --- V1 LOGIC ---
	
	# 1. Age multiplier based on club philosophy
	match club.philosophy:
		"Academy":
			if player.age <= 23:
				multiplier *= 1.5  # Value young talent
			elif player.age >= 30:
				multiplier *= 0.6  # Less interest in older players
		"Win Now":
			if player.age >= 25 and player.age <= 29:
				multiplier *= 1.3  # Prime age for immediate impact
			elif player.age <= 21:
				multiplier *= 0.7  # Not ready for immediate contribution
		"Balanced":
			if player.age >= 22 and player.age <= 28:
				multiplier *= 1.1  # Sweet spot
	
	# 2. Squad need multiplier
	var position = player.position_on_field
	var need_priority = club.squad_needs.get(position, 5)
	
	if need_priority >= 8:
		multiplier *= 1.3  # High priority
	elif need_priority >= 4:
		multiplier *= 1.0  # Medium priority
	elif need_priority >= 1:
		multiplier *= 0.7  # Low priority
	else:
		multiplier *= 0.5  # Surplus/no need
		
	# --- V2 LOGIC ---
	
	# 3. Striker & Form Premium
	if position in ["ST", "CF"]:
		multiplier *= 1.25  # Striker tax
		
	if player.recent_form.get("goals", 0) > 15:
		multiplier *= 1.2  # On fire premium
		
	# 4. "Freak Factor" (Physical Profile)
	if player.physical_profile in ["Speedster", "Powerhouse"]:
		multiplier *= 1.15  # Physical outlier premium
		
	# 5. Unwilling Seller vs Player Power
	# If rich club and key player -> "Not for sale" price
	if club.financial_strength >= 8 and player.squad_role in ["Starter", "Star"]:
		var unwillingness_mult = 3.0
		
		# But if player is forcing move, this leverage decreases
		if player.is_forcing_move:
			unwillingness_mult = 1.6  # Still high, but forced to sell
		elif player.happiness < 40:
			unwillingness_mult = 2.2  # Unhappy but not striking yet
			
		multiplier *= unwillingness_mult
	
		multiplier *= unwillingness_mult
	
	# --- V3 LOGIC (Research-Based) ---
	
	# 6. Contract Length (Amortization & Security)
	var contract_years = player.transfer_data.contract_years_remaining
	if contract_years >= 4:
		multiplier *= 1.2  # Long-term security premium
	elif contract_years == 3:
		multiplier *= 1.1
	elif contract_years == 2:
		multiplier *= 1.0  # Standard
	elif contract_years == 1:
		multiplier *= 0.4  # Massive discount (expiring soon)
		
	# 7. Homegrown Premium (Quota Factor)
	# If buying club is in same league (simplified check) and player is homegrown
	# In a full system we'd check specific league rules
	if player.transfer_data.is_homegrown and club.reputation > 7000:
		multiplier *= 1.2  # PL Homegrown tax
		
	# 8. Commercial Value (Shirt Seller)
	if player.transfer_data.marketability > 0.8:
		multiplier *= 1.15  # Superstar commercial appeal
	elif player.transfer_data.marketability > 0.6:
		multiplier *= 1.05
		
	# 9. Injury Risk (Availability)
	if player.transfer_data.injury_susceptibility > 0.7:
		multiplier *= 0.7  # High risk discount
	elif player.transfer_data.injury_susceptibility > 0.4:
		multiplier *= 0.9  # Moderate risk discount
	
	return base_value * multiplier

# Evaluate rivalry multiplier (applied to selling club's valuation)
static func get_rivalry_multiplier(selling_club, buying_club) -> float:
	if selling_club.rival_clubs.has(buying_club.name):
		return 2.0  # Demand premium from rivals
	return 1.0

# Calculate the present value of installments
static func calculate_installment_value(offer) -> float:
	if offer.payment_immediate:
		return offer.base_fee
	
	var total_value = 0.0
	for inst in offer.installments:
		var amount = inst.get("amount", 0.0)
		var years = inst.get("years", 1)
		
		# Apply time-value discount
		var discount = 1.0
		if years == 1:
			discount = 0.95  # 5% discount
		elif years <= 3:
			discount = 0.85  # 15% discount
		else:
			discount = 0.75  # 25% discount
			
		total_value += amount * discount
	
	return total_value

# Calculate value of sell-on clause
static func calculate_sellon_value(offer, player, buying_club) -> float:
	if offer.sell_on_percentage <= 0:
		return 0.0
	
	var base_value = offer.base_fee
	var potential_factor = 1.0
	
	# High potential young players likely to be sold for more
	if player.age <= 23:
		potential_factor = 1.5
	elif player.age <= 26:
		potential_factor = 1.2
	else:
		potential_factor = 0.8  # Older players less likely to increase value
	
	# Big clubs are better at selling players for profit
	var buyer_selling_ability = clamp(buying_club.reputation / 10000.0, 0.5, 1.5)
	
	# Expected value = base × percentage × potential × selling ability
	var expected_value = base_value * (offer.sell_on_percentage / 100.0) * potential_factor * buyer_selling_ability
	
	# Typical range: 10-30% of base fee
	return clamp(expected_value, base_value * 0.1, base_value * 0.3)

# Calculate value reduction from buyback clause
static func calculate_buyback_value(offer, player) -> float:
	if offer.buyback_clause <= 0:
		return 0.0
	
	var current_value = offer.base_fee
	var buyback_price = offer.buyback_clause
	
	# Only valuable if reasonably priced (1.5-2× current value)
	if buyback_price >= current_value * 1.5 and buyback_price <= current_value * 2.0:
		# Reduces required upfront fee by 15-20%
		var reduction = current_value * 0.175
		
		# More valuable if player has high potential (younger)
		if player.age <= 23:
			reduction *= 1.2
			
		return reduction
	
	return 0.0

# Calculate value of performance bonuses
static func calculate_bonus_value(offer, player) -> float:
	var total_bonus_value = 0.0
	
	# Appearance bonus
	if offer.appearance_bonus_threshold > 0:
		var likelihood = 0.5  # Default 50% chance
		# Starters more likely to hit appearance targets
		if player.squad_role == "Starter":
			likelihood = 0.8
		elif player.squad_role == "Rotation":
			likelihood = 0.5
		else:
			likelihood = 0.2
			
		total_bonus_value += offer.appearance_bonus_fee * likelihood
	
	# Goal bonus
	if offer.goal_bonus_threshold > 0:
		var likelihood = 0.3  # Default lower chance
		# Attackers more likely
		if player.position_on_field in ["ST", "LW", "RW", "CAM"]:
			likelihood = 0.6
		elif player.position_on_field in ["CM", "CDM"]:
			likelihood = 0.2
		else:
			likelihood = 0.1
			
		total_bonus_value += offer.goal_bonus_fee * likelihood
	
	return total_bonus_value

# Calculate total offer value including all clauses
static func calculate_total_offer_value(offer, player, buying_club) -> float:
	var total = 0.0
	
	# 1. Installments (discounted present value)
	total += calculate_installment_value(offer)
	
	# 2. Sell-on clause (expected future value)
	total += calculate_sellon_value(offer, player, buying_club)
	
	# 3. Performance bonuses (probability-weighted)
	total += calculate_bonus_value(offer, player)
	
	# 4. Friendly match (small goodwill value)
	if offer.friendly_match:
		total += offer.base_fee * 0.015  # 1.5%
	
	# 5. Buyback clause reduces total (it's a negative for selling club)
	total -= calculate_buyback_value(offer, player)
	
	return total

# Evaluate an offer and determine response
static func evaluate_offer(offer, player, selling_club, buying_club) -> Dictionary:
	var offer_value = calculate_total_offer_value(offer, player, buying_club)
	var club_valuation = evaluate_player_value_for_club(player, selling_club)
	
	# --- V2 LOGIC ---
	
	# 6. League Tax / Proven Premium (Tier Gap)
	# If both clubs are high reputation (likely same top league), add tax
	if selling_club.reputation > 7000 and buying_club.reputation > 7000:
		club_valuation *= 1.25  # Premier League Tax
		
	# Tier Gap: If buyer is much bigger than seller (Stepping Stone)
	# Seller knows they must sell but demands premium for potential
	if buying_club.reputation > selling_club.reputation + 2000:
		if player.age <= 23:
			club_valuation *= 1.4  # High potential premium
	
	# Apply rivalry multiplier to selling club's valuation
	var rivalry_mult = get_rivalry_multiplier(selling_club, buying_club)
	club_valuation *= rivalry_mult
	
	# 7. Release Clause Logic
	# If offer meets release clause, club MUST accept (valuation cap)
	var release_clause = player.transfer_data.release_clause
	var meets_release_clause = false
	if release_clause > 0 and offer.base_fee >= release_clause:
		meets_release_clause = true
		# Cap valuation at release clause for comparison logic
		if club_valuation > release_clause:
			club_valuation = release_clause
	
	var ratio = offer_value / club_valuation if club_valuation > 0 else 0.0
	
	var response = OfferResponse.NEGOTIATE
	var should_damage_relationship = false
	
	if meets_release_clause:
		response = OfferResponse.AUTO_ACCEPT
	# Auto-accept if offer meets valuation (100%+)
	elif ratio >= 1.0:
		response = OfferResponse.AUTO_ACCEPT
	# Auto-reject if offer is 60%+ under value (40% or less)
	elif ratio <= 0.4:
		response = OfferResponse.AUTO_REJECT
		should_damage_relationship = true  # Insulting offer
	else:
		response = OfferResponse.NEGOTIATE
	
	return {
		"response": response,
		"offer_value": offer_value,
		"club_valuation": club_valuation,
		"ratio": ratio,
		"damage_relationship": should_damage_relationship,
		"meets_release_clause": meets_release_clause
	}
