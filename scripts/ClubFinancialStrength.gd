extends Node

class_name ClubFinancialStrength

# Basic financial attributes
var debt: float
var cash_reserves: float
var operating_losses: float
var sponsorship_revenue: float
var broadcasting_revenue: float
var matchday_income: float

# Ownership-related attributes
var owner_wealth: float
var owner_investment_willingness: float
var ownership_stability: float

# FFP and market conditions
var ffp_compliance: float
var economic_conditions: float

# Transfer policy and recent activity
var recent_big_sales: bool
var recent_big_purchases: bool
var squad_depth: int
var transfer_policy: float  # A value representing the club's tendency to sell to buy

# Club objectives
var relegation_threat: float
var promotion_aspirations: float
var european_qualification: bool

# Contract and wage bill
var player_contract_length: float
var wage_bill: float

# Fan and media pressure
var fan_sentiment: float
var media_pressure: float

# External factors
var legal_issues: bool
var unexpected_events: float

func _ready():
    # Example of initializing some values
    debt = 50_000_000
    cash_reserves = 20_000_000
    operating_losses = 10_000_000
    sponsorship_revenue = 5_000_000
    broadcasting_revenue = 25_000_000
    matchday_income = 15_000_000
    owner_wealth = 100_000_000
    owner_investment_willingness = 0.7
    ownership_stability = 0.9
    ffp_compliance = 0.8
    economic_conditions = 0.7
    recent_big_sales = false
    recent_big_purchases = true
    squad_depth = 25
    transfer_policy = 0.5
    relegation_threat = 0.3
    promotion_aspirations = 0.7
    european_qualification = false
    player_contract_length = 2.5  # Average years remaining
    wage_bill = 60_000_000
    fan_sentiment = 0.6
    media_pressure = 0.5
    legal_issues = false
    unexpected_events = 0.4

func calculate_seller_financial_strength() -> float:
    # This function calculates the financial strength of the seller.
    # The following formula is a simple placeholder and can be adjusted based on game design needs.
    
    var financial_health = cash_reserves + (owner_wealth * owner_investment_willingness) - debt - operating_losses
    var revenue_streams = sponsorship_revenue + broadcasting_revenue + matchday_income
    var external_pressure = (fan_sentiment + media_pressure + unexpected_events) / 3.0
    var market_conditions = economic_conditions * ffp_compliance
    var strategic_flexibility = (1.0 - relegation_threat) * promotion_aspirations * (1.0 if european_qualification else 0.5)
    var recent_transfer_activity = 1.0 if recent_big_sales else 0.5 if recent_big_purchases else 0.75

    # Calculate overall seller financial strength
    var financial_strength = (financial_health + revenue_streams) * market_conditions * strategic_flexibility * recent_transfer_activity - external_pressure
    
    return financial_strength / 100_000_000.0  # Normalize the result

func print_financial_strength():
    var strength = calculate_seller_financial_strength()
    print("Seller Financial Strength: ", strength)
