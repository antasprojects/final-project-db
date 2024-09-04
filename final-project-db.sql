-- Drop existing tables if they exist
DROP TABLE IF EXISTS Tags CASCADE;                     
DROP TABLE IF EXISTS Environmental_Reminders CASCADE;  
DROP TABLE IF EXISTS User_Recommendations CASCADE;     
DROP TABLE IF EXISTS Saved CASCADE;           
DROP TABLE IF EXISTS Green_Places CASCADE;             
DROP TABLE IF EXISTS Users CASCADE;  
DROP TABLE IF EXISTS Users_profile;
DROP TABLE IF EXISTS likes;

-- Create the Users table to store user information
CREATE TABLE IF NOT EXISTS Users (
    user_id SERIAL PRIMARY KEY,            -- Unique identifier for each user (auto-incremented)
    username VARCHAR(100) UNIQUE NOT NULL, -- Unique username for each user
    email VARCHAR(100) UNIQUE NOT NULL,    -- User's email address
    password_hash VARCHAR(255) NOT NULL,   -- Secure hash of the user's password
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- Timestamp of when the user account was created
);

CREATE TABLE IF NOT EXISTS tags (
    tag_id SERIAL PRIMARY KEY,          -- Unique identifier for each tag (auto-incremented)
    tag_name VARCHAR(500) UNIQUE NOT NULL  -- Name of the tag (must be unique and not null)
);
-- Create the Green_Places table to store information about green spaces
CREATE TABLE IF NOT EXISTS Green_Places (
    place_id SERIAL PRIMARY KEY,             -- Unique identifier for each green place (auto-incremented)
    name VARCHAR(500) UNIQUE NOT NULL,       -- Name of the green space
    location_type VARCHAR(500),           -- Type of location (e.g., 'park', 'trail', 'beach', etc.)
    description text,                -- Description of the green space
    latitude FLOAT NOT NULL,                 -- Latitude for the green space's location
    longitude FLOAT NOT NULL,                -- Longitude for the green space's location
    rating FLOAT CHECK (rating >= 0 AND rating <= 5),  -- Average user rating (0-5 scale)
    address VARCHAR(255),                    -- Full address of the green space
    image_url VARCHAR(500)[],                  -- URL to an image of the green space
    googleid VARCHAR(255),
    tag_id INT REFERENCES Tags(tag_id)
);

-- Create the Environmental_Reminders table to store reminders associated with tags
CREATE TABLE IF NOT EXISTS Environmental_Reminders (
    reminder_id SERIAL PRIMARY KEY,               -- Unique identifier for each reminder (auto-incremented)
    reminder_text TEXT NOT NULL,                  -- Text of the reminder (e.g., "Don’t forget to bring reusable water bottles")
    tag_id INT REFERENCES tags(tag_id)                       -- References the tag_id column in the tags table
);

CREATE TABLE IF NOT EXISTS Saved_places (
    user_id INT REFERENCES Users(user_id),   -- Foreign key referencing Users table
    place_id INT REFERENCES Green_Places(place_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Timestamp of when the journey was saved
    PRIMARY KEY (user_id, place_id) 
);

CREATE TABLE IF NOT EXISTS User_Recommendations (
    recommendation_id SERIAL PRIMARY KEY,            -- Unique identifier for each recommendation (auto-incremented)
    recommender_user_id INT REFERENCES Users(user_id),  -- Foreign key referencing Users table for the recommender
    recommended_user_id INT REFERENCES Users(user_id),  -- Foreign key referencing Users table for the recommended user
    place_id INT REFERENCES Green_Places(place_id),   -- Foreign key referencing Green_Places table
    message TEXT,                                     -- Optional message included with the recommendation
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP    -- Timestamp of when the recommendation was made
);

CREATE TABLE likes (
  place_id INT PRIMARY KEY,
  like_count INT DEFAULT 0,
  FOREIGN KEY (place_id) REFERENCES Green_Places(place_id)
);

CREATE TABLE Users_Profile (
    user_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (visited_spots) REFERENCES Green_Places(place_id)
);



-- Insert predefined tags into the tags table
INSERT INTO tags (tag_name) VALUES
('Woodlands'),
('Hiking'),
('Park'),
('Garden'),
('Historic'),
('Beach'),
('Camping'),
('Wildlife'),
('Farm'),
('Rivers');



-- Insert dummy data into Users table
INSERT INTO Users (username, email, password_hash) VALUES
('john_doe', 'john-doe@example.com', '$2b$12$8RmTIuexL8qPRA8tht6V0e'),
('jane_smith', 'jane_smith@example.com', '$2b$12$ZVmNHg1w3J8HFoMHZmtIvK'),
('alice_wonder', 'alice@example.com', '$2b$12$5Le5eP9mK9BhxMPl/EbIyO'),
('michael_jordan', 'mjordan@example.com', '$2b$12$7QTyRj2oJ2Q7Pq1c3UkeQO'),
('sarah_connor', 'sarah.connor@example.com', '$2b$12$wGhSR7rKd/ULbN9zxTlCVe'),
('bruce_wayne', 'bruce.wayne@example.com', '$2b$12$8RmQd5gD8zJG8OcPhm8YH1'),
('clark_kent', 'clark.kent@example.com', '$2b$12$7TyEw6jX2qPRA9tk4L0jXe'),
('diana_prince', 'diana.prince@example.com', '$2b$12$dJe4V9gH9Gh5boMHtM9FeO'),
('peter_parker', 'peter.parker@example.com', '$2b$12$eMv5gP4vP9NkX9Ml/FbZgP'),
('tony_stark', 'tony.stark@example.com', '$2b$12$fNh5R3gV6HcJ0cDl/LbHtY'),
('natasha_romanoff', 'natasha.romanoff@example.com', '$2b$12$hJe7F6gH7Gh6LoMHpNlCfP'),
('steve_rogers', 'steve.rogers@example.com', '$2b$12$iLn5R5gF6HcK0dJl/MbIeS'),
('wanda_maximoff', 'wanda.maximoff@example.com', '$2b$12$jLe8F6hH7Gh7MoMHqOlCgR');



-- Insert dummy data into Green_Places table for locations in London 
INSERT INTO Green_Places (name, location_type, description, latitude, longitude, rating, address, image_url, googleid, tag_id)
VALUES
('Hyde Park', 'park', 'A major park in central London.', 51.507268, -0.165730, 4.7, 'London W2 2UH, UK', ARRAY['https://upload.wikimedia.org/wikipedia/commons/thumb/7/7d/Hyde_Park_from_air.jpg/640px-Hyde_Park_from_air.jpg'], 'PLACE_ID_1', 3);




INSERT INTO User_Recommendations (recommender_user_id, recommended_user_id, place_id, message)
VALUES
(1, 2, 1, 'You should check out Central Park, it is beautiful!'),
(2, 3, 1, 'Hyde Park is great for a relaxing day out.');




-- Insert environmental reminders based on tags
INSERT INTO Environmental_Reminders (tag_id, reminder_text) VALUES
-- Woodlands (ID 1)
(1, 'Stay on designated trails to protect the environment.'),
(1, 'Carry out all trash to keep the trails clean.'),
(1, 'Wear appropriate footwear to prevent injury.'),
(1, 'Respect wildlife by observing from a distance.'),
(1, 'Take plenty of water to stay hydrated.'),
(1, 'Use sunscreen to protect yourself from the sun.'),
-- Hiking (ID 2)
(2, 'Follow trail markers to avoid getting lost.'),
(2, 'Avoid picking plants or disturbing wildlife.'),
(2, 'Be aware of changing weather conditions.'),
(2, 'Inform someone of your hiking plans.'),
(2, 'Stay on marked trails to minimize impact on the environment.'),
(2, 'Carry a map and compass as a backup navigation tool.'),
-- Park (ID 3)
(3, 'Keep parks clean by using provided trash bins.'),
(3, 'Do not feed or disturb wildlife.'),
(3, 'Keep noise levels low to respect others.'),
(3, 'Follow park rules and regulations.'),
(3, 'Use designated paths and avoid trampling vegetation.'),
(3, 'Avoid littering and pick up after your pets.'),
-- Garden (ID 4)
(4, 'Water plants early in the morning to reduce evaporation.'),
(4, 'Use organic fertilizers to protect soil health.'),
(4, 'Avoid using harmful pesticides.'),
(4, 'Practice composting to reduce waste.'),
(4, 'Mulch garden beds to retain moisture and reduce weeds.'),
(4, 'Plant native species to support local wildlife.'),
-- Historic (ID 5)
(5, 'Respect historical sites and do not touch artifacts.'),
(5, 'Follow guided tours and stay on marked paths.'),
(5, 'Take photographs without using flash.'),
(5, 'Support preservation efforts through donations.'),
(5, 'Abide by site-specific regulations to protect the integrity of the location.'),
(5, 'Avoid climbing on or leaning against historical structures.'),
-- Beach (ID 6)
(6, 'Dispose of trash properly to prevent pollution.'),
(6, 'Avoid disturbing nesting birds and marine life.'),
(6, 'Use reef-safe sunscreen to protect marine ecosystems.'),
(6, 'Follow local beach regulations and guidelines.'),
(6, 'Respect beach access rules and parking regulations.'),
(6, 'Participate in beach clean-ups to help maintain cleanliness.'),
-- Camping (ID 7)
(7, 'Follow Leave No Trace principles to minimize impact.'),
(7, 'Use established campsites to avoid damaging vegetation.'),
(7, 'Store food securely to prevent wildlife encounters.'),
(7, 'Campfires should be properly extinguished and contained.'),
(7, 'Respect quiet hours in campgrounds to avoid disturbing others.'),
(7, 'Follow local fire regulations and guidelines.'),
-- Wildlife (ID 8)
(8, 'Observe wildlife from a safe distance.'),
(8, 'Do not feed or approach wild animals.'),
(8, 'Respect wildlife habitats and follow local regulations.'),
(8, 'Report any injured or distressed wildlife to authorities.'),
(8, 'Avoid making loud noises that could scare wildlife.'),
(8, 'Educate yourself about local wildlife and their behaviors.'),
-- Farm (ID 9)
(9, 'Support sustainable farming practices.'),
(9, 'Buy local produce to reduce carbon footprint.'),
(9, 'Respect farm property and follow visitor guidelines.'),
(9, 'Learn about and support organic farming methods.'),
(9, 'Avoid trampling or damaging crops during farm visits.'),
(9, 'Dispose of waste properly and recycle when possible.'),
-- Rivers (ID 10)
(10, 'Avoid polluting river waters with waste.'),
(10, 'Respect wildlife habitats along the river.'),
(10, 'Follow local regulations regarding river activities.'),
(10, 'Participate in river clean-up efforts if possible.'),
(10, 'Avoid disturbing riverbanks and riparian vegetation.'),
(10, 'Use biodegradable soaps and detergents when washing near rivers.');

