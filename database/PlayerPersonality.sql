CREATE TABLE PlayerPersonality (
    personality_id INT AUTO_INCREMENT PRIMARY KEY,
    player_id INT NOT NULL,
    leadership INT,               -- Leadership attribute (e.g., 1-20 scale)
    temperament INT,              -- Temperament attribute (e.g., 1-20 scale)
    work_ethic INT,               -- Work ethic attribute (e.g., 1-20 scale)
    ambition INT,                 -- Ambition attribute (e.g., 1-20 scale)
    loyalty INT,                  -- Loyalty attribute (e.g., 1-20 scale)
    FOREIGN KEY (player_id) REFERENCES Player(player_id)
);
