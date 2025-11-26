extends Control

signal director_created(director_profile)
signal creation_cancelled

# UI References
@onready var step_container = $VBoxContainer/StepContainer
@onready var progress_label = $VBoxContainer/Header/ProgressLabel
@onready var description_label = $VBoxContainer/DescriptionPanel/DescriptionLabel
@onready var next_button = $VBoxContainer/ButtonContainer/NextButton
@onready var back_button = $VBoxContainer/ButtonContainer/BackButton
@onready var finish_button = $VBoxContainer/ButtonContainer/FinishButton

# Step screens
@onready var name_step = $VBoxContainer/StepContainer/NameStep
@onready var background_step = $VBoxContainer/StepContainer/BackgroundStep
@onready var archetype_step = $VBoxContainer/StepContainer/ArchetypeStep
@onready var strengths_step = $VBoxContainer/StepContainer/StrengthsStep
@onready var flaw_step = $VBoxContainer/StepContainer/FlawStep
@onready var summary_step = $VBoxContainer/StepContainer/SummaryStep

# Input fields
@onready var name_input = $VBoxContainer/StepContainer/NameStep/NameInput
@onready var birth_year_spin = $VBoxContainer/StepContainer/NameStep/BirthYearSpinBox
@onready var nationality_input = $VBoxContainer/StepContainer/NameStep/NationalityInput

# Option lists
@onready var background_list = $VBoxContainer/StepContainer/BackgroundStep/BackgroundList
@onready var archetype_list = $VBoxContainer/StepContainer/ArchetypeStep/ArchetypeList
@onready var strengths_list = $VBoxContainer/StepContainer/StrengthsStep/StrengthsList
@onready var flaw_list = $VBoxContainer/StepContainer/FlawStep/FlawList

# Summary labels
@onready var summary_text = $VBoxContainer/StepContainer/SummaryStep/VBox/SummaryText
@onready var stats_preview = $VBoxContainer/StepContainer/SummaryStep/VBox/StatsPreview

var current_step: int = 0
var total_steps: int = 6

# Stored selections
var selected_name: String = ""
var selected_birth_year: int = 1985
var selected_nationality: String = "English"
var selected_background: String = ""
var selected_archetype: String = ""
var selected_strengths: Array[String] = []
var selected_flaw: String = ""

# Director profile being created
var director_profile = null

func _ready():
	director_profile = load("res://scripts/character/director_profile.gd").new()
	_setup_steps()
	_show_step(0)

func _setup_steps():
	# Hide all steps initially
	for child in step_container.get_children():
		child.visible = false
	
	# Setup backgrounds
	_populate_backgrounds()
	_populate_archetypes()
	_populate_strengths()
	_populate_flaws()
	
	# Connect signals
	next_button.pressed.connect(_on_next_pressed)
	back_button.pressed.connect(_on_back_pressed)
	finish_button.pressed.connect(_on_finish_pressed)

func _populate_backgrounds():
	var backgrounds = [
		"Legendary Player",
		"Journeyman Player",
		"Elite Scout",
		"Top Agent",
		"Data Analyst",
		"Youth Coach",
		"Tactical Analyst",
		"Complete Nobody"
	]
	
	for bg in backgrounds:
		var button = Button.new()
		button.text = bg
		button.custom_minimum_size = Vector2(0, 50)
		button.pressed.connect(_on_background_selected.bind(bg))
		background_list.add_child(button)

func _populate_archetypes():
	var archetypes = [
		"The Scout",
		"The Dealmaker",
		"The Tactician",
		"The Politician",
		"The Developer"
	]
	
	for arch in archetypes:
		var button = Button.new()
		button.text = arch
		button.custom_minimum_size = Vector2(0, 50)
		button.pressed.connect(_on_archetype_selected.bind(arch))
		archetype_list.add_child(button)

func _populate_strengths():
	var strengths = [
		"Sharp Eye",
		"Future Focused",
		"Silver Tongue",
		"Contract Wizard",
		"System Master",
		"Squad Architect",
		"Natural Leader",
		"Board Whisperer",
		"Youth Guru",
		"Long-term Thinker"
	]
	
	for strength in strengths:
		var button = Button.new()
		button.text = strength
		button.toggle_mode = true
		button.custom_minimum_size = Vector2(0, 50)
		button.toggled.connect(_on_strength_toggled.bind(strength))
		strengths_list.add_child(button)

func _populate_flaws():
	var flaws = [
		"Impatient",
		"Stubborn",
		"Trusting",
		"Arrogant",
		"Conflict-Averse",
		"Micromanager",
		"Insecure"
	]
	
	for flaw in flaws:
		var button = Button.new()
		button.text = flaw
		button.custom_minimum_size = Vector2(0, 50)
		button.pressed.connect(_on_flaw_selected.bind(flaw))
		flaw_list.add_child(button)

func _show_step(step: int):
	current_step = step
	
	# Hide all steps
	for child in step_container.get_children():
		child.visible = false
	
	# Show current step
	match step:
		0:  # Name
			name_step.visible = true
			description_label.text = "Who are you? Choose your name and background."
			back_button.disabled = true
			next_button.disabled = false
			finish_button.visible = false
		1:  # Background
			background_step.visible = true
			description_label.text = "Your path to the director's office shapes who you are today."
			back_button.disabled = false
			next_button.disabled = selected_background.is_empty()
			finish_button.visible = false
		2:  # Archetype
			archetype_step.visible = true
			description_label.text = "What's your fundamental approach to the role?"
			next_button.disabled = selected_archetype.is_empty()
			finish_button.visible = false
		3:  # Strengths
			strengths_step.visible = true
			description_label.text = "Pick 2 strengths that define your edge (no downsides!)."
			next_button.disabled = selected_strengths.size() != 2
			finish_button.visible = false
		4:  # Flaw
			flaw_step.visible = true
			description_label.text = "Nobody's perfect. Pick your fatal flaw."
			next_button.disabled = selected_flaw.is_empty()
			finish_button.visible = false
		5:  # Summary
			summary_step.visible = true
			_show_summary()
			description_label.text = "This is you. Ready to begin your journey?"
			next_button.visible = false
			finish_button.visible = true
	
	progress_label.text = "Step %d of %d" % [step + 1, total_steps]

func _on_background_selected(background: String):
	selected_background = background
	_update_description_for_background(background)
	next_button.disabled = false

func _on_archetype_selected(archetype: String):
	selected_archetype = archetype
	_update_description_for_archetype(archetype)
	next_button.disabled = false

func _on_strength_toggled(toggled_on: bool, strength: String):
	if toggled_on:
		if selected_strengths.size() < 2:
			selected_strengths.append(strength)
		else:
			# Deselect first one
			var first = selected_strengths[0]
			selected_strengths.remove_at(0)
			selected_strengths.append(strength)
			# Find and untoggle the button
			for btn in strengths_list.get_children():
				if btn.text == first:
					btn.button_pressed = false
	else:
		selected_strengths.erase(strength)
	
	next_button.disabled = selected_strengths.size() != 2
	_update_description_for_strength()

func _on_flaw_selected(flaw: String):
	selected_flaw = flaw
	_update_description_for_flaw(flaw)
	next_button.disabled = false

func _update_description_for_background(bg: String):
	var info = director_profile.BACKGROUND_MODIFIERS.get(bg, {})
	var text = "Background: %s\n\nStarting Reputation: %d\nSpecial: %s\nBurden: %s" % [
		bg,
		info.get("starting_reputation", 0),
		info.get("special", "None"),
		info.get("burden", "None")
	]
	description_label.text = text

func _update_description_for_archetype(arch: String):
	var info = director_profile.ARCHETYPE_EFFECTS.get(arch, {})
	var strengths_text = "\n• ".join(info.get("strengths", []))
	var weaknesses_text = "\n• ".join(info.get("weaknesses", []))
	
	description_label.text = "Archetype: %s\n\nSTRENGTHS:\n• %s\n\nWEAKNESSES:\n• %s" % [
		arch, strengths_text, weaknesses_text
	]

func _update_description_for_strength():
	if selected_strengths.size() == 0:
		description_label.text = "Select your first strength..."
		return
	
	var text = "Selected Strengths:\n\n"
	for strength in selected_strengths:
		var info = director_profile.AVAILABLE_STRENGTHS.get(strength, {})
		text += "• %s: %s\n" % [strength, info.get("gameplay", "")]
	
	if selected_strengths.size() < 2:
		text += "\nPick %d more..." % (2 - selected_strengths.size())
	
	description_label.text = text

func _update_description_for_flaw(flaw: String):
	var info = director_profile.AVAILABLE_FLAWS.get(flaw, {})
	description_label.text = "Flaw: %s\n\nEffect: %s\nGameplay Impact: %s" % [
		flaw,
		info.get("effect", ""),
		info.get("gameplay", "")
	]

func _show_summary():
	# Build director profile
	director_profile.director_name = name_input.text
	director_profile.date_of_birth = {"year": int(birth_year_spin.value), "month": 1, "day": 1}
	director_profile.nationality = nationality_input.text
	director_profile.background = selected_background
	director_profile.archetype = selected_archetype
	director_profile.strengths = selected_strengths.duplicate()
	director_profile.flaw = selected_flaw
	
	director_profile.calculate_stats()
	
	# Display summary
	var age = director_profile.get_age()
	summary_text.text = "%s, %d\n%s\n\nBackground: %s\nArchetype: %s\n\nStrengths: %s\nFlaw: %s" % [
		director_profile.director_name,
		age,
		director_profile.nationality,
		selected_background,
		selected_archetype,
		", ".join(selected_strengths),
		selected_flaw
	]
	
	# Display stats
	var stats_text = "STATS (1-20):\n\n"
	stats_text += "Talent ID: %d\n" % director_profile.stats["talent_id"]
	stats_text += "Potential ID: %d\n" % director_profile.stats["potential_id"]
	stats_text += "Negotiation: %d\n" % director_profile.stats["negotiation"]
	stats_text += "Tactics: %d\n" % director_profile.stats["tactics"]
	stats_text += "Charisma: %d\n" % director_profile.stats["charisma"]
	stats_text += "Youth Dev: %d\n" % director_profile.stats["youth_dev"]
	stats_text += "Determination: %d\n" % director_profile.stats["determination"]
	stats_text += "Adaptability: %d" % director_profile.stats["adaptability"]
	
	stats_preview.text = stats_text

func _on_next_pressed():
	if current_step == 0:
		selected_name = name_input.text
		selected_birth_year = int(birth_year_spin.value)
		selected_nationality = nationality_input.text
	
	_show_step(current_step + 1)

func _on_back_pressed():
	if current_step > 0:
		_show_step(current_step - 1)

func _on_finish_pressed():
	director_created.emit(director_profile)

func on_enter():
	pass

func on_exit():
	pass
