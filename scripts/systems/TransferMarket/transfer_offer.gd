class_name TransferOffer
extends Resource

# Core offer components
@export var base_fee: float = 0.0
@export var installments: Array = []  # Array of {amount: float, years: int}
@export var payment_immediate: bool = true

# Clauses
@export var sell_on_percentage: float = 0.0  # 0-50%
@export var buyback_clause: float = 0.0  # 0 = no buyback
@export var obligation_to_buy: bool = false
@export var obligation_conditions: String = ""

# Performance bonuses
@export var appearance_bonus_threshold: int = 0
@export var appearance_bonus_fee: float = 0.0
@export var goal_bonus_threshold: int = 0
@export var goal_bonus_fee: float = 0.0

# Other
@export var friendly_match: bool = false

func _init():
	installments = []
	
func get_total_immediate_payment() -> float:
	if payment_immediate:
		return base_fee
	
	var total = 0.0
	for inst in installments:
		total += inst.get("amount", 0.0)
	return total

func get_installment_count() -> int:
	return installments.size()
