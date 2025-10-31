# MainHUD.gd
extends Control

# Signals
signal time_advance_requested(days: int, hours: int)
signal skip_to_event_requested
signal menu_requested(menu_type: String)

# UI Node References
@onready var date_label = $VBoxContainer/DateLabel
@onready var events_label = $VBoxContainer/EventsLabel
@onready var advance_button = $VBoxContainer/HBoxContainer/AdvanceButton
@onready var squad_button = $VBoxContainer/MenuContainer/SquadButton
@onready var transfers_button = $VBoxContainer/MenuContainer/TransfersButton
@onready var contracts_button = $VBoxContainer/MenuContainer/ContractsButton
@onready var meetings_button = $VBoxContainer/MenuContainer/MeetingsButton

func _ready():
	# Connect all buttons to signal handlers
	advance_button.connect("pressed", Callable(self, "_on_advance_pressed"))
	squad_button.connect("pressed", Callable(self, "_on_squad_pressed"))
	transfers_button.connect("pressed", Callable(self, "_on_transfers_pressed"))
	contracts_button.connect("pressed", Callable(self, "_on_contracts_pressed"))
	meetings_button.connect("pressed", Callable(self, "_on_meetings_pressed"))

# Button signal handlers
func _on_advance_pressed():
	emit_signal("time_advance_requested", 0, 1)

func _on_squad_pressed():
	emit_signal("menu_requested", "squad")

func _on_transfers_pressed():
	emit_signal("menu_requested", "transfers")

func _on_contracts_pressed():
	emit_signal("menu_requested", "contracts")

func _on_meetings_pressed():
	emit_signal("menu_requested", "meetings")

# Public methods for Main.gd to update UI
func update_date_display(date_string: String):
	date_label.text = date_string

func update_events_display(events_string: String):
	events_label.text = events_string

func set_buttons_enabled(enabled: bool):
	advance_button.disabled = not enabled

