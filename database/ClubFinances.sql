CREATE TABLE ClubFinances (
    finance_id INT AUTO_INCREMENT PRIMARY KEY,
    club_id INT,
    season_year INT,
    revenue DECIMAL(15, 2),
    expenses DECIMAL(15, 2),
    transfer_budget DECIMAL(15, 2),
    wage_budget DECIMAL(15, 2),
    FOREIGN KEY (club_id) REFERENCES Club(club_id)
);
