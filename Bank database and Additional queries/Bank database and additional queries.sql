create database LAB_PROGRAM_Bank_1BM23CS092_DHRUVA_S_RAO;
USE LAB_PROGRAM_Bank_1BM23CS092_DHRUVA_S_RAO;
CREATE TABLE Branch (
    branch_name VARCHAR(100) PRIMARY KEY,
    branch_city VARCHAR(100),
    assets REAL
);

CREATE TABLE BankAccount (
    accno INT PRIMARY KEY,
    branch_name VARCHAR(100),
    balance REAL,
    FOREIGN KEY (branch_name) REFERENCES Branch(branch_name)
);

CREATE TABLE BankCustomer (
    customer_name VARCHAR(100),
    customer_street VARCHAR(100),
    customer_city VARCHAR(100),
    PRIMARY KEY (customer_name, customer_street, customer_city)
);

CREATE TABLE Depositer (
    customer_name VARCHAR(100),
    accno INT,
    PRIMARY KEY (customer_name, accno),
    FOREIGN KEY (accno) REFERENCES BankAccount(accno)
);

CREATE TABLE Loan (
    loan_number INT PRIMARY KEY,
    branch_name VARCHAR(100),
    amount REAL,
    FOREIGN KEY (branch_name) REFERENCES Branch(branch_name)
);

INSERT INTO Branch VALUES
('sbi_bsk', 'blore', 50000),
('sbi_jayanagar', 'blore', 10000),
('sbi_shivaji', 'bombay', 20000),
('sbi_parliment', 'delhi', 10000),
('sbi_jantar', 'delhi', 20000);

INSERT INTO BankAccount VALUES
(1, 'sbi_bsk', 2000),
(2, 'sbi_jayanagar', 5000),
(3, 'sbi_shivaji', 6000),
(4, 'sbi_parliment', 9000),
(5, 'sbi_jantar', 8000),
(6, 'sbi_shivaji', 4000),
(7, 'sbi_jayanagar', 3000);  

INSERT INTO Depositer VALUES
('avinash', 1),
('dinesh', 2),
('nikil', 4),
('ravi', 5),
('priya', 3);

insert into BankCustomer VALUES
('avinash','bull_temple','blore'),
('dinesh','bannerghatta','blore'),
('mohan','hsr','blore'),
('nikil','btm','blore'),
('ravi','akbar','delhi');


insert into Loan values
(1,'sbi_bsk',1000),
(2,'sbi_jayanagar',2000),
(3,'sbi_shivaji',3000),
(4,'sbi_parliment',5000),
(5,'sbi_jantar',4000);


SELECT branch_name, assets / 100000 AS "assets in lakhs" 
FROM Branch;

SELECT d.customer_name, a.branch_name, COUNT(a.accno) AS account_count
FROM Depositer d
INNER JOIN BankAccount a ON d.accno = a.accno
GROUP BY d.customer_name, a.branch_name
HAVING COUNT(a.accno) >= 2;

CREATE VIEW BranchLoanSum AS
SELECT branch_name, SUM(amount) AS total_loans
FROM LOAN
GROUP BY branch_name;

SELECT *
FROM BranchLoanSum;

SELECT 
	branch_name, 
    assets
FROM Branch;

SELECT 
	customer_name, 
	customer_street, 
    customer_city
FROM BankCustomer
WHERE customer_city = 'blore';


SELECT 
	bc.customer_name, 
    d.accno
FROM BankCustomer bc
LEFT JOIN Depositer d 
	ON bc.customer_name = d.customer_name;
    
SELECT bc.customer_name, l.amount
FROM BankCustomer bc
LEFT JOIN Depositer d ON bc.customer_name = d.customer_name
LEFT JOIN Loan l ON d.accno = l.loan_number;

SELECT bc.customer_name
FROM BankCustomer bc
JOIN Depositer d ON bc.customer_name = d.customer_name
JOIN BankAccount ba ON d.accno = ba.accno
WHERE ba.branch_name IN (SELECT branch_name FROM Branch WHERE branch_city = 'Delhi')
GROUP BY bc.customer_name
HAVING COUNT(DISTINCT ba.branch_name) = (SELECT COUNT(*) FROM Branch WHERE branch_city = 'Delhi');
    
SELECT bc.customer_name, ba.accno, ba.balance
FROM BankCustomer bc
INNER JOIN Depositer d ON bc.customer_name = d.customer_name
INNER JOIN BankAccount ba ON d.accno = ba.accno
WHERE ba.balance > 100000;

SELECT DISTINCT bc.customer_name, ba.branch_name
FROM BankCustomer bc
INNER JOIN Depositer d ON bc.customer_name = d.customer_name
INNER JOIN BankAccount ba ON d.accno = ba.accno
INNER JOIN Loan l ON ba.branch_name = l.branch_name
WHERE l.loan_number IN (SELECT loan_number FROM Loan WHERE branch_name = ba.branch_name);

SELECT ba.branch_name, COUNT(ba.accno) AS account_count
FROM BankAccount ba
GROUP BY ba.branch_name;
    
SELECT b.branch_name
FROM Branch b
LEFT JOIN Loan l ON b.branch_name = l.branch_name
WHERE l.loan_number IS NULL;

SELECT branch_name, SUM(amount) AS total_loan_amount
FROM Loan
GROUP BY 
	branch_name
ORDER BY 
	total_loan_amount ASC
LIMIT 1;





























