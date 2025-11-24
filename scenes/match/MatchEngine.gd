extends Node

class_name MatchSimulationSystem

const HOME_ADVANTAGE = 1.1  # 10% advantage for home team

class Player:
    var id: String
    var name: String
    var position: String
    var attack: int
    var defense: int
    var stamina: int

    func _init(p_id: String, p_name: String, p_position: String, p_attack: int, p_defense: int, p_stamina: int):
        id = p_id
        name = p_name
        position = p_position
        attack = p_attack
        defense = p_defense
        stamina = p_stamina

class Team:
    var id: String
    var name: String
    var players: Array
    var form: float  # 0.0 to 1.0

    func _init(t_id: String, t_name: String, t_players: Array, t_form: float):
        id = t_id
        name = t_name
        players = t_players
        form = t_form

class MatchResult:
    var home_team: Team
    var away_team: Team
    var home_score: int
    var away_score: int
    var scorers: Array
    var yellow_cards: Array
    var red_cards: Array

    func _init(h_team: Team, a_team: Team, h_score: int, a_score: int, p_scorers: Array, p_yellow_cards: Array, p_red_cards: Array):
        home_team = h_team
        away_team = a_team
        home_score = h_score
        away_score = a_score
        scorers = p_scorers
        yellow_cards = p_yellow_cards
        red_cards = p_red_cards

func simulate_match(home_team: Team, away_team: Team) -> MatchResult:
    var home_score = 0
    var away_score = 0
    var scorers = []
    var yellow_cards = []
    var red_cards = []

    # Simulate 90 minutes
    for i in range(90):
        if _chance_of_goal(home_team, away_team, true):
            home_score += 1
            var scorer = _select_scorer(home_team)
            scorers.append(scorer)
        if _chance_of_goal(away_team, home_team, false):
            away_score += 1
            var scorer = _select_scorer(away_team)
            scorers.append(scorer)

        # Simulate cards
        _simulate_cards(home_team, away_team, yellow_cards, red_cards)

    return MatchResult.new(home_team, away_team, home_score, away_score, scorers, yellow_cards, red_cards)

func _chance_of_goal(attacking_team: Team, defending_team: Team, is_home: bool) -> bool:
    var attack_strength = 0
    var defense_strength = 0

    for player in attacking_team.players:
        attack_strength += player.attack
    attack_strength /= attacking_team.players.size()

    for player in defending_team.players:
        defense_strength += player.defense
    defense_strength /= defending_team.players.size()

    # Apply home advantage
    if is_home:
        attack_strength *= HOME_ADVANTAGE

    # Consider team form
    attack_strength *= attacking_team.form
    defense_strength *= defending_team.form

    var goal_chance = (attack_strength - defense_strength + 50) / 1000  # Base 5% chance, adjusted by strength difference
    return randf() < goal_chance

func _select_scorer(team: Team) -> Player:
    var total_attack = 0
    for player in team.players:
        total_attack += player.attack

    var random_value = randf() * total_attack
    var cumulative_attack = 0

    for player in team.players:
        cumulative_attack += player.attack
        if random_value <= cumulative_attack:
            return player

    return team.players[team.players.size() - 1]  # Fallback to last player

func decide_player_action(player: Player) -> String:
	"""
	Simple example: decides what a player does when they get the ball.
	"""
	var weights = {
		"safe_pass": player.get_action_weight("pass_safe"),
		"killer_pass": player.get_action_weight("pass_killer"),
		"dribble": player.get_action_weight("dribble"),
	}
	
	# Pick action based on weights
	var chosen_action = pick_weighted_action(weights)
	return chosen_action

func pick_weighted_action(weights: Dictionary) -> String:
	var total = 0.0
	for weight in weights.values():
		total += weight
	
	var rand = randf() * total
	var cumulative = 0.0
	for action in weights.keys():
		cumulative += weights[action]
		if rand <= cumulative:
			return action
	
	return weights.keys()[0]  # Fallback


func _simulate_cards(home_team: Team, away_team: Team, yellow_cards: Array, red_cards: Array):
    var all_players = home_team.players + away_team.players
    for player in all_players:
        if randf() < 0.01:  # 1% chance of yellow card per minute
            yellow_cards.append(player)
        if randf() < 0.001:  # 0.1% chance of red card per minute
            red_cards.append(player)

func update_team_stats(result: MatchResult):
    # Update team form based on result
    var home_form_change = 0.1 if result.home_score > result.away_score else -0.1
    var away_form_change = 0.1 if result.away_score > result.home_score else -0.1
    result.home_team.form = clamp(result.home_team.form + home_form_change, 0.1, 1.0)
    result.away_team.form = clamp(result.away_team.form + away_form_change, 0.1, 1.0)

    # Here you would also update player stats, team rankings, etc.

func generate_match_report(result: MatchResult) -> String:
    var report = "Match Result: %s %d - %d %s\n\n" % [result.home_team.name, result.home_score, result.away_score, result.away_team.name]
    report += "Scorers:\n"
    for scorer in result.scorers:
        report += "- %s (%s)\n" % [scorer.name, scorer.team.name]
    report += "\nYellow Cards:\n"
    for player in result.yellow_cards:
        report += "- %s (%s)\n" % [player.name, player.team.name]
    report += "\nRed Cards:\n"
    for player in result.red_cards:
        report += "- %s (%s)\n" % [player.name, player.team.name]
    return report

# Example usage:
func _ready():
    # Create some example players and teams
    var players_team_a = [
        Player.new("1", "John Doe", "Forward", 80, 30, 70),
        Player.new("2", "Jane Smith", "Midfielder", 70, 60, 80),
        Player.new("3", "Bob Johnson", "Defender", 30, 80, 75)
    ]
    var players_team_b = [
        Player.new("4", "Alice Brown", "Forward", 75, 35, 72),
        Player.new("5", "Charlie Davis", "Midfielder", 65, 65, 78),
        Player.new("6", "Eve Wilson", "Defender", 35, 75, 70)
    ]
    var team_a = Team.new("A", "Team A", players_team_a, 0.7)
    var team_b = Team.new("B", "Team B", players_team_b, 0.6)

    # Simulate a match
    var result = simulate_match(team_a, team_b)

    # Update team stats
    update_team_stats(result)

    # Generate and print match report
    var report = generate_match_report(result)
    print(report)

    # Print updated team forms
    print("%s new form: %.2f" % [team_a.name, team_a.form])
    print("%s new form: %.2f" % [team_b.name, team_b.form])