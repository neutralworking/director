class_name AnalystSystem
extends Node

static func discover_metric(player, analyst_ability: float) -> bool:
	if player.transfer_data == null:
		return false
		
	var metrics = player.transfer_data.analyst_metrics
	var undiscovered = []
	
	for metric_name in metrics:
		if not metrics[metric_name].get("discovered", false):
			undiscovered.append(metric_name)
			
	if undiscovered.is_empty():
		return false
		
	if randf() * 100 < analyst_ability:
		var metric_to_reveal = undiscovered.pick_random()
		metrics[metric_to_reveal]["discovered"] = true
		return true
		
	return false
