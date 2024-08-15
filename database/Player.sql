CREATE TABLE Player (
    player_id INT AUTO_INCREMENT PRIMARY KEY,   -- Unique identifier for each player
    person_id INT NOT NULL,                     -- Foreign key linking to the Person table
    club_id INT,                                -- Foreign key linking to the Club table
    height_cm INT,                              -- Player's height in centimeters
    weight_kg INT,                              -- Player's weight in kilograms
    position VARCHAR(10),                       -- Primary playing position (e.g., "GK", "CF")
    preferred_foot VARCHAR(10),                 -- Preferred foot (e.g., "Right", "Left", "Both")
    squad_number INT,                           -- Player's squad number
    date_joined DATE,                           -- Date the player joined the current club
    nationality VARCHAR(50),                    -- Player's nationality
    youth_academy BOOLEAN DEFAULT FALSE,        -- Indicates if the player was promoted from the youth academy
    legendary_status BOOLEAN DEFAULT FALSE,     -- Indicates if the player is considered a legend
    retired BOOLEAN DEFAULT FALSE,              -- Indicates if the player has retired
    FOREIGN KEY (person_id) REFERENCES Person(person_id),
    FOREIGN KEY (club_id) REFERENCES Club(club_id)
);
