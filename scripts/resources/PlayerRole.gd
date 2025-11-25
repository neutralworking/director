class_name PlayerRole
extends Resource

@export_group("Role Identity")
@export var role_name: String = "Generic"
@export var position_code: String = "CM" # e.g., GK, ST, CDM

@export_group("Attribute Weights")
## Attributes that define this role. Higher weight = higher cost to buy in CA calc.
## Key: Attribute Name (String), Value: Weight (float 0.0 - 5.0)
@export var key_attributes: Dictionary = {
	"passing": 3.0,
	"vision": 2.0,
	"stamina": 1.0
}

## Curve used to distribute attribute values. 
## X-axis: 0-1 (Progress), Y-axis: Attribute Score (0-99).
## Default: Linear usually, but S-Curve ensures few players are "meh".
@export var distribution_curve: Curve
