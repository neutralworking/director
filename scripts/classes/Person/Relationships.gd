class_name Relationship
extends Resource

enum RelationshipType {
    ARCH_ENEMY = -5,
    BITTER_ENEMY = -4,
    ENEMY = -3,
    DISLIKE = -2,
    BAD_BLOOD = -1,
    NEUTRAL = 0,
    ACQUAINTANCE = 1,
    COLLEAGUE = 2,
    TEAMMATE = 3,
    ALLY = 4,
    FRIEND = 5,
    BEST_FRIEND = 6,
    FAMILY = 7,
    CLOSE_FAMILY = 8,
    IDOL = 9
}

@export var target: String  # Name or unique identifier of the person or club
@export var relationship_type: RelationshipType = RelationshipType.NEUTRAL
@export var relationship_score: float = 0.0  # Ranges from -10.0 to 10.0
@export_multiline var relationship_comment: String = ""

var history: Array[Dictionary] = []

func _init(p_target: String = "", p_type: RelationshipType = RelationshipType.NEUTRAL, p_score: float = 0.0, p_comment: String = "") -> void:
    target = p_target
    relationship_type = p_type
    relationship_score = clamp(p_score, -10.0, 10.0)
    relationship_comment = p_comment
    _add_to_history("Initial relationship established")

func update_relationship(delta_score: float, reason: String = "") -> void:
    var old_score = relationship_score
    relationship_score = clamp(relationship_score + delta_score, -10.0, 10.0)
    update_relationship_type()
    _add_to_history("Score changed by %.1f (%.1f to %.1f). Reason: %s" % [delta_score, old_score, relationship_score, reason])

func update_relationship_type() -> void:
    var old_type = relationship_type
    relationship_type = get_relationship_type_from_score(relationship_score)
    if old_type != relationship_type:
        _add_to_history("Relationship type changed from %s to %s" % [RelationshipType.keys()[old_type], RelationshipType.keys()[relationship_type]])

func get_relationship_type_from_score(score: float) -> RelationshipType:
    if score < -8.0:
        return RelationshipType.ARCH_ENEMY
    elif score < -6.0:
        return RelationshipType.BITTER_ENEMY
    elif score < -4.0:
        return RelationshipType.ENEMY
    elif score < -2.0:
        return RelationshipType.DISLIKE
    elif score < 0.0:
        return RelationshipType.BAD_BLOOD
    elif score == 0.0:
        return RelationshipType.NEUTRAL
    elif score < 2.0:
        return RelationshipType.ACQUAINTANCE
    elif score < 4.0:
        return RelationshipType.COLLEAGUE
    elif score < 6.0:
        return RelationshipType.TEAMMATE
    elif score < 7.0:
        return RelationshipType.ALLY
    elif score < 8.0:
        return RelationshipType.FRIEND
    elif score < 9.0:
        return RelationshipType.BEST_FRIEND
    elif score < 9.5:
        return RelationshipType.FAMILY
    elif score < 10.0:
        return RelationshipType.CLOSE_FAMILY
    else:
        return RelationshipType.IDOL

func get_relationship_type_string() -> String:
    return RelationshipType.keys()[relationship_type]

func add_comment(comment: String) -> void:
    relationship_comment += "\n" + comment if relationship_comment else comment
    _add_to_history("Comment added: " + comment)

func _add_to_history(entry: String) -> void:
    history.append({"timestamp": Time.get_unix_time_from_system(), "entry": entry})

func get_history() -> Array[Dictionary]:
    return history

func get_formatted_history() -> String:
    var formatted = ""
    for entry in history:
        var datetime = Time.get_datetime_string_from_unix_time(entry.timestamp)
        formatted += "[%s] %s\n" % [datetime, entry.entry]
    return formatted