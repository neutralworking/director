class_name TransferValueCalculator
extends Node

# Multipliers
const AGE_PEAK_START = 24
const AGE_PEAK_END = 29
const AGE_MULTIPLIER_YOUNG = 1.5
const AGE_MULTIPLIER_PEAK = 1.2
const AGE_MULTIPLIER_OLD = 0.8

const POTENTIAL_MULTIPLIER_HIGH = 1.5
const POTENTIAL_MULTIPLIER_MED = 1.1

const CONTRACT_LONG_TERM = 3 # years
const CONTRACT_MULTIPLIER_LONG = 1.3
const CONTRACT_MULTIPLIER_SHORT = 0.7

static func calculate_value(player, buyer_club = null, seller_club = null) -> float:
	if player.transfer_data == null:
		return 0.0
		
	var base_value = player.transfer_data.base_value
	var multiplier = 1.0
	
	# 1. Age Factor
	if player.age < AGE_PEAK_START:
		multiplier *= AGE_MULTIPLIER_YOUNG
	elif player.age <= AGE_PEAK_END:
		multiplier *= AGE_MULTIPLIER_PEAK
	else:
		multiplier *= AGE_MULTIPLIER_OLD
		
	# 2. Potential/Archetype Factor (Simplified for now, assuming archetype has some inherent value)
	# In a real scenario, we'd check the archetype's tier or potential stats
	if player.archetype:
		# Example: High ambition players might be valued higher or lower depending on market
		if player.archetype.ambition > 0.7:
			multiplier *= 1.1
			
	# 3. Marketability
	multiplier *= (1.0 + player.transfer_data.marketability)
	
	# 4. Contract Status (Placeholder logic as Player doesn't have contract details yet)
	# Assuming a standard contract for now
	
	# 5. Form/Morale
	if player.morale > 80:
		multiplier *= 1.1
	elif player.morale < 40:
		multiplier *= 0.9
		
	# 6. Scouting/Analyst Discovery Bonus
	# If the buyer has discovered positive traits, value goes up (or they are willing to pay more)
	# If negative traits are discovered, value might go down in negotiation, but base value remains.
	# However, for "perceived value", discovered positive traits boost it.
	for trait_name in player.transfer_data.scouting_traits:
		var trait_data = player.transfer_data.scouting_traits[trait_name]
		if trait_data.get("discovered", false):
			var effect = trait_data.get("effect", 0.0)
			multiplier *= (1.0 + effect)
			
	# 7. Latent Issues (Negative impact if known)
	# We need a way to check if the *buyer* knows about these. 
	# For now, let's assume this function calculates "Objective Market Value".
	# Negotiation logic would handle knowledge asymmetry.
	
	return base_value * multiplier
