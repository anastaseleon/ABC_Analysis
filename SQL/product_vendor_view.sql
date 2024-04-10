Use AdventureWorks2019
GO
Create view Product_vendor as (
SELECT
    FG.ProductID,
    COALESCE(CAST(PV.BusinessEntityId AS VARCHAR), 'InHouse') AS BusinessEntityId,
    CASE 
        WHEN COALESCE(CAST(PV.BusinessEntityId AS VARCHAR), 'InHouse') = 'InHouse' THEN 'InHouse'
        ELSE 'Sourced'
    END AS ProcurementType
FROM
    FinishedGoods FG
LEFT JOIN
    purchasing.ProductVendor PV ON FG.ProductID = PV.ProductID
 )
GO
