CREATE VIEW LeagueStandings AS
SELECT
    lp.league_id,
    lp.season_year,
    lp.club_id,
    c.club_name,
    lp.points,
    lp.position
FROM
    ClubParticipation lp
JOIN
    Club c ON lp.club_id = c.club_id
WHERE
    lp.league_id IS NOT NULL
ORDER BY
    lp.league_id, lp.season_year, lp.position;
