-- Drop existing tables if they exist
DROP TABLE IF EXISTS Tags CASCADE;                     -- Standalone table
DROP TABLE IF EXISTS Interesting_Facts CASCADE;        -- Dependent on Green_Places
DROP TABLE IF EXISTS Activities CASCADE;               -- Dependent on Green_Places
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

-- Create the Green_Places table to store information about green spaces
CREATE TABLE IF NOT EXISTS Green_Places (
    place_id SERIAL PRIMARY KEY,             -- Unique identifier for each green place (auto-incremented)
    name VARCHAR(100) UNIQUE NOT NULL,       -- Name of the green space
    location_type VARCHAR(50),           -- Type of location (e.g., 'park', 'trail', 'beach', etc.)
    description VARCHAR(255),                -- Description of the green space
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

-- Insert dummy data into Green_Places table for locations in London 
INSERT INTO Green_Places (name, location_type, description, latitude, longitude, rating, address, phone_number, website_url, image_url, open_now, opening_hours)
VALUES
('Hyde Park', 'park', 'A major park in central London.', 51.507268, -0.165730, 4.7, 'London W2 2UH, UK', '+44 20 7298 2100', 'https://www.royalparks.org.uk/parks/hyde-park', 'https://upload.wikimedia.org/wikipedia/commons/8/8c/Hyde_Park%2C_London_-_March_2008.jpg', TRUE, '{"monday": "05:00-00:00", "tuesday": "05:00-00:00"}'),
('Regent Park', 'park', 'A large park in central London, north of Marylebone Road.', 51.531270, -0.156969, 4.6, 'London NW1 4NR, UK', '+44 20 7486 7905', 'https://www.royalparks.org.uk/parks/the-regents-park', 'https://upload.wikimedia.org/wikipedia/commons/7/73/Regents_Park.jpg', TRUE, '{"monday": "05:00-00:00", "tuesday": "05:00-00:00"}'),
('Hampstead Heath', 'woodlands', 'A large, ancient London park, covering 320 hectares.', 51.556667, -0.178444, 4.8, 'London NW3 7JR, UK', '+44 20 7332 3322', 'https://www.cityoflondon.gov.uk/things-to-do/green-spaces/hampstead-heath', 'https://upload.wikimedia.org/wikipedia/commons/d/d5/Hampstead_Heath.jpg', TRUE, '{"monday": "06:00-22:00", "tuesday": "06:00-22:00"}'),
('Richmond Park', 'woodlands', 'A national nature reserve in southwest London.', 51.442623, -0.273960, 4.8, 'Richmond, London TW10 5HS, UK', '+44 20 8948 3209', 'https://www.royalparks.org.uk/parks/richmond-park', 'https://upload.wikimedia.org/wikipedia/commons/e/ec/Richmond_Park.jpg', TRUE, '{"monday": "07:00-20:00", "tuesday": "07:00-20:00"}'),
('Greenwich Park', 'openspaces', 'One of the largest green spaces in southeast London.', 51.476918, 0.000461, 4.7, 'London SE10 8QY, UK', '+44 20 8858 2608', 'https://www.royalparks.org.uk/parks/greenwich-park', 'https://upload.wikimedia.org/wikipedia/commons/8/83/Greenwich_Park_2004.jpg', TRUE, '{"monday": "06:00-21:30", "tuesday": "06:00-21:30"}'),
('Regents Canal', 'rivers', 'A canal across an area just north of central London.', 51.535519, -0.139748, 4.4, 'London NW1 7NT, UK', '+44 20 7482 7082', 'https://www.canalrivertrust.org.uk/', 'https://upload.wikimedia.org/wikipedia/commons/6/6c/Regent%27s_Canal.jpg', TRUE, '{"monday": "06:00-21:00", "tuesday": "06:00-21:00"}'),
('Thames Path', 'trail', 'A National Trail following the River Thames from its source to the sea.', 51.5074, -0.1278, 4.6, 'London, UK', '+44 20 8871 7530', 'https://www.nationaltrail.co.uk/en_GB/trails/thames-path/', 'https://upload.wikimedia.org/wikipedia/commons/3/3a/Thames_Path_near_Richmond.jpg', TRUE, '{"monday": "Open 24 hours", "tuesday": "Open 24 hours"}'),
('Wimbledon Common', 'openspaces', 'A large open space in Wimbledon, southwest London.', 51.4285, -0.2197, 4.5, 'London SW19 4UE, UK', '+44 20 8788 7655', 'https://www.wpcc.org.uk/', 'https://upload.wikimedia.org/wikipedia/commons/2/2d/Wimbledon_Common_Pond.JPG', TRUE, '{"monday": "06:00-21:00", "tuesday": "06:00-21:00"}'),
('Battersea Park', 'park', 'A 200-acre green space at the southern edge of Chelsea.', 51.478111, -0.157499, 4.6, 'London SW11 4NJ, UK', '+44 20 8871 7530', 'https://www.wandsworth.gov.uk/battersea-park/', 'https://upload.wikimedia.org/wikipedia/commons/7/7f/Battersea_Park_Children%27s_Zoo_-_geograph.org.uk_-_2049527.jpg', TRUE, '{"monday": "06:00-23:00", "tuesday": "06:00-23:00"}'),
('Victoria Park', 'openspaces', 'A park in East London that opened in 1845.', 51.536346, -0.043004, 4.7, 'London E9 7HD, UK', '+44 20 8986 7955', 'https://www.towerhamlets.gov.uk/lgnl/leisure_and_culture/parks_and_open_spaces/victoria_park.aspx', 'https://upload.wikimedia.org/wikipedia/commons/8/88/Victoria_Park_Fountain.jpg', TRUE, '{"monday": "07:00-20:00", "tuesday": "07:00-20:00"}'),
('Holland Park', 'woodlands', 'A district and a public park in the Royal Borough of Kensington and Chelsea, in central London.', 51.503582, -0.201596, 4.6, 'London W8 6LU, UK', '+44 20 7361 3003', 'https://www.rbkc.gov.uk/leisure-and-culture/parks/holland-park', 'https://upload.wikimedia.org/wikipedia/commons/2/29/Holland_Park_Sept_2015.jpg', TRUE, '{"monday": "07:30-20:00", "tuesday": "07:30-20:00"}'),
('Bushy Park', 'woodlands', 'The second largest of London''s Royal Parks.', 51.414025, -0.335439, 4.7, 'Hampton Hill TW12 1JX, UK', '+44 20 8979 1586', 'https://www.royalparks.org.uk/parks/bushy-park', 'https://upload.wikimedia.org/wikipedia/commons/e/ea/Bushy_Park_Waterhouse.JPG', TRUE, '{"monday": "06:00-22:30", "tuesday": "06:00-22:30"}'),
('Clapham Common', 'openspaces', 'A large triangular urban park in Clapham, south London.', 51.461280, -0.138065, 4.5, 'London SW4 9DE, UK', '+44 20 7926 6207', 'https://www.lambeth.gov.uk/clapham-common', 'https://upload.wikimedia.org/wikipedia/commons/4/42/Clapham_Common_February_2013.JPG', TRUE, '{"monday": "06:00-21:00", "tuesday": "06:00-21:00"}'),
('Crystal Palace Park', 'openspaces', 'A Victorian pleasure ground in the south London district of Crystal Palace.', 51.420964, -0.071695, 4.6, 'London SE19 2GA, UK', '+44 20 8778 9496', 'https://www.bromley.gov.uk/crystal-palace-park', 'https://upload.wikimedia.org/wikipedia/commons/f/fd/Crystal_Palace_Park_-_London_England.jpg', TRUE, '{"monday": "07:30-21:00", "tuesday": "07:30-21:00"}'),
('Brockwell Park', 'openspaces', 'A large, historic park located between Brixton, Dulwich, and Herne Hill.', 51.4534, -0.1080, 4.6, 'London SE24 9BJ, UK', '+44 20 7926 6207', 'https://www.lambeth.gov.uk/places/brockwell-park', 'https://upload.wikimedia.org/wikipedia/commons/7/71/Brockwell_Park_from_Brixton_Water_Lane.jpg', TRUE, '{"monday": "07:30-21:00", "tuesday": "07:30-21:00"}'),
('Primrose Hill', 'openspaces', 'A hill on the northern side of Regent''s Park offering great views of central London.', 51.5373, -0.1586, 4.7, 'London NW1 4NR, UK', '+44 20 7486 7905', 'https://www.royalparks.org.uk/parks/the-regents-park/primrose-hill', 'https://upload.wikimedia.org/wikipedia/commons/a/ac/View_from_Primrose_Hill.jpg', TRUE, '{"monday": "05:00-00:00", "tuesday": "05:00-00:00"}'),
('Kenwood House', 'woodlands', 'A former stately home on Hampstead Heath, surrounded by landscaped gardens.', 51.5718, -0.1704, 4.8, 'London NW3 7JR, UK', '+44 20 8348 1286', 'https://www.english-heritage.org.uk/visit/places/kenwood/', 'https://upload.wikimedia.org/wikipedia/commons/1/1f/Kenwood_House_London.jpg', TRUE, '{"monday": "08:00-18:00", "tuesday": "08:00-18:00"}'),
('Alexandra Palace Park', 'openspaces', 'A large Victorian park with panoramic views of London.', 51.5942, -0.1307, 4.6, 'London N22 7AY, UK', '+44 20 8365 2121', 'https://www.alexandrapalace.com/our-park/', 'https://upload.wikimedia.org/wikipedia/commons/5/55/Alexandra_Palace_Park_London.jpg', TRUE, '{"monday": "07:00-21:00", "tuesday": "07:00-21:00"}'),
('Kensington Gardens', 'park', 'A royal park in central London, home to Kensington Palace.', 51.5058, -0.1795, 4.7, 'London W2 2UH, UK', '+44 20 7298 2000', 'https://www.royalparks.org.uk/parks/kensington-gardens', 'https://upload.wikimedia.org/wikipedia/commons/3/31/Kensington_Gardens_Serpertine_Lake_London_UK.jpg', TRUE, '{"monday": "06:00-20:00", "tuesday": "06:00-20:00"}'),
('Morden Hall Park', 'openspaces', 'A National Trust park in south London, with wetlands, a river, and historic buildings.', 51.4022, -0.1962, 4.7, 'London SM4 5JD, UK', '+44 20 8545 6850', 'https://www.nationaltrust.org.uk/morden-hall-park', 'https://upload.wikimedia.org/wikipedia/commons/c/c2/Morden_Hall_Park.JPG', TRUE, '{"monday": "08:00-18:00", "tuesday": "08:00-18:00"}'),
('The Serpentine', 'rivers', 'A recreational lake in Hyde Park, popular for boating and swimming.', 51.5054, -0.1657, 4.6, 'London W2 2UH, UK', '+44 20 7706 3422', 'https://www.royalparks.org.uk/parks/hyde-park/things-to-see-and-do/the-serpentine', 'https://upload.wikimedia.org/wikipedia/commons/e/e5/Serpentine_Lake_London.JPG', TRUE, '{"monday": "06:00-20:00", "tuesday": "06:00-20:00"}'),
('Hampstead Pergola and Hill Gardens', 'woodlands', 'A hidden gem with beautiful gardens and a stunning pergola.', 51.5644, -0.1783, 4.9, 'London NW3 7EX, UK', '+44 20 7332 3322', 'https://www.cityoflondon.gov.uk/things-to-do/green-spaces/hampstead-heath/visitor-information/pergola-and-hill-gardens', 'https://upload.wikimedia.org/wikipedia/commons/9/95/Hampstead_Pergola_London.jpg', TRUE, '{"monday": "08:00-18:00", "tuesday": "08:00-18:00"}'),
('Walthamstow Wetlands', 'woodlands', 'Europe''s largest urban wetland nature reserve, offering birdwatching and trails.', 51.5781, -0.0466, 4.7, 'London N17 9NH, UK', '+44 20 3897 6151', 'https://walthamstowwetlands.com/', 'https://upload.wikimedia.org/wikipedia/commons/6/66/Walthamstow_Wetlands_View.jpg', TRUE, '{"monday": "09:30-16:00", "tuesday": "09:30-16:00"}'),
('Holland Park Kyoto Garden', 'woodlands', 'A Japanese-style garden in Holland Park, with a pond and koi fish.', 51.5013, -0.2015, 4.8, 'London W8 6LU, UK', '+44 20 7361 3003', 'https://www.rbkc.gov.uk/leisure-and-culture/parks/holland-park/kyoto-garden', 'https://upload.wikimedia.org/wikipedia/commons/a/a1/Kyoto_Garden_Holland_Park_London.JPG', TRUE, '{"monday": "07:30-20:00", "tuesday": "07:30-20:00"}'),
('The Greenway', 'trail', 'A 7-kilometre path for walking and cycling, offering views of the Olympic Park.', 51.5348, -0.0115, 4.5, 'London E15, UK', '+44 20 3856 3600', 'https://www.tfl.gov.uk/modes/walking/the-greenway', 'https://upload.wikimedia.org/wikipedia/commons/5/5a/The_Greenway_East_London.jpg', TRUE, '{"monday": "Open 24 hours", "tuesday": "Open 24 hours"}'),
('Lea Valley', 'rivers', 'A green corridor following the River Lea, with parks and nature reserves.', 51.5637, -0.0333, 4.6, 'London E5, UK', '+44 300 003 0610', 'https://www.visitleevalley.org.uk/lee-valley-regional-park', 'https://upload.wikimedia.org/wikipedia/commons/c/cc/River_Lea_Near_Hackney_Marshes.jpg', TRUE, '{"monday": "Open 24 hours", "tuesday": "Open 24 hours"}'),
('Ruislip Lido', 'beaches', 'A 60-acre lake with a sandy beach, surrounded by woodland.', 51.5853, -0.4348, 4.6, 'London HA4 7TY, UK', '+44 1895 558191', 'https://www.hillingdon.gov.uk/ruisliplido', 'https://upload.wikimedia.org/wikipedia/commons/3/3c/Ruislip_Lido_-_geograph.org.uk_-_508929.jpg', TRUE, '{"monday": "07:30-20:00", "tuesday": "07:30-20:00"}'),
('Frensham Ponds', 'beaches', 'Two large lakes offering swimming, sailing, and sunbathing.', 51.1568, -0.7947, 4.7, 'Frensham, London GU10 2QB, UK', '+44 1252 792801', 'https://www.nationaltrust.org.uk/frensham-great-pond-and-common', 'https://upload.wikimedia.org/wikipedia/commons/e/eb/Frensham_Great_Pond.jpg', TRUE, '{"monday": "07:00-19:00", "tuesday": "07:00-19:00"}');


-- Create the Users_Profile table to store user preferences and visited spots
CREATE TABLE IF NOT EXISTS Users_Profile (
    user_id INT REFERENCES Users(user_id),   -- Foreign key referencing Users table
    preferences JSONB,                       -- JSON object to store user preferences (e.g., preferred activities, weather conditions)
    visited_spots_id INT REFERENCES Green_Places(place_id)  -- Foreign key referencing Green_Places table for visited spots
);

-- Corrected INSERT statement for Users_Profile table
INSERT INTO Users_Profile (user_id, preferences, visited_spots_id) VALUES 
(1, '{"preferred_activities": ["hiking", "picnicking"]}', 1),
(2, '{"preferred_activities": ["cycling", "bird watching"]}', 2),
(3, '{"preferred_activities": ["running", "photography"]}', 3),
(4, '{"preferred_activities": ["cycling", "picnicking"]}', 4),
(5, '{"preferred_activities": ["bird watching", "hiking"]}', 3),
(6, '{"preferred_activities": ["photography", "walking"]}', 5),
(7, '{"preferred_activities": ["boating", "running"]}', 1),
(8, '{"preferred_activities": ["horse riding", "wildlife watching"]}', 8),
(9, '{"preferred_activities": ["fishing", "picnicking"]}', 10),
(10, '{"preferred_activities": ["art exhibits", "stargazing"]}', 17),
(11, '{"preferred_activities": ["hiking", "bird watching"]}', 12),
(12, '{"preferred_activities": ["cycling", "scenic walks"]}', 6),
(13, '{"preferred_activities": ["kayaking", "swimming"]}', 27);



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
(2, 'Boating', 'Rent a boat and enjoy the lake.'),
(3, 'Wildlife Watching', 'Observe various species of wildlife in their natural habitat at Hampstead Heath.'),
(4, 'Cycling', 'Cycle through the extensive trails in Richmond Park.'),
(5, 'Picnicking', 'Have a relaxing picnic with a view of the River Thames in Greenwich Park.'),
(6, 'Photography', 'Capture the beautiful scenes along the Regents Canal.'),
(7, 'Running', 'Enjoy a run along the scenic Thames Path.'),
(8, 'Bird Watching', 'Wimbledon Common offers a tranquil spot for bird watching.'),
(9, 'Tennis', 'Play a game of tennis at one of Battersea Park courts.'),
(10, 'Fishing', 'Try your hand at fishing in the lakes of Victoria Park.'),
(11, 'Yoga', 'Join an outdoor yoga class in Holland Park.'),
(12, 'Horse Riding', 'Experience horse riding in the open spaces of Bushy Park.'),
(13, 'Outdoor Fitness', 'Take part in outdoor fitness activities on Clapham Common.'),
(14, 'Historical Tour', 'Explore the historical sites of Crystal Palace Park.'),
(15, 'Skating', 'Enjoy roller skating or skateboarding at Brockwell Park.'),
(16, 'Stargazing', 'Head to Primrose Hill for a stargazing evening with a view.'),
(17, 'Art Exhibits', 'Visit the art exhibits and gardens at Kenwood House.'),
(18, 'Kayaking', 'Go kayaking in the Serpentine at Hyde Park.'),
(19, 'Botanical Walk', 'Take a botanical walk through the Kyoto Garden in Holland Park.'),
(20, 'Nature Trails', 'Explore the nature trails at Walthamstow Wetlands.');


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
(1, 'Hyde Park was originally established by Henry VIII in 1536.'),
(2, 'Regent Park was designed by John Nash and opened to the public in 1835.'),
(3, 'Hampstead Heath covers 320 hectares and is one of London oldest parks.'),
(4, 'Richmond Park is the largest of London Royal Parks, encompassing 2,500 acres.'),
(5, 'Greenwich Park offers stunning views of the River Thames and the London skyline.'),
(6, 'Regents Canal was completed in 1820 and runs through some of London most scenic areas.'),
(7, 'Thames Path is a 184-mile long trail that follows the River Thames from its source in the Cotswolds to the Thames Barrier in London.'),
(8, 'Wimbledon Common is home to a variety of wildlife, including the famous Wombles from the childrens TV show.'),
(9, 'Battersea Park was opened in 1858 and was used as a training ground during both World Wars.'),
(10, 'Victoria Park, known as the People Park, was the first public park in London.'),
(11, 'Holland Park is home to the Kyoto Garden, a Japanese garden donated by the Chamber of Commerce of Kyoto in 1991.'),
(12, 'Bushy Park is home to the famous Chestnut Avenue, which was designed by Sir Christopher Wren.'),
(13, 'Clapham Common is one of London largest open spaces and was originally a marshy area.'),
(14, 'Crystal Palace Park is named after the Crystal Palace, a large glass structure that housed the Great Exhibition of 1851.'),
(15, 'Brockwell Park features a historic lido, one of the few remaining in London, which first opened in 1937.'),
(16, 'Primrose Hill offers one of the best views of the London skyline, especially at sunrise or sunset.'),
(17, 'Kenwood House, located on Hampstead Heath, was featured in the movie "Notting Hill".'),
(18, 'Alexandra Palace Park hosts regular events including the famous fireworks display on Bonfire Night.'),
(19, 'Kensington Gardens is home to the Albert Memorial, one of London most ornate monuments.'),
(20, 'Morden Hall Park was once a deer park, and its historic watermills are still visible today.'),
(21, 'The Serpentine in Hyde Park was created in 1730 and was one of the first lakes in England designed specifically for leisure.'),
(22, 'Hampstead Pergola and Hill Gardens were originally built as a private garden for Lord Leverhulme in the early 20th century.'),
(23, 'Walthamstow Wetlands is Europe largest urban wetland reserve, covering 211 hectares.'),
(24, 'Holland Park Kyoto Garden features a koi pond and a waterfall, making it a serene spot in the heart of London.'),
(25, 'The Greenway offers panoramic views of the London Olympic Park and the Lea Valley.'),
(26, 'Lea Valley is a popular spot for bird watching and is home to a variety of migratory birds.'),
(27, 'Ruislip Lido was originally a reservoir created in 1811 and now features a sandy beach and a miniature railway.'),
(28, 'Frensham Ponds were created in the Middle Ages to supply fish to the Bishop of Winchester estate.');


-- Tags table for filtering green spaces by categories or features
CREATE TABLE IF NOT EXISTS Tags (
    gptag_id SERIAL PRIMARY KEY,              -- Unique identifier for each tag (auto-incremented)
    tag_name VARCHAR(50) UNIQUE NOT NULL,   -- Name of the tag (e.g., 'forest', 'playground', 'waterfront')
    place_id INT REFERENCES Green_Places(place_id)  -- Foreign key referencing Green_Places table
);

-- Insert dummy data into Tags table referring to all Green_Places
INSERT INTO Tags (tag_name, place_id)
VALUES
('park', 1),
('boating', 1),
('large', 1),
('central', 2),
('royal', 2),
('family-friendly', 2),
('wildlife', 3),
('hiking', 3),
('cycling', 4),
('nature-reserve', 4),
('deer', 4),
('scenic-views', 5),
('heritage', 5),
('picnicking', 5),
('canal', 6),
('walking', 6),
('photography', 6),
('trail', 7),
('running', 7),
('waterfront', 7),
('woodland', 8),
('bird-watching', 8),
('horse-riding', 8),
('victorian', 9),
('sports', 9),
('playground', 9),
('fishing', 10),
('events', 10),
('japanese-garden', 11),
('botanical', 11),
('art', 11),
('historical', 14),
('lido', 15),
('fitness', 15),
('stargazing', 16),
('lake', 18),
('wetlands', 20),
('urban', 20),
('gardens', 22),
('scenic-walk', 22),
('cultural', 24),
('meditative', 24),
('panoramic-views', 25),
('beach', 26),
('swimming', 27),
('recreation', 27);


-- Table for saving user journeys to revisit their planned trips
CREATE TABLE IF NOT EXISTS Saved_Journeys (
    journey_id SERIAL PRIMARY KEY,           -- Unique identifier for each saved journey (auto-incremented)
    user_id INT REFERENCES Users(user_id),   -- Foreign key referencing Users table
    journey_name VARCHAR(100),               -- User-defined name for the journey
    journey_details JSONB,                   -- JSON object storing details about the journey (e.g., places, activities)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP  -- Timestamp of when the journey was saved
);

-- Insert dummy data into Saved_Journeys table
INSERT INTO Saved_Journeys (user_id, journey_name, journey_details) VALUES
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
(1, 2, 1, 'You should check out Central Park, it is beautiful!'),
(2, 3, 2, 'Hyde Park is great for a relaxing day out.');



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
