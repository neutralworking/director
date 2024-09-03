extends Node

class_name DirectorProfile

# Attributes for the Director of Football

# Intelligence
var scouting_acumen: float = 0.0
var analytical_skills: float = 0.0
var strategic_planning: float = 0.0

# Wisdom
var judgment: float = 0.0
var experience: float = 0.0
var networking: float = 0.0

# Charisma
var negotiation_skills: float = 0.0
var leadership: float = 0.0
var communication: float = 0.0

# Dexterity
var adaptability: float = 0.0
var multitasking: float = 0.0

# Diligence
var resilience: float = 0.0
var consistency: float = 0.0

# Authority
var decision_making_power: float = 0.0
var resource_management: float = 0.0

# Initialization function to set up default values for a new director profile
func _init():
    # Example: Set initial values for attributes (these values can be customized)
    scouting_acumen = 50.0
    analytical_skills = 50.0
    strategic_planning = 50.0

    judgment = 50.0
    experience = 50.0
    networking = 50.0

    negotiation_skills = 50.0
    leadership = 50.0
    communication = 50.0

    adaptability = 50.0
    multitasking = 50.0

    resilience = 50.0
    consistency = 50.0

    decision_making_power = 50.0
    resource_management = 50.0

# Function to display the director's profile attributes
func display_profile():
    print("Director Profile:")
    print("Intelligence:")
    print("  Scouting Acumen: ", scouting_acumen)
    print("  Analytical Skills: ", analytical_skills)
    print("  Strategic Planning: ", strategic_planning)
    print("Wisdom:")
    print("  Judgment: ", judgment)
    print("  Experience: ", experience)
    print("  Networking: ", networking)
    print("Charisma:")
    print("  Negotiation Skills: ", negotiation_skills)
    print("  Leadership: ", leadership)
    print("  Communication: ", communication)
    print("Dexterity:")
    print("  Adaptability: ", adaptability)
    print("  Multitasking: ", multitasking)
    print("Diligence:")
    print("  Resilience: ", resilience)
    print("  Consistency: ", consistency)
    print("Authority:")
    print("  Decision-Making Power: ", decision_making_power)
    print("  Resource Management: ", resource_management)

# Example of increasing a specific attribute
func increase_attribute(attribute: String, amount: float):
    match attribute:
        "scouting_acumen":
            scouting_acumen += amount
        "analytical_skills":
            analytical_skills += amount
        "strategic_planning":
            strategic_planning += amount
        "judgment":
            judgment += amount
        "experience":
            experience += amount
        "networking":
            networking += amount
        "negotiation_skills":
            negotiation_skills += amount
        "leadership":
            leadership += amount
        "communication":
            communication += amount
        "adaptability":
            adaptability += amount
        "multitasking":
            multitasking += amount
        "resilience":
            resilience += amount
        "consistency":
            consistency += amount
        "decision_making_power":
            decision_making_power += amount
        "resource_management":
            resource_management += amount
        _:
            print("Attribute not found: ", attribute)
    
    # Ensure the attribute doesn't exceed 100
    set(attribute, clamp(get(attribute), 0.0, 100.0))

# Example of decreasing a specific attribute
func decrease_attribute(attribute: String, amount: float):
    increase_attribute(attribute, -amount)
