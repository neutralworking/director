class_name RelationshipSystem
extends Node

const RelationshipDataConst = preload("res://scripts/character/relationship.gd")

func modify_opinion(source, target, amount: int, reason: String = ""):
	if not source.relationships.has(target.id):
		source.relationships[target.id] = RelationshipDataConst.new()
	
	var rel = source.relationships[target.id]
	rel.opinion = clamp(rel.opinion + amount, -100, 100)
	
	if reason != "":
		rel.history.append({
			"date": "TODO: Get Date", # Placeholder for date system integration
			"change": amount,
			"reason": reason
		})
		
	print("Relationship update: %s -> %s: %+d (%s). New opinion: %d" % [source.name, target.name, amount, reason, rel.opinion])

func get_opinion(source, target) -> int:
	if source.relationships.has(target.id):
		return source.relationships[target.id].opinion
	return 0
