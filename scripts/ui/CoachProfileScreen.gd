extends Control

signal request_push(screen_scene)
signal request_pop()

@onready var coach_name_label = $VBoxContainer/Header/CoachNameLabel
@onready var hire_coach_button = $VBoxContainer/Header/HireCoachButton
@onready var basic_info = $VBoxContainer/ScrollContainer/VBox/BasicInfoCard/VBox/InfoLabel
@onready var archetype_info = $VBoxContainer/ScrollContainer/VBox/ArchetypeCard/VBox/ArchetypeLabel
@onready var attributes_info = $VBoxContainer/ScrollContainer/VBox/AttributesCard/VBox/AttributesLabel
@onready var tactical_info = $VBoxContainer/ScrollContainer/VBox/TacticalCard/VBox/TacticalLabel
@onready var relationship_info = $VBoxContainer/ScrollContainer/VBox/RelationshipCard/VBox/RelationshipLabel
@onready var staff_container = $VBoxContainer/ScrollContainer/VBox/StaffCard/VBox/StaffContainer
@onready var contract_info = $VBoxContainer/ScrollContainer/VBox/ContractCard/VBox/ContractLabel

var current_coach = null

func _ready():
	# Only connect signals - no autoload access yet
	if hire_coach_button:
		hire_coach_button.pressed.connect(_on_hire_coach_pressed)

func _create_test_coach():
	"""Create a test coach for demonstration"""
	var coach_script = load("res://scripts/character/head_coach_profile.gd")
	current_coach = coach_script.new("Emma Martinez")
	
	current_coach.age = 42
	current_coach.nationality = "Spanish"
	current_coach.reputation = 65
	current_coach.archetype = "The System"
	current_coach.tactical_style = "Control"
	current_coach.apply_archetype_attributes()
	current_coach.weekly_wage = 75000
	current_coach.contract_years = 2.5
	current_coach.seasons_at_club = 1
	current_coach.director_relationship = 72
	
	current_coach.coaching_staff = {
		"assistant_coach": true,
		"set_piece_coach": true,
		"sports_psychologist": true
	}
	
	CoachManager.current_head_coach = current_coach
	_refresh_display()

func set_coach(coach):
	current_coach = coach
	_refresh_display()

func _refresh_display():
	if not current_coach:
		return
	
	# Header
	coach_name_label.text = current_coach.coach_name
	
	# Basic Info
	basic_info.text = "Age: %d\nNationality: %s\nReputation: %d/100\nSeasons at Club: %d" % [
		current_coach.age,
		current_coach.nationality,
		current_coach.reputation,
		current_coach.seasons_at_club
	]
	
	# Archetype
	var archetype_data = current_coach.ARCHETYPE_MECHANICS.get(current_coach.archetype, {})
	var bonuses = archetype_data.get("squad_fit_bonus", {})
	var penalties = archetype_data.get("squad_fit_penalty", {})
	
	archetype_info.text = "%s\n\nTactical Style: %s\n\n" % [
		current_coach.archetype,
		current_coach.tactical_style
	]
	
	if bonuses:
		archetype_info.text += "WHEN SQUAD FITS (≥75%):\n"
		for key in bonuses:
			archetype_info.text += "• %s: %s\n" % [key, str(bonuses[key])]
	
	# Attributes
	attributes_info.text = "CORE ATTRIBUTES (1-20):\n\n"
	for attr in current_coach.attributes:
		attributes_info.text += "%s: %d\n" % [attr.capitalize(), current_coach.attributes[attr]]
	
	# Tactical Requirements
	var style_reqs = current_coach.STYLE_REQUIREMENTS.get(current_coach.tactical_style, {})
	tactical_info.text = "Required Player Attributes:\n"
	for req in style_reqs.get("must_have", []):
		tactical_info.text += "• %s\n" % req
	
	tactical_info.text += "\nStrength: %s\n" % style_reqs.get("strength", "")
	tactical_info.text += "Weakness: %s" % style_reqs.get("weakness", "")
	
	# Relationship
	var rel_status = current_coach._get_relationship_status()
	relationship_info.text = "Director Relationship: %d/100\n\nStatus: %s" % [
		current_coach.director_relationship,
		rel_status
	]
	
	# Coaching Staff
	_refresh_staff()
	
	# Contract
	contract_info.text = "Weekly Wage: £%s\nContract: %.1f years remaining" % [
		_format_number(current_coach.weekly_wage),
		current_coach.contract_years
	]

func _refresh_staff():
	# Clear existing
	for child in staff_container.get_children():
		child.queue_free()
	
	if current_coach.coaching_staff.is_empty():
		var label = Label.new()
		label.text = "No coaching staff"
		staff_container.add_child(label)
		return
	
	var staff_bonuses = current_coach.STAFF_BONUSES
	for staff_type in current_coach.coaching_staff:
		if current_coach.coaching_staff[staff_type]:
			var hbox = HBoxContainer.new()
			
			var name_label = Label.new()
			name_label.text = staff_type.replace("_", " ").capitalize()
			name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			hbox.add_child(name_label)
			
			var effect_label = Label.new()
			var staff_data = staff_bonuses.get(staff_type, {})
			effect_label.text = staff_data.get("effect", "")
			effect_label.add_theme_color_override("font_color", Color(0.7, 0.9, 0.7))
			hbox.add_child(effect_label)
			
			staff_container.add_child(hbox)

func _format_number(value: int) -> String:
	if value >= 1000:
		return str(value / 1000) + "k"
	return str(value)

func _on_back_button_pressed():
	request_pop.emit()

func _on_hire_coach_pressed():
	"""Navigate to coach hiring screen"""
	var hiring_screen = load("res://scenes/ui/CoachHiringScreen.tscn").instantiate()
	hiring_screen.coach_hired.connect(_on_coach_hired)
	request_push.emit(hiring_screen)

func _on_coach_hired(coach):
	"""Called when a new coach is hired"""
	set_coach(coach)
	_refresh_display()

func on_enter():
	# Safe to access CoachManager here - autoloads are ready
	if CoachManager.current_head_coach:
		set_coach(CoachManager.current_head_coach)
	else:
		# Create test coach if none exists
		_create_test_coach()
	_refresh_display()

func on_exit():
	pass
