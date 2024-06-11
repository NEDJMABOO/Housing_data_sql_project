SELECT *
FROM portfolioproject.dbo.[Nashville Housing Data for Data Cleaning (reuploaded) (3)]

--populate property address

select PropertyAddress
FROM portfolioproject.dbo.[Nashville Housing Data for Data Cleaning (reuploaded) (3)]
where PropertyAddress is not null 
order by ParcelID

select a.ParcelID, a.PropertyAddress,b.ParcelID,b.PropertyAddress,isnull(a.PropertyAddress ,b.PropertyAddress)
from portfolioproject.dbo.[Nashville Housing Data for Data Cleaning (reuploaded) (3)] a
join portfolioproject.dbo.[Nashville Housing Data for Data Cleaning (reuploaded) (3)] b
      on a.ParcelID = b.ParcelID
	  and a.[UniqueID ]<>b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress ,b.PropertyAddress)
FROM portfolioproject.dbo.[Nashville Housing Data for Data Cleaning (reuploaded) (3)] a
join portfolioproject.dbo.[Nashville Housing Data for Data Cleaning (reuploaded) (3)] b
      on a.ParcelID = b.ParcelID
	  and a.[UniqueID ]<>b.[UniqueID ]
WHERE a.PropertyAddress IS NULL



--breaking out into individual column 

SELECT 
    SUBSTRING(PropertyAddress, 1, NULLIF(CHARINDEX(',', PropertyAddress) - 1, -1)) AS address_part1,
    SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) AS address_part2
FROM 
    portfolioproject.dbo.[Nashville Housing Data for Data Cleaning (reuploaded) (3)];

alter table [Nashville Housing Data for Data Cleaning (reuploaded) (3)]
add prsplitaddress nvarchar (255)

update [Nashville Housing Data for Data Cleaning (reuploaded) (3)]
set prsplitaddress = SUBSTRING(PropertyAddress, 1, NULLIF(CHARINDEX(',', PropertyAddress) - 1, -1))

alter table [Nashville Housing Data for Data Cleaning (reuploaded) (3)]
add presplitcity nvarchar (255)

update [Nashville Housing Data for Data Cleaning (reuploaded) (3)]
set presplitcity =  SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) 


select *
from portfolioproject.dbo.[Nashville Housing Data for Data Cleaning (reuploaded) (3)]



select 
parsename (replace (OwnerAddress, ',' ,'.' ),3)
, parsename (replace (OwnerAddress, ',' ,'.' ),2)
, parsename (replace (OwnerAddress, ',' ,'.' ),1)
from portfolioproject.dbo.[Nashville Housing Data for Data Cleaning (reuploaded) (3)]

alter table [Nashville Housing Data for Data Cleaning (reuploaded) (3)]
add Ownerddress nvarchar (255)

update [Nashville Housing Data for Data Cleaning (reuploaded) (3)]
set Ownerddress = parsename (replace (OwnerAddress, ',' ,'.' ),3)

alter table [Nashville Housing Data for Data Cleaning (reuploaded) (3)]
add ownercity nvarchar (255)

update [Nashville Housing Data for Data Cleaning (reuploaded) (3)]
set ownercity = parsename (replace (OwnerAddress, ',' ,'.' ),2) 

select*
FROM portfolioproject.dbo.[Nashville Housing Data for Data Cleaning (reuploaded) (3)]

SELECT Distinct (SoldAsVacant), count(SoldAsVacant)
FROM portfolioproject.dbo.[Nashville Housing Data for Data Cleaning (reuploaded) (3)]
group by SoldAsVacant
order by 2



SELECT 
    SoldAsVacant,
    CASE 
        WHEN SoldAsVacant = 'Y' THEN 'Yes'
        WHEN SoldAsVacant = 'N' THEN 'No'
        ELSE SoldAsVacant
    END 
FROM 
    portfolioproject.dbo.[Nashville Housing Data for Data Cleaning (reuploaded) (3)];

update [Nashville Housing Data for Data Cleaning (reuploaded) (3)]
set SoldAsVacant =
    CASE 
        WHEN SoldAsVacant = 'Y' THEN 'Yes'
        WHEN SoldAsVacant = 'N' THEN 'No'
        ELSE SoldAsVacant
    END 
FROM 
    portfolioproject.dbo.[Nashville Housing Data for Data Cleaning (reuploaded) (3)];

--remove duplicate 

WITH RowNumCTE AS (
SELECT*,
    ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
                 SalePrice,
				 SaleDate,
				 LegalReference
				 order by 
				     UniqueID
					 ) row_num 
FROM 
    portfolioproject.dbo.[Nashville Housing Data for Data Cleaning (reuploaded) (3)]
--order by ParcelID
)
DELETE 
FROM RowNumCTE
where row_num > 1
--order by ParcelID




--DELETE COLUMN 

SELECT * 
FROM portfolioproject.dbo.[Nashville Housing Data for Data Cleaning (reuploaded) (3)]

alter  table portfolioproject.dbo.[Nashville Housing Data for Data Cleaning (reuploaded) (3)]
drop column TaxDistrict 
