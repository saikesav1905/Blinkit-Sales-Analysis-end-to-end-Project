select * from [ Blinkit_Data]
select count(*) from [ Blinkit_Data]

--DATA CLEANING
update [ Blinkit_Data]
SET Item_Fat_Content = 
CASE
WHEN Item_Fat_Content IN ('LF','low fat') THEN 'Low Fat'
WHEN Item_Fat_Content = 'reg'THEN 'Regular'
ELSE Item_Fat_Content
END

SELECT DISTINCT Item_Fat_Content FROM [ Blinkit_Data]


--TOTAL SALES
SELECT CAST(SUM(Sales)/1000000 AS DECIMAL(10,2)) AS Total_Sales_In_Millions FROM [ Blinkit_Data]


-- AVERAGE SALES 
SELECT CAST(AVG(Sales) AS DECIMAL(10,0))  AS Avg_Sales FROM [ Blinkit_Data]


--NO OF ITEMS
SELECT COUNT(*) AS Total_Items  FROM [ Blinkit_Data]


--AVERAGE RATING
SELECT CAST(AVG(Rating) AS DECIMAL(10,0)) AS AVG_RATING FROM [ Blinkit_Data]


--TOTAL SALES BY FAT CONTENT
SELECT Item_Fat_Content,
		CAST(SUM(Total_Sales)/1000 AS DECIMAL(10,0)) AS Total_Sales_Thousands,
		CAST(AVG(Total_Sales) AS DECIMAL(10,0)) AS AVG_SALES,
		COUNT(*) AS Total_Item,
		CAST(AVG(Rating) AS DECIMAL(10,0)) AS AVG_RATING 
FROM [ Blinkit_Data]
GROUP BY Item_Fat_Content  
ORDER BY  Total_Sales_Thousands desc


--TOTAL SALES BY ITEM TYPE
SELECT Item_Type,
		CAST(SUM(Total_Sales) AS DECIMAL(10,0)) AS Total_Sales,
		CAST(AVG(Total_Sales) AS DECIMAL(10,1)) AS AVG_SALES,
		COUNT(*) AS Total_Item,
		CAST(AVG(Rating) AS DECIMAL(10,0)) AS AVG_RATING 
FROM [ Blinkit_Data]
GROUP BY Item_Type
ORDER BY  Total_Sales desc


--FAT CONTENT BY OUTLET FOR TOTAL SALES
SELECT Outlet_Location_Type, 
       ISNULL([Low Fat], 0) AS Low_Fat, 
       ISNULL([Regular], 0) AS Regular
FROM 
(
    SELECT Outlet_Location_Type, Item_Fat_Content, 
           CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales
    FROM [ Blinkit_Data]
    GROUP BY Outlet_Location_Type, Item_Fat_Content
) AS SourceTable
PIVOT 
(
    SUM(Total_Sales) 
    FOR Item_Fat_Content IN ([Low Fat], [Regular])
) AS PivotTable
ORDER BY Outlet_Location_Type;


--TOTAL SALES BY OUTLET ESTABLISHMENT
SELECT Outlet_Establishment_Year,
		CAST(SUM(Total_Sales) AS DECIMAL(10,0)) AS Total_Sales,
		COUNT(*) AS Total_Item
		FROM [ Blinkit_Data]
GROUP BY Outlet_Establishment_Year 
ORDER BY Outlet_Establishment_Year

--PERCENTAGE OF SALES BY OUTLET SIZE
SELECT Outlet_Size, 
    CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales,
    CAST((SUM(Total_Sales) * 100.0 / SUM(SUM(Total_Sales)) OVER()) AS DECIMAL(10,2)) AS Sales_Percentage
FROM [ Blinkit_Data]
GROUP BY Outlet_Size
ORDER BY Total_Sales DESC;

--SALES BY OUTLET LOCATION
SELECT Outlet_Location_Type, 
	CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales
FROM [ Blinkit_Data]
GROUP BY Outlet_Location_Type
ORDER BY Total_Sales DESC


--ALL METRICS BY OUTLET TYPE
SELECT Outlet_Type, 
CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales,
		CAST(AVG(Total_Sales) AS DECIMAL(10,0)) AS Avg_Sales,
		COUNT(*) AS No_Of_Items,
		CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Rating,
		CAST(AVG(Item_Visibility) AS DECIMAL(10,2)) AS Item_Visibility
FROM [ Blinkit_Data]
GROUP BY Outlet_Type
ORDER BY Total_Sales DESC




