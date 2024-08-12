Every player should have a TransferScore relative to every team.
There won't be many teams so this can probably be its own table for each team.
The transferScore determines the targetStatus, found on/linked to the clubTarget table.

var clubTargets: {
clubID: 0
targets: []
}

# Requirements

If a club has no requirements, no players show up on the radar.
Managers will submit requirements.
Directors will submit requirements.
Players can make requirements sometimes if they are homesick or they aren't satisfied.
Fans can make requirements through social media campaigns.

Reputation Level
Technical Score
