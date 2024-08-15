CREATE TABLE PlayerContract (
    contract_id INT AUTO_INCREMENT PRIMARY KEY,
    player_id INT NOT NULL,
    club_id INT NOT NULL,
    contract_start DATE NOT NULL,
    contract_end DATE NOT NULL,
    weekly_wage DECIMAL(10, 2) NOT NULL,
    signing_bonus DECIMAL(10, 2),
    release_clause DECIMAL(15, 2),
    appearance_bonus DECIMAL(10, 2),
    goal_bonus DECIMAL(10, 2),
    clean_sheet_bonus DECIMAL(10, 2),
    renewal_option BOOLEAN DEFAULT FALSE,
    termination_clause DECIMAL(15, 2),
    FOREIGN KEY (player_id) REFERENCES Player(player_id),
    FOREIGN KEY (club_id) REFERENCES Club(club_id)
);
