CREATE TABLE Cup (
    cup_id INT AUTO_INCREMENT PRIMARY KEY,
    cup_name VARCHAR(100) NOT NULL,
    country VARCHAR(50) NOT NULL,
    reputation INT,  -- Cup reputation impacts club participation interest
    knockout_stage_start INT,  -- Defines at what stage the knockout begins (e.g., quarter-finals)
    is_international BOOLEAN DEFAULT FALSE  -- Indicates whether the cup is an international competition
);
