CREATE TABLE Supplier (
    sid INT PRIMARY KEY,
    sname VARCHAR(50),
    city VARCHAR(50)
);

CREATE TABLE Parts (
    pid INT PRIMARY KEY,
    pname VARCHAR(50),
    color VARCHAR(20)
);

CREATE TABLE Catalog (
    sid INT,
    pid INT,
    cost DECIMAL(10, 2),
    PRIMARY KEY (sid, pid),
    FOREIGN KEY (sid) REFERENCES Supplier(sid),
    FOREIGN KEY (pid) REFERENCES Parts(pid)
);

INSERT INTO Supplier (sid, sname, city) VALUES (1, 'Acme Widget Suppliers', 'New York');
INSERT INTO Supplier (sid, sname, city) VALUES (2, 'Global Parts Co.', 'San Francisco');

INSERT INTO Parts (pid, pname, color) VALUES (101, 'Widget A', 'Red');
INSERT INTO Parts (pid, pname, color) VALUES (102, 'Widget B', 'Blue');

INSERT INTO Catalog (sid, pid, cost) VALUES (1, 101, 50.00);
INSERT INTO Catalog (sid, pid, cost) VALUES (2, 101, 55.00);
INSERT INTO Catalog (sid, pid, cost) VALUES (2, 102, 60.00);

SELECT DISTINCT p.pname
FROM Parts p
JOIN Catalog c ON p.pid = c.pid;
SELECT s.sname
FROM Supplier s
WHERE NOT EXISTS (
    SELECT p.pid
    FROM Parts p
    WHERE NOT EXISTS (
        SELECT c.sid
        FROM Catalog c
        WHERE c.pid = p.pid AND c.sid = s.sid
    )
);
SELECT s.sname
FROM Supplier s
WHERE NOT EXISTS (
    SELECT p.pid
    FROM Parts p
    WHERE p.color = 'Red' AND NOT EXISTS (
        SELECT c.sid
        FROM Catalog c
        WHERE c.pid = p.pid AND c.sid = s.sid
    )
);
SELECT p.pname
FROM Parts p
JOIN Catalog c ON p.pid = c.pid
JOIN Supplier s ON s.sid = c.sid
WHERE s.sname = 'Acme Widget Suppliers'
AND p.pid NOT IN (
    SELECT c1.pid
    FROM Catalog c1
    JOIN Supplier s1 ON c1.sid = s1.sid
    WHERE s1.sname != 'Acme Widget Suppliers'
);
SELECT DISTINCT c.sid
FROM Catalog c
JOIN (
    SELECT pid, AVG(cost) AS avg_cost
    FROM Catalog
    GROUP BY pid
) avg_costs ON c.pid = avg_costs.pid
WHERE c.cost > avg_costs.avg_cost;
SELECT p.pname, s.sname
FROM Parts p
JOIN Catalog c ON p.pid = c.pid
JOIN Supplier s ON c.sid = s.sid
WHERE c.cost = (
    SELECT MAX(c1.cost)
    FROM Catalog c1
    WHERE c1.pid = p.pid
);