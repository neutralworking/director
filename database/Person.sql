CREATE TABLE Person (
    person_id INT AUTO_INCREMENT PRIMARY KEY,  -- Unique identifier for each person
    first_name VARCHAR(50) NOT NULL,           -- First name of the person
    last_name VARCHAR(50) NOT NULL,            -- Last name of the person
    date_of_birth DATE NOT NULL,               -- Date of birth
    nationality VARCHAR(50) NOT NULL,          -- Nationality
    gender VARCHAR(10) NOT NULL,               -- Gender (e.g., Male, Female, Non-binary)
    current_club_id INT,                       -- Reference to the current club (if applicable)
    person_type VARCHAR(20) NOT NULL,          -- Type of person (e.g., Player, Coach, Agent)
    height_cm INT,                             -- Height in centimeters
    weight_kg INT,                             -- Weight in kilograms
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Record creation timestamp
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- Record update timestamp
    FOREIGN KEY (current_club_id) REFERENCES Club(club_id) -- Foreign key to Club table (assuming Club table exists)
);
