"""gdscript
extends Node

class_name SaveManager

func save_game(file_path: String, game_data: Dictionary) -> void:
    var file = File.new()
    if file.open(file_path, File.WRITE) == OK:
        file.store_string(to_json(game_data))
        file.close()
    else:
        print("Failed to save game!")

func load_game(file_path: String) -> Dictionary:
    var file = File.new()
    if file.file_exists(file_path) and file.open(file_path, File.READ) == OK:
        var data = parse_json(file.get_as_text())
        file.close()
        return data
    else:
        print("Failed to load game!")
        return {}

func _ready():
    var game_data = {"date": "2025-11-24", "player": {"name": "John Doe"}, "finances": {"balance": 1000}}
    save_game("user://savefile.json", game_data)
    var loaded_data = load_game("user://savefile.json")
    print(loaded_data)
"""