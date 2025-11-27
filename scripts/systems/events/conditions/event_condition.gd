class_name EventCondition
extends Resource

## Base check function to be overridden. Returns true if condition is met.
func is_met(target: Object, director: DirectorProfile) -> bool:
	return true
