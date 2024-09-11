CREATE TABLE ClubParticipation (
    participation_id INT AUTO_INCREMENT PRIMARY KEY,
    club_id INT NOT NULL,
    league_id INT,
    cup_id INT,
    season_year INT NOT NULL,  -- The season year of participation
    points INT DEFAULT 0,  -- Points accumulated by the club in the league (used for leagues only)
    position INT,  -- Final position in the league (used for leagues only)
    round_reached INT,  -- Round reached in the cup (used for cups only)
    FOREIGN KEY (club_id) REFERENCES Club(club_id),
    FOREIGN KEY (league_id) REFERENCES League(league_id),
    FOREIGN KEY (cup_id) REFERENCES Cup(cup_id)
);
