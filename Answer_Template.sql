--SQL Advance Case Study
use db_SQLCaseStudies

--Q1--BEGIN 
	
	select l.state from fact_transactions t inner join dim_location l on t.idlocation = l.idlocation
	where year (date) > 2004
	group by l.state



--Q1--END

--Q2--BEGIN
	

	select top 1 l.[State], ma.Manufacturer_Name, sum (t.Quantity) Total_Sales from fact_transactions t inner join dim_location l on t.idlocation = l.idlocation
										inner join DIM_MODEL m on t.IDModel = m.IDModel
										inner join DIM_MANUFACTURER ma on m.IDManufacturer = ma.IDManufacturer
	where Country = 'US' and Manufacturer_Name = 'Samsung'
	group by l.[State], ma.Manufacturer_Name
	










--Q2--END

--Q3--BEGIN      
	

		select l.State, l.ZipCode, m.Model_Name, count (t.IDModel)  [Transactions]
							from fact_transactions t inner join dim_location l on t.idlocation = l.idlocation
										inner join DIM_MODEL m on t.IDModel = m.IDModel
										inner join DIM_MANUFACTURER ma on m.IDManufacturer = ma.IDManufacturer
							group by l.State, l.ZipCode, m.Model_Name






--Q3--END

--Q4--BEGIN


	select top 1 Unit_price, Model_Name  from DIM_MODEL
	order by Unit_price asc





--Q4--END

--Q5--BEGIN



	SELECT TOP 5
	Manufacturer_Name,
	AVG(TOTALPRICE) AVG_RATE,
	SUM(QUANTITY)   SALE_QUANTITY
	FROM FACT_TRANSACTIONS T 
                          LEFT JOIN DIM_MODEL M
                          ON T.IDModel=M.IDModel
                          INNER JOIN DIM_MANUFACTURER M2
                          ON M.IDManufacturer=M2.IDManufacturer
	GROUP BY Manufacturer_Name
	ORDER BY SALE_QUANTITY DESC












--Q5--END

--Q6--BEGIN

	select
	Customer_Name,
	avg (TotalPrice) [Avg_Price]
		from DIM_CUSTOMER c
						inner join FACT_TRANSACTIONS t 
						on c.IDCustomer = t.IDCustomer
	where year (Date) = 2009
	group by Customer_Name
	having avg (TotalPrice) > 500
	order by avg (TotalPrice) desc









--Q6--END
	
--Q7--BEGIN  
	
	select * from 
	(
		select top 5
	Model_Name
				from FACT_TRANSACTIONS t
							inner join DIM_MODEL m
							on t.IDModel = m.IDModel
	where year (date) = 2008
	group by Model_Name, year (date)
	order by sum (quantity) desc
INTERSECT
		select top 5
	Model_Name
				from FACT_TRANSACTIONS t
							inner join DIM_MODEL m
							on t.IDModel = m.IDModel
	where year (date) = 2009
	group by Model_Name, year (date)
	order by sum (quantity) desc
INTERSECT
	select top 5
	Model_Name
				from FACT_TRANSACTIONS t
							inner join DIM_MODEL m
							on t.IDModel = m.IDModel
	where year (date) = 2010
	group by Model_Name, year (date)
	order by sum (quantity) desc  
	) xyz






--Q7--END	
--Q8--BEGIN


	select top 1 * 
From (
	select
	Manufacturer_Name,
	sum (Quantity) [2009 Sale]
		from FACT_TRANSACTIONS t
							inner join DIM_MODEL m
							on t.IDModel = m.IDModel
							inner join DIM_MANUFACTURER ma
							on m.IDManufacturer = ma.IDManufacturer
		where year (date) = 2009
		group by Manufacturer_Name
		order by sum (Quantity) desc
		OFFSET 1 ROWS
        FETCH NEXT 1 ROWS ONLY 
			) 
		as A,
		
		(
	select
	Manufacturer_Name,
	sum (Quantity) [2010 Sale]
		from FACT_TRANSACTIONS t
							inner join DIM_MODEL m
							on t.IDModel = m.IDModel
							inner join DIM_MANUFACTURER ma
							on m.IDManufacturer = ma.IDManufacturer
		where year (date) = 2010
		group by Manufacturer_Name
		order by sum (Quantity) desc
		OFFSET 1 ROWS
        FETCH NEXT 1 ROWS ONLY 
		) 
		as B

		
	




--Q8--END
--Q9--BEGIN
	
	
	select *
	from (
	select
	Manufacturer_Name
			from FACT_TRANSACTIONS t
							inner join DIM_MODEL m
							on t.IDModel = m.IDModel
							inner join DIM_MANUFACTURER ma
							on m.IDManufacturer = ma.IDManufacturer
	where year (date) = 2010
	group by Manufacturer_Name
Intersect
	select
	Manufacturer_Name
			from FACT_TRANSACTIONS t
							inner join DIM_MODEL m
							on t.IDModel = m.IDModel
							inner join DIM_MANUFACTURER ma
							on m.IDManufacturer = ma.IDManufacturer
	where year (date) = 2009
	group by Manufacturer_Name
	) xyz








--Q9--END

--Q10--BEGIN
	

	SELECT top 100
    T1.Customer_Name, T1.Year, T1.Avg_Price,T1.Avg_Qty,
    CASE
        WHEN T2.Year IS NOT NULL
        THEN FORMAT(CONVERT(DECIMAL(8,2),(T1.Avg_Price-T2.Avg_Price))/CONVERT(DECIMAL(8,2),T2.Avg_Price),'p') ELSE NULL 
        END AS 'YEARLY_%_CHANGE'
    FROM
        (SELECT 
			t2.Customer_Name, 
			YEAR(t1.DATE) AS YEAR, 
			AVG(t1.TotalPrice) AS Avg_Price, 
			AVG(t1.Quantity) AS Avg_Qty 
						FROM FACT_TRANSACTIONS AS t1 
											left join DIM_CUSTOMER as t2 ON t1.IDCustomer=t2.IDCustomer
         group by t2.Customer_Name, YEAR(t1.Date)
		)T1
    left join
        (SELECT
			t2.Customer_Name, 
			YEAR(t1.DATE) AS YEAR, 
			AVG(t1.TotalPrice) AS Avg_Price, 
			AVG(t1.Quantity) AS Avg_Qty 
						FROM FACT_TRANSACTIONS AS t1 
											left join DIM_CUSTOMER as t2 ON t1.IDCustomer=t2.IDCustomer
        group by t2.Customer_Name, YEAR(t1.Date)
		)T2
        on T1.Customer_Name=T2.Customer_Name and T2.YEAR=T1.YEAR-1 
		order by t1.Customer_Name
	

--Q10--END
	

	