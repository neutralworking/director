extends Control

signal request_push(screen_scene)
signal request_pop()

@onready var director_name_label = $VBoxContainer/Header/DirectorNameLabel
@onready var basic_info_label = $VBoxContainer/ScrollContainer/VBox/BasicInfoCard/VBox/InfoLabel
@onready var archetype_label = $VBoxContainer/ScrollContainer/VBox/ArchetypeCard/VBox/ArchetypeLabel
@onready var strengths_label = $VBoxContainer/ScrollContainer/VBox/StrengthsCard/VBox/StrengthsLabel
@onready var flaw_label = $VBoxContainer/ScrollContainer/VBox/FlawCard/VBox/FlawLabel
@onready var stats_label = $VBoxContainer/ScrollContainer/VBox/StatsCard/VBox/StatsLabel
@onready var career_label = $VBoxContainer/ScrollContainer/VBox/CareerCard/VBox/CareerLabel
@onready var badges_container = $VBoxContainer/ScrollContainer/VBox/BadgesCard/VBox/BadgesContainer

var director_profile = null

func _ready():
	# For now, create a test director
	# TODO: Load from actual game save
	_create_test_director()

func _create_test_director():
	var director_script = load("res://scripts/character/director_profile.gd")
	director_profile = director_script.new("Emma Chen")
	
	director_profile.date_of_birth = {"year": 1988, "month": 3, "day": 15}
	director_profile.nationality = "Chinese"
	director_profile.background = "Data Analyst"
	director_profile.archetype = "The Scout"
	director_profile.strengths = ["Sharp Eye", "Future Focused"]
	director_profile.flaw = "Conflict-Averse"
	director_profile.reputation = 35
	director_profile.seasons_completed = 3
	
	director_profile.calculate_stats()
	
	_refresh_display()

func set_director(director):
	director_profile = director
	_refresh_display()

func _refresh_display():
	if not director_profile:
		return
	
	# Header
	director_name_label.text = director_profile.director_name
	
	# Basic Info
	var age = director_profile.get_age()
	basic_info_label.text = "Age: %d\nNationality: %s\nReputation: %d/100\nSeasons Completed: %d" % [
		age,
		director_profile.nationality,
		director_profile.reputation,
		director_profile.seasons_completed
	]
	
	# Archetype
	var archetype_info = director_profile.ARCHETYPE_EFFECTS.get(director_profile.archetype, {})
	var strengths_text = "\n• ".join(archetype_info.get("strengths", []))
	var weaknesses_text = "\n• ".join(archetype_info.get("weaknesses", []))
	
	archetype_label.text = "%s\n\nBackground: %s\n\nSTRENGTHS:\n• %s\n\nWEAKNESSES:\n• %s" % [
		director_profile.archetype,
		director_profile.background,
		strengths_text,
		weaknesses_text
	]
	
	# Strengths
	var strengths_info = ""
	for strength in director_profile.strengths:
		var info = director_profile.AVAILABLE_STRENGTHS.get(strength, {})
		strengths_info += "• %s\n  %s\n\n" % [strength, info.get("gameplay", "")]
	strengths_label.text = strengths_info
	
	# Flaw
	var flaw_info = director_profile.AVAILABLE_FLAWS.get(director_profile.flaw, {})
	flaw_label.text = "%s\n\n%s\n\nGameplay: %s" % [
		director_profile.flaw,
		flaw_info.get("effect", ""),
		flaw_info.get("gameplay", "")
	]
	
	# Stats
	stats_label.text = """ATTRIBUTES (1-20):

Talent ID: %d
Potential ID: %d
Negotiation: %d
Tactics: %d
Charisma: %d
Youth Dev: %d
Determination: %d
Adaptability: %d""" % [
		director_profile.stats["talent_id"],
		director_profile.stats["potential_id"],
		director_profile.stats["negotiation"],
		director_profile.stats["tactics"],
		director_profile.stats["charisma"],
		director_profile.stats["youth_dev"],
		director_profile.stats["determination"],
		director_profile.stats["adaptability"]
	]
	
	# Career Record
	career_label.text = """CAREER RECORD:

Clubs: %d
Trophies: %d
Promotions: %d
Transfer Profit: £%.1fM
Youth Promoted: %d
Legendary Signings: %d
Disasters: %d""" % [
		director_profile.career_record.get("clubs", 0),
		director_profile.career_record.get("trophies", 0),
		director_profile.career_record.get("promotions", 0),
		director_profile.career_record.get("transfer_profit", 0.0),
		director_profile.career_record.get("youth_promoted", 0),
		director_profile.career_record.get("legendary_signings", 0),
		director_profile.career_record.get("disastrous_signings", 0)
	]
	
	# Badges
	_refresh_badges()

func _refresh_badges():
	# Clear existing badges
	for child in badges_container.get_children():
		child.queue_free()
	
	if director_profile.badges.size() == 0:
		var label = Label.new()
		label.text = "No badges earned yet. Keep playing to unlock achievements!"
		badges_container.add_child(label)
	else:
		for badge_name in director_profile.badges:
			var badge_info = director_profile.BADGE_SYSTEM.get(badge_name, {})
			var panel = PanelContainer.new()
			var vbox = VBoxContainer.new()
			
			var title = Label.new()
			title.text = "🏆 " + badge_name
			vbox.add_child(title)
			
			var desc = Label.new()
			desc.text = badge_info.get("bonus", "")
			desc.add_theme_color_override("font_color", Color(0.8, 0.8, 0.8))
			vbox.add_child(desc)
			
			panel.add_child(vbox)
			badges_container.add_child(panel)

func _on_back_button_pressed():
	request_pop.emit()

func on_enter():
	_refresh_display()

func on_exit():
	pass
