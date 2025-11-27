class_name GameEvent
extends Resource

@export_group("Display")
@export var title: String
@export_multiline var description: String
@export var sender_name: String = "System"

@export_group("Logic")
## If true, this event forces the game to pause/popup (Dilemma)
@export var is_urgent: bool = false
## The specific logic required to trigger this (optional, handled by managers usually)
@export var trigger_conditions: Array[EventCondition] 

@export_group("Choices")
## The buttons the user can click.
@export var options: Array[EventOption]
