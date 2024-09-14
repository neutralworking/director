# player_attributes.gd

enum Rating {
    TERRIBLE = 1,
    POOR = 2,
    AVERAGE = 3,
    GOOD = 4,
    EXCELLENT = 5
}

const MENTAL_ATTRIBUTES = [
    "Communication", "Concentration", "Drive", "Leadership", "Anticipation",
    "Composure", "Decisions", "Tempo", "Creativity", "Set Pieces",
    "Unpredictability", "Vision"
]

const PHYSICAL_ATTRIBUTES = [
  "Duels", "Shielding", "Throwing", "Acceleration",
    "Balance", "Movement", "Pace", "Aerial Duels", "Heading",
    "Jumping", "Volleys", "Weak Foot"
]

const TACTICAL_ATTRIBUTES = [
    "Aggression", "Awareness", "Discipline", "Interceptions", "Positioning", "Blocking",
    "Clearances", "Marking", "Tackling", "Intensity", "Pressing",
    "Stamina"
]

const TECHNICAL_ATTRIBUTES = [
    "Carries", "First Touch", "Skills", "Takeons", "Crossing",
    "PassAccuracy", "PassRange", "ThroughBalls", "CloseRange", "MidRange",
    "LongRange", "Penalties"
]

const KEEPER_ATTRIBUTES = [
    "Agility", "Footwork", "Handling", "Reactions"
]

const ALL_ATTRIBUTES = MENTAL_ATTRIBUTES + PHYSICAL_ATTRIBUTES + \
                       TACTICAL_ATTRIBUTES + TECHNICAL_ATTRIBUTES + KEEPER_ATTRIBUTES