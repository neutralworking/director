# Function to adjust form based on fatigue
func adjust_form():
    var fatigue_impact = fatigue / 100.0
    form = max(0, form - int(form * fatigue_impact))

# Function to simulate player training
func train():
    # Simulate training effects on fitness and fatigue
    fitness = min(100, fitness + 5)
    fatigue = min(100, fatigue + 10)

# Function to simulate player recovery
func recover():
    # Simulate recovery effects on fitness and fatigue
    fitness = min(100, fitness + 10)
    fatigue = max(0, fatigue - 10)

# Function to apply an injury to the player
func apply_injury(injury):
    is_injured = true
    current_injury = injury
    injury_recovery_days = injury.recovery_time

# Function to recover from injury
func recover_from_injury():
    if injury_recovery_days > 0:
        injury_recovery_days -= 1
    if injury_recovery_days == 0:
        is_injured = false
        current_injury = null

# Function to adjust form based on fatigue and injuries
func adjust_form():
    var fatigue_impact = fatigue / 100.0
    form = max(0, form - int(form * fatigue_impact))
    if is_injured:
        form = max(0, form - int(form * 0.5))  # Injured players perform worse