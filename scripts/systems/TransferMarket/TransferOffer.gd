extends Node2D

# Declare necessary variables for the transfer offer
var player_name = ""
var transfer_fee = 0
var additional_terms = ""

# Declare signals to notify other parts of the game when an offer is sent or canceled
signal transfer_offer_sent(player_name, transfer_fee, additional_terms)
signal transfer_offer_canceled()

func _ready():
    # Setting up UI elements
    $Panel/Label.text = "Send Transfer Offer"
    
    # Connect the button signals to respective functions
    $Panel/ButtonSend.connect("pressed", self, "_on_ButtonSend_pressed")
    $Panel/ButtonCancel.connect("pressed", self, "_on_ButtonCancel_pressed")

func _on_ButtonSend_pressed():
    # Collect input data
    player_name = $Panel/LineEditPlayerName.text
    transfer_fee = int($Panel/LineEditTransferFee.text)
    additional_terms = $Panel/LineEditAdditionalTerms.text
    
    # Validate the input
    if player_name == "" or transfer_fee <= 0:
        $Panel/LabelStatus.text = "Invalid input. Please check the details."
        return
    
    # Emit signal to send the transfer offer
    emit_signal("transfer_offer_sent", player_name, transfer_fee, additional_terms)
    
    # Update the status label
    $Panel/LabelStatus.text = "Transfer offer sent for %s.".format(player_name)

func _on_ButtonCancel_pressed():
    # Emit signal to cancel the transfer offer
    emit_signal("transfer_offer_canceled")
    
    # Reset the input fields
    $Panel/LineEditPlayerName.text = ""
    $Panel/LineEditTransferFee.text = ""
    $Panel/LineEditAdditionalTerms.text = ""
    
    # Update the status label
    $Panel/LabelStatus.text = "Transfer offer canceled."
