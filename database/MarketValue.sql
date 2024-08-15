DELIMITER //

CREATE FUNCTION CalculateMarketValue(
    PlayingLevel INT,
    PotentialLevel INT,
    CareerStage VARCHAR(20),
    Health VARCHAR(20),
    TransferStatus VARCHAR(20),
    ClubStatus VARCHAR(20),
    NationStatus VARCHAR(20)
) RETURNS DECIMAL(15,2)
BEGIN
    DECLARE base_value DECIMAL(15,2);
    DECLARE playing_modifier DECIMAL(10,2);
    DECLARE potential_modifier DECIMAL(10,2);
    DECLARE career_modifier DECIMAL(10,2);
    DECLARE health_modifier DECIMAL(10,2);
    DECLARE transfer_modifier DECIMAL(10,2);
    DECLARE club_modifier DECIMAL(10,2);
    DECLARE nation_modifier DECIMAL(10,2);
    
    -- Base value calculated from playing level
    SET base_value = (PlayingLevel - 70 ) * 100000;  -- Assuming each playing level unit above 70 is worth 100,000

    -- Modifier based on potential level
    IF PotentialLevel > (PlayingLevel + 10) THEN
        SET potential_modifier = 1.2;
    ELSEIF PotentialLevel > (PlayingLevel + 5) THEN
        SET potential_modifier = 1.2;
    ELSE
        SET potential_modifier = 1.0;
    END IF;

    -- Modifier based on career stage
    IF CareerStage = 'Early' THEN
        SET career_modifier = 1.5;
    ELSEIF CareerStage = 'Prime' THEN
        SET career_modifier = 2.0;
    ELSEIF CareerStage = 'Late' THEN
        SET career_modifier = 0.8;
    ELSE
        SET career_modifier = 1.0; -- Default to normal if undefined
    END IF;

    -- Modifier based on health
    IF Health = 'Excellent' THEN
        SET health_modifier = 1.2;
    ELSEIF Health = 'Good' THEN
        SET health_modifier = 1.0;
    ELSEIF Health = 'Injured' THEN
        SET health_modifier = 0.6;
    ELSE
        SET health_modifier = 0.8; -- Default for minor health issues
    END IF;

    -- Modifier based on transfer status
    IF TransferStatus = 'Not for Sale' THEN
        SET transfer_modifier = 1.5;
    ELSEIF TransferStatus = 'Available' THEN
        SET transfer_modifier = 1.0;
    ELSEIF TransferStatus = 'Transfer Listed' THEN
        SET transfer_modifier = 0.8;
    ELSE
        SET transfer_modifier = 1.0; -- Default to normal if undefined
    END IF;

    -- Modifier based on club status
    IF ClubStatus = 'Key Player' THEN
        SET club_modifier = 1.5;
    ELSEIF ClubStatus = 'Rotation' THEN
        SET club_modifier = 1.0;
    ELSEIF ClubStatus = 'Fringe' THEN
        SET club_modifier = 0.7;
    ELSE
        SET club_modifier = 1.0; -- Default to normal if undefined
    END IF;

    -- Modifier based on national team status
    IF NationStatus = 'Star' THEN
        SET nation_modifier = 1.5;
    ELSEIF NationStatus = 'Regular' THEN
        SET nation_modifier = 1.2;
    ELSEIF NationStatus = 'Occasional' THEN
        SET nation_modifier = 1.0;
    ELSEIF NationStatus = 'Not Selected' THEN
        SET nation_modifier = 0.8;
    ELSE
        SET nation_modifier = 1.0; -- Default to normal if undefined
    END IF;

    -- Calculate final market value
    RETURN base_value * potential_modifier * career_modifier * health_modifier * transfer_modifier * club_modifier * nation_modifier;

END //

DELIMITER ;


SELECT CalculateMarketValue(
    85,               -- PlayingLevel
    90,               -- PotentialLevel
    'Prime',          -- CareerStage
    'Good',           -- Health
    'Available',      -- TransferStatus
    'Key Player',     -- ClubStatus
    'Star'            -- NationStatus
) AS MarketValue;
