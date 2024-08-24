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
('Jason Lee Scott', 'Red', 'Mighty Morphin Power Rangers', 'Earth', 'Tyrannosaurus Dinozord'),
('Trini Kwan', 'Yellow', 'Mighty Morphin Power Rangers', 'Earth', 'Saber-Toothed Tiger Dinozord'),
('Tommy Oliver', 'Green', 'Mighty Morphin Power Rangers', 'Earth', 'Dragonzord'),
('Kimberly Ann Hart', 'Pink', 'Mighty Morphin Power Rangers', 'Earth', 'Pterodactyl Dinozord'),
('Zack Taylor', 'Black', 'Mighty Morphin Power Rangers', 'Earth', 'Mastodon Dinozord'),
('Andros', 'Red', 'Power Rangers in Space', 'KO-35', 'Astro Megazord'),
('T.J. Johnson', 'Blue', 'Power Rangers in Space', 'Earth', 'Astro Megazord'),
('Karone', 'Pink', 'Power Rangers Lost Galaxy', 'Mirinoi', 'Wildcat Galactabeast'),
('Lauren Shiba', 'Red', 'Power Rangers Samurai', 'Earth', 'Lion Folding Zord'),
('Merrick Baliton', 'Silver', 'Power Rangers Wild Force', 'Earth', 'Predazord'),
('Antek', 'Red', 'Power Rangers Koks', 'Tatooine', 'Kozakzord');

