
USE AdventureWorks;
GO

-- Query 1: Assign a row number to each sales order

SELECT
    SalesOrderID,
    OrderDate,
    CustomerID,
    TotalDue,
    ROW_NUMBER() OVER (
        ORDER BY OrderDate, SalesOrderID
    ) AS Row_Num
FROM Sales.SalesOrderHeader
ORDER BY OrderDate, SalesOrderID;


-- Query 2: Rank customers based on their total sales

WITH CustomerSales AS (
    SELECT
        CustomerID,
        SUM(TotalDue) AS TotalSales
    FROM Sales.SalesOrderHeader
    GROUP BY CustomerID
)
SELECT
    CustomerID,
    TotalSales,
    RANK() OVER (
        ORDER BY TotalSales DESC
    ) AS SalesRank
FROM CustomerSales


-- Query 3: Rank products based on their sales

WITH ProductSales AS (
    SELECT
        ProductID,
        SUM(LineTotal) AS TotalSales
    FROM Sales.SalesOrderDetail
    GROUP BY ProductID
)
SELECT
    ProductID,
    TotalSales,
    DENSE_RANK() OVER (
        ORDER BY TotalSales DESC
    ) AS SalesRank
FROM ProductSales



-- Query 4: Compare RANK and DENSE_RANK

WITH ProductSales AS (
    SELECT
        ProductID,
        SUM(LineTotal) AS TotalSales
    FROM Sales.SalesOrderDetail
    GROUP BY ProductID
)
SELECT
    ProductID,
    TotalSales,
    RANK() OVER (
        ORDER BY TotalSales DESC
    ) AS ProductRank,
    DENSE_RANK() OVER (
        ORDER BY TotalSales DESC
    ) AS DenseProductRank
FROM ProductSales
ORDER BY TotalSales DESC;


-- Query 5: Find the top five customer sales ranks


WITH CustomerSales AS (
    SELECT
        CustomerID,
        SUM(TotalDue) AS TotalSales
    FROM Sales.SalesOrderHeader
    GROUP BY CustomerID
),
RankedCustomers AS (
    SELECT
        CustomerID,
        TotalSales,
        DENSE_RANK() OVER (
            ORDER BY TotalSales DESC
        ) AS SalesRank
    FROM CustomerSales
)
SELECT
    CustomerID,
    TotalSales,
    SalesRank
FROM RankedCustomers
WHERE SalesRank <= 5
ORDER BY SalesRank, CustomerID;


-- Query 6: Rank products within each category


WITH ProductSales AS (
    SELECT
        p.ProductID,
        p.Name AS ProductName,
        pc.Name AS CategoryName,
        SUM(sod.LineTotal) AS TotalSales
    FROM Sales.SalesOrderDetail AS sod
    INNER JOIN Production.Product AS p
        ON sod.ProductID = p.ProductID
    INNER JOIN Production.ProductSubcategory AS psc
        ON p.ProductSubcategoryID = psc.ProductSubcategoryID
    INNER JOIN Production.ProductCategory AS pc
        ON psc.ProductCategoryID = pc.ProductCategoryID
    GROUP BY
        p.ProductID,
        p.Name,
        pc.Name
)
SELECT
    ProductID,
    ProductName,
    CategoryName,
    TotalSales,
    DENSE_RANK() OVER (
        PARTITION BY CategoryName
        ORDER BY TotalSales DESC
    ) AS CategoryRank
FROM ProductSales
ORDER BY CategoryName, CategoryRank, ProductID;


-- Query 7: Compare sales between months


WITH MonthlySales AS (
    SELECT
        DATEFROMPARTS(
            YEAR(OrderDate),
            MONTH(OrderDate),
            1
        ) AS SalesMonth,
        SUM(TotalDue) AS TotalSales
    FROM Sales.SalesOrderHeader
    GROUP BY
        YEAR(OrderDate),
        MONTH(OrderDate)
)
SELECT
    SalesMonth,
    TotalSales,
    LAG(TotalSales) OVER (
        ORDER BY SalesMonth
    ) AS PreviousMonthSales
FROM MonthlySales

-- Query 8: Calculate the change in monthly sales


WITH MonthlySales AS (
    SELECT
        DATEFROMPARTS(
            YEAR(OrderDate),
            MONTH(OrderDate),
            1
        ) AS SalesMonth,
        SUM(TotalDue) AS TotalSales
    FROM Sales.SalesOrderHeader
    GROUP BY
        YEAR(OrderDate),
        MONTH(OrderDate)
),
SalesComparison AS (
    SELECT
        SalesMonth,
        TotalSales,
        LAG(TotalSales) OVER (
            ORDER BY SalesMonth
        ) AS PreviousMonthSales
    FROM MonthlySales
)
SELECT
    SalesMonth,
    TotalSales,
    PreviousMonthSales,
    TotalSales - PreviousMonthSales AS SalesChange
FROM SalesComparison

-- Query 9: Find the previous order date for each customer


WITH CustomerOrders AS (
    SELECT
        CustomerID,
        SalesOrderID,
        OrderDate,
        TotalDue,
        LAG(OrderDate) OVER (
            PARTITION BY CustomerID
            ORDER BY OrderDate, SalesOrderID
        ) AS PreviousOrderDate
    FROM Sales.SalesOrderHeader
)
SELECT
    CustomerID,
    SalesOrderID,
    OrderDate,
    TotalDue,
    PreviousOrderDate
FROM CustomerOrders


-- Query 10: Calculate the days between customer orders


WITH CustomerOrders AS (
    SELECT
        CustomerID,
        SalesOrderID,
        OrderDate,
        LAG(OrderDate) OVER (
            PARTITION BY CustomerID
            ORDER BY OrderDate, SalesOrderID
        ) AS PreviousOrderDate
    FROM Sales.SalesOrderHeader
)
SELECT
    CustomerID,
    SalesOrderID,
    OrderDate,
    PreviousOrderDate,
    DATEDIFF(
        DAY,
        PreviousOrderDate,
        OrderDate
    ) AS DaysBetweenOrders
FROM CustomerOrders


-- Query 11: Find the highest-selling product in each category


WITH ProductSales AS (
    SELECT
        p.ProductID,
        p.Name AS ProductName,
        pc.Name AS CategoryName,
        SUM(sod.LineTotal) AS TotalSales
    FROM Sales.SalesOrderDetail AS sod
    INNER JOIN Production.Product AS p
        ON sod.ProductID = p.ProductID
    INNER JOIN Production.ProductSubcategory AS psc
        ON p.ProductSubcategoryID = psc.ProductSubcategoryID
    INNER JOIN Production.ProductCategory AS pc
        ON psc.ProductCategoryID = pc.ProductCategoryID
    GROUP BY
        p.ProductID,
        p.Name,
        pc.Name
),
RankedProducts AS (
    SELECT
        ProductID,
        ProductName,
        CategoryName,
        TotalSales,
        DENSE_RANK() OVER (
            PARTITION BY CategoryName
            ORDER BY TotalSales DESC
        ) AS SalesRank
    FROM ProductSales
)
SELECT
    ProductID,
    ProductName,
    CategoryName,
    TotalSales
FROM RankedProducts
WHERE SalesRank = 1
ORDER BY CategoryName, ProductID;


-- Query 12: Combine ranking and LAG


WITH CustomerSales AS (
    SELECT
        CustomerID,
        SUM(TotalDue) AS TotalSales
    FROM Sales.SalesOrderHeader
    GROUP BY CustomerID
),
CustomerAnalysis AS (
    SELECT
        CustomerID,
        TotalSales,
        DENSE_RANK() OVER (
            ORDER BY TotalSales DESC
        ) AS SalesRank,
        LAG(TotalSales) OVER (
            ORDER BY TotalSales DESC, CustomerID
        ) AS PreviousCustomerSales
    FROM CustomerSales
)
SELECT
    CustomerID,
    TotalSales,
    SalesRank,
    PreviousCustomerSales,
    TotalSales - PreviousCustomerSales AS SalesDifference
FROM CustomerAnalysis


