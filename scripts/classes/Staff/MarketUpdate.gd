extends Node

class_name MarketUpdate

signal market_update_received(report: String)

func send_market_update():
    var report = generate_market_update()
    emit_signal("market_update_received", report)
    # Handle new additions to scouting radar here

func generate_market_update() -> String:
    var report = "Market Update:\n"
    report += "New players have been added to the scouting radar.\n"
    # Example report generation, this should include actual market data
    report += "Player X: Added to radar.\n"
    report += "Player Y: Highly recommended by scouts.\n"
    return report
