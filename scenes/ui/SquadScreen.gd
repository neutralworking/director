extends Control

var squad = [
    {"number": 1, "name": "J. Smith", "position": "GK", "rating": 75},
    {"number": 2, "name": "M. Johnson", "position": "DF", "rating": 70},
    {"number": 3, "name": "L. Williams", "position": "DF", "rating": 72},
    # Add more players as needed
]

func _ready():
    var main_container = VBoxContainer.new()
    add_child(main_container)
    main_container.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

    # Title
    var title = Label.new()
    title.text = "NY/NJ Metrostars"
    title.align = Label.ALIGN_CENTER
    main_container.add_child(title)

    # Player list container
    var player_container = HBoxContainer.new()
    main_container.add_child(player_container)

    # Left column
    var left_column = create_player_column(squad.slice(0, squad.size() / 2))
    player_container.add_child(left_column)

    # Right column
    var right_column = create_player_column(squad.slice(squad.size() / 2, squad.size()))
    player_container.add_child(right_column)

func create_player_column(players):
    var column = VBoxContainer.new()
    for player in players:
        var player_row = HBoxContainer.new()
        
        var number = Label.new()
        number.text = str(player.number)
        player_row.add_child(number)
        
        var name = Label.new()
        name.text = player.name
        player_row.add_child(name)
        
        var position = Label.new()
        position.text = player.position
        player_row.add_child(position)
        
        var rating = Label.new()
        rating.text = str(player.rating)
        player_row.add_child(rating)
        
        column.add_child(player_row)
    
    return column

func _draw():
    # Set background color
    draw_rect(Rect2(Vector2(), get_size()), Color(0, 0, 0.5))  # Dark blue background