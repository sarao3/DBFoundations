--*************************************************************************--
-- Title: Assignment06
-- Author: Sara ONeal
-- Desc: This file demonstrates how to use Views
-- Change Log: When,Who,What
-- 2021-02-20,SaraONeal,Created File
-- 2021-02-20,SaraONeal,Added Try-Catch block to first use Master database, determine if Assignment06DB_SaraONeal 
-- database exists, if so drop database, then create Assignment06DB_SaraONeal database (lines 19-32)
-- 2021-02-20,SaraONeal,Use Assignment06DB_SaraONeal database (lines 32-33)
-- 2021-02-20,SaraONeal,Created Categories, Products, Employees and Inventories Tables (lines 35-65)
-- 2021-02-20,SaraONeal,Added database constraints (lines 67-130)
-- 2021-02-20,SaraONeal,Insert data into Assignment06DB_SaraONeal database (lines 132-165)
-- 2021-02-20,SaraONeal,Show all of the data in the Categories, Products, Employees and Inventories Tables (lines 167-175)
-- 2021-02-20,SaraONeal,Answered questions 1 through 10 (lines 177-481)
-- 2021-02-20,SaraONeal,Show all views created for questions 1 through 10 (lines 484-498)
--**************************************************************************--


-- Try-Catch block to create and use Assignment06DB_SaraONeal database
Begin Try
	Use Master;
	If Exists(Select Name From SysDatabases Where Name = 'Assignment06DB_SaraONeal')
	 Begin 
	  Alter Database [Assignment06DB_SaraONeal] set Single_user With Rollback Immediate;
	  Drop Database Assignment06DB_SaraONeal;
	 End
	Create Database Assignment06DB_SaraONeal;
End Try
Begin Catch
	Print Error_Number();
End Catch
go
Use Assignment06DB_SaraONeal;

-- Create Tables (Module 01)-- 
Create Table Categories
([CategoryID] [int] IDENTITY(1,1) NOT NULL 
,[CategoryName] [nvarchar](100) NOT NULL
);
go

Create Table Products
([ProductID] [int] IDENTITY(1,1) NOT NULL 
,[ProductName] [nvarchar](100) NOT NULL 
,[CategoryID] [int] NULL  
,[UnitPrice] [mOney] NOT NULL
);
go

Create Table Employees -- New Table
([EmployeeID] [int] IDENTITY(1,1) NOT NULL 
,[EmployeeFirstName] [nvarchar](100) NOT NULL
,[EmployeeLastName] [nvarchar](100) NOT NULL 
,[ManagerID] [int] NULL  
);
go

Create Table Inventories
([InventoryID] [int] IDENTITY(1,1) NOT NULL
,[InventoryDate] [Date] NOT NULL
,[EmployeeID] [int] NOT NULL -- New Column
,[ProductID] [int] NOT NULL
,[Count] [int] NOT NULL
);
go

-- Add Constraints (Module 02) -- 
Begin  -- Categories
	Alter Table Categories 
	 Add Constraint pkCategories 
	  Primary Key (CategoryId);

	Alter Table Categories 
	 Add Constraint ukCategories 
	  Unique (CategoryName);
End
go 

Begin -- Products
	Alter Table Products 
	 Add Constraint pkProducts 
	  Primary Key (ProductId);

	Alter Table Products 
	 Add Constraint ukProducts 
	  Unique (ProductName);

	Alter Table Products 
	 Add Constraint fkProductsToCategories 
	  Foreign Key (CategoryId) References Categories(CategoryId);

	Alter Table Products 
	 Add Constraint ckProductUnitPriceZeroOrHigher 
	  Check (UnitPrice >= 0);
End
go

Begin -- Employees
	Alter Table Employees
	 Add Constraint pkEmployees 
	  Primary Key (EmployeeId);

	Alter Table Employees 
	 Add Constraint fkEmployeesToEmployeesManager 
	  Foreign Key (ManagerId) References Employees(EmployeeId);
End
go

Begin -- Inventories
	Alter Table Inventories 
	 Add Constraint pkInventories 
	  Primary Key (InventoryId);

	Alter Table Inventories
	 Add Constraint dfInventoryDate
	  Default GetDate() For InventoryDate;

	Alter Table Inventories
	 Add Constraint fkInventoriesToProducts
	  Foreign Key (ProductId) References Products(ProductId);

	Alter Table Inventories 
	 Add Constraint ckInventoryCountZeroOrHigher 
	  Check ([Count] >= 0);

	Alter Table Inventories
	 Add Constraint fkInventoriesToEmployees
	  Foreign Key (EmployeeId) References Employees(EmployeeId);
End 
go

-- Adding Data (Module 04) -- 
Insert Into Categories 
(CategoryName)
Select CategoryName 
 From Northwind.dbo.Categories
 Order By CategoryID;
go

Insert Into Products
(ProductName, CategoryID, UnitPrice)
Select ProductName,CategoryID, UnitPrice 
 From Northwind.dbo.Products
  Order By ProductID;
go

Insert Into Employees
(EmployeeFirstName, EmployeeLastName, ManagerID)
Select E.FirstName, E.LastName, IsNull(E.ReportsTo, E.EmployeeID) 
 From Northwind.dbo.Employees as E
  Order By E.EmployeeID;
go

Insert Into Inventories
(InventoryDate, EmployeeID, ProductID, [Count])
Select '20170101' as InventoryDate, 5 as EmployeeID, ProductID, ABS(CHECKSUM(NewId())) % 100 as RandomValue
From Northwind.dbo.Products
Union
Select '20170201' as InventoryDate, 7 as EmployeeID, ProductID, ABS(CHECKSUM(NewId())) % 100 as RandomValue
From Northwind.dbo.Products
Union
Select '20170301' as InventoryDate, 9 as EmployeeID, ProductID, ABS(CHECKSUM(NewId())) % 100 as RandomValue
From Northwind.dbo.Products
Order By 1, 2
go

-- Show the Current data in the Categories, Products, and Inventories Tables
Select * From Categories;
go
Select * From Products;
go
Select * From Employees;
go
Select * From Inventories;
go

/********************************* Questions and Answers *********************************/
-- 'NOTES------------------------------------------------------------------------------------ 
--  1) You can use any name you like for you views, but be descriptive and consistent
--  2) You can use your working code from assignment 5 for much of this assignment
--  3) You must use the BASIC views for each table after they are created in Question 1
------------------------------------------------------------------------------------------'

-- Question 1 (5 pts): How can you create BACIC views to show data from each table in the database.
-- NOTES: 1) Do not use a *, list out each column!
--        2) Create one view per table!
--		  3) Use SchemaBinding to protect the views from being orphaned!

go
Create -- Drop
View vCategories
WITH SCHEMABINDING
AS
  Select CategoryID
       , CategoryName 
  From dbo.Categories;
go


go
Create -- Drop
View vProducts
WITH SCHEMABINDING
AS
  Select ProductID
       , ProductName
	   , CategoryID
	   , UnitPrice 
  From dbo.Products;
go


go
Create -- Drop
View vEmployees
WITH SCHEMABINDING
AS
  Select EmployeeID
       , EmployeeFirstName
	   , EmployeeLastName
	   , ManagerID 
  From dbo.Employees;
go


go
Create -- Drop
View vInventories
WITH SCHEMABINDING
AS
  Select InventoryID
       , InventoryDate
	   , EmployeeID
	   , ProductID
	   , [Count] 
  From dbo.Inventories;
go


-- Question 2 (5 pts): How can you set permissions, so that the public group CANNOT select data 
-- from each table, but can select data from each view?

Deny Select On Categories to Public;
Grant Select On vCategories to Public;


Deny Select On Products to Public;
Grant Select On vProducts to Public;


Deny Select On Employees to Public;
Grant Select On vEmployees to Public;


Deny Select On Inventories to Public;
Grant Select On vInventories to Public;


-- Question 3 (10 pts): How can you create a view to show a list of Category and Product names, 
-- and the price of each product?
-- Order the result by the Category and Product!

-- Here is an example of some rows selected from the view:
-- CategoryName,ProductName,UnitPrice
-- Beverages,Chai,18.00
-- Beverages,Chang,19.00
-- Beverages,Chartreuse verte,18.00

go
Create -- Drop
View vProductsByCategories
WITH SCHEMABINDING
AS
  Select Top 100000
  c.CategoryName, p.ProductName, p.UnitPrice 
  From dbo.Products as p
  Join dbo.Categories as c
	On p.CategoryID = c.CategoryID
  Order By c.CategoryName
         , p.ProductName
		 , p.UnitPrice;
go


-- Question 4 (10 pts): How can you create a view to show a list of Product names 
-- and Inventory Counts on each Inventory Date?
-- Order the results by the Product, Date, and Count!

-- Here is an example of some rows selected from the view:
--ProductName,InventoryDate,Count
--Alice Mutton,2017-01-01,15
--Alice Mutton,2017-02-01,78
--Alice Mutton,2017-03-01,83

go
Create -- Drop
View vInventoriesByProductsByDates
WITH SCHEMABINDING
AS
  Select Top 100000
  p.ProductName, i.InventoryDate, i.[Count]
  From dbo.Products as p 
  Inner Join dbo.Inventories as i
	On p.ProductID = i.ProductID
  Order By p.ProductName
         , i.InventoryDate
         , i.[Count];
go


-- Question 5 (10 pts): How can you create a view to show a list of Inventory Dates 
-- and the Employee that took the count?
-- Order the results by the Date and return only one row per date!

-- Here is an example of some rows selected from the view:
-- InventoryDate,EmployeeName
-- 2017-01-01,Steven Buchanan
-- 2017-02-01,Robert King
-- 2017-03-01,Anne Dodsworth

go
Create -- Drop
View vInventoriesByEmployeesByDates
WITH SCHEMABINDING
AS
  Select Distinct Top 100000
  i.InventoryDate, e.EmployeeFirstName + ' ' + e.EmployeeLastName as EmployeeName
  From dbo.Inventories as i 
  Inner Join dbo.Employees as e
    On i.EmployeeID = e.EmployeeID
  Order By i.InventoryDate;
go


-- Question 6 (10 pts): How can you create a view show a list of Categories, Products, 
-- and the Inventory Date and Count of each product?
-- Order the results by the Category, Product, Date, and Count!

-- Here is an example of some rows selected from the view:
-- CategoryName,ProductName,InventoryDate,Count
-- Beverages,Chai,2017-01-01,72
-- Beverages,Chai,2017-02-01,52
-- Beverages,Chai,2017-03-01,54

go
Create -- Drop
View vInventoriesByProductsByCategories
WITH SCHEMABINDING
AS
  Select Top 100000
  c.CategoryName, p.ProductName, i.InventoryDate, i.[Count]
  From dbo.Inventories as i 
    Inner Join dbo.Products as p
        On i.ProductID = p.ProductID
    Inner Join dbo.Categories as c
        On p.CategoryID = c.CategoryID
  Order By c.CategoryName
         , p.ProductName
		 , i.InventoryDate
		 , i.[Count];
go


-- Question 7 (10 pts): How can you create a view to show a list of Categories, Products, 
-- the Inventory Date and Count of each product, and the EMPLOYEE who took the count?
-- Order the results by the Inventory Date, Category, Product and Employee!

-- Here is an example of some rows selected from the view:
-- CategoryName,ProductName,InventoryDate,Count,EmployeeName
-- Beverages,Chai,2017-01-01,72,Steven Buchanan
-- Beverages,Chang,2017-01-01,46,Steven Buchanan
-- Beverages,Chartreuse verte,2017-01-01,61,Steven Buchanan

go
Create -- Drop
View vInventoriesByProductsByEmployees
WITH SCHEMABINDING
AS
  Select Top 100000
  c.CategoryName, p.ProductName, i.InventoryDate, i.[Count], e.EmployeeFirstName + ' ' + e.EmployeeLastName as EmployeeName
  From dbo.Inventories as i
    Inner Join dbo.Employees as e
        On i.EmployeeID = e.EmployeeID
    Inner Join dbo.Products as p
        On i.ProductID = p.ProductID
    Inner Join dbo.Categories as c
        On p.CategoryID = c.CategoryID
  Order By i.InventoryDate
         , c.CategoryName
		 , p.ProductName
		 , EmployeeName;
go


-- Question 8 (10 pts): How can you create a view to show a list of Categories, Products, 
-- the Inventory Date and Count of each product, and the Employee who took the count
-- for the Products 'Chai' and 'Chang'? 

-- Here is an example of some rows selected from the view:
-- CategoryName,ProductName,InventoryDate,Count,EmployeeName
-- Beverages,Chai,2017-01-01,72,Steven Buchanan
-- Beverages,Chang,2017-01-01,46,Steven Buchanan
-- Beverages,Chai,2017-02-01,52,Robert King

go
Create -- Drop
View vInventoriesForChaiAndChangByEmployees
WITH SCHEMABINDING
AS
  Select Top 100000
  c.CategoryName, p.ProductName, i.InventoryDate, i.[Count], e.EmployeeFirstName + ' ' + e.EmployeeLastName as EmployeeName
  From dbo.Inventories as i
    Inner Join dbo.Employees as e
        On i.EmployeeID = e.EmployeeID
    Inner Join dbo.Products as p
        On i.ProductID = p.ProductID
    Inner Join dbo.Categories as c
        On p.CategoryID = c.CategoryID
  Where i.ProductID In (Select ProductID From dbo.Products Where ProductName In ('Chai', 'Chang'))
  Order By i.InventoryDate
         , c.CategoryName
		 , p.ProductName
		 , i.[Count]
		 , EmployeeName;
go


-- Question 9 (10 pts): How can you create a view to show a list of Employees and the Manager who manages them?
-- Order the results by the Manager's name!

-- Here is an example of some rows selected from the view:
-- Manager,Employee
-- Andrew Fuller,Andrew Fuller
-- Andrew Fuller,Janet Leverling
-- Andrew Fuller,Laura Callahan

go
Create -- Drop
View vEmployeesByManager
WITH SCHEMABINDING
AS
  Select Top 100000
  m.EmployeeFirstName + ' ' + m.EmployeeLastName as Manager, e.EmployeeFirstName + ' ' + e.EmployeeLastName as Employee
  From dbo.Employees as e
    Inner Join dbo.Employees as m
        On e.ManagerID = m.EmployeeID
  Order By Manager
         , Employee;
go


-- Question 10 (10 pts): How can you create one view to show all the data from all four 
-- BASIC Views?

-- Here is an example of some rows selected from the view:
-- CategoryID,CategoryName,ProductID,ProductName,UnitPrice,InventoryID,InventoryDate,Count,EmployeeID,Employee,Manager
-- 1,Beverages,1,Chai,18.00,1,2017-01-01,72,5,Steven Buchanan,Andrew Fuller
-- 1,Beverages,1,Chai,18.00,78,2017-02-01,52,7,Robert King,Steven Buchanan
-- 1,Beverages,1,Chai,18.00,155,2017-03-01,54,9,Anne Dodsworth,Steven Buchanan

go
Create -- Drop
View vInventoriesByProductsByCategoriesByEmployees
WITH SCHEMABINDING
AS
  Select Top 100000
  c.CategoryID, c.CategoryName, p.ProductID, p.ProductName, p.UnitPrice, i.InventoryID, i.InventoryDate, i.[Count], e.EmployeeID, e.EmployeeFirstName + ' ' + e.EmployeeLastName as EmployeeName, m.EmployeeFirstName + ' ' + m.EmployeeLastName as Manager
  From dbo.Employees as e
    Inner Join dbo.Employees as m
        On e.ManagerID = m.EmployeeID
    Inner Join dbo.Inventories as i
        On i.EmployeeID = e.EmployeeID
	Inner Join dbo.Products as p
        On i.ProductID = p.ProductID
	Inner Join dbo.Categories as c
        On p.CategoryID = c.CategoryID
  Order By c.CategoryName
         , p.ProductName
		 , i.InventoryDate
		 , Manager;
go


-- Test your Views (NOTE: You must change the names to match yours as needed!)
Select * From [dbo].[vCategories]
Select * From [dbo].[vProducts]
Select * From [dbo].[vInventories]
Select * From [dbo].[vEmployees]

Select * From [dbo].[vProductsByCategories]
Select * From [dbo].[vInventoriesByProductsByDates]
Select * From [dbo].[vInventoriesByEmployeesByDates]
Select * From [dbo].[vInventoriesByProductsByCategories]
Select * From [dbo].[vInventoriesByProductsByEmployees]
Select * From [dbo].[vInventoriesForChaiAndChangByEmployees]
Select * From [dbo].[vEmployeesByManager]
Select * From [dbo].[vInventoriesByProductsByCategoriesByEmployees]
/***************************************************************************************/