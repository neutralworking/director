# player.gd
extends Resource
class_name Player

var id: int
var name: String
var attributes: Dictionary = {}

func _init(p_id: int, p_name: String):
    id = p_id
    name = p_name
    for attr in PlayerAttributes.ALL_ATTRIBUTES:
        attributes[attr] = PlayerAttributes.Rating.AVERAGE

func set_attribute(attr: String, value: int):
    if attr in PlayerAttributes.ALL_ATTRIBUTES:
        attributes[attr] = clamp(value, PlayerAttributes.Rating.TERRIBLE, PlayerAttributes.Rating.EXCELLENT)

func get_attribute(attr: String) -> int:
    return attributes.get(attr, PlayerAttributes.Rating.AVERAGE)

func get_attribute_display(attr: String) -> String:
    var value = get_attribute(attr)
    return PlayerAttributes.Rating.keys()[value - 1].capitalize()

func calculate_score(attr_list: Array) -> float:
    var total = 0
    for attr in attr_list:
        total += get_attribute(attr)
    return total / float(attr_list.size())

func get_mental_score() -> float:
    return calculate_score(PlayerAttributes.MENTAL_ATTRIBUTES)

func get_physical_score() -> float:
    return calculate_score(PlayerAttributes.PHYSICAL_ATTRIBUTES)

func get_tactical_score() -> float:
    return calculate_score(PlayerAttributes.TACTICAL_ATTRIBUTES)

func get_technical_score() -> float:
    return calculate_score(PlayerAttributes.TECHNICAL_ATTRIBUTES)

func get_keeper_score() -> float:
    return calculate_score(PlayerAttributes.KEEPER_ATTRIBUTES)

func get_overall_score() -> float:
    var scores = [
        get_mental_score(),
        get_physical_score(),
        get_tactical_score(),
        get_technical_score(),
        get_keeper_score()
    ]
    return scores.reduce(func(accum, number): return accum + number) / scores.size()

func to_dict() -> Dictionary:
    return {
        "id": id,
        "name": name,
        "attributes": attributes,
        "scores": {
            "mental": get_mental_score(),
            "physical": get_physical_score(),
            "tactical": get_tactical_score(),
            "technical": get_technical_score(),
            "keeper": get_keeper_score(),
            "overall": get_overall_score()
        }
    }

static func from_dict(data: Dictionary) -> Player:
    var player = Player.new(data.id, data.name)
    for attr in data.attributes:
        player.set_attribute(attr, data.attributes[attr])
    return player