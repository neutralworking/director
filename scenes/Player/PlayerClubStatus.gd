# PlayerClubStatus.gd
extends Node

class_name PlayerClubStatus

{
    "player_club_status_options": [
        {
            "status": "Untouchable",
            "description": "A key player for the club, highly valued and not for sale under almost any circumstances.",
            "impact_on_transfer_score": "Significantly increases TransferScore, making the player extremely expensive and difficult to sign."
        },
        {
            "status": "Key Player",
            "description": "An important player in the first team, central to the club's plans.",
            "impact_on_transfer_score": "Increases TransferScore, making the player expensive and requiring a strong offer to initiate negotiations."
        },
        {
            "status": "Important First Team Player",
            "description": "A regular starter who plays a vital role in the squad but is not indispensable.",
            "impact_on_transfer_score": "Moderately increases TransferScore, the player is valuable but could be sold for the right price."
        },
        {
            "status": "First Team Regular",
            "description": "A consistent member of the starting lineup but not considered a key figure.",
            "impact_on_transfer_score": "Slightly increases TransferScore, the player can be negotiated for with a reasonable offer."
        },
        {
            "status": "Squad Rotation",
            "description": "A player who regularly rotates in and out of the first team, not guaranteed a starting spot.",
            "impact_on_transfer_score": "Neutral impact on TransferScore, the player is available for transfer at market value."
        },
        {
            "status": "Backup Player",
            "description": "A player who primarily serves as a substitute or cover for first-team players.",
            "impact_on_transfer_score": "Decreases TransferScore, the player is likely to be available at a lower price."
        },
        {
            "status": "Fringe Player",
            "description": "A player who is not regularly involved in the first team and is on the periphery of the squad.",
            "impact_on_transfer_score": "Significantly decreases TransferScore, the player can be signed for a relatively low fee."
        },
        {
            "status": "Transfer Listed",
            "description": "A player who has been officially listed for transfer by the club, actively seeking to sell.",
            "impact_on_transfer_score": "Greatly decreases TransferScore, the player is available at a discount as the club is eager to sell."
        },
        {
            "status": "Youth Prospect",
            "description": "A young player who shows potential for the future but is not yet a first-team regular.",
            "impact_on_transfer_score": "Varies depending on potential; high potential can increase TransferScore, while unproven status might decrease it."
        },
        {
            "status": "Loaned Out",
            "description": "A player currently on loan to another club, gaining experience or out of favor at the parent club.",
            "impact_on_transfer_score": "Varies; the player might be available for transfer depending on performance and the club’s long-term plans."
        },
        {
            "status": "Out of Contract Soon",
            "description": "A player whose contract is nearing its end, potentially available at a reduced price to avoid losing them on a free transfer.",
            "impact_on_transfer_score": "Decreases TransferScore, the club may be motivated to sell to avoid losing the player for nothing."
        },
        {
            "status": "Injured",
            "description": "A player who is currently injured and not available for immediate selection.",
            "impact_on_transfer_score": "Typically decreases TransferScore, depending on the severity of the injury and the player’s importance to the club."
        },
        {
            "status": "Recovering from Injury",
            "description": "A player who is returning from an injury and may need time to regain full fitness.",
            "impact_on_transfer_score": "Slightly decreases TransferScore, the player might be available but with some risk attached."
        },
        {
            "status": "Contract Rebel",
            "description": "A player who is refusing to sign a new contract and is looking to leave the club.",
            "impact_on_transfer_score": "Decreases TransferScore, the club may be forced to sell at a lower price."
        },
        {
            "status": "Unsettled",
            "description": "A player who is unhappy at the club, possibly due to lack of playing time or other issues.",
            "impact_on_transfer_score": "Decreases TransferScore, the player may be available for transfer at a reduced price."
        },
        {
            "status": "Homesick",
            "description": "A player who is looking to move closer to home for personal reasons.",
            "impact_on_transfer_score": "Varies depending on the destination; the player may be more affordable for clubs in their home country."
        },
        {
            "status": "Loan Target",
            "description": "A player the club is willing to loan out, either to gain experience or due to surplus in the squad.",
            "impact_on_transfer_score": "TransferScore is low, but the player may be available for a loan rather than a permanent move."
        }
    ]
}
