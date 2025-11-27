extends Node

class_name InboxSystem

signal new_message_received(message)
signal messages_updated()

var messages: Array = []
var time_system # Removed strict type to avoid parse error

func _ready():
	# Find TimeProgressionSystem
	time_system = get_node("/root/Main/TimeProgressionSystem")

func add_message(title: String, body: String, type: String = "INFO", related: Dictionary = {}):
	var msg_script = load("res://scripts/systems/inbox_message.gd")
	var message = msg_script.new()
	
	message.title = title
	message.body = body
	message.message_type = type
	message.related_data = related
	message.read = false
	
	if time_system and time_system.current_date:
		message.set_date(time_system.current_date)
	
	messages.append(message)
	new_message_received.emit(message)
	messages_updated.emit()
	
	print("📬 New inbox message: %s" % title)
	
	return message

func get_all_messages() -> Array:
	return messages

func get_unread_messages() -> Array:
	return messages.filter(func(m): return not m.read)

func get_unread_count() -> int:
	return get_unread_messages().size()

func mark_as_read(message):
	message.read = true
	messages_updated.emit()

func mark_all_as_read():
	for msg in messages:
		msg.read = true
	messages_updated.emit()

func delete_message(message):
	messages.erase(message)
	messages_updated.emit()

func clear_all():
	messages.clear()
	messages_updated.emit()
