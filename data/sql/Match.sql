CREATE TABLE Match (
    match_id INT AUTO_INCREMENT PRIMARY KEY,
    home_team_id INT NOT NULL,
    away_team_id INT NOT NULL,
    league_id INT,
    cup_id INT,
    match_date DATE NOT NULL,
    home_team_score INT DEFAULT 0,
    away_team_score INT DEFAULT 0,
    round INT,  -- Round of the competition (relevant for cups)
    FOREIGN KEY (home_team_id) REFERENCES Club(club_id),
    FOREIGN KEY (away_team_id) REFERENCES Club(club_id),
    FOREIGN KEY (league_id) REFERENCES League(league_id),
    FOREIGN KEY (cup_id) REFERENCES Cup(cup_id)
);
