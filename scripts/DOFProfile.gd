extends Panel

@onready var title_label = $VBoxContainer/TitleLabel
@onready var name_label = $VBoxContainer/NameLabel
@onready var reputation_label = $VBoxContainer/ReputationLabel
@onready var confidence_label = $VBoxContainer/BoardConfidenceLabel
@onready var stats_label = $VBoxContainer/StatsLabel
@onready var close_button = $CloseButton

func _ready():
	close_button.connect("pressed", Callable(self, "_on_close_pressed"))
	hide() # Starts hidden

func show_profile(dof_data: Dictionary):
	name_label.text = "Name: %s" % dof_data.get("name", "Unknown")
	reputation_label.text = "Reputation: %d" % dof_data.get("reputation", 0)
	confidence_label.text = "Board Confidence: %d" % dof_data.get("board_confidence", 0)
	stats_label.text = "Seasons: %d\nSignings: %d\nTrophies: %d" % [
		dof_data.get("total_seasons", 0),
		dof_data.get("total_signings", 0),
		dof_data.get("trophies_won", 0)
	]
	show()

func _on_close_pressed():
	hide()
