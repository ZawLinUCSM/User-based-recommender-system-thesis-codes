USE [OnlineCarDB]
GO
/****** Object:  StoredProcedure [dbo].[GetRecommendationProducts]    Script Date: 08/13/2015 21:11:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER Procedure [dbo].[GetRecommendationProducts]
(@Brand nvarchar(50),
@Year nvarchar(50),
@Model nvarchar(50),
@Type nvarchar(50),
@Price money,
@Color nvarchar(50),
@Fuel nvarchar(50),
@EnginePower nvarchar(50),
@HandDrive nvarchar(50),
@Milage int,
@Door int,
@Seat int)
AS 
Select ProductID,Description,Thumbnail,Price ,Image,Name 
From(
Select Row_Number() OVER(Order by ProductID) AS Row,ProductID,Description,Thumbnail,Product .Price AS Price,Image,Name     
FROM   Product INNER JOIN
                      Seat_Attribute ON Product.SeatID = Seat_Attribute.SeatID INNER JOIN
                      Type_Attribute ON Product.TypeID = Type_Attribute.TypeID INNER JOIN
                      Year_Attribute ON Product.YearID = Year_Attribute.YearID INNER JOIN
                      Price_Attribute ON Product.PriceID = Price_Attribute.PriceID INNER JOIN
                      Model_Attribute ON Product.ModelID = Model_Attribute.ModelID INNER JOIN
                      Milage_Attribute ON Product.MilageID = Milage_Attribute.MilageID INNER JOIN
                      HandDrive_Attribute ON Product.HandDriveID = HandDrive_Attribute.HandDriveID INNER JOIN
                      Fuel_Attribute ON Product.FuelID = Fuel_Attribute.FuelID INNER JOIN
                      EnginePower_Attribute ON Product.EnginePowerID = EnginePower_Attribute.EnginePowerID INNER JOIN
                      Door_Attribute ON Product.DoorID = Door_Attribute.DoorID INNER JOIN
                      Color_Attribute ON Product.ColorID = Color_Attribute.ColorID INNER JOIN
                      Brand_Attribute ON Product.BrandID = Brand_Attribute.BrandID
                      
Where Brand_Attribute.BrandName=@Brand And
Year_Attribute.Year =@Year And
Model_Attribute .ModelName =@Model  And 
Type_Attribute .TypeName =@Type And
Price_Attribute .Price =@Price And
Color_Attribute .ColorName =@Color And 
EnginePower_Attribute .EngineName =@EnginePower And
Fuel_Attribute .FuelName =@Fuel And
HandDrive_Attribute .HandDriveName =@HandDrive And
Door_Attribute .DoorQty =@Door Or 
Seat_Attribute .SeatQty =@Seat Or
Milage_Attribute .Milage =@Milage) AS ProductLists
Where Row >=1 And Row <=5
