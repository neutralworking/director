func calculate_market_value(player):
    # Base value is determined by skill level and potential
    var base_value = player.skill_level * 100_000
    
    # Modifier based on recent performance (form)
    var form_modifier = 1.0 + (player.form - 0.5) * 0.2
    # Example: If form is 0.7 (good form), modifier is 1.04
    
    # Modifier based on age
    var age_modifier = 1.0
    if player.age < 21:
        age_modifier = 1.5  # Very young and high potential
    elif player.age >= 21 and player.age <= 25:
        age_modifier = 1.2  # Prime age with potential
    elif player.age > 25 and player.age <= 30:
        age_modifier = 1.0  # Peak performance years
    elif player.age > 30:
        age_modifier = 0.8  # Declining years, reduced value
    
    # Modifier based on contract length
    var contract_modifier = 1.0 + (player.contract_years_left - 2) * 0.1
    # Example: 3 years left gives 1.1, 1 year left gives 0.9
    
    # Modifier based on hype level (media attention, shortlisting by clubs)
    var hype_modifier = 1.0 + (player.hype_level * 0.3)
    # Example: Hype level 0.8 gives 1.24, hype level 0.3 gives 1.09
    
    # Modifier based on injury status
    var injury_modifier = 1.0
    if player.is_injured:
        injury_modifier = 0.7  # Injury reduces market value
    
    # Modifier based on position scarcity in the market
    var market_modifier = calculate_market_modifier(player.position)
    
    # Modifier based on club's financial health
    var club_financial_modifier = 1.0
    if player.current_club.financial_health == "Strong":
        club_financial_modifier = 1.1  # Club has strong negotiation power
    elif player.current_club.financial_health == "Weak":
        club_financial_modifier = 0.9  # Club may need to sell at a lower price
    
    # Final market value calculation
    var market_value = base_value * form_modifier * age_modifier * contract_modifier * hype_modifier * injury_modifier * market_modifier * club_financial_modifier
    
    return market_value

func calculate_market_modifier(position):
    # Example market demand data for different positions
    var market_demand = {
        "GK": 0.9,
        "DR": 1.0,
        "DC": 1.2,
        "DL": 1.0,
        "DM": 1.1,
        "MR": 1.0,
        "MC": 1.0,
        "ML": 1.0,
        "AMR": 1.2,
        "AMC": 1.3,
        "AML": 1.2,
        "CF": 1.4,
    }
    
    return market_demand.get(position, 1.0)  # Default to 1.0 if position is not found
