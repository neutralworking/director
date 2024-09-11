extends Node

class_name EventQueueSystem

enum EventType {
    TRANSFER,
    MATCH,
    INJURY,
    CONTRACT_EXPIRY,
    FINANCIAL_UPDATE,
    TOURNAMENT_START,
    TOURNAMENT_END,
    SEASON_START,
    SEASON_END
    # Add more event types as needed
}

class Event:
    var type: int
    var date: GameDate
    var target: Object
    var method: String
    var data

    func _init(p_type: int, p_date: GameDate, p_target: Object, p_method: String, p_data = null):
        type = p_type
        date = p_date
        target = p_target
        method = p_method
        data = p_data

var events: Array = []

func add_event(event: Event):
    # Insert event in the correct position to keep the array sorted by date
    var index = 0
    for existing_event in events:
        if event.date._to_string() < existing_event.date._to_string():
            break
        index += 1
    events.insert(index, event)

func remove_event(event: Event):
    events.erase(event)

func process_events(current_date: GameDate):
    while not events.empty() and events[0].date._to_string() <= current_date._to_string():
        var event = events.pop_front()
        event.target.call(event.method, event.data)

func get_upcoming_events(days: int, current_date: GameDate) -> Array:
    var end_date = GameDate.new(current_date.day, current_date.month, current_date.year)
    for i in range(days):
        end_date.advance()
    
    return events.filter(func(event): 
        return (event.date._to_string() >= current_date._to_string() and 
                event.date._to_string() <= end_date._to_string())
    )

# Example usage:
func handle_transfer(data):
    print("Processing transfer: %s" % data)

func handle_match(data):
    print("Simulating match: %s" % data)

# Uncomment this to test the system
#func _ready():
#    var time_system = TimeProgressionSystem.new()
#    add_child(time_system)
#
#    # Schedule some events
#    add_event(Event.new(EventType.TRANSFER, GameDate.new(15, 7, 2024), self, "handle_transfer", "Player A to Club B"))
#    add_event(Event.new(EventType.MATCH, GameDate.new(20, 7, 2024), self, "handle_match", "Team X vs Team Y"))
#
#    # Connect to time progression system
#    time_system.connect("date_changed", self, "_on_date_changed")
#
#    time_system.start()
#
#func _on_date_changed(date):
#    print("Date changed to: %s" % date)
#    process_events(date)