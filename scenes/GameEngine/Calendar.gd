extends Node

var training_update = TrainingUpdate.new()
var market_update = MarketUpdate.new()
var value_update = ValueUpdate.new()
var medical_update = MedicalUpdate.new()
var board_update = BoardUpdate.new()
var competition_update = CompetitionUpdate.new()
var supporter_update = SupporterUpdate.new()

func _ready():
    # Connect signals to appropriate handlers
    training_update.connect("training_report_received", self, "_on_training_report_received")
    market_update.connect("market_update_received", self, "_on_market_update_received")
    value_update.connect("value_update_received", self, "_on_value_update_received")
    medical_update.connect("medical_update_received", self, "_on_medical_update_received")
    board_update.connect("board_update_received", self, "_on_board_update_received")
    competition_update.connect("competition_update_received", self, "_on_competition_update_received")
    supporter_update.connect("supporter_update_received", self, "_on_supporter_update_received")

    # Example of sending an update
    training_update.send_training_report()

func _on_training_report_received(report):
    print(report)
    # Display training report to user

func _on_market_update_received(report):
    print(report)
    # Display market update to user

func _on_value_update_received(report):
    print(report)
    # Display value update to user

func _on_medical_update_received(report):
    print(report)
    # Display medical update to user

func _on_board_update_received(report):
    print(report)
    # Display board update to user

func _on_competition_update_received(report):
    print(report)
    # Display competition update to user

func _on_supporter_update_received(report):
    print(report)
    # Display supporter update to user
