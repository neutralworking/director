extends Node
# CoachManager - Singleton for managing head coaches
# Similar to CharacterManager but for coaching staff

var current_head_coach = null
var available_coaches: Array = []

# Preload coach profile script
const CoachProfile = preload("res://scripts/character/head_coach_profile.gd")

func _ready():
	print("CoachManager initialized")

func generate_sample_coaches(count: int = 10):
	"""Generate pool of available coaches for hiring"""
	available_coaches.clear()
	
	var archetypes = ["The System", "The People", "The Believer", "The Builder", "The Winner"]
	var styles = ["Control", "Transition", "Defense"]
	
	var first_names = ["Marco", "Sarah", "Viktor", "Emma", "Carlos", "Lisa", "Ahmed", "Yuki", "Diego", "Anna"]
	var last_names = ["Rossi", "Chen", "Petrov", "Silva", "Garcia", "Schmidt", "Hassan", "Tanaka", "Martinez", "Kowalski"]
	
	for i in range(count):
		var coach = CoachProfile.new()
		coach.coach_name = first_names[i % first_names.size()] + " " + last_names[i % last_names.size()]
		coach.age = randi_range(35, 65)
		coach.nationality = ["English", "Spanish", "Italian", "German", "French"].pick_random()
		coach.reputation = randi_range(20, 80)
		coach.archetype = archetypes.pick_random()
		coach.tactical_style = styles.pick_random()
		coach.apply_archetype_attributes()
		coach.weekly_wage = coach.calculate_wage_demands(50)  # Assume rep 50 club
		coach.contract_years = randf_range(1.5, 3.0)
		
		# Add some coaching staff
		var staff_options = ["assistant_coach", "fitness_coach", "sports_psychologist", "set_piece_coach"]
		var num_staff = randi_range(2, 3)
		coach.coaching_staff = {}
		for j in range(num_staff):
			var staff_type = staff_options[j % staff_options.size()]
			coach.coaching_staff[staff_type] = true
		
		available_coaches.append(coach)
	
	print("Generated %d coaches" % count)

func hire_coach(coach):
	"""Set as current head coach"""
	if current_head_coach:
		print("Warning: Replacing current coach %s with %s" % [current_head_coach.coach_name, coach.coach_name])
	
	current_head_coach = coach
	available_coaches.erase(coach)
	print("Hired %s as head coach" % coach.coach_name)

func fire_coach():
	"""Fire current coach"""
	if current_head_coach:
		print("Fired %s" % current_head_coach.coach_name)
		# Calculate severance (simplified)
		var severance = current_head_coach.weekly_wage * 52 * current_head_coach.contract_years
		print("Severance payment: £%d" % severance)
		current_head_coach = null

func get_current_coach():
	return current_head_coach

func conduct_quarterly_review(results: Dictionary) -> Dictionary:
	"""Run quarterly review for current coach"""
	if not current_head_coach:
		return {}
	
	return current_head_coach.conduct_quarterly_review(results)

func end_of_season():
	"""Called at season end"""
	if current_head_coach:
		current_head_coach.end_of_season_progression()
		print("Coach %s aged to %d, seasons at club: %d" % [
			current_head_coach.coach_name,
			current_head_coach.age,
			current_head_coach.seasons_at_club
		])
