USE [BalloonShop]
GO
/****** Object:  StoredProcedure [dbo].[CatalogGetProductsInCategory]    Script Date: 07/14/2015 13:52:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER Procedure [dbo].[CatalogGetProductsInCategory]
(@CategoryID int,
@DescriptionLength int,
@PageNumber int,
@ProductsPerPage int,
@HowManyProducts int OUTPUT)
AS
--Declare a new Table variable
Declare @Products Table
(RowNumber int,
ProductID int,
Name nvarchar(50),
Description nvarchar(max),
Price money,
Thumbnail nvarchar(50),
Image nvarchar(50),
PromoFront bit,
PromoDept bit)

-- Populate the table variable with the complete list of products
Insert into @Products 
Select ROW_NUMBER () Over (Order by Product.ProductID),
Product.ProductID ,Name,
Case When LEN (Description)<=@DescriptionLength  Then Description 
		Else SUBSTRING(Description,1,@DescriptionLength)+'...' End
		As Description,Price,Thumbnail,Image,PromoFront,PromoDept
		From Product INNER JOIN ProductCategory 
		On Product .ProductID =ProductCategory .ProductID 
		Where ProductCategory .CategoryID =@CategoryID 
		
	--return the total number of products using an OUTPUT variable
	Select @HowManyProducts =COUNT(ProductID) 
	From @Products 
	--extract the requested page of products
	Select ProductId,Name,Description,Price,Thumbnail,Image,
	PromoFront,PromoDept 
	From @Products 
	Where RowNumber >(@PageNumber -1)*@ProductsPerPage 
	AND RowNumber <=@PageNumber *@ProductsPerPage 
