extends Node

class_name TimeProgressionSystem

signal date_changed(new_date)

enum GameSpeed {
	PAUSED,
	NORMAL,
	FAST,
	VERY_FAST
}

class GameDate:
	var day: int
	var month: int
	var year: int

	func _init(p_day: int, p_month: int, p_year: int):
		day = p_day
		month = p_month
		year = p_year

	func advance():
		day += 1
		if day > 30:  # Simplified month length
			day = 1
			month += 1
			if month > 12:
				month = 1
				year += 1

	func _to_string():
		return "%02d/%02d/%d" % [day, month, year]

var current_date: GameDate
var current_speed: int = GameSpeed.NORMAL
var is_running: bool = false
var tick_timer: Timer

func _ready():
	current_date = GameDate.new(1, 7, 2024)  # Start at July 1, 2024
	tick_timer = Timer.new()
	add_child(tick_timer)
	tick_timer.connect("timeout", Callable(self, "_on_tick_timer_timeout"))

func set_speed(speed: int):
	current_speed = speed
	_update_timer_interval()

func toggle_pause():
	if current_speed == GameSpeed.PAUSED:
		current_speed = GameSpeed.NORMAL
	else:
		current_speed = GameSpeed.PAUSED
	_update_timer_interval()

func start():
	is_running = true
	_update_timer_interval()

func stop():
	is_running = false
	tick_timer.stop()

func _on_tick_timer_timeout():
	if current_speed != GameSpeed.PAUSED:
		_tick()

func _tick():
	current_date.advance()
	emit_signal("date_changed", current_date)

func _update_timer_interval():
	var interval = _get_tick_interval()
	if interval > 0:
		tick_timer.start(interval)
	else:
		tick_timer.stop()

func _get_tick_interval() -> float:
	match current_speed:
		GameSpeed.NORMAL:
			return 1.0  # 1 second per day
		GameSpeed.FAST:
			return 0.5  # 0.5 seconds per day
		GameSpeed.VERY_FAST:
			return 0.1  # 0.1 seconds per day
		_:
			return 0  # Paused

# Example usage:
func _on_date_change(date: GameDate):
	print("Date changed to: %s" % date)

func _input(event):
	if event.is_action_pressed("ui_accept"):
		toggle_pause()
	elif event.is_action_pressed("ui_up"):
		set_speed(GameSpeed.FAST)
	elif event.is_action_pressed("ui_down"):
		set_speed(GameSpeed.NORMAL)

# Uncomment this to test the system
#func _ready():
#    connect("date_changed", self, "_on_date_change")
#    start()
