-- Create an enum for attribute values
CREATE TYPE attribute_value AS ENUM ('Terrible', 'Poor', 'Average', 'Good', 'Excellent');

-- Create the players table
CREATE TABLE players (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    position VARCHAR(2) NOT NULL
);

-- Create the player_attributes table
CREATE TABLE player_attributes (
    player_id INTEGER REFERENCES players(id),
    attribute VARCHAR(20) NOT NULL,
    value attribute_value NOT NULL,
    PRIMARY KEY (player_id, attribute)
);

-- Insert a player (example)
INSERT INTO players (name, position) VALUES ('John Doe', 'GK');

-- Insert player attributes (example)
INSERT INTO player_attributes (player_id, attribute, value) VALUES
(1, 'Communication', 'Good'),
(1, 'Concentration', 'Excellent'),
-- ... (insert all attributes)

-- Function to convert attribute value to numeric score
CREATE OR REPLACE FUNCTION attribute_to_score(attr attribute_value) RETURNS INTEGER AS $$
BEGIN
    RETURN CASE attr
        WHEN 'Terrible' THEN 1
        WHEN 'Poor' THEN 2
        WHEN 'Average' THEN 3
        WHEN 'Good' THEN 4
        WHEN 'Excellent' THEN 5
        ELSE 0
    END;
END;
$$ LANGUAGE plpgsql;

-- View to calculate MENTAL score
CREATE OR REPLACE VIEW player_mental_score AS
SELECT 
    player_id,
    (SUM(attribute_to_score(value)) * 100.0 / (12 * 5)) AS mental_score
FROM player_attributes
WHERE attribute IN ('Communication', 'Concentration', 'Drive', 'Leadership', 'Anticipation', 'Composure', 'Decisions', 'Tempo', 'Creativity', 'Set Pieces', 'Unpredictability', 'Vision')
GROUP BY player_id;

-- Similar views for PHYSICAL, TACTICAL, TECHNICAL, and KEEPER scores

-- View to calculate OVERALL score
CREATE OR REPLACE VIEW player_overall_score AS
SELECT 
    p.id AS player_id,
    p.position,
    m.mental_score,
    ph.physical_score,
    ta.tactical_score,
    te.technical_score,
    k.keeper_score,
    CASE 
        WHEN p.position = 'GK' THEN (m.mental_score + ph.physical_score + ta.tactical_score + te.technical_score + k.keeper_score) / 5
        ELSE (m.mental_score + ph.physical_score + ta.tactical_score + te.technical_score) / 4
    END AS overall_score
FROM 
    players p
    JOIN player_mental_score m ON p.id = m.player_id
    JOIN player_physical_score ph ON p.id = ph.player_id
    JOIN player_tactical_score ta ON p.id = ta.player_id
    JOIN player_technical_score te ON p.id = te.player_id
    LEFT JOIN player_keeper_score k ON p.id = k.player_id;

-- Query to get a player's attributes and scores
SELECT 
    p.name,
    p.position,
    pa.attribute,
    pa.value,
    pos.mental_score,
    pos.physical_score,
    pos.tactical_score,
    pos.technical_score,
    pos.keeper_score,
    pos.overall_score
FROM 
    players p
    JOIN player_attributes pa ON p.id = pa.player_id
    JOIN player_overall_score pos ON p.id = pos.player_id
WHERE 
    p.id = 1;  -- Replace with the desired player ID