extends Node

class_name ValueUpdate

signal value_update_received(report: String)

func send_value_update():
    var report = generate_value_update()
    emit_signal("value_update_received", report)
    # Handle value changes here

func generate_value_update() -> String:
    var report = "Value Update:\n"
    report += "Player values have changed over the last period.\n"
    # Example report generation, this should include actual player value changes
    report += "Player A: Value increased by 10%.\n"
    report += "Player B: Value decreased by 5%.\n"
    return report
