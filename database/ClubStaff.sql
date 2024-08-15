CREATE TABLE ClubStaff (
    staff_id INT AUTO_INCREMENT PRIMARY KEY,
    person_id INT,
    club_id INT,
    role VARCHAR(50),  -- The staff member's role (e.g., Manager, Assistant Coach, Scout)
    contract_start DATE,
    contract_end DATE,
    salary DECIMAL(10, 2),
    FOREIGN KEY (person_id) REFERENCES Person(person_id),
    FOREIGN KEY (club_id) REFERENCES Club(club_id)
);
