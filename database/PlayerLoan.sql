CREATE TABLE PlayerLoan (
    loan_id INT AUTO_INCREMENT PRIMARY KEY,
    player_id INT,
    loaning_club_id INT,
    receiving_club_id INT,
    loan_start DATE,
    loan_end DATE,
    loan_fee DECIMAL(10, 2),
    option_to_buy BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (player_id) REFERENCES Player(player_id),
    FOREIGN KEY (loaning_club_id) REFERENCES Club(club_id),
    FOREIGN KEY (receiving_club_id) REFERENCES Club(club_id)
);
