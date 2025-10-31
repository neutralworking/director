# EventQueueSystem.gd
extends Node

class_name EventQueueSystem

var event_queue: Array = []

enum EventType { MATCH, TRANSFER, CONTRACT, MEETING }

# Add an event to the queue
func schedule_event(date: Dictionary, event_type: int, data: Dictionary):
	event_queue.append({
		"date": date,            # {"year":2025, "month":10, "day":29, "hour":9}
		"type": event_type,
		"data": data
	})

# Returns all events for the current date/hour
func get_events_for_date(current_date: Dictionary) -> Array:
	var todays_events = []
	for event in event_queue:
		if event.date == current_date:
			todays_events.append(event)
	return todays_events

# Get the next scheduled event after current date/time
func get_next_event(current_date: Dictionary) -> Dictionary:
	# Find all future events after current_date
	var future_events = []
	for event in event_queue:
		if _is_later(event.date, current_date):
			future_events.append(event)
	if future_events.is_empty():
		return {}  # Return an empty dictionary instead of null
	
	future_events.sort_custom(Callable(self, "_compare_dates"))
	return future_events[0]



# Helper: returns true if a is later than b
func _is_later(a: Dictionary, b: Dictionary) -> bool:
	if a["year"] != b["year"]:
		return a["year"] > b["year"]
	if a["month"] != b["month"]:
		return a["month"] > b["month"]
	if a["day"] != b["day"]:
		return a["day"] > b["day"]
	if a.has("hour") and b.has("hour") and a["hour"] != b["hour"]:
		return a["hour"] > b["hour"]
	return false

# Helper for sorting by date
func _compare_dates(ev1: Dictionary, ev2: Dictionary) -> int:
	var a = ev1.date
	var b = ev2.date
	if _is_later(a, b): return 1
	if _is_later(b, a): return -1
	return 0
