Every player should have a TransferScore relative to every team.
There won't be many teams so this can probably be its own table for each team.
The transferScore determines the targetStatus, found on/linked to the clubTarget table.

var clubTargets: {
clubID: 0
targets: []
}

Reputation Level
Technical Score
Hype

- If a player is on a lot of shortlists, then their hype increases which multiplies their baseValue

PlayerClubStatus will determine a lot with regard to TransferScore
Players with a very high PlayerClubStatus will be much more expensive.
