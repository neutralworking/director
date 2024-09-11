CREATE TABLE YouthPlayer (
    youth_player_id INT AUTO_INCREMENT PRIMARY KEY,
    person_id INT NOT NULL,
    academy_id INT NOT NULL,
    position VARCHAR(10) NOT NULL,
    current_level INT,  -- Current skill level of the youth player
    potential_level INT,  -- Potential skill level the player could reach
    training_schedule_id INT,  -- Links to their specific training schedule
    promotion_status BOOLEAN DEFAULT FALSE,  -- Indicates if the player is ready for promotion
    FOREIGN KEY (person_id) REFERENCES Person(person_id),
    FOREIGN KEY (academy_id) REFERENCES YouthAcademy(academy_id),
    FOREIGN KEY (training_schedule_id) REFERENCES TrainingSchedule(schedule_id)
);
