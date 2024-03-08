USE mydata;

-------------------------------------------------------------------------------------------------------
-- CONVERTING DATE TO DATE COLUMN
ALTER TABLE nashville_housing
Add converted_date DATE;

UPDATE nashville_housing
SET converted_date = STR_TO_DATE(SaleDate, '%M %e, %Y');

---------------------------------------------------------------------------------------------------------
-- POPULATE THE PROPERTY ADDRESS BY SPLITTING INTO ANOTHER COLUMN 

ALTER TABLE nashville_housing
Add Property_City varchar(50);
UPDATE nashville_housing
SET Property_City = SUBSTRING_INDEX(PropertyAddress, ',', -1);

ALTER TABLE nashville_housing
Add Property_split varchar(50);
UPDATE nashville_housing
SET Property_split = SUBSTRING_INDEX(PropertyAddress, ',', 1);

----------------------------------------------------------------------------------------------
-- POPULATE THE OWNERADDRESS BY SPLITTING INTO COLUMNS ALSO

ALTER TABLE nashville_housing
Add OwnerAddress_split varchar(50);
UPDATE nashville_housing
SET OwnerAddress_split = SUBSTRING_INDEX(OwnerAddress, ',', 1);

ALTER TABLE nashville_housing
Add OwnerState_split varchar(50);
UPDATE nashville_housing
SET OwnerState_split = SUBSTRING_INDEX(OwnerAddress, ',', -1);

-----------------------------------------------------------------------------------
-- CHANGE Y AND N IN THE SOLD TO VACANT FIELD

UPDATE nashville_housing
SET SoldAsVacant ='Yes'
WHERE SoldAsVacant = 'Y';

UPDATE nashville_housing
SET SoldAsVacant ='No'
WHERE SoldAsVacant = 'N';

-------------------------------------------------------------------------------------
-- REMOVE DUPLICATE

DELETE 
FROM nashville_housing 
WHERE (ParcelID, PropertyAddress, SalePrice, OwnerAddress) 
    IN (
        SELECT ParcelID, PropertyAddress, SalePrice, OwnerAddress
        FROM (
            SELECT ParcelID, PropertyAddress, SalePrice, OwnerAddress,
                   ROW_NUMBER() OVER (PARTITION BY ParcelID) AS row_num
            FROM nashville_housing
        ) AS numbered_rows
        WHERE row_num > 1
    );

    
    -------------------------------------------------------------------------------------------------
    -- DELETING REDUNDANT COLUMN
    ALTER TABLE nashville_housing
    DROP COLUMN PropertyAddress,
    DROP COLUMN OwnerAddress
    

