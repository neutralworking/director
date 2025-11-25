@tool
extends SceneTree

func _init():
	print("Starting RelationshipSystem Verification...")
	
	# Load classes
	var CharacterDataScript = load("res://scripts/character/character_data.gd")
	var RelationshipSystem = load("res://scripts/systems/RelationshipSystem.gd").new()
	
	# Create characters
	var char1 = CharacterDataScript.new("c1", "Director")
	var char2 = CharacterDataScript.new("c2", "Manager")
	
	# Test 1: Initial opinion should be 0
	var opinion = RelationshipSystem.get_opinion(char1, char2)
	if opinion == 0:
		print("PASS: Initial opinion is 0")
	else:
		print("FAIL: Initial opinion is %d (expected 0)" % opinion)
		
	# Test 2: Modify opinion
	RelationshipSystem.modify_opinion(char1, char2, 10, "Hired")
	opinion = RelationshipSystem.get_opinion(char1, char2)
	if opinion == 10:
		print("PASS: Opinion modified to 10")
	else:
		print("FAIL: Opinion is %d (expected 10)" % opinion)
		
	# Test 3: Clamp opinion
	RelationshipSystem.modify_opinion(char1, char2, 200, "Love")
	opinion = RelationshipSystem.get_opinion(char1, char2)
	if opinion == 100:
		print("PASS: Opinion clamped to 100")
	else:
		print("FAIL: Opinion is %d (expected 100)" % opinion)
		
	# Test 4: Negative opinion
	RelationshipSystem.modify_opinion(char1, char2, -200, "Hate")
	opinion = RelationshipSystem.get_opinion(char1, char2)
	if opinion == -100:
		print("PASS: Opinion clamped to -100")
	else:
		print("FAIL: Opinion is %d (expected -100)" % opinion)
		
	print("Verification Complete.")
	quit()
