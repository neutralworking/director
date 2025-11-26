extends Node

var active_league # : League

func _ready():
	# For testing, generate a dummy league if none exists
	if active_league == null:
		generate_test_league()

func generate_test_league():
	print("Generating test league...")
	var league_script = load("res://scripts/classes/League.gd")
	active_league = league_script.new("Test League")
	
	var club_names = [
		"Arsenal", "Aston Villa", "Bournemouth", "Brentford", "Brighton",
		"Chelsea", "Crystal Palace", "Everton", "Fulham", "Liverpool",
		"Luton Town", "Man City", "Man Utd", "Newcastle", "Nottm Forest",
		"Sheffield Utd", "Tottenham", "West Ham", "Wolves"
	]
	
	var club_script = load("res://scripts/classes/Club.gd")
	for name in club_names:
		var club = club_script.new(name, randi_range(4000, 9000))
		_generate_dummy_squad(club)
		active_league.clubs.append(club)
		
	print("Test league generated with %d clubs" % active_league.clubs.size())

func _generate_dummy_squad(club):
	# Generate 20-25 players for the club
	var squad_size = randi_range(20, 25)
	var player_script = load("res://scripts/character/player.gd")
	var transfer_data_script = load("res://scripts/character/player_transfer_data.gd")
	
	for i in range(squad_size):
		var player = player_script.new()
		player.character_name = _generate_random_name()
		player.age = randi_range(18, 35)
		player.position_on_field = _get_random_position()
		player.shirt_number = randi_range(1, 99)
		
		# Init transfer data
		player.transfer_data = transfer_data_script.new()
		player.transfer_data.base_value = randf_range(500000, 50000000)
		player.transfer_data.marketability = randf()
		
		club.squad.append(player)

func _generate_random_name() -> String:
	var first_names = ["James", "John", "Robert", "Michael", "William", "David", "Richard", "Joseph", "Thomas", "Charles"]
	var last_names = ["Smith", "Johnson", "Williams", "Brown", "Jones", "Garcia", "Miller", "Davis", "Rodriguez", "Martinez"]
	return first_names.pick_random() + " " + last_names.pick_random()

func _get_random_position() -> String:
	var positions = ["GK", "CB", "LB", "RB", "CDM", "CM", "CAM", "LW", "RW", "ST"]
	return positions.pick_random()
