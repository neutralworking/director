extends Node

var db # Your database connection object

func get_player_data(player_id):
    var query = """
    SELECT 
        p.name,
        p.position,
        pa.attribute,
        pa.value,
        pos.mental_score,
        pos.physical_score,
        pos.tactical_score,
        pos.technical_score,
        pos.keeper_score,
        pos.overall_score
    FROM 
        players p
        JOIN player_attributes pa ON p.id = pa.player_id
        JOIN player_overall_score pos ON p.id = pos.player_id
    WHERE 
        p.id = $1
    """
    var result = db.query_dict(query, [player_id])
    return result

func update_player_attribute(player_id, attribute, value):
    var query = """
    INSERT INTO player_attributes (player_id, attribute, value)
    VALUES ($1, $2, $3)
    ON CONFLICT (player_id, attribute) DO UPDATE SET value = $3
    """
    db.query(query, [player_id, attribute, value])

# Use these functions in your game logic
func _ready():
    var player_data = get_player_data(1)
    print("Player name: ", player_data[0].name)
    print("Overall score: ", player_data[0].overall_score)

    update_player_attribute(1, "Communication", "Excellent")