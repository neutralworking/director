CREATE TABLE League (
    league_id INT AUTO_INCREMENT PRIMARY KEY,
    league_name VARCHAR(100) NOT NULL,
    country VARCHAR(50) NOT NULL,
    tier INT,  -- Represents the tier level of the league (e.g., 1 for top division)
    reputation INT  -- League reputation can impact club finances, player interest, etc.
);
