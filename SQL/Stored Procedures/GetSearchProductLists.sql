USE [OnlineCarDB]
GO
/****** Object:  StoredProcedure [dbo].[GetSearchProductLists]    Script Date: 08/31/2015 13:45:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER Procedure [dbo].[GetSearchProductLists]
(
@Brand nvarchar(50),
@Model nvarchar(50),
@Type nvarchar(50),
@Year nvarchar(50),
@Price1 money,
@Price2 money,
@DescriptionLength int,
@PageNumber int,
@ProductsPerPage int,
@HowManyProducts int out)
AS

--declare a new TABLE variable
Declare @Products Table
(RowNumber int,
ProductID int,
Description nvarchar(max),
Thumbnail nvarchar(50),
Image nvarchar(50),
Name nvarchar(50),
Price money)

--pouplate the table variable with the complete list of products
Insert into @Products 
Select ROW_NUMBER () OVER (Order by Product.ProductID),
ProductID,
Case When LEN(Description)<=@DescriptionLength Then Description 
	Else SUBSTRING (Description,1,@DescriptionLength)+'...' End
	AS Description,
	Thumbnail ,Image,Name,Price_Attribute.Price	
From  Product INNER JOIN
                      Price_Attribute ON Product.PriceID = Price_Attribute.PriceID INNER JOIN
                      Model_Attribute ON Product.ModelID = Model_Attribute.ModelID INNER JOIN
                      Type_Attribute ON Product.TypeID = Type_Attribute.TypeID INNER JOIN
                      Year_Attribute ON Product.YearID = Year_Attribute.YearID INNER JOIN
                      Brand_Attribute ON Product.BrandID = Brand_Attribute.BrandID
                      
Where Brand_Attribute .BrandName =@Brand 
And Model_Attribute .ModelName =@Model 
And Type_Attribute .TypeName =@Type 
or Year_Attribute .Year =@Year 
Or Price_Attribute.Price Between @Price1 And @Price2 

--return the total number of products using an Ouput variable
Select @HowManyProducts =COUNT (ProductID ) 
From @Products 

--extract the requested page of products
Select ProductID,Description ,Thumbnail ,Image,Name,Price
From @Products 
Where RowNumber >(@PageNumber -1) * @ProductsPerPage
AND RowNumber <=@PageNumber *@ProductsPerPage