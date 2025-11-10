```gdscript
extends Control

@onready var header_container = $VBoxContainer/Header
@onready var tab_container = $VBoxContainer/TabBar
@onready var content_container = $VBoxContainer/PanelContent

var player_data: PlayerData
var current_panel: int = 0
var panels: Array[Node] = []

const PANEL_NAMES = [
	"Overview",
	"Scout Report",
	"Analyst Report",
	"Coach Report",
	"Medical Report",
	"PLO Report",
	"Contract",
	"Transfer",
	"History"
]

func _ready() -> void:
	player_data = PlayerData.new()
	_load_player_data()
	_setup_ui()
	_show_panel(0)

func _load_player_data() -> void:
	# Load sample player data
	player_data.name = "Marcus Silva"
	player_data.position = "ST"
	player_data.secondary_positions = ["CF", "LW"]
	player_data.age = 26
	player_data.nationality = "Brazil"
	player_data.overall_rating = 84
	
	# Overview
	player_data.key_strengths = ["Elite finishing ability", "Excellent movement in the box", "Strong aerial presence"]
	player_data.current_form = "Excellent (9/10)"
	player_data.contract_status = "Secure - 3 years remaining"
	player_data.injury_status = "Fully Fit"
	player_data.market_value = "£45.5M"
	
	# Scout Report
	player_data.playing_style = "A clinical striker who thrives in the penalty area. Silva is a poacher with excellent positioning and finishing."
	player_data.traits = ["Clinical Finisher", "Poacher", "Aerial Threat", "Speed Demon", "One-on-One Specialist", "Penalty Expert"]
	player_data.strengths = ["World-class finishing with both feet", "Exceptional positioning and movement", "Strong in the air", "Clinical in one-on-one situations", "High work rate and pressing"]
	player_data.weaknesses = ["Limited playmaking ability", "Can be isolated if service is poor"]
	player_data.scout_rating = 8.5
	player_data.scout_notes = "Silva is a proven goalscorer at the highest level."
	
	# Analyst Report
	player_data.current_season = {
		"games": 28,
		"goals": 21,
		"assists": 6,
		"pass_accuracy": 78,
		"shots_per_game": 4.2,
		"shots_on_target": 54,
		"tackles": 12
	}
	player_data.career_stats = {
		"total_games": 312,
		"total_goals": 189,
		"total_assists": 47,
		"goals_per_game": 0.61
	}
	player_data.key_metrics = {
		"finishing": 92,
		"positioning": 88,
		"pace": 85,
		"dribbling": 76,
		"passing": 74,
		"heading": 81,
		"strength": 78,
		"stamina": 83
	}
	
	# Coach Report
	player_data.personality = "Professional"
	player_data.work_rate = 8.5
	player_data.leadership = 7
	player_data.tactical_fit = "Excellent - Perfect for counter-attacking system"
	player_data.morale = "High"
	player_data.attitude = "Model Professional"
	player_data.training_performance = 8
	
	# Medical Report
	player_data.fitness_level = 95
	player_data.condition = "Fresh"
	player_data.current_injuries = []
	player_data.injury_proneness = "Low"
	player_data.physical_attributes = {
		"stamina": 83,
		"strength": 78,
		"speed": 85,
		"agility": 80
	}
	
	# PLO Report
	player_data.happiness = 85
	player_data.manager_relationship = 9
	player_data.teammate_relationship = 8
	player_data.fan_relationship = 9
	player_data.morale_trend = "Stable"
	
	# Contract
	player_data.start_date = "July 1, 2023"
	player_data.end_date = "June 30, 2027"
	player_data.weekly_wage = "£125,000"
	player_data.release_clause = "£65M"
	player_data.contract_status_detail = "Satisfied"

func _setup_ui() -> void:
	_setup_header()
	_setup_tabs()
	_setup_panels()

func _setup_header() -> void:
	var header_label = Label.new()
	header_label.text = "%s | %s | Age %d | %s" % [player_data.name, player_data.position, player_data.age, player_data.nationality]
	header_label.add_theme_font_size_override("font_size", 24)
	
	var rating_label = Label.new()
	rating_label.text = "Overall Rating: %d" % player_data.overall_rating
	rating_label.add_theme_font_size_override("font_size", 20)
	
	header_container.add_child(header_label)
	header_container.add_child(rating_label)

func _setup_tabs() -> void:
	tab_container.clear_children()
	
	for i in range(PANEL_NAMES.size()):
		var tab_button = Button.new()
		tab_button.text = PANEL_NAMES[i]
		tab_button.custom_minimum_size = Vector2(100, 40)
		tab_button.pressed.connect(_on_tab_pressed.bind(i))
		tab_container.add_child(tab_button)

func _setup_panels() -> void:
	# Instantiate all panel scenes
	# For this example, we'll create them dynamically
	panels = []
	for i in range(PANEL_NAMES.size()):
		panels.append(null)

func _show_panel(panel_index: int) -> void:
	current_panel = panel_index
	content_container.clear_children()
	
	var panel_content = Label.new()
	panel_content.text = "Panel: %s\n\nLoad your panel scene here" % PANEL_NAMES[panel_index]
	content_container.add_child(panel_content)
	
	match panel_index:
		0:
			_show_overview_panel()
		1:
			_show_scout_panel()
		2:
			_show_analyst_panel()
		3:
			_show_coach_panel()
		4:
			_show_medical_panel()
		5:
			_show_plo_panel()
		6:
			_show_contract_panel()
		7:
			_show_transfer_panel()
		8:
			_show_history_panel()

func _show_overview_panel() -> void:
	content_container.clear_children()
	var vbox = VBoxContainer.new()
	content_container.add_child(vbox)
	
	# Overall Rating
	var rating_label = Label.new()
	rating_label.text = "Overall Rating: %d" % player_data.overall_rating
	rating_label.add_theme_font_size_override("font_size", 32)
	vbox.add_child(rating_label)
	
	# Key Strengths
	var strengths_label = Label.new()
	strengths_label.text = "Key Strengths:"
	strengths_label.add_theme_font_size_override("font_size", 18)
	vbox.add_child(strengths_label)
	
	for strength in player_data.key_strengths:
		var item_label = Label.new()
		item_label.text = "• " + strength
		vbox.add_child(item_label)
	
	# Status Info
	var status_hbox = HBoxContainer.new()
	vbox.add_child(status_hbox)
	
	var form_label = Label.new()
	form_label.text = "Form: %s" % player_data.current_form
	status_hbox.add_child(form_label)
	
	var injury_label = Label.new()
	injury_label.text = "Injury: %s" % player_data.injury_status
	status_hbox.add_child(injury_label)
	
	var value_label = Label.new()
	value_label.text = "Market Value: %s" % player_data.market_value
	vbox.add_child(value_label)

func _show_scout_panel() -> void:
	content_container.clear_children()
	var vbox = VBoxContainer.new()
	content_container.add_child(vbox)
	
	var style_label = Label.new()
	style_label.text = player_data.playing_style
	style_label.autowrap_mode = TextServer.AUTOWRAP_WORD
	vbox.add_child(style_label)
	
	var traits_label = Label.new()
	traits_label.text = "Traits:"
	traits_label.add_theme_font_size_override("font_size", 16)
	vbox.add_child(traits_label)
	
	for trait in player_data.traits:
		var trait_label = Label.new()
		trait_label.text = "• " + trait
		vbox.add_child(trait_label)

func _show_analyst_panel() -> void:
	content_container.clear_children()
	var vbox = VBoxContainer.new()
	content_container.add_child(vbox)
	
	var season_label = Label.new()
	season_label.text = "Current Season Stats:"
	season_label.add_theme_font_size_override("font_size", 16)
	vbox.add_child(season_label)
	
	for key in player_data.current_season.keys():
		var stat_label = Label.new()
		stat_label.text = "%s: %s" % [key.capitalize(), player_data.current_season[key]]
		vbox.add_child(stat_label)
	
	var career_label = Label.new()
	career_label.text = "\nCareer Stats:"
	career_label.add_theme_font_size_override("font_size", 16)
	vbox.add_child(career_label)
	
	for key in player_data.career_stats.keys():
		var stat_label = Label.new()
		stat_label.text = "%s: %s" % [key.capitalize(), player_data.career_stats[key]]
		vbox.add_child(stat_label)

func _show_coach_panel() -> void:
	content_container.clear_children()
	var vbox = VBoxContainer.new()
	content_container.add_child(vbox)
	
	var info_array = [
		["Personality:", player_data.personality],
		["Work Rate:", "%.1f/10" % player_data.work_rate],
		["Leadership:", "%.1f/10" % player_data.leadership],
		["Tactical Fit:", player_data.tactical_fit],
		["Morale:", player_data.morale],
		["Attitude:", player_data.attitude]
	]
	
	for info in info_array:
		var label = Label.new()
		label.text = "%s %s" % [info[0], info[1]]
		vbox.add_child(label)

func _show_medical_panel() -> void:
	content_container.clear_children()
	var vbox = VBoxContainer.new()
	content_container.add_child(vbox)
	
	var fitness_label = Label.new()
	fitness_label.text = "Fitness: %d%%" % player_data.fitness_level
	vbox.add_child(fitness_label)
	
	var condition_label = Label.new()
	condition_label.text = "Condition: %s" % player_data.condition
	vbox.add_child(condition_label)
	
	var injuries_label = Label.new()
	injuries_label.text = "Current Injuries: %s" % ("None" if player_data.current_injuries.is_empty() else "See details")
	vbox.add_child(injuries_label)

func _show_plo_panel() -> void:
	content_container.clear_children()
	var vbox = VBoxContainer.new()
	content_container.add_child(vbox)
	
	var happiness_label = Label.new()
	happiness_label.text = "Happiness: %d/100" % player_data.happiness
	vbox.add_child(happiness_label)
	
	var manager_label = Label.new()
	manager_label.text = "Manager Relationship: %d/10" % player_data.manager_relationship
	vbox.add_child(manager_label)
	
	var morale_label = Label.new()
	morale_label.text = "Morale Trend: %s" % player_data.morale_trend
	vbox.add_child(morale_label)

func _show_contract_panel() -> void:
	content_container.clear_children()
	var vbox = VBoxContainer.new()
	content_container.add_child(vbox)
	
	var contract_array = [
		["Start Date:", player_data.start_date],
		["End Date:", player_data.end_date],
		["Weekly Wage:", player_data.weekly_wage],
		["Release Clause:", player_data.release_clause],
		["Status:", player_data.contract_status_detail]
	]
	
	for contract_info in contract_array:
		var label = Label.new()
		label.text = "%s %s" % [contract_info[0], contract_info[1]]
		vbox.add_child(label)

func _show_transfer_panel() -> void:
	content_container.clear_children()
	var vbox = VBoxContainer.new()
	content_container.add_child(vbox)
	
	var value_label = Label.new()
	value_label.text = "Market Value: %s" % player_data.market_value
	value_label.add_theme_font_size_override("font_size", 24)
	vbox.add_child(value_label)
	
	var status_label = Label.new()
	status_label.text = "Transfer Status: %s" % player_data.transfer_status
	vbox.add_child(status_label)

func _show_history_panel() -> void:
	content_container.clear_children()
	var vbox = VBoxContainer.new()
	content_container.add_child(vbox)
	
	var achievements_label = Label.new()
	achievements_label.text = "Achievements:"
	achievements_label.add_theme_font_size_override("font_size", 16)
	vbox.add_child(achievements_label)
	
	for achievement in player_data.achievements:
		var ach_label = Label.new()
		ach_label.text = "• " + achievement
		vbox.add_child(ach_label)

func _on_tab_pressed(index: int) -> void:
	_show_panel(index)
```
