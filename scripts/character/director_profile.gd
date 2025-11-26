extends Resource
# class_name DirectorProfile

# ============================================================================
# DIRECTOR PROFILE V3 - Refined Gameplay-First Design
# Each choice has clear mechanical impact on core game loops
# ============================================================================

# Basic Info
@export var director_name: String = ""
@export var date_of_birth: Dictionary = {"year": 1985, "month": 1, "day": 1}
@export var nationality: String = "English"

# ============================================================================
# CORE ARCHETYPE (Choose ONE - Your fundamental approach to the role)
# Each archetype has a PRIMARY LOOP they excel at + clear weaknesses
# ============================================================================
@export_enum(
	"The Scout",        # RECRUITMENT LOOP: Find hidden gems, terrible at selling your vision
	"The Dealmaker",    # NEGOTIATION LOOP: Extract maximum value, poor talent evaluation
	"The Tactician",    # SQUAD BUILDING: Perfect team composition, weak politics
	"The Politician",   # BOARD RELATIONS: Secure resources, players don't respect you
	"The Developer"     # YOUTH ACADEMY: Build from within, impatient for results
) var archetype: String = "The Scout"

# Gameplay Impact Per Archetype:
const ARCHETYPE_EFFECTS = {
	"The Scout": {
		"strengths": [
			"+40% accuracy identifying player ability and potential",
			"Unlock 'hidden gem' players in lower leagues",
			"Scouts cost 30% less and are 20% more effective"
		],
		"weaknesses": [
			"-20% negotiation success (struggle to close deals)",
			"-15% board confidence gain (can't sell the vision)",
			"Players don't understand your 'system'"
		],
		"unlock_condition": "Start with this OR achieve 10 A-grade signings"
	},
	
	"The Dealmaker": {
		"strengths": [
			"+30% negotiation success on transfers and contracts",
			"20% cheaper transfer fees via creative deal structures",
			"Can flip players for profit 50% faster"
		],
		"weaknesses": [
			"-30% talent evaluation accuracy (miss obvious flaws)",
			"40% chance to sign the 'wrong' player type",
			"Over-promise to agents (creates future problems)"
		],
		"unlock_condition": "Start with this OR save £50M in negotiations"
	},
	
	"The Tactician": {
		"strengths": [
			"Perfectly identify tactical fits for your system",
			"Squad chemistry +15% when signings match style",
			"Unlock 'tactical briefing' to boost match performance"
		],
		"weaknesses": [
			"-25% board confidence (they don't understand tactics)",
			"Alienate 'wrong fit' players (morale penalty)",
			"Stubborn about 'the system' (miss good players)"
		],
		"unlock_condition": "Start with this OR win trophy playing 'beautiful football'"
	},
	
	"The Politician": {
		"strengths": [
			"+50% board confidence generation",
			"Unlock budget increases via persuasion",
			"Survive failures that would sack other directors"
		],
		"weaknesses": [
			"Players don't trust you (-10 base relationship)",
			"-20% youth academy effectiveness (distant from players)",
			"Media scrutinizes your 'spin' (higher pressure)"
		],
		"unlock_condition": "Start with this OR survive 3 'sacking threshold' moments"
	},
	
	"The Developer": {
		"strengths": [
			"+50% youth intake quality",
			"Youth players develop 30% faster under you",
			"Board patience +2 seasons for youth-focused plans"
		],
		"weaknesses": [
			"-30% when signing 'ready-made' stars (scouts doubt you)",
			"Struggle to identify peak-age talent (25-28)",
			"Impatient fans demand instant results"
		],
		"unlock_condition": "Start with 3 OR promote 20 youth players to first team"
	}
}

# ============================================================================
# STRENGTHS (Pick 2) - Positive traits with no downside, but narrow focus
# ============================================================================
@export var strengths: Array = []

const AVAILABLE_STRENGTHS = {
	# Scouting & Recruitment
	"Sharp Eye": {
		"effect": "+2 to talent identification",
		"gameplay": "Reduce 'bust' signings by 40%"
	},
	"Future Focused": {
		"effect": "+3 to potential identification", 
		"gameplay": "Identify wonderkids 2 years earlier"
	},
	
	# Negotiation & Deals
	"Silver Tongue": {
		"effect": "+2 to negotiation",
		"gameplay": "15% better contract terms on average"
	},
	"Contract Wizard": {
		"effect": "Unlock creative clauses",
		"gameplay": "Add sell-ons, buybacks, performance bonuses"
	},
	
	# Tactical & Squad Building
	"System Master": {
		"effect": "+2 to tactical knowledge",
		"gameplay": "Identify tactical fits with 90% accuracy"
	},
	"Squad Architect": {
		"effect": "Optimal squad balance",
		"gameplay": "+10% team chemistry when balanced"
	},
	
	# People & Politics
	"Natural Leader": {
		"effect": "+2 to charisma",
		"gameplay": "Players more likely to trust your vision"
	},
	"Board Whisperer": {
		"effect": "+30% board confidence gains",
		"gameplay": "Get more patience and resources"
	},
	
	# Development & Long-term
	"Youth Guru": {
		"effect": "+2 to youth development",
		"gameplay": "Academy players develop attributes 25% faster"
	},
	"Long-term Thinker": {
		"effect": "3-year plans valued higher",
		"gameplay": "Board gives +1 season patience"
	}
}

# ============================================================================
# FLAWS (Forced to pick 1) - Creates interesting failure states
# ============================================================================
@export var flaw: String = ""

const AVAILABLE_FLAWS = {
	"Impatient": {
		"effect": "Struggle with long-term projects",
		"gameplay": "-1 season board patience, -10% youth effectiveness"
	},
	"Stubborn": {
		"effect": "Refuse to adapt when proven wrong",
		"gameplay": "20% chance to ignore negative feedback, leading to disasters"
	},
	"Trusting": {
		"effect": "Agents exploit your good nature",
		"gameplay": "15% chance agent demands hurt you in negotiations"
	},
	"Arrogant": {
		"effect": "Dismissive of  staff input",
		"gameplay": "Scouts 20% less effective (you ignore their warnings)"
	},
	"Conflict-Averse": {
		"effect": "Avoid necessary confrontations",
		"gameplay": "Can't discipline problematic players (morale issues spread)"
	},
	"Micromanager": {
		"effect": "Interfere with staff autonomy",
		"gameplay": "Staff morale -15%, higher turnover"
	},
	"Insecure": {
		"effect": "Overreact to criticism",
		"gameplay": "Media pressure builds 50% faster"
	}
}

# ============================================================================
# BACKGROUND (Choose ONE - Shapes starting stats and opportunities)
# ============================================================================
@export_enum(
	"Legendary Player",     # High charisma, tactical knowledge | Low analytical skills
	"Journeyman Player",    # Balanced | Nothing exceptional
	"Elite Scout",          # High talent ID | Poor negotiation
	"Top Agent",            # High negotiation, network | Players distrust you
	"Data Analyst",         # High analytical | Terrible people skills
	"Youth Coach",          # High development | Intimidated by stars
	"Tactical Analyst",     # High tactics | Zero charisma
	"Complete Nobody"       # Completely average | Must earn everything
) var background: String = "Complete Nobody"

const BACKGROUND_MODIFIERS = {
	"Legendary Player": {
		"starting_reputation": 60,
		"stat_mods": {"charisma": +4, "tactics": +3, "talent_id": -1, "negotiation": -1},
		"special": "Players start with +20 opinion of you",
		"burden": "Expectations are crushing - 1st season failure = instant dismissal"
	},
	"Elite Scout": {
		"starting_reputation": 30,
		"stat_mods": {"talent_id": +5, "potential_id": +4, "negotiation": -3, "charisma": -2},
		"special": "Unlock 3 'hidden gem' players per window",
		"burden": "Agents know you're weak - they exploit you"
	},
	"Top Agent": {
		"starting_reputation": 40,
		"stat_mods": {"negotiation": +5, "charisma": +2, "talent_id": -2},
		"special": "Access to exclusive player network via agents",
		"burden": "Players suspicious of your motives (-15 starting relationship)"
	},
	"Data Analyst": {
		"starting_reputation": 15,
		"stat_mods": {"talent_id": +4, "potential_id": +5, "charisma": -4, "negotiation": -2},
		"special": "Unlock advanced analytics dashboard",
		"burden": "Board and players mock your 'spreadsheets'"
	},
	"Complete Nobody": {
		"starting_reputation": 0,
		"stat_mods": {},  # All stats start at 10
		"special": "Blank canvas - can develop any direction via gameplay",
		"burden": "Zero shortcuts, zero respect, zero Help"
	}
}

# ============================================================================
# DERIVED STATS (Auto-calculated based on choices)
# Scale: 1-20 (FM style), affects actual game mechanics
# ============================================================================
var stats: Dictionary = {
	"talent_id": 10,       # Accuracy spotting current ability → Fewer transfer busts
	"potential_id": 10,    # Spotting future stars → Find wonderkids
	"negotiation": 10,     # Deal-making → Save money, better contracts
	"tactics": 10,         # Understanding systems → Sign right players for style
	"charisma": 10,        # Relationships → Board confidence, player trust
	"youth_dev": 10,       # Academy effectiveness → Promote more players
	"determination": 10,   # Resilience → Survive setbacks, rebuild after disasters
	"adaptability": 10     # Flexibility → Succeed in different leagues/cultures
}

# ============================================================================
# PROGRESSION & CAREER TRACKING
# ============================================================================
@export var reputation: int = 0  # 0-100
@export var seasons_completed: int = 0
@export var career_record: Dictionary = {}

# Unlockable badges (permanent bonuses earned through play)
@export var badges: Array = []

const BADGE_SYSTEM = {
	"The Architect": {
		"requirement": "5+ seasons same club, consistent success",
		"bonus": "+1 to all stats, +10% board patience"
	},
	"The Surgeon": {
		"requirement": "£100M+ career profit",
		"bonus": "+3 negotiation, unlock 'financial wizardry' deals"
	},
	"Youth Whisperer": {
		"requirement": "25+ youth promotions",
		"bonus": "+5 youth_dev, youth intake quality doubled"
	},
	"Serial Winner": {
		"requirement": "5+ major trophies",
		"bonus": "+2 charisma, attract star players"
	},
	"Firefighter": {
		"requirement": "Save 3 clubs from relegation",
		"bonus": "+3 determination, thrive under impossible pressure"
	}
}

func _init(p_name: String = "New Director"):
	director_name = p_name
	_initialize_stats()

func _initialize_stats():
	career_record = {
		"seasons": 0,
		"clubs": 0,
		"trophies": 0,
		"promotions": 0,
		"relegations": 0,
		"transfer_profit": 0.0,
		"legendary_signings": 0,
		"disastrous_signings": 0,
		"youth_promoted": 0,
		"fired_count": 0,
		"boards_charmed": 0
	}

func calculate_stats():
	"""Calculate final stats based on archetype + strengths + background + flaw"""
	# Start with base 10
	for stat in stats:
		stats[stat] = 10
	
	# Apply archetype bonuses (biggest impact)
	_apply_archetype_stats()
	
	# Apply background modifiers
	if background in BACKGROUND_MODIFIERS:
		var mods = BACKGROUND_MODIFIERS[background]["stat_mods"]
		for stat in mods:
			stats[stat] += mods[stat]
	
	# Apply strength bonuses
	_apply_strength_bonuses()
	
	# Apply flaw penalties
	_apply_flaw_penalty()
	
	# Clamp to 1-20 range
	for stat in stats:
		stats[stat] = clampi(stats[stat], 1, 20)

func _apply_archetype_stats():
	match archetype:
		"The Scout":
			stats["talent_id"] = 16
			stats["potential_id"] = 17
			stats["negotiation"] = 8
			stats["charisma"] = 7
			stats["tactics"] = 12
		
		"The Dealmaker":
			stats["negotiation"] = 18
			stats["charisma"] = 14
			stats["talent_id"] = 7
			stats["tactics"] = 9
			stats["determination"] = 14
		
		"The Tactician":
			stats["tactics"] = 18
			stats["talent_id"] = 14
			stats["charisma"] = 7
			stats["negotiation"] = 8
			stats["determination"] = 13
		
		"The Politician":
			stats["charisma"] = 18
			stats["negotiation"] = 14
			stats["talent_id"] = 8
			stats["youth_dev"] = 6
			stats["tactics"] = 9
		
		"The Developer":
			stats["youth_dev"] = 18
			stats["potential_id"] = 16
			stats["talent_id"] = 11
			stats["negotiation"] = 7
			stats["determination"] = 15

func _apply_strength_bonuses():
	for strength in strengths:
		match strength:
			"Sharp Eye":
				stats["talent_id"] += 2
			"Future Focused":
				stats["potential_id"] += 3
			"Silver Tongue":
				stats["negotiation"] += 2
			"System Master":
				stats["tactics"] += 2
			"Natural Leader":
				stats["charisma"] += 2
			"Youth Guru":
				stats["youth_dev"] += 2

func _apply_flaw_penalty():
	match flaw:
		"Impatient":
			stats["determination"] -= 2
			stats["youth_dev"] -= 1
		"Stubborn":
			stats["adaptability"] -= 3
		"Trusting":
			stats["negotiation"] -= 2
		"Arrogant":
			stats["charisma"] -= 2
func get_archetype_summary() -> String:
	return ARCHETYPE_EFFECTS.get(archetype, {}).get("strengths", [""])[0]

func get_starting_reputation() -> int:
	return BACKGROUND_MODIFIERS.get(background, {}).get("starting_reputation", 0)

func get_age() -> int:
	return 2025 - date_of_birth["year"]
