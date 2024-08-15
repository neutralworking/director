INSERT INTO Club (club_name, founded_year, stadium_id, league_id, club_reputation)
VALUES ('Ashburton', 1894, NULL, NULL, 90);



INSERT INTO Person (first_name, last_name, date_of_birth, nation, gender)
VALUES ('Ken', 'Allen', '1988-10-22', 'England', 'Male');
INSERT INTO Player (person_id, club_id, height_cm, weight_kg, position, preferred_foot, squad_number, date_joined, nationality, youth_academy, legendary_status, retired)
VALUES (LAST_INSERT_ID(), 1, 189, 82, 'GK', 'Right', 1, '2024-08-07', 'Russian', FALSE, TRUE, TRUE);

INSERT INTO Person (first_name, last_name, date_of_birth, nationality, gender)
VALUES ('Lev', 'Yashin', '1929-10-22', 'Russian', 'Male');
INSERT INTO Player (person_id, club_id, height_cm, weight_kg, position, preferred_foot, squad_number, date_joined, nationality, youth_academy, legendary_status, retired)
VALUES (LAST_INSERT_ID(), 1, 189, 82, 'GK', 'Right', 1, '2024-08-07', 'Russian', FALSE, TRUE, TRUE);