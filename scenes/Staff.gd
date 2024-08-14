# Staff.gd
extends Node

class_name Staff

# Staff attributes
var name = ""
var role = ""
var expertise = 0  # Level of expertise (1-100)

{
    role: "Director of Football",
    primaryAttribute: "Negotiation"
},
{
    role: "Manager",
    primaryAttribute: "Tactical Knowledge"
},
{
    role: "Assistant Manager",
    primaryAttribute: "Motivation"
},
{
    role: "Coach",
    primaryAttribute: "Coaching",
    specialisation: 
},
{
    role: "Sport Scientist",
    primaryAttribute: ""
},
{
    role: "Physio",
    primaryAttribute: ""
},
{
    role: "Chief Scout",
    primaryAttribute: "PlayerAssessment"
},
{
    role: "Scout",
    primaryAttribute: "PlayerPotentialAssessment"
},
{
    role: "Performance Analyst",
    primaryAttribute: "TechnicalAssessment"
},
{
    role: "Head of Recruitment",
    primaryAttribute: "Negotiation"
},
{
    role: "Recruitment Analyst",
    primaryAttribute: "StaffAssessment"
},
{
    role: "Secretary",
    primaryAttribute: "Organisation"
},
{
    role: "Player Liaison Officer",
    primaryAttribute: "Comfort"
}


# Function to provide tactical input
func provide_tactical_input(team, opponents):
    return {}