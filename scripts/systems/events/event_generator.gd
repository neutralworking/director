tool
extends SceneTree

func _init():
	generate_leak_event()
	quit()

func generate_leak_event():
	print("Generating Leak Dilemma Event Resources...")
	
	var events_dir = "res://data/events/"
	var dir = DirAccess.open("res://")
	if not dir.dir_exists(events_dir):
		dir.make_dir_recursive(events_dir)

	# 1. Create Effects
	var eff_opinion = EffectModifyOpinion.new()
	eff_opinion.opinion_modifier_id = "threw_under_bus"
	eff_opinion.value_change = -20
	eff_opinion.duration_months = 24
	ResourceSaver.save(eff_opinion, events_dir + "eff_opinion_threw_under_bus.tres")
	
	var eff_stress = EffectChangeStress.new()
	eff_stress.amount = 15
	ResourceSaver.save(eff_stress, events_dir + "eff_stress_ego_boost.tres")
	
	# 2. Create Options
	var opt_spin = EventOption.new()
	opt_spin.text = "Spin the story (Blame Player)"
	opt_spin.effects = [eff_opinion] # In real scenario, might want to load from disk to ensure ref, but this works
	ResourceSaver.save(opt_spin, events_dir + "opt_leak_spin.tres")
	
	var opt_silence = EventOption.new()
	opt_silence.text = "Stay Silent"
	# Creating other effects for silence option as per prompt
	var eff_protected = EffectModifyOpinion.new()
	eff_protected.opinion_modifier_id = "protected_me"
	eff_protected.value_change = 10
	eff_protected.duration_months = 12
	ResourceSaver.save(eff_protected, events_dir + "eff_opinion_protected_me.tres")
	
	opt_silence.effects = [eff_protected]
	ResourceSaver.save(opt_silence, events_dir + "opt_leak_silence.tres")

	# 3. Create Event
	var event = GameEvent.new()
	event.title = "Journalist Inquiry"
	event.description = "A journalist is asking about the recent locker room incident."
	event.options = [opt_spin, opt_silence]
	event.is_urgent = true
	
	var error = ResourceSaver.save(event, events_dir + "evt_journalist_leak.tres")
	if error == OK:
		print("Successfully saved evt_journalist_leak.tres and dependencies.")
	else:
		print("Error saving event: %s" % error)
