class_name ScoutingSystem
extends Node

# Probability of discovering a trait depends on scout's attributes
static func discover_trait(player, scout_ability: float) -> bool:
	if player.transfer_data == null:
		return false
		
	var traits = player.transfer_data.scouting_traits
	var undiscovered = []
	
	for trait_name in traits:
		if not traits[trait_name].get("discovered", false):
			undiscovered.append(trait_name)
			
	if undiscovered.is_empty():
		return false
		
	# Simple check: Scout ability (0-100) vs Random roll
	# Higher ability = higher chance to find something
	if randf() * 100 < scout_ability:
		var trait_to_reveal = undiscovered.pick_random()
		traits[trait_to_reveal]["discovered"] = true
		return true
		
	return false

static func reveal_latent_issue(player, scout_ability: float) -> String:
	if player.transfer_data == null:
		return ""
		
	# Latent issues are harder to find
	if player.transfer_data.latent_issues.is_empty():
		return ""
		
	# Hard check
	if randf() * 150 < scout_ability:
		# For now, we don't have a "discovered" flag for latent issues in the simple array
		# We might want to move latent_issues to a Dictionary like traits if we want to track discovery permanently
		# For now, let's just return one if found
		return player.transfer_data.latent_issues.pick_random()
		
	return ""
