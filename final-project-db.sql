-- Drop the 'power_rangers' table if it exists
DROP TABLE IF EXISTS power_rangers;

-- Create the 'power_rangers' table with the necessary columns and constraints
CREATE TABLE power_rangers (
    ranger_id INT GENERATED ALWAYS AS IDENTITY,
    name TEXT NOT NULL,
    color TEXT NOT NULL,
    series TEXT NOT NULL,
    home_planet TEXT NOT NULL,
    zord TEXT NOT NULL,
    CONSTRAINT ranger_color_check CHECK (
        color IN ('Red', 'Blue', 'Yellow', 'Black', 'Pink', 'Green', 'White', 'Gold', 'Silver', 'Purple', 'Orange')
    )
);

-- Insert data into the 'power_rangers' table
INSERT INTO power_rangers (name, color, series, home_planet, zord) VALUES
('Antoni Szczekot', 'Red', 'Mighty Morphin Power Rangers', 'Earth', 'Tyrannosaurus Dinozord'),
('Antoni Szczekot', 'Yellow', 'Mighty Morphin Power Rangers', 'Earth', 'Saber-Toothed Tiger Dinozord'),
('Antoni Szczekot', 'Green', 'Mighty Morphin Power Rangers', 'Earth', 'Dragonzord'),
('Antoni Szczekot', 'Pink', 'Mighty Morphin Power Rangers', 'Earth', 'Pterodactyl Dinozord'),
('Antoni Szczekot', 'Black', 'Mighty Morphin Power Rangers', 'Earth', 'Mastodon Dinozord'),
('Antoni Szczekot', 'Red', 'Power Rangers in Space', 'KO-35', 'Astro Megazord'),
('Antoni Szczekot', 'Blue', 'Power Rangers in Space', 'Earth', 'Astro Megazord'),
('Antoni Szczekot', 'Pink', 'Power Rangers Lost Galaxy', 'Mirinoi', 'Wildcat Galactabeast'),
('Antoni Szczekot', 'Red', 'Power Rangers Samurai', 'Earth', 'Lion Folding Zord'),
('Antoni Szczekot', 'Silver', 'Power Rangers Wild Force', 'Earth', 'Predazord')