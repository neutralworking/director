extends Control

signal request_push(screen_scene)
signal request_pop()
signal negotiation_requested(pending_transfer)

@onready var message_list = $VBoxContainer/ScrollContainer/MessageList
@onready var empty_label = $VBoxContainer/EmptyLabel

var inbox_system # Removed strict type to avoid parse error

func _ready():
	inbox_system = get_node("/root/Main/InboxSystem")
	if inbox_system:
		inbox_system.messages_updated.connect(_refresh_messages)
	_refresh_messages()

func on_enter():
	_refresh_messages()

func on_exit():
	pass

func _refresh_messages():
	# Clear existing messages
	for child in message_list.get_children():
		child.queue_free()
	
	if not inbox_system:
		return
	
	var messages = inbox_system.get_all_messages()
	
	if messages.is_empty():
		empty_label.visible = true
		return
	
	empty_label.visible = false
	
	# Sort by date (newest first)
	messages.sort_custom(func(a, b): 
		if a.year != b.year:
			return a.year > b.year
		if a.month != b.month:
			return a.month > b.month
		return a.day > b.day
	)
	
	# Create message items
	for msg in messages:
		var item = _create_message_item(msg)
		message_list.add_child(item)

func _create_message_item(message) -> Control:
	var container = PanelContainer.new()
	container.custom_minimum_size = Vector2(0, 80)
	
	# Style based on read status
	if not message.read:
		var style = StyleBoxFlat.new()
		style.bg_color = Color(0.2, 0.3, 0.4, 0.3)
		container.add_theme_stylebox_override("panel", style)
	
	var vbox = VBoxContainer.new()
	container.add_child(vbox)
	
	# Header (icon + title + date)
	var header = HBoxContainer.new()
	vbox.add_child(header)
	
	var icon_label = Label.new()
	icon_label.text = message.get_icon()
	header.add_child(icon_label)
	
	var title_label = Label.new()
	title_label.text = message.title
	title_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	if not message.read:
		title_label.add_theme_font_size_override("font_size", 16)
	header.add_child(title_label)
	
	var date_label = Label.new()
	date_label.text = message.get_date_string()
	date_label.add_theme_color_override("font_color", Color(0.7, 0.7, 0.7))
	header.add_child(date_label)
	
	# Body
	var body_label = Label.new()
	body_label.text = message.body
	body_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	vbox.add_child(body_label)
	
	# Action Buttons
	var button_hbox = HBoxContainer.new()
	vbox.add_child(button_hbox)
	
	# Negotiate Button (if applicable)
	# Debug print to verify condition
	# print("Checking negotiate button: Type=%s, HasPending=%s" % [message.message_type, message.related_data.has("pending_transfer")])
	
	if message.message_type == "TRANSFER_NEGOTIATING" and message.related_data.has("pending_transfer"):
		var neg_btn = Button.new()
		neg_btn.text = "Negotiate"
		neg_btn.custom_minimum_size = Vector2(100, 30) # Ensure it has size
		neg_btn.mouse_filter = Control.MOUSE_FILTER_STOP # Ensure it catches clicks
		
		neg_btn.pressed.connect(func():
			print("Inbox: Negotiate button pressed for %s" % message.related_data.player_name)
			negotiation_requested.emit(message.related_data.pending_transfer)
		)
		button_hbox.add_child(neg_btn)
		# print("Negotiate button added")
	
	# Mark as read when clicked (using gui_input on container)
	container.mouse_filter = Control.MOUSE_FILTER_STOP
	container.gui_input.connect(func(event):
		if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			inbox_system.mark_as_read(message)
			_refresh_messages()
	)
	
	return container

func _on_back_pressed():
	request_pop.emit()

func _on_mark_all_read_pressed():
	if inbox_system:
		inbox_system.mark_all_as_read()
