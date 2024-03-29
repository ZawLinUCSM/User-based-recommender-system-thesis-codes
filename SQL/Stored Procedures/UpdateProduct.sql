Create Procedure UpdateProduct
(@ProductID int,
@BrandID int,
@YearID int,
@ModelID int,
@TypeID int,
@PriceID int,
@ColorID int,
@FuelID int,
@EnginePowerID int,
@HandDriveID int,
@MilageID int,
@DoorID int,
@SeatID int,
@Description nvarchar(max),
@Thumbnail nvarchar(50),
@Image nvarchar(50))
AS 
Update Product 
Set BrandID =@BrandID,
YearID =@YearID ,
ModelID =@ModelID ,
TypeID =@TypeID ,
PriceID =@PriceID ,
ColorID =@ColorID ,
FuelID =@FuelID ,
EnginePowerID =@EnginePowerID,
HandDriveID =@HandDriveID ,
MilageID =@MilageID ,
DoorID =@DoorID ,
SeatID =@SeatID,
Description =@Description ,
Thumbnail =@Thumbnail ,
Image =@Image
Where ProdcutID =@ProductID 