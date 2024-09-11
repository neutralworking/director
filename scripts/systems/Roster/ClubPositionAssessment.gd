# ClubPositionAssessment.gd
extends Node

# Structure to hold club position scores
class ClubPositionScores:
    var ClubID: int
    var ClubFormation: String
    var ClubGKScore: float
    var ClubDRScore: float
    var ClubDCScore: float
    var ClubDLScore: float
    var ClubWBRScore: float
    var ClubDMScore: float
    var ClubWBLScore: float
    var ClubMRScore: float
    var ClubMCScore: float
    var ClubMLScore: float
    var ClubAMRScore: float
    var ClubAMCScore: float
    var ClubAMLScore: float
    var ClubRFScore: float
    var ClubCFScore: float
    var ClubLFScore: float

# Function to assess club requirements based on position scores
func ChiefScoutAssessClubRequirements(club_id: int, players_by_position: Dictionary) -> ClubPositionScores:
    var club_position_scores = ClubPositionScores.new()
    club_position_scores.ClubID = club_id
    club_position_scores.ClubFormation = determine_formation(club_id)
    
    club_position_scores.ClubGKScore = calculate_position_score(players_by_position.get("GK", []))
    club_position_scores.ClubDRScore = calculate_position_score(players_by_position.get("DR", []))
    club_position_scores.ClubDCScore = calculate_position_score(players_by_position.get("DC", []))
    club_position_scores.ClubDLScore = calculate_position_score(players_by_position.get("DL", []))
    club_position_scores.ClubWBRScore = calculate_position_score(players_by_position.get("WBR", []))
    club_position_scores.ClubDMScore = calculate_position_score(players_by_position.get("DM", []))
    club_position_scores.ClubWBLScore = calculate_position_score(players_by_position.get("WBL", []))
    club_position_scores.ClubMRScore = calculate_position_score(players_by_position.get("MR", []))
    club_position_scores.ClubMCScore = calculate_position_score(players_by_position.get("MC", []))
    club_position_scores.ClubMLScore = calculate_position_score(players_by_position.get("ML", []))
    club_position_scores.ClubAMRScore = calculate_position_score(players_by_position.get("AMR", []))
    club_position_scores.ClubAMCScore = calculate_position_score(players_by_position.get("AMC", []))
    club_position_scores.ClubAMLScore = calculate_position_score(players_by_position.get("AML", []))
    club_position_scores.ClubRFScore = calculate_position_score(players_by_position.get("RF", []))
    club_position_scores.ClubCFScore = calculate_position_score(players_by_position.get("CF", []))
    club_position_scores.ClubLFScore = calculate_position_score(players_by_position.get("LF", []))
    
    return club_position_scores

# Function to calculate the average score of the top two players in a position
func calculate_position_score(players: Array) -> float:
    if players.size() == 0:
        return 0.0  # No players in this position
    
    players.sort_custom("rating")  # Sort players by their rating or score
    var top_two_average = 0.0
    for i in range(min(2, players.size())):
        top_two_average += players[i].rating
    
    return top_two_average / min(2, players.size())

# Example function to determine the club's formation (stub, implementation needed)
func determine_formation(club_id: int) -> String:
    # This function should return the club's formation based on the club ID
    return "4-3-3"

# Determine positional requirements based on club position scores
func determine_positional_requirements(club_position_scores: ClubPositionScores) -> Array:
    var requirements = []
    
    # Create an array of position scores to calculate the median
    var scores = [
        club_position_scores.ClubGKScore,
        club_position_scores.ClubDRScore,
        club_position_scores.ClubDCScore,
        club_position_scores.ClubDLScore,
        club_position_scores.ClubWBRScore,
        club_position_scores.ClubDMScore,
        club_position_scores.ClubWBLScore,
        club_position_scores.ClubMRScore,
        club_position_scores.ClubMCScore,
        club_position_scores.ClubMLScore,
        club_position_scores.ClubAMRScore,
        club_position_scores.ClubAMCScore,
        club_position_scores.ClubAMLScore,
        club_position_scores.ClubRFScore,
        club_position_scores.ClubCFScore,
        club_position_scores.ClubLFScore
    ]
    
    scores.sort()  # Sort to find the median
    var median_score = scores[scores.size() / 2]
    
    # Add positions below the median to the requirements list
    if club_position_scores.ClubGKScore < median_score:
        requirements.append("GK")
    if club_position_scores.ClubDRScore < median_score:
        requirements.append("DR")
    if club_position_scores.ClubDCScore < median_score:
        requirements.append("DC")
    if club_position_scores.ClubDLScore < median_score:
        requirements.append("DL")
    if club_position_scores.ClubWBRScore < median_score:
        requirements.append("WBR")
    if club_position_scores.ClubDMScore < median_score:
        requirements.append("DM")
    if club_position_scores.ClubWBLScore < median_score:
        requirements.append("WBL")
    if club_position_scores.ClubMRScore < median_score:
        requirements.append("MR")
    if club_position_scores.ClubMCScore < median_score:
        requirements.append("MC")
    if club_position_scores.ClubMLScore < median_score:
        requirements.append("ML")
    if club_position_scores.ClubAMRScore < median_score:
        requirements.append("AMR")
    if club_position_scores.ClubAMCScore < median_score:
        requirements.append("AMC")
    if club_position_scores.ClubAMLScore < median_score:
        requirements.append("AML")
    if club_position_scores.ClubRFScore < median_score:
        requirements.append("RF")
    if club_position_scores.ClubCFScore < median_score:
        requirements.append("CF")
    if club_position_scores.ClubLFScore < median_score:
        requirements.append("LF")
    
    return requirements

# Suggest players based on the positional requirements
func suggest_players(requirements: Array, scouting_pool: Array) -> Array:
    var primary_shortlist = []
    
    for requirement in requirements:
        for player in scouting_pool:
            if player.position == requirement:
                primary_shortlist.append(player)
    
    return primary_shortlist
