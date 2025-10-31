# ==============================================================================
# DOFManager.gd - Main game controller
# ==============================================================================
extends Node
class_name DOFManager

signal board_confidence_changed(new_value: float)
signal objective_completed(objective_name: String)
signal contract_offered(contract_details: Dictionary)
signal season_ended(season_stats: Dictionary)

var current_season: int = 1
var board_confidence: float = 75.0
var dof_reputation: int = 0
var career_stats: Dictionary = {}

# @onready var transfer_manager = $TransferManager
# @onready var squad_manager = $SquadManager
# @onready var staff_manager = $StaffManager
# @onready var contract_manager = $ContractManager
# @onready var board_manager = $BoardManager

func _ready() -> void:
	initialize_game()
	load_or_create_career()

func initialize_game() -> void:
	career_stats = {
		"total_seasons": 0,
		"total_signings": 0,
		"transfer_success_rate": 0.0,
		"cumulative_net_spend": 0.0,
		"trophies_won": 0,
		"youth_players_promoted": 0,
		"clubs_managed": 1,
		"total_xp": 0,
		"specialization_badges": []
	}

func advance_season() -> void:
	current_season += 1
	career_stats.total_seasons += 1
	
#	var season_review = board_manager.evaluate_season_performance()
#	emit_signal("season_ended", season_review)
	
#	if season_review.objectives_met >= 0.7:
#		modify_board_confidence(10.0)
#		award_xp(1000 + season_review.bonus_xp)
#	else:
#		modify_board_confidence(-15.0)
	
	check_contract_status()

func modify_board_confidence(amount: float) -> void:
	board_confidence = clamp(board_confidence + amount, 0.0, 100.0)
	emit_signal("board_confidence_changed", board_confidence)
	
	if board_confidence < 25.0:
		handle_dismissal_risk()

func award_xp(amount: int) -> void:
	dof_reputation += amount
	career_stats.total_xp += amount
	check_reputation_tier()
	check_badge_unlocks()

func load_or_create_career():
	print("Stub: load_or_create_career")

func check_contract_status():
	print("Stub: check_contract_status")

func handle_dismissal_risk():
	print("Stub: handle_dismissal_risk")

func check_reputation_tier():
	print("Stub: check_reputation_tier")

func check_badge_unlocks():
	print("Stub: check_badge_unlocks")
