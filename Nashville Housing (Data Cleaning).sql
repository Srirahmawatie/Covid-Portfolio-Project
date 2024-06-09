--Data Cleaning in SQL


SELECT * FROM NashvileHousing

SELECT SaleDate 
FROM NashvileHousing

--converting the saledate into date type

SELECT SaleDate, CONVERT(Date, SaleDate) 
FROM NashvileHousing


--Updating the column using the new values

UPDATE NashvileHousing
SET SaleDate = CONVERT(Date, SaleDate)

SELECT SaleDate 
FROM NashvileHousing

--or we can add the new column using alter table

ALTER TABLE NashvileHousing
add SaleDate_1 date;

UPDATE NashvileHousing
SET SaleDate_1 = CONVERT(Date, SaleDate)


SELECT SaleDate_1, CONVERT(Date, SaleDate) 
FROM NashvileHousing


--working on the property adress

select PropertyAddress 
FROM NashvileHousing
where PropertyAddress is null


select * from NashvileHousing
order by ParcelID

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress 
from NashvileHousing a
join NashvileHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

--use isnull to check the null column

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from NashvileHousing as a
join NashvileHousing as b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


update a
set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from NashvileHousing as a
join NashvileHousing as b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


--breaking out address into individual column(address, city, state)

select PropertyAddress
from NashvileHousing
order by ParcelID


SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address
from NashvileHousing

--create 2 new columns

ALTER TABLE NashvileHousing
ADD Propertysplitaddress Nvarchar(255);

update NashvileHousing
set Propertysplitaddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )

ALTER TABLE NashvileHousing
ADD Propertysplitcity Nvarchar(255);

update NashvileHousing
set Propertysplitcity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

 
select * from NashvileHousing


--the owner address using parse name


select OwnerAddress
from NashvileHousing


select
PARSENAME(replace(OwnerAddress, ',', '.'), 1)
from NashvileHousing


--its doing backwards

select
PARSENAME(replace(OwnerAddress, ',', '.'), 3)
,PARSENAME(replace(OwnerAddress, ',', '.'), 2)
,PARSENAME(replace(OwnerAddress, ',', '.'), 1)
from NashvileHousing


--now lets add the columns

alter table NashvileHousing
add ownersplitaddress Nvarchar (255);


update NashvileHousing
set ownersplitaddress = PARSENAME(replace(OwnerAddress, ',', '.'), 3)


alter table NashvileHousing
add ownersplitcity Nvarchar (255);


update NashvileHousing
set ownersplitcity = PARSENAME(replace(OwnerAddress, ',', '.'), 2)


alter table NashvileHousing
add ownersplitstate Nvarchar (255);


update NashvileHousing
set ownersplitstate = PARSENAME(replace(OwnerAddress, ',', '.'), 1)


Select *
From NashvileHousing



--changing the value on soldasvacant colum from y or n to yes or no


select distinct(SoldAsVacant), COUNT(SoldAsVacant)
from NashvileHousing
group by SoldAsVacant
order by 2

select SoldAsVacant,
case when SoldAsVacant = 'Y' then 'Yes'
	 when SoldAsVacant = 'N' then 'No'
	 else SoldAsVacant
	 end
from NashvileHousing


update NashvileHousing
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
	 when SoldAsVacant = 'N' then 'No'
	 else SoldAsVacant
	 end


--remove the duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From NashvileHousing
--order by ParcelID
)
--Select *, using select first to see the data and then delete
delete
From RowNumCTE
Where row_num > 1
--Order by PropertyAddress

--delete unused columns we have changed earlier


select * from NashvileHousing


ALTER TABLE NashvileHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

