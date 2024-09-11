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