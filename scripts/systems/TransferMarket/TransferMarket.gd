extends Node

flowchart TD
    A[Football Transfer Market]
    A --> B[Player Factors]
    A --> C[Club Factors]
    A --> D[Market Factors]
    A --> E[External Factors]
    
    B --> B1[Performance]
    B --> B2[Potential]
    B --> B3[Age]
    B --> B4[Versatility]
    B --> B5[Marketability]
    
    C --> C1[Financial Situation]
    C --> C2[Squad Needs]
    C --> C3[Playing Style]
    C --> C4[Competition Level]
    
    D --> D1[Supply and Demand]
    D --> D2[Comparable Transfers]
    D --> D3[Economic Climate]
    
    E --> E1[Media Influence]
    E --> E2[Agent Negotiations]
    E --> E3[Regulatory Changes]
    E --> E4[Global Events]

# Reference to the agent class
var agent_script = preload("res://Agent.gd")

# Placeholder for transfer window status
var transfer_enabled: bool = true

# Function to attempt a player transfer
func attempt_transfer(player, club):
    if transfer_enabled:
        # Check if player has an agent, if not create a dummy one or handle it
        # For now assuming player.agent exists or we mock it
        var agent = player.get("agent") 
        if agent == null:
            # Create a dummy agent structure if not present for now
            agent = { "fee_percentage": 10, "reputation": 50, "prefers_club": func(c): return false }
            
        # Use the new calculator
        var base_transfer_fee = TransferValueCalculator.calculate_value(player, club)
        var agent_fee = base_transfer_fee * (agent.fee_percentage / 100.0)
        
        # Adjust transfer fee based on agent reputation
        var adjusted_transfer_fee = base_transfer_fee * (1.0 + (agent.reputation / 100.0))
        
        # Check if the agent prefers the club
        if agent.has_method("prefers_club") and agent.prefers_club(club.name):
            adjusted_transfer_fee *= 0.9  # Give a discount if the agent prefers the club
        
        # Simulate negotiation
        print("Negotiating transfer for player: ", player.name)
        print("Base Transfer Fee: ", base_transfer_fee)
        print("Agent Fee: ", agent_fee)
        print("Adjusted Transfer Fee: ", adjusted_transfer_fee)
        
        # Assume negotiation success for simplicity
        finalize_transfer(player, club, adjusted_transfer_fee, agent_fee)
    else:
        print("Transfer window is closed. Cannot transfer player: ", player.name)

# Function to finalize the transfer
func finalize_transfer(player, club, transfer_fee, agent_fee):
    print("Transfer successful!")
    print("Player: ", player.name, " moved to Club: ", club.name)
    print("Transfer Fee: ", transfer_fee, " Agent Fee: ", agent_fee)
    # Additional logic to update player and club data