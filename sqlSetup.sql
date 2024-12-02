--source C:\Users\gavin\Desktop\cop4710\sqlSetup.sql

CREATE DATABASE real_estate_3;
-- Use the specific database
USE real_estate_3;

-- Drop tables if they exist to avoid duplicate creation errors
DROP TABLE IF EXISTS Works_With;
DROP TABLE IF EXISTS Listings;
DROP TABLE IF EXISTS Buyer;
DROP TABLE IF EXISTS Agent;
DROP TABLE IF EXISTS Firm;
DROP TABLE IF EXISTS BusinessProperty;
DROP TABLE IF EXISTS House;
DROP TABLE IF EXISTS Property;

-- Create Firm table first
CREATE TABLE Firm (
    id INTEGER PRIMARY KEY,
    name VARCHAR(30),
    address VARCHAR(50)
);

-- Create Agent table next
CREATE TABLE Agent (
    agentId INTEGER PRIMARY KEY,
    name VARCHAR(30),
    phone CHAR(12),
    firmId INTEGER NOT NULL, -- An agent must work for exactly one firm
    dateStarted DATE,
    FOREIGN KEY (firmId) REFERENCES Firm(id) ON DELETE CASCADE
);

-- Create Property table after Agent (it references Agent)
CREATE TABLE Property (
    address VARCHAR(50) PRIMARY KEY,
    ownerName VARCHAR(30),
    price INTEGER,
    listedByAgentId INTEGER, -- A property can be listed by one agent
    FOREIGN KEY (listedByAgentId) REFERENCES Agent(agentId) ON DELETE SET NULL
);

-- Create House table (it references Property)
CREATE TABLE House (
    bedrooms INTEGER,
    bathrooms INTEGER,
    size INTEGER,
    address VARCHAR(50) PRIMARY KEY,
    FOREIGN KEY (address) REFERENCES Property(address) ON DELETE CASCADE
);

-- Create BusinessProperty table (it references Property)
CREATE TABLE BusinessProperty (
    type CHAR(20),
    size INTEGER,
    address VARCHAR(50) PRIMARY KEY,
    FOREIGN KEY (address) REFERENCES Property(address) ON DELETE CASCADE
);

-- Create Listings table (it references Property and Agent)
CREATE TABLE Listings (
    mlsNumber INTEGER PRIMARY KEY, -- A listing is identified by its MLS number
    address VARCHAR(50),
    agentId INTEGER,
    dateListed DATE,
    FOREIGN KEY (address) REFERENCES Property(address) ON DELETE CASCADE,
    FOREIGN KEY (agentId) REFERENCES Agent(agentId) ON DELETE SET NULL
);

-- Create Buyer table
CREATE TABLE Buyer (
    id INTEGER PRIMARY KEY,
    name VARCHAR(30),
    phone CHAR(12),
    propertyType CHAR(20),
    bedrooms INTEGER,
    bathrooms INTEGER,
    businessPropertyType CHAR(20),
    minimumPreferredPrice INTEGER,
    maximumPreferredPrice INTEGER
);

-- Create Works_With table
CREATE TABLE Works_With (
    buyerId INTEGER,
    agentId INTEGER,
    PRIMARY KEY (buyerId, agentId),
    FOREIGN KEY (buyerId) REFERENCES Buyer(id) ON DELETE CASCADE,
    FOREIGN KEY (agentId) REFERENCES Agent(agentId) ON DELETE CASCADE
);


INSERT INTO Firm (id, name, address) VALUES
(1, 'Realty Group', '100 Market St'),
(2, 'Acme Real Estate', '200 Elm St');

INSERT INTO Agent (agentId, name, phone, firmId, dateStarted) VALUES
(1, 'Alice Brown', '555-1234', 1, '2020-01-01'),
(2, 'Bob White', '555-5678', 2, '2019-05-15');

INSERT INTO Property (address, ownerName, price, listedByAgentId) VALUES
('101 Cherry Ln', 'Sarah Williams', 220000, 1),
('202 Birch Rd', 'Tom Harris', 180000, 2),
('303 Maple St', 'Emily Clark', 275000, 1),
('404 Cedar Ave', 'Oliver Johnson', 350000, NULL),
('123 Main St', 'John Doe', 250000, 1),
('456 Oak Ave', 'Jane Smith', 300000, NULL),
('789 Pine Rd', 'Acme Corp', 500000, 2),
('505 Walnut Dr', 'Jessica Allen', 220000, 1);

INSERT INTO House (bedrooms, bathrooms, size, address) VALUES
(3, 2, 1500, '123 Main St'),
(3, 2, 1600, '101 Cherry Ln'),
(3, 2, 1800, '303 Maple St'),
(4, 3, 2000, '456 Oak Ave');

INSERT INTO BusinessProperty (type, size, address) VALUES
('Office', 5000, '789 Pine Rd'),
('Office', 8000, '404 Cedar Ave'),
('Office', 12000, '505 Walnut Dr'),
('Retail', 5000, '101 Cherry Ln');

INSERT INTO Listings (mlsNumber, address, agentId, dateListed) VALUES
(1001, '123 Main St', 1, '2024-11-30'),
(1002, '789 Pine Rd', 2, '2024-10-15'),
(1003, '101 Cherry Ln', 1, '2024-11-10'),
(1004, '303 Maple St', 1, '2024-11-05'),
(1005, '505 Walnut Dr', 2, '2024-11-01');

INSERT INTO Buyer (id, name, phone, propertyType, bedrooms, bathrooms, businessPropertyType, minimumPreferredPrice, maximumPreferredPrice) VALUES
(1, 'Charlie Green', '555-9876', 'House', 3, 2, NULL, 200000, 300000),
(2, 'Dana Blue', '555-6543', 'Business', NULL, NULL, 'Office', 400000, 600000),
(3, 'Frank Black', '555-1122', 'House', 3, 2, NULL, 150000, 250000),
(4, 'Grace Pink', '555-3344', 'Business', NULL, NULL, 'Office', 350000, 500000),
(5, 'Hank Red', '555-5566', 'House', 3, 2, NULL, 200000, 350000);

INSERT INTO Works_With (buyerId, agentId) VALUES
(1, 1),
(2, 2),
(3, 1),
(4, 2),
(5, 1);
