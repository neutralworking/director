class_name PendingTransfer
extends Resource

# The transfer offer details
@export var offer: Resource  # TransferOffer
@export var player_name: String  # Store name for display
@export var selling_club_name: String
@export var buying_club_name: String

# Reference IDs (we'll store these to re-fetch objects when needed)
var player_ref: WeakRef
var selling_club_ref: WeakRef  
var buying_club_ref: WeakRef

# Timeline
@export var submitted_day: int
@export var submitted_month: int
@export var submitted_year: int
@export var response_day: int
@export var response_month: int
@export var response_year: int

# Status
@export var status: String = "PENDING"  # PENDING, ACCEPTED, REJECTED, NEGOTIATING
@export var ai_evaluation: Dictionary = {}  # Store the evaluation result

func _init():
	pass

func set_dates(submit_date, response_date):
	submitted_day = submit_date.day
	submitted_month = submit_date.month
	submitted_year = submit_date.year
	response_day = response_date.day
	response_month = response_date.month
	response_year = response_date.year

func has_response_arrived(current_date) -> bool:
	# Check if current date >= response date
	if current_date.year > response_year:
		return true
	elif current_date.year == response_year:
		if current_date.month > response_month:
			return true
		elif current_date.month == response_month:
			if current_date.day >= response_day:
				return true
	return false

func get_response_date_string() -> String:
	return "%02d/%02d/%d" % [response_day, response_month, response_year]
