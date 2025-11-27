class_name EventOption
extends Resource

@export var text: String
@export var tooltip: String
## If the director needs a specific trait to see this (e.g., "Political Operator")
# Note: We use a String ID or a Resource for traits. Assuming TraitDefinition is a resource type based on user request.
# If TraitDefinition doesn't exist yet, we might need to use a placeholder or String.
# The user prompt used: @export var required_trait: TraitDefinition
# I will assume TraitDefinition exists or I should create a placeholder for it if it doesn't.
# For now, I'll use Resource and comment it, or check if TraitDefinition exists.
# Given I haven't seen TraitDefinition in the file list, I will use Resource for now to avoid errors, 
# but ideally this should be typed.
@export var required_trait: Resource 
## The actual changes this option applies
@export var effects: Array[EventEffect]
