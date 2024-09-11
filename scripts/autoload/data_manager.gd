# data_manager.gd
extends Node

const SAVE_PATH = "user://game_data.json"

var data = {
    "players": [],
    "teams": [],
    "leagues": [],
    "relationships": []
}

func _ready():
    load_data()
    load_players()

func load_data():
    if FileAccess.file_exists(SAVE_PATH):
        var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
        var json = JSON.parse_string(file.get_as_text())
        if json:
            data = json
        file.close()

func save_data():
    var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
    file.store_string(JSON.stringify(data, "\t"))
    file.close()

# data_manager.gd

const Player = preload("res://path/to/player.gd")

var players = {}

func add_player(player_data: Dictionary) -> int:
    var player_id = generate_unique_id()
    var player = Player.new(player_id, player_data.name)
    
    # Set attributes if provided
    for attr in player_data.get("attributes", {}):
        player.set_attribute(attr, player_data.attributes[attr])
    
    players[player_id] = player
    save_players()
    return player_id

func get_player(player_id: int) -> Player:
    return players.get(player_id)

func update_player_attribute(player_id: int, attribute: String, value: int) -> void:
    var player = get_player(player_id)
    if player:
        player.set_attribute(attribute, value)
        save_players()

func save_players() -> void:
    var data_to_save = {}
    for player_id in players:
        data_to_save[player_id] = players[player_id].to_dict()
    
    var file = FileAccess.open("user://players.json", FileAccess.WRITE)
    file.store_string(JSON.stringify(data_to_save))
    file.close()

func load_players() -> void:
    if FileAccess.file_exists("user://players.json"):
        var file = FileAccess.open("user://players.json", FileAccess.READ)
        var json = JSON.parse_string(file.get_as_text())
        file.close()
        
        players.clear()
        for player_id in json:
            players[int(player_id)] = Player.from_dict(json[player_id])
