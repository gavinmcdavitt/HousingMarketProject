-- 1. Select all houses
SELECT * FROM House;

-- 2. Select addresses of houses that are listed by an agent
SELECT p.address FROM House h JOIN Property p ON h.address = p.address WHERE p.listedByAgentId IS NOT NULL;

-- 3. Select addresses of houses with 3 bedrooms and 2 bathrooms
SELECT address FROM House WHERE bedrooms = 3 AND bathrooms = 2;

-- 4. Select addresses and prices of houses with 3 bedrooms, 2 bathrooms, and prices between $100,000 and $250,000, ordered by price in descending order
SELECT p.address, p.price FROM House h JOIN Property p ON h.address = p.address WHERE h.bedrooms = 3 AND h.bathrooms = 2 AND p.price BETWEEN 100000 AND 250000 ORDER BY p.price DESC;

-- 5. Select addresses and prices of business properties that are office type, ordered by price in descending order
SELECT p.address, p.price FROM BusinessProperty bp JOIN Property p ON bp.address = p.address WHERE bp.type = 'Office' ORDER BY p.price DESC;

-- 6. Select agent details along with their firm details
SELECT a.agentId, a.name, a.phone, f.name AS firmName, a.dateStarted AS Started FROM Agent a JOIN Firm f ON a.firmId = f.id;

-- 7. Select addresses of properties listed by agent with id 1
SELECT p.address FROM Property p WHERE p.listedByAgentId = 1;

-- 8. Select pairs of agent and buyer names, ordered alphabetically by agent name
SELECT a.name AS agentName, b.name AS buyerName FROM Works_With ww JOIN Agent a ON ww.agentId = a.agentId JOIN Buyer b ON ww.buyerId = b.id ORDER BY a.name, b.name;

-- 9. Select agent ids and the total number of buyers working with each agent
SELECT a.agentId, COUNT(ww.buyerId) AS totalBuyers FROM Agent a LEFT JOIN Works_With ww ON a.agentId = ww.agentId GROUP BY a.agentId;

-- 10. Select addresses and prices of houses that meet a buyer's preferences (replace 1 with actual buyer id)
SELECT p.address, p.price FROM House h JOIN Property p ON h.address = p.address WHERE h.bedrooms = (SELECT b.bedrooms FROM Buyer b WHERE b.id = 1) 
AND h.bathrooms = (SELECT b.bathrooms FROM Buyer b WHERE b.id = 1) 
AND p.price BETWEEN (SELECT b.minimumPreferredPrice FROM Buyer b WHERE b.id = 1) 
AND (SELECT b.maximumPreferredPrice FROM Buyer b WHERE b.id = 1) 
ORDER BY p.price DESC;
