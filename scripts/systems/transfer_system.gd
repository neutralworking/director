# scripts/systems/transfer_system.gd
extends Node

var transfer_statuses = {}

func _ready():
    load_transfer_statuses()

func load_transfer_statuses():
    var file = FileAccess.open("res://data/transfer/statuses.json", FileAccess.READ)
    transfer_statuses = JSON.parse_string(file.get_as_text())
    file.close()

func get_status_effects(status: String) -> Dictionary:
    return transfer_statuses.get(status, {}).get("effects", {})

func apply_status_to_player(player, status: String):
    var effects = get_status_effects(status)
    player.transfer_interest *= effects.get("transfer_interest", 1.0)
    player.morale += effects.get("player_morale", 0.0)
    player.transfer_value *= effects.get("transfer_fee_multiplier", 1.0)