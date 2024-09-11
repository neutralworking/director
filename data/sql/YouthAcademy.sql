CREATE TABLE YouthAcademy (
    academy_id INT AUTO_INCREMENT PRIMARY KEY,
    academy_name VARCHAR(100) NOT NULL,
    club_id INT NOT NULL,
    reputation INT,  -- Reputation of the academy, influencing the quality of youth players
    FOREIGN KEY (club_id) REFERENCES Club(club_id)
);
