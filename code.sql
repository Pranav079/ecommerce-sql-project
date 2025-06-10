CREATE DATABASE ecommerce_db;
USE ecommerce_db;
CREATE TABLE Customers (
    CustomerID VARCHAR(5) PRIMARY KEY,
    CompanyName VARCHAR(100),
    ContactName VARCHAR(100),
    Country VARCHAR(50),
    City VARCHAR(50),
    PostalCode VARCHAR(20),
    Fax VARCHAR(50)
);

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    ReportsTo INT
);

CREATE TABLE Suppliers (
    SupplierID INT PRIMARY KEY,
    CompanyName VARCHAR(100)
);

CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(100)
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    SupplierID INT,
    CategoryID INT,
    Discontinued BIT,
    UnitsInStock INT,
    UnitsOnOrder INT,
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID),
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID VARCHAR(5),
    EmployeeID INT,
    OrderDate DATE,
    ShipCountry VARCHAR(50),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);

CREATE TABLE OrderDetails (
    OrderID INT,
    ProductID INT,
    UnitPrice DECIMAL(10,2),
    Quantity INT,
    Discount DECIMAL(4,2),
    PRIMARY KEY (OrderID, ProductID),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- CUSTOMERS
INSERT INTO Customers VALUES 
('ALFKI', 'Alfreds Futterkiste', 'Maria Anders', 'Germany', 'Berlin', '12209', '030-0076545'),
('BLAUS', 'Blauer See Delikatessen', 'Hanna Moos', 'Germany', 'Mannheim', '68306', NULL),
('BOLID', 'Bólido Comidas preparadas', 'Martín Sommer', 'Spain', 'Madrid', '28023', '91-555 22 82'),
('BOTTM', 'Bottom-Dollar Markets', 'Elizabeth Lincoln', 'Canada', 'London', 'N3A 4J1', NULL),
('FRANK', 'Frankenversand', 'Peter Franken', 'Germany', 'Berlin', '12209', NULL),
('FOLKO', 'Folk och fä HB', 'Maria Larsson', 'Sweden', 'Bräcke', 'S-844 67', '0695-34 67 21'),
('NORTS', 'North/South', 'Simon Crowther', 'UK', 'London', 'WX1 6LT', NULL),
('SAVEA', 'Save-a-lot Markets', 'Jose Pavarotti', 'USA', 'Boise', '83720', NULL),
('QUEEN', 'Queen Co.', 'Alice Newton', 'France', 'Paris', '75000', NULL),
('AROUT', 'Around the Horn', 'Thomas Hardy', 'USA', 'New York', '10001', NULL);

-- EMPLOYEES
INSERT INTO Employees VALUES 
(1, 'Nancy', 'Davolio', NULL),
(2, 'Andrew', 'Fuller', 1),
(3, 'Janet', 'Leverling', 2),
(4, 'Margaret', 'Peacock', 2),
(5, 'Steven', 'Buchanan', 2),
(6, 'Laura', 'Callahan', 2),
(7, 'Michael', 'Suyama', 2),
(8, 'Robert', 'King', 2),
(9, 'Anne', 'Dodsworth', 2);

-- SUPPLIERS
INSERT INTO Suppliers VALUES 
(1, 'Exotic Liquids'),
(2, 'Specialty Biscuits, Ltd.');

-- CATEGORIES
INSERT INTO Categories VALUES 
(1, 'Beverages'),
(2, 'Condiments');

-- PRODUCTS
INSERT INTO Products VALUES 
(1, 'Chai', 1, 1, 0, 39, 0),
(2, 'Chang', 1, 1, 0, 17, 40),
(3, 'Tofu', 1, 2, 0, 10, 20),
(4, 'Aniseed Syrup', 1, 2, 1, 5, 0),
(5, 'Apple Jam', 2, 2, 0, 8, 0),
(6, 'Avocado Oil', 2, 2, 0, 9, 0),
(7, 'Biscuits', 2, 2, 0, 20, 10);

-- ORDERS
INSERT INTO Orders VALUES 
(10100, 'ALFKI', 1, '1996-12-31', 'Germany'),
(10101, 'BOTTM', 2, '1997-01-01', 'Canada'),
(10102, 'NORTS', 3, '1997-02-15', 'UK'),
(10103, 'FRANK', 3, '1997-03-01', 'Germany'),
(10104, 'SAVEA', 4, '1997-04-10', 'USA'),
(10105, 'AROUT', 5, '1997-06-18', 'USA'),
(10106, 'QUEEN', 2, '1997-07-19', 'France');

-- ORDER DETAILS
INSERT INTO OrderDetails VALUES 
(10100, 1, 18.00, 10, 0.0),
(10100, 3, 23.25, 15, 0.0),
(10101, 3, 23.25, 20, 0.0),
(10102, 1, 18.00, 5, 0.0),
(10103, 2, 19.00, 100, 0.0),
(10104, 1, 18.00, 50, 0.0),
(10105, 3, 23.25, 200, 0.0),
(10106, 4, 25.00, 300, 0.0),
(10106, 5, 30.00, 100, 0.0);


SELECT * FROM Customers;
SELECT * FROM Orders;
SELECT * FROM Products;

-- 1. List of all customers
SELECT * FROM Customers; 

-- 2. List of all customers where company name ends with 'N'
SELECT * FROM Customers WHERE CompanyName LIKE '%N';

-- 3. List of all customers who live in Berlin or London
SELECT * FROM Customers WHERE City IN ('Berlin', 'London');

-- 4. List of all customers who live in UK or USA
SELECT * FROM Customers WHERE Country IN ('UK', 'USA');

-- 5. List of all products sorted by product name
SELECT * FROM Products ORDER BY ProductName;

-- 6. List of all products where product name starts with an 'A'
SELECT * FROM Products WHERE ProductName LIKE 'A%';

-- 7. List of customers who ever placed an order
SELECT DISTINCT c.* 
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID;

-- 8. List of customers who live in London and have bought Chai
SELECT DISTINCT c.*
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
WHERE c.City = 'London' AND p.ProductName = 'Chai';

-- 9. List of customers who never placed an order
SELECT * FROM Customers
WHERE CustomerID NOT IN (SELECT DISTINCT CustomerID FROM Orders);

-- 10. List of customers who ordered Tofu
SELECT DISTINCT c.*
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
WHERE p.ProductName = 'Tofu';

-- 11. Details of first order of the system
SELECT * FROM Orders
ORDER BY OrderDate ASC
LIMIT 1;

-- 12. Find the details of the most expensive order date
SELECT o.OrderID, o.OrderDate, SUM(od.UnitPrice * od.Quantity) AS Total
FROM Orders o
JOIN OrderDetails od ON o.OrderID = od.OrderID
GROUP BY o.OrderID
ORDER BY Total DESC
LIMIT 1;

-- 13. For each order, get OrderID and average quantity
SELECT OrderID, AVG(Quantity) AS AvgQuantity
FROM OrderDetails
GROUP BY OrderID;

-- 14. For each order, get OrderID, min quantity, max quantity
SELECT OrderID, MIN(Quantity) AS MinQty, MAX(Quantity) AS MaxQty
FROM OrderDetails
GROUP BY OrderID;

-- 15. Managers and number of employees reporting to them
SELECT e1.EmployeeID AS ManagerID, e1.FirstName AS ManagerFirstName, COUNT(e2.EmployeeID) AS ReportCount
FROM Employees e1
JOIN Employees e2 ON e1.EmployeeID = e2.ReportsTo
GROUP BY e1.EmployeeID, e1.FirstName;

-- 16. Orders with total quantity > 300
SELECT OrderID, SUM(Quantity) AS TotalQuantity
FROM OrderDetails
GROUP BY OrderID
HAVING SUM(Quantity) > 300;

-- 17. Orders placed on or after 1996-12-31
SELECT * FROM Orders
WHERE OrderDate >= '1996-12-31';

-- 18. Orders shipped to Canada
SELECT * FROM Orders
WHERE ShipCountry = 'Canada';

-- 19. Orders with total > 200
SELECT o.OrderID, SUM(od.UnitPrice * od.Quantity) AS Total
FROM Orders o
JOIN OrderDetails od ON o.OrderID = od.OrderID
GROUP BY o.OrderID
HAVING Total > 200;

-- 20. Sales made in each country
SELECT ShipCountry, SUM(od.UnitPrice * od.Quantity) AS Sales
FROM Orders o
JOIN OrderDetails od ON o.OrderID = od.OrderID
GROUP BY ShipCountry;

-- 21. Customer contact name and number of orders they placed
SELECT c.ContactName, COUNT(o.OrderID) AS OrderCount
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.ContactName;

-- 22. Customer contact names with more than 3 orders
SELECT c.ContactName
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.ContactName
HAVING COUNT(o.OrderID) > 3;

-- 23. Discontinued products ordered between 1/1/1997 and 1/1/1998
SELECT DISTINCT p.*
FROM Products p
JOIN OrderDetails od ON p.ProductID = od.ProductID
JOIN Orders o ON od.OrderID = o.OrderID
WHERE p.Discontinued = 1 AND o.OrderDate BETWEEN '1997-01-01' AND '1998-01-01';

-- 24. Employee and supervisor full names
SELECT e.EmployeeID, e.FirstName, e.LastName, s.FirstName AS SupervisorFirstName, s.LastName AS SupervisorLastName
FROM Employees e
LEFT JOIN Employees s ON e.ReportsTo = s.EmployeeID;

-- 25. EmployeeID and total sales they handled
SELECT o.EmployeeID, SUM(od.UnitPrice * od.Quantity) AS TotalSales
FROM Orders o
JOIN OrderDetails od ON o.OrderID = od.OrderID
GROUP BY o.EmployeeID;

-- 26. Employees whose first name contains 'a'
SELECT * FROM Employees
WHERE FirstName LIKE '%a%';

-- 27. Managers with more than 4 employees reporting to them
SELECT e1.EmployeeID, COUNT(e2.EmployeeID) AS ReportCount
FROM Employees e1
JOIN Employees e2 ON e1.EmployeeID = e2.ReportsTo
GROUP BY e1.EmployeeID
HAVING COUNT(e2.EmployeeID) > 4;

-- 28. Orders and product names
SELECT o.OrderID, p.ProductName
FROM Orders o
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID;

-- 29. Orders placed by the best customer
SELECT o.*
FROM Orders o
WHERE o.CustomerID = (
    SELECT CustomerID
    FROM Orders o2
    JOIN OrderDetails od ON o2.OrderID = od.OrderID
    GROUP BY o2.CustomerID
    ORDER BY SUM(od.UnitPrice * od.Quantity) DESC
    LIMIT 1
);

-- 30. Orders by customers without Fax number
SELECT o.*
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE c.Fax IS NULL;

-- 31. Postal codes where Tofu was shipped
SELECT DISTINCT c.PostalCode
FROM Orders o
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE p.ProductName = 'Tofu';

-- 32. Products shipped to France
SELECT DISTINCT p.ProductName
FROM Orders o
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
WHERE o.ShipCountry = 'France';

-- 33. Products and categories for 'Specialty Biscuits, Ltd.'
SELECT p.ProductName, c.CategoryName
FROM Products p
JOIN Categories c ON p.CategoryID = c.CategoryID
JOIN Suppliers s ON p.SupplierID = s.SupplierID
WHERE s.CompanyName = 'Specialty Biscuits, Ltd.';

-- 34. Products never ordered
SELECT * FROM Products
WHERE ProductID NOT IN (
    SELECT DISTINCT ProductID FROM OrderDetails
);

-- 35. Products with UnitsInStock < 10 and UnitsOnOrder = 0
SELECT * FROM Products
WHERE UnitsInStock < 10 AND UnitsOnOrder = 0;

-- 36. Top 10 countries by sales
SELECT ShipCountry, SUM(od.UnitPrice * od.Quantity) AS Sales
FROM Orders o
JOIN OrderDetails od ON o.OrderID = od.OrderID
GROUP BY ShipCountry
ORDER BY Sales DESC
LIMIT 10;

-- 37. Number of orders each employee took for customerIDs between 'A' and 'AQ'
SELECT o.EmployeeID, COUNT(o.OrderID) AS OrderCount
FROM Orders o
WHERE o.CustomerID BETWEEN 'A' AND 'AQ'
GROUP BY o.EmployeeID;

-- 38. OrderDate of most expensive order
SELECT o.OrderDate
FROM Orders o
JOIN OrderDetails od ON o.OrderID = od.OrderID
GROUP BY o.OrderID
ORDER BY SUM(od.UnitPrice * od.Quantity) DESC
LIMIT 1;

-- 39. Product name and total revenue
SELECT p.ProductName, SUM(od.UnitPrice * od.Quantity) AS Revenue
FROM Products p
JOIN OrderDetails od ON p.ProductID = od.ProductID
GROUP BY p.ProductName;

-- 40. SupplierID and number of products
SELECT SupplierID, COUNT(*) AS ProductCount
FROM Products
GROUP BY SupplierID;

-- 41. Top 10 customers by business
SELECT o.CustomerID, SUM(od.UnitPrice * od.Quantity) AS TotalBusiness
FROM Orders o
JOIN OrderDetails od ON o.OrderID = od.OrderID
GROUP BY o.CustomerID
ORDER BY TotalBusiness DESC
LIMIT 10;

-- 42. Total revenue of the company
SELECT SUM(UnitPrice * Quantity) AS TotalRevenue
FROM OrderDetails;





