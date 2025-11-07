# player.gd
extends Resource
class_name Player

# === BASIC INFO ===
var id: int
var name: String
var age: int
var nationality: String
var club_id: int = -1  # -1 means free agent
var position: String  # GK, DEF, MID, ATT
var preferred_foot: String = "Right"  # Left, Right, Both

# === CONTRACT INFO ===
var contract_wage: int = 0
var contract_expiry_year: int = 0

# === CORE ATTRIBUTES (simplified to 6) ===
var technical: int = 50      # Shooting, passing, dribbling, first touch
var physical: int = 50       # Pace, strength, stamina
var mental: int = 50         # Positioning, decisions, composure
var defensive: int = 50      # Tackling, marking, heading
var goalkeeping: int = 50    # Only relevant for GK
var potential: int = 50      # Growth ceiling (for development)

# === DERIVED VALUES ===
var overall_rating: int = 50
var market_value: int = 0
var morale: int = 50  # Simplified 0-100

# === INITIALIZATION ===
func _init(p_id: int = 0, p_name: String = "", p_age: int = 20, p_position: String = "MID"):
	id = p_id
	name = p_name
	age = p_age
	position = p_position
	_generate_random_attributes()
	_calculate_overall()
	_calculate_market_value()

# === ATTRIBUTE MANAGEMENT ===
func _generate_random_attributes():
	"""Generate random starting attributes based on position"""
	technical = randi_range(40, 70)
	physical = randi_range(40, 70)
	mental = randi_range(40, 70)
	defensive = randi_range(40, 70)
	potential = randi_range(50, 90)
	
	# Position-specific adjustments
	match position:
		"GK":
			goalkeeping = randi_range(50, 80)
			technical = randi_range(20, 40)
		"DEF":
			defensive = randi_range(60, 80)
		"ATT":
			technical = randi_range(60, 80)
			defensive = randi_range(20, 40)
	
	morale = 50

func set_attribute(attr_name: String, value: int):
	"""Set an attribute with clamping"""
	value = clamp(value, 1, 99)
	
	match attr_name:
		"technical": technical = value
		"physical": physical = value
		"mental": mental = value
		"defensive": defensive = value
		"goalkeeping": goalkeeping = value
		"potential": potential = value
	
	_calculate_overall()
	_calculate_market_value()

func get_attribute(attr_name: String) -> int:
	"""Get attribute value"""
	match attr_name:
		"technical": return technical
		"physical": return physical
		"mental": return mental
		"defensive": return defensive
		"goalkeeping": return goalkeeping
		"potential": return potential
		"overall": return overall_rating
		_: return 50

# === CALCULATIONS ===
func _calculate_overall():
	"""Calculate overall rating based on position"""
	match position:
		"GK":
			overall_rating = int((goalkeeping * 0.7 + physical * 0.2 + mental * 0.1))
		"DEF":
			overall_rating = int((defensive * 0.4 + physical * 0.3 + mental * 0.2 + technical * 0.1))
		"MID":
			overall_rating = int((technical * 0.35 + mental * 0.3 + physical * 0.25 + defensive * 0.1))
		"ATT":
			overall_rating = int((technical * 0.5 + physical * 0.25 + mental * 0.2 + defensive * 0.05))
		_:
			overall_rating = int((technical + physical + mental + defensive) / 4)
	
	overall_rating = clamp(overall_rating, 1, 99)

func _calculate_market_value():
	"""Calculate market value based on age, overall, and potential"""
	var base_value = overall_rating * 100000
	
	# Age curve (peak 25-28)
	var age_multiplier = 1.0
	if age < 23:
		age_multiplier = 0.7 + (potential / 100.0) * 0.5  # Young with potential
	elif age > 30:
		age_multiplier = max(0.3, 1.0 - (age - 30) * 0.1)  # Declining
	
	market_value = int(base_value * age_multiplier)

# === CONTRACT MANAGEMENT ===
func sign_contract(wage: int, years: int, current_year: int):
	"""Sign player to contract"""
	contract_wage = wage
	contract_expiry_year = current_year + years

func is_contract_expired(current_year: int) -> bool:
	"""Check if contract is expired"""
	return current_year >= contract_expiry_year

func years_remaining(current_year: int) -> int:
	"""Get years remaining on contract"""
	return max(0, contract_expiry_year - current_year)

# === DEVELOPMENT ===
func age_one_year():
	"""Age player by one year and potentially improve/decline"""
	age += 1
	
	# Development/decline based on age
	if age < 24 and overall_rating < potential:
		# Young player developing
		var improvement = randi_range(1, 3)
		_improve_random_attributes(improvement)
	elif age > 30:
		# Decline
		var decline = randi_range(0, 2)
		_decline_random_attributes(decline)
	
	_calculate_overall()
	_calculate_market_value()

func _improve_random_attributes(amount: int):
	"""Improve random attributes"""
	var attrs = ["technical", "physical", "mental", "defensive"]
	for i in amount:
		var attr = attrs[randi() % attrs.size()]
		var current = get_attribute(attr)
		if current < potential:
			set_attribute(attr, current + 1)

func _decline_random_attributes(amount: int):
	"""Decline random attributes"""
	var attrs = ["technical", "physical", "mental", "defensive"]
	for i in amount:
		var attr = attrs[randi() % attrs.size()]
		set_attribute(attr, get_attribute(attr) - 1)

# === MORALE ===
func adjust_morale(change: int):
	"""Adjust player morale"""
	morale = clamp(morale + change, 0, 100)

# === SERIALIZATION ===
func to_dict() -> Dictionary:
	"""Convert to dictionary for saving"""
	return {
		"id": id,
		"name": name,
		"age": age,
		"nationality": nationality,
		"club_id": club_id,
		"position": position,
		"preferred_foot": preferred_foot,
		"contract_wage": contract_wage,
		"contract_expiry_year": contract_expiry_year,
		"technical": technical,
		"physical": physical,
		"mental": mental,
		"defensive": defensive,
		"goalkeeping": goalkeeping,
		"potential": potential,
		"overall_rating": overall_rating,
		"market_value": market_value,
		"morale": morale
	}

static func from_dict(data: Dictionary) -> Player:
	"""Create player from dictionary"""
	var player = Player.new(data.id, data.name, data.age, data.position)
	
	# Restore all values
	player.nationality = data.get("nationality", "")
	player.club_id = data.get("club_id", -1)
	player.preferred_foot = data.get("preferred_foot", "Right")
	player.contract_wage = data.get("contract_wage", 0)
	player.contract_expiry_year = data.get("contract_expiry_year", 0)
	player.technical = data.get("technical", 50)
	player.physical = data.get("physical", 50)
	player.mental = data.get("mental", 50)
	player.defensive = data.get("defensive", 50)
	player.goalkeeping = data.get("goalkeeping", 50)
	player.potential = data.get("potential", 50)
	player.morale = data.get("morale", 50)
	
	player._calculate_overall()
	player._calculate_market_value()
	
	return player

# === DISPLAY HELPERS ===
func get_display_name() -> String:
	"""Get formatted display name with age"""
	return "%s (%d)" % [name, age]

func get_position_color() -> Color:
	"""Get color for position badge"""
	match position:
		"GK": return Color.YELLOW
		"DEF": return Color.BLUE
		"MID": return Color.GREEN
		"ATT": return Color.RED
		_: return Color.WHITE

func get_wage_display() -> String:
	"""Format wage for display"""
	return "$%s/week" % [_format_number(contract_wage)]

func get_value_display() -> String:
	"""Format market value for display"""
	if market_value >= 1000000:
		return "$%.1fM" % (market_value / 1000000.0)
	else:
		return "$%dK" % (market_value / 1000)

func _format_number(num: int) -> String:
	"""Format number with commas"""
	var s = str(num)
	var result = ""
	var count = 0
	for i in range(s.length() - 1, -1, -1):
		if count == 3:
			result = "," + result
			count = 0
		result = s[i] + result
		count += 1
	return result
