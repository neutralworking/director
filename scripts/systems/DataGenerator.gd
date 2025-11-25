class_name DataGenerator
extends RefCounted

# Load generator
# var gen = DataGenerator.new()

# Generate 200 players for a "League 2" level (Avg CA 80)
#var league_two_pool = gen.generate_pool(200, 80)

# Generate 200 players for "Premier League" level (Avg CA 145)
#var prem_pool = gen.generate_pool(200, 145)
#print(prem_pool[0].full_name, " - Role: ", prem_pool[0].role_archetype, " - OVR: ", prem_pool[0].get_average_rating())



# --- Dependencies ---
# In a real project, load these from a folder using DirAccess
var _roles: Array[PlayerRole] = []
var _names_first: Array[String] = ["James", "Luca", "Sven", "Hiro", "Marcus"]
var _names_last: Array[String] = ["Silva", "Muller", "Tanaka", "Dubois", "Weber"]
var _rng = RandomNumberGenerator.new()

func _init():
	_rng.randomize()
	_load_default_roles() # Fallback if no resources exist

## Main Entry Point: Generates a robust pool
func generate_pool(count: int, target_avg_ca: int = 100) -> Array[PlayerDTO]:
	var pool: Array[PlayerDTO] = []
	print("Systems: Generating %d players with target CA ~%d..." % [count, target_avg_ca])
	
	for i in range(count):
		# 1. Determine "Class" of player (Star, Squad, Youth) using Normal Distribution
		var ca = int(clamp(_rng.randfn(target_avg_ca, 25.0), 1, 190))
		var age = _generate_weighted_age()
		
		# 2. Pick a random Role Archetype
		var role = _roles.pick_random()
		
		# 3. Create Player
		pool.append(_build_player(ca, age, role))
		
	return pool

func _build_player(ca: int, age: int, role: PlayerRole) -> PlayerDTO:
	var p = PlayerDTO.new()
	p.uid = _rng.randi()
	p.full_name = "%s %s" % [_names_first.pick_random(), _names_last.pick_random()]
	p.age = age
	p.position = role.position_code
	p.role_archetype = role.role_name
	p.ca = ca
	p.foot = "Right" if _rng.randf() > 0.25 else "Left"
	
	# EXPERT LOGIC: Distribute CA points into attributes
	p.attributes = _allocate_attributes(ca, role)
	
	# Logic: PA is always >= CA, young players have higher gap
	var potential_gap = (30 - age) * 4 # Rough logic: younger = more potential
	if potential_gap < 0: potential_gap = 0
	p.pa = clampi(ca + _rng.randi_range(0, potential_gap), ca, 200)
	
	return p

## The "Secret Sauce" - Attributes are bought with CA points
func _allocate_attributes(ca: int, role: PlayerRole) -> Dictionary:
	var attrs = {}
	
	# 1. Define all possible stats (simplified for example)
	var all_stats = ["finishing", "passing", "tackling", "pace", "stamina", "strength", "vision", "positioning"]
	
	# 2. Calculate the "Cost" of every attribute based on Role
	# e.g. For a Striker, Finishing is expensive (weight 3.0), Tackling is cheap (weight 0.5)
	var total_weight = 0.0
	var weights = {}
	
	for stat in all_stats:
		var w = role.key_attributes.get(stat, 0.5) # Default low weight if not in role
		weights[stat] = w
		total_weight += w
	
	# 3. Distribute the CA
	# A higher CA means we have more "points" to spread.
	# We use the curve to add natural variance so not every 150 CA player looks identical.
	for stat in all_stats:
		var role_weight = weights[stat]
		
		# Base value driven by CA (linear mapping 1-200 CA -> 1-99 Stat)
		var base_val = float(ca) / 2.0 
		
		# Apply Role Modifier: Important stats get a boost, useless ones get a penalty
		# If weight is 3.0 (Critical), we boost. If 0.5, we dampen.
		var modifier = (role_weight * 0.6) + _rng.randf_range(0.8, 1.2) # Add noise
		
		var final_val = base_val * modifier
		attrs[stat] = int(clamp(final_val, 1, 99))
		
	return attrs

func _generate_weighted_age() -> int:
	# Use a logistical curve or simple weighted logic
	# We want few 16s, many 24s, few 38s.
	return int(clamp(_rng.randfn(25, 4.5), 16, 39))

func _load_default_roles():
	# In a real app, you would loop over a folder of .tres files.
	# Here we mock one for safety.
	var r = PlayerRole.new()
	r.role_name = "Complete Forward"
	r.position_code = "ST"
	r.key_attributes = {"finishing": 3.0, "pace": 2.5, "strength": 2.0, "passing": 1.5}
	_roles.append(r)
	
	var r2 = PlayerRole.new()
	r2.role_name = "Ball Playing Defender"
	r2.position_code = "CB"
	r2.key_attributes = {"tackling": 3.0, "positioning": 3.0, "passing": 2.0, "strength": 2.5}
	_roles.append(r2)
