extends Node

class_name TransferManager

signal transfer_resolved(pending_transfer)

var pending_transfers: Array = []
var time_system # Removed strict type to avoid parse error

func _ready():
	# Find TimeProgressionSystem in the scene
	time_system = get_node("/root/Main/TimeProgressionSystem")
	if time_system:
		time_system.date_changed.connect(_on_date_changed)
	else:
		push_warning("TransferManager: TimeProgressionSystem not found")

# ... (rest of the file)



func submit_offer(offer, player, selling_club, buying_club) -> Dictionary:
	# Evaluate the offer
	var evaluator_script = load("res://scripts/systems/TransferMarket/club_transfer_evaluator.gd")
	var evaluation = evaluator_script.evaluate_offer(offer, player, selling_club, buying_club)
	
	# Calculate response time
	var response_days = _calculate_response_time(evaluation, player, selling_club)
	
	# Create pending transfer
	var pending_script = load("res://scripts/systems/TransferMarket/pending_transfer.gd")
	var pending = pending_script.new()
	
	pending.offer = offer
	pending.player_name = player.character_name
	pending.selling_club_name = selling_club.name
	pending.buying_club_name = buying_club.name
	pending.ai_evaluation = evaluation
	
	# Store weak references
	pending.player_ref = weakref(player)
	pending.selling_club_ref = weakref(selling_club)
	pending.buying_club_ref = weakref(buying_club)
	
	# Set dates
	var current_date = time_system.current_date
	var response_date = _add_days_to_date(current_date, response_days)
	pending.set_dates(current_date, response_date)
	
	pending_transfers.append(pending)
	
	print("Transfer offer submitted for %s. Response expected by %s" % [player.character_name, pending.get_response_date_string()])
	
	return {
		"success": true,
		"response_date": pending.get_response_date_string(),
		"days_until_response": response_days
	}

func _on_date_changed(new_date):
	# Check all pending transfers
	var to_process = []
	for pending in pending_transfers:
		if pending.status == "PENDING" and pending.has_response_arrived(new_date):
			to_process.append(pending)
	
	# Process transfers that have responses due
	for pending in to_process:
		_process_transfer(pending)

func _process_transfer(pending: Resource):
	# Determine final status based on evaluation
	var evaluation = pending.ai_evaluation
	
	match evaluation.response:
		0:  # AUTO_ACCEPT
			pending.status = "ACCEPTED"
		1:  # AUTO_REJECT
			pending.status = "REJECTED"
		2:  # NEGOTIATE
			pending.status = "NEGOTIATING"
	
	# Create inbox message
	_create_inbox_message(pending)
	
	# Emit signal
	transfer_resolved.emit(pending)
	
	print("Transfer %s: %s - %s" % [pending.status, pending.player_name, pending.selling_club_name])

func _create_inbox_message(pending: Resource):
	var inbox_system = get_node("/root/Main/InboxSystem")
	if not inbox_system:
		print("Warning: InboxSystem not found")
		return
	
	var message_type = ""
	var title = ""
	var body = ""
	
	match pending.status:
		"ACCEPTED":
			message_type = "TRANSFER_ACCEPTED"
			title = "✅ Transfer Accepted!"
			body = "%s has accepted your offer for %s ($%.1fM)" % [
				pending.selling_club_name,
				pending.player_name,
				pending.offer.base_fee / 1000000.0
			]
		"REJECTED":
			message_type = "TRANSFER_REJECTED"
			title = "❌ Transfer Rejected"
			body = "%s has rejected your offer for %s" % [
				pending.selling_club_name,
				pending.player_name
			]
		"NEGOTIATING":
			message_type = "TRANSFER_NEGOTIATING"
			title = "💬 Transfer Under Negotiation"
			body = "%s is willing to negotiate for %s (Your offer: $%.1fM, Their valuation: ~$%.1fM)" % [
				pending.selling_club_name,
				pending.player_name,
				pending.ai_evaluation.offer_value / 1000000.0,
				pending.ai_evaluation.club_valuation / 1000000.0
			]
	
	inbox_system.add_message(title, body, message_type, {
		"pending_transfer": pending,
		"player_name": pending.player_name,
		"club_name": pending.selling_club_name
	})

func _calculate_response_time(evaluation: Dictionary, player, club) -> int:
	var ratio = evaluation.ratio
	var base_days = 0
	
	# 1. Quality-based timing
	if ratio >= 1.0:
		base_days = 0  # Instant accept if valuation met
	elif ratio >= 0.9:
		base_days = 4  # Fair offer
	elif ratio >= 0.6:
		base_days = 7  # Below value
	else:
		base_days = 2  # Insulting - quick reject
	
	# 2. Release clause override
	if evaluation.get("meets_release_clause", false):
		return 1
	
	# 3. Player importance modifier
	if player.squad_role in ["Star", "Starter"]:
		base_days += 2
	
	# 4. Club bureaucracy
	if club.financial_strength >= 8:
		base_days += 2
	
	return base_days

func _add_days_to_date(date, days: int):
	# Use dynamic load to access inner class
	var time_script = load("res://scripts/TimeProgressionSystem.gd")
	var new_date = time_script.GameDate.new(date.day, date.month, date.year)
	for i in range(days):
		new_date.advance()
	return new_date

func get_pending_count() -> int:
	return pending_transfers.filter(func(t): return t.status == "PENDING").size()
