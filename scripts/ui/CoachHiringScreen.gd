extends "res://scripts/ui/Screen.gd"

signal coach_hired(coach)

@onready var available_coaches_list = $VBoxContainer/HBox/LeftPanel/VBox/ScrollContainer/CoachList
@onready var detail_panel = $VBoxContainer/HBox/RightPanel
@onready var coach_name_label = $VBoxContainer/HBox/RightPanel/VBox/NameLabel
@onready var detail_text = $VBoxContainer/HBox/RightPanel/VBox/ScrollContainer/DetailText
@onready var hire_button = $VBoxContainer/HBox/RightPanel/VBox/HireButton
@onready var compatibility_label = $VBoxContainer/HBox/RightPanel/VBox/CompatibilityLabel

var available_coaches: Array = []
var selected_coach = null
var director_archetype: String = "The Scout"  # TODO: Get from actual director

func _ready():
	# Only connect signals - no autoload access yet
	hire_button.pressed.connect(_on_hire_pressed)
	detail_panel.visible = false

func _populate_coach_list():
	# Clear existing
	for child in available_coaches_list.get_children():
		child.queue_free()
	
	# Sort by reputation
	available_coaches.sort_custom(func(a, b): return a.reputation > b.reputation)
	
	for coach in available_coaches:
		var button = Button.new()
		button.custom_minimum_size = Vector2(0, 80)
		button.text_overrun_behavior = TextServer.OVERRUN_NO_TRIMMING
		
		# Format coach info
		var button_text = "%s\n%s | %s\nRep: %d | Age: %d | £%s/week" % [
			coach.coach_name,
			coach.archetype,
			coach.tactical_style,
			coach.reputation,
			coach.age,
			_format_wage(coach.weekly_wage)
		]
		button.text = button_text
		
		# Color code by compatibility
		var compatibility = coach.calculate_director_compatibility(director_archetype)
		if compatibility >= 80:
			button.modulate = Color(0.7, 1.0, 0.7)  # Green
		elif compatibility <= 30:
			button.modulate = Color(1.0, 0.7, 0.7)  # Red
		
		button.pressed.connect(_on_coach_selected.bind(coach))
		available_coaches_list.add_child(button)

func _on_coach_selected(coach):
	selected_coach = coach
	detail_panel.visible = true
	_show_coach_details()

func _show_coach_details():
	if not selected_coach:
		return
	
	coach_name_label.text = selected_coach.coach_name
	
	# Calculate compatibility with director
	var compatibility = selected_coach.calculate_director_compatibility(director_archetype)
	var comp_color = Color.GREEN if compatibility >= 70 else (Color.YELLOW if compatibility >= 40 else Color.RED)
	compatibility_label.text = "Director Compatibility: %d%%" % compatibility
	compatibility_label.add_theme_color_override("font_color", comp_color)
	
	# Build detailed info
	var details = ""
	
	# Basic Info
	details += "═══ BASIC INFO ═══\n"
	details += "Age: %d\n" % selected_coach.age
	details += "Nationality: %s\n" % selected_coach.nationality
	details += "Reputation: %d/100\n\n" % selected_coach.reputation
	
	# Archetype
	details += "═══ ARCHETYPE ═══\n"
	details += "%s\n" % selected_coach.archetype
	details += "Tactical Style: %s\n\n" % selected_coach.tactical_style
	
	# Attributes
	details += "═══ ATTRIBUTES ═══\n"
	for attr in selected_coach.attributes:
		var value = selected_coach.attributes[attr]
		var bar = _create_stat_bar(value)
		details += "%s: %d %s\n" % [attr.capitalize(), value, bar]
	details += "\n"
	
	# Key Strengths
	var archetype_data = selected_coach.ARCHETYPE_MECHANICS.get(selected_coach.archetype, {})
	var bonuses = archetype_data.get("squad_fit_bonus", {})
	
	if bonuses:
		details += "═══ STRENGTHS (When Squad Fits) ═══\n"
		for key in bonuses:
			details += "• %s: %s\n" % [key.replace("_", " ").capitalize(), str(bonuses[key])]
		details += "\n"
	
	# Weaknesses
	var penalties = archetype_data.get("squad_fit_penalty", {})
	if penalties:
		details += "═══ WEAKNESSES (Poor Squad Fit) ═══\n"
		for key in penalties:
			details += "• %s: %s\n" % [key.replace("_", " ").capitalize(), str(penalties[key])]
		details += "\n"
	
	# Tactical Requirements
	var style_reqs = selected_coach.STYLE_REQUIREMENTS.get(selected_coach.tactical_style, {})
	details += "═══ TACTICAL REQUIREMENTS ═══\n"
	details += "Must Have:\n"
	for req in style_reqs.get("must_have", []):
		details += "  • %s\n" % req
	details += "\nStrength: %s\n" % style_reqs.get("strength", "")
	details += "Weakness: %s\n\n" % style_reqs.get("weakness", "")
	
	# Coaching Staff
	if not selected_coach.coaching_staff.is_empty():
		details += "═══ BRINGS COACHING STAFF ═══\n"
		var staff_bonuses = selected_coach.STAFF_BONUSES
		for staff_type in selected_coach.coaching_staff:
			if selected_coach.coaching_staff[staff_type]:
				var staff_data = staff_bonuses.get(staff_type, {})
				details += "• %s\n  %s\n" % [
					staff_type.replace("_", " ").capitalize(),
					staff_data.get("effect", "")
				]
		details += "\n"
	
	# Contract Demands
	details += "═══ CONTRACT DEMANDS ═══\n"
	details += "Weekly Wage: £%s\n" % _format_wage(selected_coach.weekly_wage)
	details += "Contract Length: %.1f years\n" % selected_coach.contract_years
	
	# Annual cost
	var annual_cost = selected_coach.weekly_wage * 52
	details += "Annual Cost: £%s\n" % _format_wage(annual_cost)
	
	detail_text.text = details

func _create_stat_bar(value: int, max_value: int = 20) -> String:
	var filled = int(value / 2.0)  # Convert 20-scale to 10-bar
	var empty = 10 - filled
	return "█" .repeat(filled) + "░".repeat(empty)

func _format_wage(value: int) -> String:
	if value >= 1000000:
		return "%.1fM" % (value / 1000000.0)
	elif value >= 1000:
		return "%dk" % (value / 1000)
	return str(value)

func _on_hire_pressed():
	if not selected_coach:
		return
	
	# Check if can afford
	# TODO: Check actual club finances
	var can_afford = true
	
	if not can_afford:
		_show_cant_afford_message()
		return
	
	# Hire coach
	CoachManager.hire_coach(selected_coach)
	
	# Emit signal
	coach_hired.emit(selected_coach)
	
	# Show confirmation
	_show_hire_confirmation()
	
	# Return to previous screen
	await get_tree().create_timer(1.5).timeout
	request_pop.emit()

func _show_cant_afford_message():
	hire_button.text = "CAN'T AFFORD!"
	await get_tree().create_timer(2.0).timeout
	hire_button.text = "HIRE"

func _show_hire_confirmation():
	hire_button.text = "✓ HIRED!"
	hire_button.disabled = true

func _on_back_button_pressed():
	request_pop.emit()

func on_enter():
	# Safe to access CoachManager here - autoloads are ready
	if CoachManager.available_coaches.is_empty():
		CoachManager.generate_sample_coaches(12)
	available_coaches = CoachManager.available_coaches
	_populate_coach_list()
	detail_panel.visible = false
	selected_coach = null

func on_exit():
	pass
