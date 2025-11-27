class_name EffectModifyOpinion
extends EventEffect

@export var opinion_modifier_id: String # e.g., "threw_under_bus"
@export var value_change: int = -20
@export var duration_months: int = 24

func execute(target: Object, director: DirectorProfile) -> void:
	# Assuming 'target' is passed as the context (e.g., the Player entity)
	if target.has_method("add_opinion_modifier"):
		target.add_opinion_modifier(opinion_modifier_id, value_change, duration_months)
	else:
		push_warning("EffectModifyOpinion: Target %s does not have method 'add_opinion_modifier'" % target)
