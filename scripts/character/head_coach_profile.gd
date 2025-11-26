extends Resource
# HEAD COACH PROFILE V3 - Maximum Mechanical Clarity
# 
# FINAL REFINEMENTS:
# 1. Concrete numbers for all bonuses/penalties (no vague percentages)
# 2. Dynamic relationship events with clear triggers
# 3. Coaching staff system (coach brings assistants)
# 4. Clear success/failure states with specific thresholds
# 5. Seasonal progression/regression mechanics

# Basic Info
@export var coach_name: String = ""
@export var age: int = 45
@export var nationality: String = "English"
@export var reputation: int = 50  # 0-100

# ============================================================================
# CORE ARCHETYPE (Refined to 5 Pure Archetypes)
# Each is extreme in one direction - no middle-ground options
# ============================================================================
@export_enum(
	"The System",     # Tactics purist - perfect system or bust
	"The People",     # Relationships expert - happy squad wins
	"The Believer",   # Motivation king - heart over head
	"The Builder",    # Youth obsessed - academy über alles
	"The Winner"      # Results only - ends justify means
) var archetype: String = "The System"

# ============================================================================
# MECHANICAL BONUSES (Exact Numbers, Not Percentages)
# Clear cause → effect for each archetype
# ============================================================================
const ARCHETYPE_MECHANICS = {
	"The System": {
		# WHEN squad tactical fit >= 75%:
		"squad_fit_bonus": {
			"match_rating": +0.5,      # Team plays 0.5 rating points better
			"goals_for": +8,            # Score 8 more goals per season
			"goals_against": -6,        # Concede 6 fewer per season
			"player_growth": +2         # Players gain +2 to tactical attributes
		},
		
		# WHEN squad tactical fit < 50%:
		"squad_fit_penalty": {
			"match_rating": -0.8,       # Team plays 0.8 worse
			"morale": -15,              # Squad confused and frustrated
			"contract_demands": true    # Players want to leave
		},
		
		# ALWAYS:
		"constraints": {
			"refuses_signings": true,   # Vetoes players who don't fit
			"inflexible": true,         # Can't change formation mid-season
			"requires_time": 2          # Needs 2 seasons minimum
		}
	},
	
	"The People": {
		# ALWAYS:
		"morale_baseline": +15,         # Every player starts 15 morale higher
		"conflict_resolution": "auto",  # Player conflicts resolve automatically
		"rotation_acceptance": +20,     # Bench players happier
		
		# WHEN squad morale >= 75:
		"high_morale_bonus": {
			"match_rating": +0.3,       # Over-performance when happy
			"injury_recovery": -2,      # Players return 2 weeks faster
			"contract_renewals": +30    # More likely to sign extensions
		},
		
		# PENALTY:
		"tactical_ceiling": 7.0,        # Max team rating = 7.0 (can't beat elite teams)
		"cant_drop_stars": true,        # Must play big names even if out of form
		"over_promises": true           # Creates future problems
	},
	
	"The Believer": {
		# IN HIGH PRESSURE GAMES (knockout, must-win):
		"pressure_bonus": {
			"match_rating": +0.7,       # Team rises to occasion
			"late_goals": +12,          # 12 more goals after 75th minute per season
			"comeback_chance": +25      # 25% more comebacks from losing positions
		},
		
		# COST:
		"burnout_tracker": 0,           # Increments each season
		"injury_rate": +8,              # 8 more injuries per season
		"player_exhaustion": +15,       # Fitness drops faster
		
		# AT burnout_tracker >= 3:
		"burnout_state": {
			"match_rating": -1.0,       # Complete collapse
			"morale": -30,              # Squad broken
			"requires_rebuild": true    # Must sell 50%+ of squad
		}
	},
	
	"The Builder": {
		# FOR PLAYERS age <= 23:
		"youth_bonus": {
			"attribute_growth": +4,     # +4 to growth rate per season
			"morale": +20,              # Young players love him
			"potential_unlock": +5      # Reach 5 CA higher than normal
		},
		
		# FOR PLAYERS age >= 28:
		"veteran_penalty": {
			"morale": -20,              # Feel neglected
			"performance": -0.3,        # Play worse
			"transfer_demands": true    # Want to leave
		},
		
		# TIMELINE:
		"year_1_2": -10,                # Finish -10 positions below expectation
		"year_3_4": 0,                  # Break even
		"year_5_plus": +15,              # Finish +15 above expectation
		
		# REQUIREMENT:
		"board_patience_required": 4    # Board must give 4 seasons minimum
	},
	
	"The Winner": {
		# VS top 6 opponents:
		"big_game_bonus": {
			"match_rating": +0.6,       # Raises game vs elite
			"tactical_prep": +2,        # Extra preparation bonus
			"clean_sheets": +8          # 8 more clean sheets vs top teams
		},
		
		# GENERAL:
		"pressure_immune": true,        # Media/board pressure doesn't affect
		"ruthless": true,               # Will drop anyone for results
		
		# COST:
		"fan_approval": -25,            # Boring football
		"creative_morale": -25,         # Flair players hate restrictions
		"shelf_life": 3,                # 3 seasons max before collapse
		"creates_toxicity": true        # Dressing room issues after year 2
	}
}

# ============================================================================
# ATTRIBUTES (Reduced to 4 Core Stats)
# Each directly affects one major system
# ============================================================================
var attributes: Dictionary = {
	"tactics": 10,          # Affects: Match engine performance modifier
	"relationships": 10,    # Affects: Base squad morale
	"development": 10,      # Affects: Player attribute growth rate
	"pressure": 10          # Affects: Performance under stress
}

# These map DIRECTLY to archetype:
func apply_archetype_attributes():
	match archetype:
		"The System":
			attributes = {"tactics": 19, "relationships": 9, "development": 14, "pressure": 12}
		"The People":
			attributes = {"tactics": 11, "relationships": 19, "development": 13, "pressure": 14}
		"The Believer":
			attributes = {"tactics": 12, "relationships": 16, "development": 11, "pressure": 19}
		"The Builder":
			attributes = {"tactics": 13, "relationships": 14, "development": 19, "pressure": 11}
		"The Winner":
			attributes = {"tactics": 17, "relationships": 8, "development": 9, "pressure": 18}

# ============================================================================
# TACTICAL PREFERENCE (Single Choice)
# Determines REQUIRED player attributes
# ============================================================================
@export_enum("Control", "Transition", "Defense") var tactical_style: String = "Control"

const STYLE_REQUIREMENTS = {
	"Control": {
		"must_have": ["Passing >= 14", "Vision >= 13", "Technique >= 14"],
		"bonus_if": ["Composure >= 15", "First Touch >= 14"],
		"weakness": "Vulnerable if lose possession"
	},
	"Transition": {
		"must_have": ["Pace >= 14", "Stamina >= 14", "Dribbling >= 13"],
		"bonus_if": ["Work Rate >= 15", "Acceleration >= 14"],
		"weakness": "Struggle vs compact defenses"
	},
	"Defense": {
		"must_have": ["Positioning >= 14", "Tackling >= 14", "Work Rate >= 14"],
		"bonus_if": ["Heading >= 14", "Strength >= 13"],
		"weakness": "Low scoring, fans bored"
	}
}

# ============================================================================
# SQUAD FIT CALCULATION (Concrete Formula)
# ============================================================================
func calculate_squad_fit(squad_players: Array) -> Dictionary:
	"""
	Returns exact squad fit percentage
	
	Formula:
	1. For each player, check tactical style requirements
	2. Player fits if has ALL must_have attributes
	3. Squad Fit = (Fitting Players / Total Players) * 100
	"""
	
	var fitting_players = 0
	var total_players = squad_players.size()
	
	# TODO: Implement with actual player data
	# For now, return structure
	
	var fit_percentage = 60  # Placeholder
	
	return {
		"fit_percentage": fit_percentage,
		"fitting_players": fitting_players,
		"total_players": total_players,
		"missing_positions": [],
		"recommendation": _get_fit_recommendation(fit_percentage)
	}

func _get_fit_recommendation(fit: int) -> String:
	if fit >= 80:
		return "Excellent fit - immediate success likely"
	elif fit >= 65:
		return "Good fit - need 2-3 signings to optimize"
	elif fit >= 50:
		return "Moderate fit - requires 5-6 signings"
	else:
		return "Poor fit - complete rebuild needed (1-2 seasons)"

# ============================================================================
# DIRECTOR COMPATIBILITY
# ============================================================================
func calculate_director_compatibility(director_archetype: String) -> int:
	"""
	Calculate how well this coach works with director archetype
	Based on archetype synergies from V2 design
	"""
	var compatibility_table = {
		"The System": {
			"The Scout": 90,      # Perfect partnership
			"The Tactician": 90,  # Both tactical nerds
			"The Dealmaker": 30,  # Constant conflict
			"The Politician": 50,
			"The Developer": 70
		},
		"The People": {
			"The Politician": 95,  # Master class in relationships
			"The Developer": 80,   # Both patient
			"The Scout": 45,       # Wants proven players
			"The Dealmaker": 50,
			"The Tactician": 55
		},
		"The Believer": {
			"The Firefighter": 90,  # Perfect for crisis (not in director list but conceptually)
			"The Politician": 40,   # Too emotional
			"The Developer": 20,    # Burns out youth
			"The Scout": 60,
			"The Dealmaker": 60,
			"The Tactician": 55
		},
		"The Builder": {
			"The Developer": 95,   # Match made in heaven
			"The Scout": 85,       # Find young talent
			"The Dealmaker": 25,   # Wants to develop, not sell
			"The Politician": 65,
			"The Tactician": 70
		},
		"The Winner": {
			"The Politician": 90,  # Ruthless power duo
			"The Dealmaker": 80,   # Both results-focused
			"The Developer": 15,   # Opposite philosophies
			"The Scout": 60,
			"The Tactician": 65
		}
	}
	
	var coach_compatibilities = compatibility_table.get(archetype, {})
	return coach_compatibilities.get(director_archetype, 50)  # Default to neutral

# ============================================================================
# COACHING STAFF (Coach brings his team)
# Each staff member provides specific bonus
# ============================================================================
@export var coaching_staff: Dictionary = {}

# Coach brings 2-3 staff members:
const STAFF_BONUSES = {
	"assistant_coach": {
		"bonus": "Helps with tactics",
		"effect": "+5 to tactics attribute"
	},
	"fitness_coach": {
		"bonus": "Reduces injuries",
		"effect": "-3 injuries per season"
	},
	"sports_psychologist": {
		"bonus": "Improves morale",
		"effect": "+10 baseline morale"
	},
	"set_piece_coach": {
		"bonus": "Better at set pieces",
		"effect": "+6 goals from set pieces per season"
	}
}

# ============================================================================
# DIRECTOR RELATIONSHIP (Dynamic Event System)
# ============================================================================
@export var director_relationship: int = 50  # 0-100

# Relationship changes based on SPECIFIC EVENTS:
const RELATIONSHIP_EVENTS = {
	# POSITIVE EVENTS
	"met_critical_objective": +15,
	"exceeded_expectations": +20,
	"won_trophy": +25,
	"promoted_academy_player": +5,
	"good_press_conference": +3,
	"backed_publicly": +10,
	
	# NEGATIVE EVENTS
	"missed_critical_objective": -20,
	"dressing_room_revolt": -30,
	"bad_loss_streak": -15,  # (5+ losses in row)
	"refused_director_signing": -15,
	"criticized_board_publicly": -25,
	"failed_big_game": -10
}

# RELATIONSHIP THRESHOLDS:
const RELATIONSHIP_STATES = {
	80: "Trusted - Full autonomy, contract extension likely",
	60: "Solid - Normal cooperation",
	40: "Strained - Increased scrutiny, some demands",
	20: "Crisis - Job at risk, emergency meeting",
	0: "Sacked - Fired"
}

# ============================================================================
# QUARTERLY REVIEW SYSTEM
# Director evaluates coach every 3 months
# ============================================================================
func conduct_quarterly_review(results: Dictionary) -> Dictionary:
	"""
	Reviews:
	1. League position vs target
	2. Playing style adherence
	3. Youth integration
	4. Squad morale
	
	Returns: {grade: String, relationship_change: int, status: String}
	"""
	
	var grade = "C"
	var rel_change = 0
	
	# Simple grading:
	var objectives_met = results.get("objectives_met", 0)
	var objectives_total = results.get("objectives_total", 4)
	
	var success_rate = float(objectives_met) / float(objectives_total)
	
	if success_rate >= 0.75:
		grade = "A"
		rel_change = +10
	elif success_rate >= 0.5:
		grade = "B"
		rel_change = +5
	elif success_rate >= 0.25:
		grade = "C"
		rel_change = 0
	else:
		grade = "F"
		rel_change = -15
	
	director_relationship += rel_change
	director_relationship = clampi(director_relationship, 0, 100)
	
	return {
		"grade": grade,
		"relationship_change": rel_change,
		"new_relationship": director_relationship,
		"status": _get_relationship_status()
	}

func _get_relationship_status() -> String:
	for threshold in [80, 60, 40, 20, 0]:
		if director_relationship >= threshold:
			return RELATIONSHIP_STATES[threshold]
	return "Unknown"

# ============================================================================
# PROGRESSION & AGING
# Coaches improve/decline over time
# ============================================================================
@export var seasons_at_club: int = 0
@export var burnout_level: int = 0  # For "The Believer"

func end_of_season_progression():
	"""Called at season end to update coach"""
	seasons_at_club += 1
	age += 1
	
	# Archetype-specific progression:
	match archetype:
		"The Believer":
			burnout_level += 1
			if burnout_level >= 3:
				_trigger_burnout()
		
		"The Builder":
			# Gets better over time
			if seasons_at_club >= 3:
				attributes["development"] = mini(20, attributes["development"] + 1)
		
		"The Winner":
			# Shelf life countdown
			if seasons_at_club >= 3:
				attributes["relationships"] = maxi(5, attributes["relationships"] - 2)

func _trigger_burnout():
	"""Believer coach burns out after 3 seasons"""
	print("%s has burned out! Squad exhausted, major rebuild needed." % coach_name)
	# This would trigger game event

# ============================================================================
# CONTRACT & HIRING
# ============================================================================
@export var weekly_wage: int = 50000
@export var contract_years: float = 2.0

# Wage demands based on reputation + archetype:
func calculate_wage_demands(club_reputation: int) -> int:
	var base_wage = reputation * 1000  # Rep 50 = £50k/week
	
	# Archetype modifiers:
	match archetype:
		"The Builder":
			base_wage *= 0.8  # Accepts lower wage for project
		"The Winner":
			base_wage *= 1.3  # Commands premium
	
	return int(base_wage)

func would_accept_job(club_reputation: int, board_patience: int) -> Dictionary:
	"""Returns whether coach would accept offer + reasoning"""
	
	var reasons = []
	var will_accept = true
	
	# Reputation check:
	if club_reputation < reputation - 20:
		will_accept = false
		reasons.append("Club beneath his level")
	
	# Archetype-specific checks:
	match archetype:
		"The Builder":
			if board_patience < 4:
				will_accept = false
				reasons.append("Board too impatient for youth project")
		
		"The System":
			# Check squad fit
			if true:  # TODO: Check actual squad
				reasons.append("Squad tactical fit must be analyzed")
	
	return {
		"accepts": will_accept,
		"reasons": reasons,
		"wage_demand": calculate_wage_demands(club_reputation)
	}

# ============================================================================
# HELPER FUNCTIONS
# ============================================================================

func _init(p_name: String = "New Coach"):
	coach_name = p_name
	apply_archetype_attributes()

func get_archetype_strengths() -> Array:
	return ARCHETYPE_MECHANICS.get(archetype, {}).keys()

func get_tactical_requirements() -> Array:
	return STYLE_REQUIREMENTS.get(tactical_style, {}).get("must_have", [])
