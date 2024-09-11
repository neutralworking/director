# StaffMemberCard.gd
extends PanelContainer

onready var name_label = $VBoxContainer/HBoxContainer/VBoxContainer/NameLabel
onready var type_label = $VBoxContainer/HBoxContainer/VBoxContainer/TypeLabel
onready var notification_icon = $VBoxContainer/HBoxContainer/NotificationIcon
onready var attributes_container = $VBoxContainer/AttributesContainer
onready var expand_button = $VBoxContainer/HBoxContainer/ExpandButton

var staff_member: StaffMember

func setup(member: StaffMember):
    staff_member = member
    name_label.text = member.name
    type_label.text = member.type
    update_attributes()

func update_attributes():
    for child in attributes_container.get_children():
        child.queue_free()
    
    for attribute in staff_member.attributes:
        var hbox = HBoxContainer.new()
        var label = Label.new()
        label.text = attribute
        hbox.add_child(label)
        
        var value = staff_member.get_weighted_attribute(attribute)
        var stars = HBoxContainer.new()
        for i in range(5):
            var star = TextureRect.new()
            star.texture = preload("res://assets/star.png")  # Make sure to add a star texture
            star.modulate = Color.yellow if i < value else Color.gray
            stars.add_child(star)
        hbox.add_child(stars)
        
        attributes_container.add_child(hbox)

func _on_ExpandButton_pressed():
    attributes_container.visible = !attributes_container.visible
    expand_button.text = "-" if attributes_container.visible else "+"