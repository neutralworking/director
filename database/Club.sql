CREATE TABLE Club (
    club_id INT AUTO_INCREMENT PRIMARY KEY,
    club_name VARCHAR(100) NOT NULL,
    founded_year INT,
    stadium_id INT,
    league_id INT,
    club_reputation INT,  -- A numerical value representing the club's reputation
    FOREIGN KEY (stadium_id) REFERENCES Stadium(stadium_id),
    FOREIGN KEY (league_id) REFERENCES League(league_id)
);
