class_name InboxMessage
extends Resource

@export var title: String = ""
@export var body: String = ""
@export var message_type: String = ""  # "TRANSFER_ACCEPTED", "TRANSFER_REJECTED", etc.
@export var day: int = 1
@export var month: int = 1
@export var year: int = 2024
@export var read: bool = false

# Optional related data (stored as variant for flexibility)
@export var related_data: Dictionary = {}

func _init():
	pass

func get_date_string() -> String:
	return "%02d/%02d/%d" % [day, month, year]

func set_date(game_date):
	day = game_date.day
	month = game_date.month
	year = game_date.year

func get_icon() -> String:
	match message_type:
		"TRANSFER_ACCEPTED":
			return "✅"
		"TRANSFER_REJECTED":
			return "❌"
		"TRANSFER_NEGOTIATING":
			return "💬"
		"INFO":
			return "ℹ️"
		_:
			return "📬"
