-- Drop existing tables if they exist
DROP TABLE IF EXISTS GreenPlace_Tags CASCADE;          -- Dependent on Green_Places and Tags
DROP TABLE IF EXISTS Tags CASCADE;                     -- Standalone table
DROP TABLE IF EXISTS Interesting_Facts CASCADE;        -- Dependent on Green_Places
DROP TABLE IF EXISTS Activities CASCADE;               -- Dependent on Green_Places
DROP TABLE IF EXISTS Weather_Info CASCADE;             -- Dependent on Green_Places
DROP TABLE IF EXISTS User_Interactions CASCADE;        -- Dependent on Users
DROP TABLE IF EXISTS Environmental_Reminders CASCADE;  -- Dependent on Green_Places
DROP TABLE IF EXISTS User_Recommendations CASCADE;     -- Dependent on Users and Green_Places
DROP TABLE IF EXISTS Saved_Journeys CASCADE;           -- Dependent on Users
DROP TABLE IF EXISTS Users_Profile CASCADE;            -- Dependent on Users and Green_Places
DROP TABLE IF EXISTS Green_Places CASCADE;             -- Dependent on nothing, referenced by many
DROP TABLE IF EXISTS Users CASCADE;                    -- Dependent on nothing, referenced by many

-- Create the Users table to store user information
CREATE TABLE IF NOT EXISTS Users (
    user_id SERIAL PRIMARY KEY,            -- Unique identifier for each user (auto-incremented)
    username VARCHAR(100) UNIQUE NOT NULL, -- Unique username for each user
    email VARCHAR(100) UNIQUE NOT NULL,    -- User's email address
    password_hash VARCHAR(255) NOT NULL,   -- Secure hash of the user's password
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- Timestamp of when the user account was created
);

-- Insert dummy data into Users table
INSERT INTO Users (username, email, password_hash) VALUES
('john_doe', 'john-doe@example.com', '$2b$12$8RmTIuexL8qPRA8tht6V0e'),
('jane_smith', 'jane_smith@example.com', '$2b$12$ZVmNHg1w3J8HFoMHZmtIvK'),
('alice_wonder', 'alice@example.com', '$2b$12$5Le5eP9mK9BhxMPl/EbIyO');

-- Create the Users_Profile table to store user preferences and visited spots
CREATE TABLE IF NOT EXISTS Users_Profile (
    user_id INT REFERENCES Users(user_id),   -- Foreign key referencing Users table
    preferences JSONB,                       -- JSON object to store user preferences (e.g., preferred activities, weather conditions)
    visited_spots_id INT REFERENCES Green_Places(place_id)  -- Foreign key referencing Green_Places table for visited spots
);

-- Insert dummy data into Users_Profile table
INSERT INTO Users_Profile (user_id, preferences, visited_spots_id) VALUES 
(1, '{"preferred_activities": ["hiking", "picnicking"], "weather_conditions": ["sunny"]}', 1),
(2, '{"preferred_activities": ["cycling", "bird watching"], "weather_conditions": ["overcast"]}', 2),
(3, '{"preferred_activities": ["running", "photography"], "weather_conditions": ["clear"]}', 3);

-- Create the Green_Places table to store information about green spaces
CREATE TABLE IF NOT EXISTS Green_Places (
    place_id SERIAL PRIMARY KEY,             -- Unique identifier for each green place (auto-incremented)
    name VARCHAR(100) UNIQUE NOT NULL,       -- Name of the green space
    description VARCHAR(255),                -- Description of the green space
    location_type VARCHAR(50),               -- Type of location (e.g., 'park', 'trail', 'beach', etc.)
    latitude FLOAT NOT NULL,                 -- Latitude for the green space's location
    longitude FLOAT NOT NULL,                -- Longitude for the green space's location
    rating FLOAT CHECK (rating >= 0 AND rating <= 5),  -- Average user rating (0-5 scale)
    address VARCHAR(255),                    -- Full address of the green space
    phone_number VARCHAR(20),                -- Contact number for the green space, if available
    website_url VARCHAR(255),                -- Website URL for the green space, if available
    image_url VARCHAR(255),                  -- URL to an image of the green space
    open_now BOOLEAN,                        -- Indicates if the green space is currently open
    opening_hours JSONB                      -- JSON object storing the opening hours for each day of the week
);

-- Insert dummy data into Green_Places table
INSERT INTO Green_Places (name, description, location_type, latitude, longitude, rating, address, phone_number, website_url, image_url, open_now)
VALUES
('Central Park', 'A large public park in New York City.', 'park', 40.785091, -73.968285, 4.8, 'New York, NY 10024', '(212) 310-6600', 'http://www.centralparknyc.org/', 'https://example.com/central_park.jpg', TRUE),
('Hyde Park', 'A major park in central London.', 'park', 51.507268, -0.165730, 4.7, 'London W2 2UH, UK', '+44 20 7298 2100', 'https://www.royalparks.org.uk/parks/hyde-park', 'https://example.com/hyde_park.jpg', TRUE);

-- Create the Weather_Info table to store weather data associated with green spaces
CREATE TABLE IF NOT EXISTS Weather_Info (
    weather_id SERIAL PRIMARY KEY,           -- Unique identifier for each weather record (auto-incremented)
    place_id INT REFERENCES Green_Places(place_id),  -- Foreign key referencing Green_Places table
    weather_condition VARCHAR(50),           -- Description of the weather condition (e.g., 'Sunny', 'Rainy')
    temperature FLOAT,                       -- Temperature at the green space
    weather_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP  -- Timestamp of when the weather data was recorded
);

-- Insert dummy data into Weather_Info table
INSERT INTO Weather_Info (place_id, weather_condition, temperature)
VALUES
(1, 'Sunny', 25.0),
(2, 'Cloudy', 18.0);

-- Create the Activities table to store information about activities available at green spaces
CREATE TABLE IF NOT EXISTS Activities (
    activity_id SERIAL PRIMARY KEY,          -- Unique identifier for each activity (auto-incremented)
    place_id INT REFERENCES Green_Places(place_id),  -- Foreign key referencing Green_Places table
    activity_name VARCHAR(100) NOT NULL,     -- Name of the activity (e.g., 'Hiking', 'Picnic')
    description TEXT                         -- Description of the activity
);

-- Insert dummy data into Activities table
INSERT INTO Activities (place_id, activity_name, description)
VALUES
(1, 'Hiking', 'Enjoy a scenic hike through the park.'),
(2, 'Boating', 'Rent a boat and enjoy the lake.');

-- Create the Interesting_Facts table for AI-generated content about green spaces
CREATE TABLE IF NOT EXISTS Interesting_Facts (
    fact_id SERIAL PRIMARY KEY,              -- Unique identifier for each fact (auto-incremented)
    place_id INT REFERENCES Green_Places(place_id),  -- Foreign key referencing Green_Places table
    fact TEXT NOT NULL,                      -- Interesting fact about the green place
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP  -- Timestamp of when the fact was created
);

-- Insert dummy data into Interesting_Facts table
INSERT INTO Interesting_Facts (place_id, fact)
VALUES
(1, 'Central Park is larger than the principality of Monaco.'),
(2, 'Hyde Park was originally established by Henry VIII in 1536.');

-- Tags table for filtering green spaces by categories or features
CREATE TABLE IF NOT EXISTS Tags (
    tag_id SERIAL PRIMARY KEY,               -- Unique identifier for each tag (auto-incremented)
    tag_name VARCHAR(50) UNIQUE NOT NULL     -- Name of the tag (e.g., 'forest', 'playground', 'waterfront')
);

-- Insert dummy data into Tags table
INSERT INTO Tags (tag_name)
VALUES
('forest'),
('playground'),
('waterfront');

-- Linking tags to green spaces for filtering purposes
CREATE TABLE IF NOT EXISTS GreenPlace_Tags (
    place_id INT REFERENCES Green_Places(place_id),  -- Foreign key referencing Green_Places table
    tag_id INT REFERENCES Tags(tag_id),              -- Foreign key referencing Tags table
    PRIMARY KEY (place_id, tag_id)                   -- Composite primary key to ensure a unique tag for each place
);

-- Insert dummy data into GreenPlace_Tags table
INSERT INTO GreenPlace_Tags (place_id, tag_id)
VALUES
(1, 2),  -- Central Park has a playground
(2, 3);  -- Hyde Park is a waterfront park

-- Table for saving user journeys to revisit their planned trips
CREATE TABLE IF NOT EXISTS Saved_Journeys (
    journey_id SERIAL PRIMARY KEY,           -- Unique identifier for each saved journey (auto-incremented)
    user_id INT REFERENCES Users(user_id),   -- Foreign key referencing Users table
    journey_name VARCHAR(100),               -- User-defined name for the journey
    journey_details JSONB,                   -- JSON object storing details about the journey (e.g., places, activities)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP  -- Timestamp of when the journey was saved
);

-- Insert dummy data into Saved_Journeys table
INSERT INTO Saved_Journeys (user_id, journey_name, journey_details)
VALUES
(1, 'Weekend Getaway', '{"places": ["Central Park", "Hyde Park"], "activities": ["Hiking", "Boating"]}');

-- Table for storing user recommendations of green spaces to other users
CREATE TABLE IF NOT EXISTS User_Recommendations (
    recommendation_id SERIAL PRIMARY KEY,            -- Unique identifier for each recommendation (auto-incremented)
    recommender_user_id INT REFERENCES Users(user_id),  -- Foreign key referencing Users table for the recommender
    recommended_user_id INT REFERENCES Users(user_id),  -- Foreign key referencing Users table for the recommended user
    place_id INT REFERENCES Green_Places(place_id),   -- Foreign key referencing Green_Places table
    message TEXT,                                     -- Optional message included with the recommendation
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP    -- Timestamp of when the recommendation was made
);

-- Insert dummy data into User_Recommendations table
INSERT INTO User_Recommendations (recommender_user_id, recommended_user_id, place_id, message)
VALUES
(1, 2, 1, "You should check out Central Park, it's beautiful!"),
(2, 3, 2, "Hyde Park is great for a relaxing day out.");


-- Table for storing environmental reminders related to specific green spaces
CREATE TABLE IF NOT EXISTS Environmental_Reminders (
    reminder_id SERIAL PRIMARY KEY,               -- Unique identifier for each reminder (auto-incremented)
    place_id INT REFERENCES Green_Places(place_id),  -- Foreign key referencing Green_Places table
    reminder_text TEXT NOT NULL,                  -- Text of the reminder (e.g., "Don’t forget to bring reusable water bottles")
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP  -- Timestamp of when the reminder was created
);

-- Insert dummy data into Environmental_Reminders table
INSERT INTO Environmental_Reminders (place_id, reminder_text)
VALUES
(1, 'Please do not litter.'),
(2, 'Respect the wildlife. No feeding animals.');
