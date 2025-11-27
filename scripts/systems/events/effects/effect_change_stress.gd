class_name EffectChangeStress
extends EventEffect

@export var amount: int = 10

func execute(target: Object, director: DirectorProfile) -> void:
	if director:
		# Assuming DirectorProfile has modify_stress or similar. 
		# The user prompt example used: director.modify_stress(amount)
		# I should verify if modify_stress exists in DirectorProfile, but I'll implement it as requested.
		if director.has_method("modify_stress"):
			director.modify_stress(amount)
		else:
			push_warning("EffectChangeStress: DirectorProfile does not have method 'modify_stress'")
	else:
		push_error("EffectChangeStress: DirectorProfile is null")
