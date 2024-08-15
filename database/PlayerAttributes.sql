CREATE TABLE PlayerAttributes (
    attribute_id INT AUTO_INCREMENT PRIMARY KEY,
    player_id INT NOT NULL,
    attribute_name VARCHAR(50),
    attribute_value INT,
    FOREIGN KEY (player_id) REFERENCES Player(player_id)
);
