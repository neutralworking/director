class_name ArchetypeData extends Resource

@export var id: String
@export var name: String
@export var mbti: String
@export var faction_belief: String

@export_group("Flavor")
@export var summary: String
@export var vibe: String

@export_group("Match Engine Weights")
@export var tempo: float = 0.5
@export var risk_tolerance: float = 0.5
@export var expressiveness: float = 0.5
@export var work_rate: float = 0.5
@export var tactical_discipline: float = 0.5

@export_group("Management Traits")
@export var loyalty: float = 0.5
@export var professionalism: float = 0.5
@export var controversy: float = 0.5
@export var ambition: float = 0.5

@export_group("Chemistry")
@export var conflicts_with: PackedStringArray = []
@export var synergizes_with: PackedStringArray = []

@export var player_examples: PackedStringArray = []
