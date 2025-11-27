extends Control

signal request_push(screen_scene)
signal request_pop()
signal offer_submitted(offer, player, selling_club)

@onready var player_name_label = $VBoxContainer/Header/PlayerName
@onready var selling_club_label = $VBoxContainer/Header/SellingClub
@onready var base_fee_slider = $VBoxContainer/ScrollContainer/VBoxContainer/BaseFeeContainer/Slider
@onready var base_fee_value = $VBoxContainer/ScrollContainer/VBoxContainer/BaseFeeContainer/Value
@onready var installments_toggle = $VBoxContainer/ScrollContainer/VBoxContainer/PaymentContainer/InstallmentsToggle
@onready var installment_years = $VBoxContainer/ScrollContainer/VBoxContainer/PaymentContainer/YearsInput
@onready var sellon_toggle = $VBoxContainer/ScrollContainer/VBoxContainer/ClausesContainer/SellonToggle
@onready var sellon_percent = $VBoxContainer/ScrollContainer/VBoxContainer/ClausesContainer/SellonPercent
@onready var buyback_toggle = $VBoxContainer/ScrollContainer/VBoxContainer/ClausesContainer/BuybackToggle
@onready var buyback_value = $VBoxContainer/ScrollContainer/VBoxContainer/ClausesContainer/BuybackValue
@onready var offer_value_label = $VBoxContainer/Summary/VBox/OfferValue
@onready var club_valuation_label = $VBoxContainer/Summary/VBox/ClubValuation
@onready var status_label = $VBoxContainer/Summary/VBox/Status

var current_player
var selling_club
var evaluator_script

func _ready():
	evaluator_script = load("res://scripts/systems/TransferMarket/club_transfer_evaluator.gd")
	if current_player:
		_refresh_display()
	
	if pending_negotiation_data:
		_apply_negotiation_data()

func set_transfer_context(player, club):
	current_player = player
	selling_club = club
	if is_node_ready():
		_refresh_display()

func _refresh_display():
	if not current_player or not selling_club:
		return
	
	player_name_label.text = current_player.character_name
	selling_club_label.text = "To: " + selling_club.name
	
	# Set base fee slider range based on player value
	var base_value = _get_player_base_value()
	base_fee_slider.min_value = base_value * 0.5
	base_fee_slider.max_value = base_value * 3.0
	base_fee_slider.value = base_value
	
	_update_offer_evaluation()
	_update_ui()

func _get_player_base_value() -> float:
	var calc_script = load("res://scripts/systems/TransferMarket/transfer_value_calculator.gd")
	if calc_script and current_player.transfer_data:
		return calc_script.calculate_value(current_player)
	return 1000000.0

func _on_slider_changed(_value):
	base_fee_value.text = "$%.1fM" % (base_fee_slider.value / 1000000.0)
	_update_offer_evaluation()

func _on_toggle_changed(_state):
	_update_offer_evaluation()

@onready var submit_button = $VBoxContainer/ButtonContainer/SubmitButton
@onready var meet_valuation_button = $VBoxContainer/ButtonContainer/MeetValuationButton

var current_club_valuation: float = 0.0

# ... (existing code)

func _update_offer_evaluation():
	if not evaluator_script or not current_player or not selling_club:
		return
	
	# ... (existing offer build code)
	var offer_script = load("res://scripts/systems/TransferMarket/transfer_offer.gd")
	var offer = offer_script.new()
	offer.base_fee = base_fee_slider.value
	offer.payment_immediate = not installments_toggle.button_pressed
	
	if not offer.payment_immediate:
		var years = int(installment_years.value)
		var per_year = offer.base_fee / years
		for y in range(years):
			offer.installments.append({"amount": per_year, "years": y + 1})
	
	if sellon_toggle.button_pressed:
		offer.sell_on_percentage = sellon_percent.value
	
	if buyback_toggle.button_pressed:
		offer.buyback_clause = float(buyback_value.text) if buyback_value.text != "" else 0.0
	
	# Evaluate 
	var buying_club = LeagueManager.active_league.clubs[0]
	var evaluation = evaluator_script.evaluate_offer(offer, current_player, selling_club, buying_club)
	
	current_club_valuation = evaluation.club_valuation
	
	# Display results
	offer_value_label.text = "Offer Value: $%.1fM" % (evaluation.offer_value / 1000000.0)
	if club_valuation_label:
		club_valuation_label.text = "Their Valuation: ~$%.1fM" % (evaluation.club_valuation / 1000000.0)
	
	# Update Match Valuation Button Text
	if meet_valuation_button:
		meet_valuation_button.text = "Match ($%.1fM)" % (evaluation.club_valuation / 1000000.0)
	
	match evaluation.response:
		0:  # AUTO_ACCEPT
			status_label.text = "🟢 Likely to Accept"
			status_label.add_theme_color_override("font_color", Color.GREEN)
			if is_negotiation:
				submit_button.text = "Accept Offer"
			else:
				submit_button.text = "Confirm Deal"
			if meet_valuation_button:
				meet_valuation_button.visible = false
		1:  # AUTO_REJECT
			status_label.text = "🔴 Will Reject"
			status_label.add_theme_color_override("font_color", Color.RED)
			submit_button.text = "Submit Offer"
			if meet_valuation_button:
				meet_valuation_button.visible = true
		2:  # NEGOTIATE
			status_label.text = "🟡 Likely to Negotiate"
			status_label.add_theme_color_override("font_color", Color.YELLOW)
			submit_button.text = "Submit Offer"
			if meet_valuation_button:
				meet_valuation_button.visible = true
	
	print("Eval Update: Response=%d, ClubVal=%.1f, ButtonVis=%s" % [evaluation.response, evaluation.club_valuation, meet_valuation_button.visible if meet_valuation_button else "N/A"])

func _on_meet_valuation_pressed():
	if current_club_valuation > 0:
		base_fee_slider.value = current_club_valuation
		# Trigger update
		_on_slider_changed(current_club_valuation)

func _update_ui():
	if not current_player:
		return
		
	# Update Header
	var title = $VBoxContainer/Header/Title
	if title:
		title.text = "Transfer Offer: %s" % current_player.character_name
	
	# Update Player Info
	var info_label = $VBoxContainer/PlayerInfo/InfoLabel
	if info_label:
		info_label.text = "%s | %d y/o | %s" % [
			current_player.position_on_field,
			current_player.age,
			"OVR: ??" # Placeholder as current_ability is not in Player.gd yet
		]
	
	# Update Valuation
	if selling_club:
		var eval_script = load("res://scripts/systems/TransferMarket/club_transfer_evaluator.gd")
		var evaluator = eval_script.new()
		var valuation = evaluator.evaluate_player_value_for_club(current_player, selling_club)
		if club_valuation_label:
			club_valuation_label.text = "Club Valuation: $%.1fM" % (valuation / 1000000.0)
		# evaluator is ref counted or needs manual free? Scripts extending RefCounted (default) don't need free.
		# If it extends Node, it needs free. Assuming it's a Reference/RefCounted or we just let it be.
		# If it extends Node and we don't add it to tree, we should free it.
		if evaluator is Node:
			evaluator.free()
	
	_update_offer_evaluation()

func set_player(player):
	current_player = player
	# Find the selling club (assuming player has a club reference or we find it via league)
	# For now, we'll try to get it from the player if possible, or search
	# This part depends on how Player -> Club relationship is stored
	# If player.club is a weakref or direct ref:
	if "club" in player and player.club:
		selling_club = player.club
	else:
		# Fallback: Search all clubs (inefficient but safe for now)
		var league_manager = get_node("/root/Main/DOFManager/LeagueManager") # Adjust path if needed
		if league_manager:
			selling_club = league_manager.find_club_for_player(player)
	
	if is_node_ready():
		_update_ui()

var is_negotiation = false
var pending_negotiation_data = null

func setup_negotiation(pending_transfer):
	is_negotiation = true
	pending_negotiation_data = pending_transfer
	
	# Set player (using weakref if needed, or just the object if valid)
	var player = pending_transfer.player_ref.get_ref()
	if player:
		set_player(player)
	
	# Explicitly set selling club from pending transfer to ensure it's not null
	if pending_transfer.selling_club_ref:
		var club = pending_transfer.selling_club_ref.get_ref()
		if club:
			selling_club = club
	
	if is_node_ready():
		_apply_negotiation_data()

func _apply_negotiation_data():
	if not pending_negotiation_data:
		return
		
	var offer = pending_negotiation_data.offer
	if offer:
		# Update UI elements to match offer
		if base_fee_slider: base_fee_slider.value = offer.base_fee
		if installments_toggle: installments_toggle.button_pressed = not offer.payment_immediate
		
		if not offer.payment_immediate and offer.installments.size() > 0:
			# Assuming uniform installments for now
			if installment_years: installment_years.value = offer.installments.size()
			
		if sellon_toggle:
			if offer.sell_on_percentage > 0:
				sellon_toggle.button_pressed = true
				sellon_percent.value = offer.sell_on_percentage
			else:
				sellon_toggle.button_pressed = false
			
		if buyback_toggle:
			if offer.buyback_clause > 0:
				buyback_toggle.button_pressed = true
				buyback_value.text = str(offer.buyback_clause)
			else:
				buyback_toggle.button_pressed = false
		
		# Trigger update to refresh evaluation with new values
		_update_offer_evaluation()
			
	# Update title to indicate negotiation
	var title = $VBoxContainer/Header/Title
	if title:
		title.text = "Negotiate Transfer: %s" % pending_negotiation_data.player_name

func _on_submit_pressed():
	print("Submit pressed. Player: %s, Club: %s" % [current_player, selling_club])
	if not current_player or not selling_club:
		print("Error: Missing player or club data")
		return
	
	# Build final offer from UI
	var offer_script = load("res://scripts/systems/TransferMarket/transfer_offer.gd")
	var offer = offer_script.new()
	offer.base_fee = base_fee_slider.value
	offer.payment_immediate = not installments_toggle.button_pressed
	
	if not offer.payment_immediate:
		var years = int(installment_years.value)
		var per_year = offer.base_fee / years
		for y in range(years):
			offer.installments.append({"amount": per_year, "years": y + 1})
	
	if sellon_toggle.button_pressed:
		offer.sell_on_percentage = sellon_percent.value
	
	if buyback_toggle.button_pressed:
		offer.buyback_clause = float(buyback_value.text) if buyback_value.text != "" else 0.0
	
	# Submit to TransferManager
	var transfer_manager = get_node("/root/Main/TransferManager")
	if transfer_manager:
		var buying_club = LeagueManager.active_league.clubs[0]  # User's club
		var result = transfer_manager.submit_offer(offer, current_player, selling_club, buying_club)
		
		if result.success:
			print("✅ Offer submitted! Response expected by %s (%d days)" % [result.response_date, result.days_until_response])
		
	request_pop.emit()

func _on_cancel_pressed():
	request_pop.emit()

func on_enter():
	_refresh_display()

func on_exit():
	pass
