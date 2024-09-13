# StaffList.gd
extends ScrollContainer

export(PackedScene) var staff_member_card_scene

onready var staff_container = $VBoxContainer

var staff_members = []

func _ready():
    load_staff_members()
    update_staff_list()

func load_staff_members():
    # This is where you would load your staff members from your game data
    # For now, we'll just create some example staff members
    staff_members.append(HeadCoach.new("John Doe"))
    staff_members.append(ChiefScout.new("Jane Smith"))
    # Add more staff members as needed

func update_staff_list():
    for child in staff_container.get_children():
        child.queue_free()
    
    for member in staff_members:
        var card = staff_member_card_scene.instance()
        card.setup(member)
        staff_container.add_child(card)

func add_staff_member(member: StaffMember):
    staff_members.append(member)
    update_staff_list()

func remove_staff_member(member: StaffMember):
    staff_members.erase(member)
    update_staff_list()


Staff

Manager
Assistant Manager
First-Team Coach x 2
Goalkeeping coach
Head of Performance
Fitness Coach
Head of medical sciences
Club Doctor
First-Team Physio x 2
Assistant Fitness Coach
Masseur x 3
Kit Manager
Assistant Kit Manager
Equipment Manager
Performance Nutritionist
Football Analyst

Chairman
Owner
Managing Director
Director
Director of Football
General Manager
Head of Youth Development
Chief Scout
Scout
Head Physio
Manager First Team
Assistant Manager First Team
Coach First Team
Gk Coach First Team
Fitness Coach First Team
Physio First Team
Manager Reserve Team
Manager (U23 Team)
Assistant Manager Reserve Team
Coach Reserve Team
Gk Coach Reserve Team
Fitness Coach Reserve Team
Physio Reserve Team
Assistant Manager (U23 Team)
Coach (U23 Team)
Gk Coach (U23 Team)
Fitness Coach (U23 Team)
Physio (U23 Team)
Assistant Manager (U21 Team)
Coach (U21 Team)
Gk Coach (U21 Team)
Fitness Coach (U21 Team)
Physio (U21 Team)
Assistant Manager (U19 Team)
Coach (U19 Team)
Gk Coach (U19 Team)
Fitness Coach (U19 Team)
Physio (U19 Team)
Assistant Manager (U18 Team)
Coach (U18 Team)
Gk Coach (U18 Team)
Fitness Coach (U18 Team)
Physio (U18 Team)
Player
Player/Chairman
Player/Managing Director
Player/Director
Player/Director of Football
Player/Head of Youth Development
Player/Chief Scout
Player/Scout
Player/Head Physio
Player/Manager First Team
Player/Assistant Manager First Team
Player/Coach
Player/Gk Coach First Team
Player/Fitness Coach First Team
Player/Physio First Team
Player/Manager Reserves
Player/Assistant Manager Reserves
Player/Coach
Player/Gk Coach Reserves
Player/Fitness Coach Reserves
Player/Physio Reserves
Player/Manager U21
Player/Assistant Manager U21
Player/Coach
Player/Gk Coach U21
Player/Fitness Coach U21
Player/Physio U21
Player/Coach (Youth Teams)
