-------------------------Cleaning Data : Making it more usable and standardized------------------------
Select *
From PortfolioProject.dbo.NashvilleHousing$


/*********Stanadardize Format(Converting SaleDatea field format from string to date)********/

--1.Check date format of SaleDate format field
Select NashvilleHousing$.SaleDatea
From NashvilleHousing$

--2.Create a new column(SaleDateConverted) for converted date format
ALTER TABLE NashvilleHousing$
ADD SaleDateConverted DATE;

--3.Convert the date format of SaleDatea field from string to date into the new column(SaleDateConverted)
UPDATE NashvilleHousing$
SET NashvilleHousing$.SaleDateConverted = CONVERT(Date,NashvilleHousing$.SaleDate)

--4.Check the date format converted
Select NashvilleHousing$.SaleDateConverted
From NashvilleHousing$

--5.Delete the previous fomat field
ALTER TABLE NashvilleHousing$
DROP COLUMN SaleDate



/************Populate Property Address Data using Self Join & ISNULL***************/

--Populate blank rows in PropertyAddress field with same ParcelID but different UniqueIDs

--1.Check if there's same ParcelIDs
Select *
From NashvilleHousing$
Order by ParcelID


--2.Check if there's NULLs in PropertyAddress field and see if it could be be populated with other field values
Select a.[UniqueID ], a.ParcelID, a.PropertyAddress, b.[UniqueID ], b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From NashvilleHousing$ a
Join NashvilleHousing$ b
On a.ParcelID = b.ParcelID
   And a.[UniqueID ] <> b.[UniqueID ]
Where b.PropertyAddress is null

--3.Populate Nulls in PropertyAddress field using Self Join
UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From NashvilleHousing$ a
Join NashvilleHousing$ b
On a.ParcelID = b.ParcelID
   And a.[UniqueID ] <> b.[UniqueID ]
Where b.PropertyAddress is not null


--4.Check if there's any Nulls left in PropertyAddress field
Select a.[UniqueID ], a.ParcelID, a.PropertyAddress, b.[UniqueID ], b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From NashvilleHousing$ a
Join NashvilleHousing$ b
On a.ParcelID = b.ParcelID
   And a.[UniqueID ] <> b.[UniqueID ]
Where b.PropertyAddress is null




/************Breaking out Address into Individual Columns(Address, City, State)********/
--In PropertyAddress and OwnerAddress fields, Separating address and City existing in one field

--<<1>>Split with Index

--1.Check format of PropertyAddress field :ex)PropertyAddress filed :'StreetName'+','+'CityName'
Select PropertyAddress
From NashvilleHousing$


--2.Check if the column breaks out properly
Select 
Substring(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as PropertySplitStreet,
Substring(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,Len(PropertyAddress)) as PropertySplitCity
From PortfolioProject.dbo.NashvilleHousing$

--3.Create columns for addresses separated 
ALTER TABLE NashvilleHousing$
ADD PropertySplitStreet Nvarchar(255);

ALTER TABLE NashvilleHousing$
ADD PropertySplitCity Nvarchar(255);

--4. Update the data into the new columns
UPDATE NashvilleHousing$
SET NashvilleHousing$.PropertySplitStreet = Substring(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

UPDATE NashvilleHousing$
SET NashvilleHousing$.PropertySplitCity= Substring(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,Len(PropertyAddress))

--5. Check if query is done properly
Select PropertyAddress,PropertySplitStreet,PropertySplitCity
From NashvilleHousing$


--<<2>>Split with PARSENAME
--1.Check format of OwnerAddress field : 'StreetName'+','+'CityName'+','+'StateName'
Select OwnerAddress
From PortfolioProject.dbo.NashvilleHousing$

--2.Check if the column breaks out properly using PARSENAME
Select
PARSENAME(REPLACE(OwnerAddress,',','.'),1) as SplitOwnerStreetAddress,
PARSENAME(REPLACE(OwnerAddress,',','.'),2) as SplitOwnerCityAddress,
PARSENAME(REPLACE(OwnerAddress,',','.'),3) as SplitOwnerStateAddress 
From NashvilleHousing$

--3.Create columns for OwnerAddresse split in three part 
ALTER TABLE NashvilleHousing$
ADD SplitOwnerStateAddress Nvarchar(255);

ALTER TABLE NashvilleHousing$
ADD SplitOwnerCityAddress Nvarchar(255);

ALTER TABLE NashvilleHousing$
ADD SplitOwnerStreetAddress Nvarchar(255);


--4.Update the data into the new columns
UPDATE NashvilleHousing$
SET NashvilleHousing$.SplitOwnerStateAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),1)

UPDATE NashvilleHousing$
SET NashvilleHousing$.SplitOwnerCityAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),2) 

UPDATE NashvilleHousing$
SET NashvilleHousing$.SplitOwnerStreetAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

--5. Check if query is done properly
Select OwnerAddress, SplitOwnerStreetAddress, SplitOwnerCityAddress,SplitOwnerStateAddress
From NashvilleHousing$
Where OwnerAddress is not null


/*************Change 'Y and N' to 'Yes and No' in "Sold as Vacant" field **************/

--1.Check SoldAsVacant field
Select Distinct(SoldAsVacant),Count(SoldAsVacant)
From PortfolioProject..NashvilleHousing$
Group by SoldAsVacant

--2. Update the data into the new columns

UPDATE NashvilleHousing$
SET SoldAsVacant = 
CASE
 When SoldAsVacant = 'N' Then 'No'
 When SoldAsVacant = 'Y' Then 'Yes'
 Else SoldAsVacant
End 

/**************Remove Duplicates******************/
--1.Check if there's any duplicated data
With CTE_RowNum As (
Select *,
Row_Number() Over(Partition by 
                  ParcelID,
				  PropertyAddress,
				  SalePrice,
				  LegalReference
				   Order by 
				    UniqueID
                  ) row_num
From NashvilleHousing$
)
Select *
From CTE_RowNum
Where row_num>1

--2.Remove duplicated data

With CTE_RowNum As (
Select *,
Row_Number() Over(Partition by 
                  ParcelID,
				  PropertyAddress,
				  SalePrice,
				  LegalReference
				   Order by 
				    UniqueID
                  ) row_num
From NashvilleHousing$
)
Delete
From CTE_RowNum
Where row_num>1

--3.Check if there's any duplicated data left
With CTE_RowNum As (
Select *,
Row_Number() Over(Partition by 
                  ParcelID,
				  PropertyAddress,
				  SalePrice,
				  LegalReference
				   Order by 
				    UniqueID
                  ) row_num
From NashvilleHousing$
)
Select *
From CTE_RowNum
Where row_num>1

/****************Delete Unused column*****************/
Alter Table NashvilleHousing$
Drop Column PropertyAddress, OwnerAddress,TaxDistrict

