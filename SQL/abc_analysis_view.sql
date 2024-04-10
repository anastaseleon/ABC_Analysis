USE AdventureWorks2019
GO
DROP VIEW IF EXISTS ABC_analysis;
GO

-- Create the view
CREATE VIEW ABC_analysis AS
WITH SalesCTE AS (
    SELECT
        a.ProductID,
        a.name,
	    ISNULL(SUM(b.LineTotal), 0) AS SalesAmount, -- Replace null with 0
        SUM(ISNULL(SUM(b.LineTotal), 0)) OVER() AS TotalSales,
        SUM(SUM(ISNULL(b.LineTotal, 0))) OVER(ORDER BY SUM(ISNULL(b.LineTotal, 0)) DESC) AS RunningTotal
    FROM
        sourcedproducts a
        LEFT JOIN sales.SalesOrderDetail b ON a.ProductID = b.ProductID 
    GROUP BY
        a.ProductID, a.name
),
PercentCTE AS (
    SELECT
        ProductID,
        name,
        SalesAmount,
        RunningTotal,
        TotalSales,
        (RunningTotal / TotalSales) * 100 AS RunningPct
    FROM
        SalesCTE
)
SELECT
    ProductID,
    name,
    SalesAmount,
    RunningTotal,
    RunningPct,
    CASE
        WHEN RunningPct <= 80 THEN 'A'
        WHEN RunningPct > 80 AND RunningPct <= 95 THEN 'B'
        ELSE 'C'
    END AS Category
FROM
    PercentCTE;
GO
