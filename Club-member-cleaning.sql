--Retrieve all the data 
SELECT * FROM club_member_info;

--Make a copy of the dataset
SELECT * INTO ClubMemberCopy FROM club_member_info;

SELECT * FROM ClubMemberCopy;

-- Remove '???' from some names in the full_name column
UPDATE ClubMemberCopy
SET full_name = REPLACE(full_name,'???','')

/*Some names are not written in proper capitulation, we solve this problem by firstly making the first letter 
of all first names to be in capital letters and the remaining letters be in small letters*/

SELECT full_name,
		UPPER(SUBSTRING(full_name,1,1)) AS Name_UpperCase,
		LOWER(SUBSTRING(full_name, 2, CHARINDEX(' ', full_name) -1)) AS Remaining_part_of_first_name,
		CONCAT(UPPER(SUBSTRING(full_name,1,1)), LOWER(SUBSTRING(full_name, 2, CHARINDEX(' ', full_name) -1))) AS FirstNameProper
FROM ClubMemberCopy;

/*Next, we do the same for last names*/
SELECT full_name,
		SUBSTRING(full_name, CHARINDEX(' ', full_name) +1, LEN(full_name)) AS LastName,
		UPPER(LEFT(SUBSTRING(full_name, CHARINDEX(' ', full_name) +1, LEN(full_name)), 1)) AS First_letter_of_LN,
		LOWER(SUBSTRING(SUBSTRING(full_name, CHARINDEX(' ', full_name) +1, LEN(full_name)), 2, LEN(SUBSTRING(full_name, CHARINDEX(' ', full_name) +1, LEN(full_name))))),
		CONCAT(UPPER(LEFT(SUBSTRING(full_name, CHARINDEX(' ', full_name) +1, LEN(full_name)), 1)), LOWER(SUBSTRING(SUBSTRING(full_name, CHARINDEX(' ', full_name) +1, LEN(full_name)), 2, LEN(SUBSTRING(full_name, CHARINDEX(' ', full_name) +1, LEN(full_name)))))) AS LastNameProper
FROM ClubMemberCopy;

/*Now, we combine FirstNameProper and LastNameProper together*/
SELECT full_name,
		CONCAT(CONCAT(UPPER(SUBSTRING(full_name,1,1)), LOWER(SUBSTRING(full_name, 2, CHARINDEX(' ', full_name) -1))) , 
		CONCAT(UPPER(LEFT(SUBSTRING(full_name, CHARINDEX(' ', full_name) +1, LEN(full_name)), 1)), 
		LOWER(SUBSTRING(SUBSTRING(full_name, CHARINDEX(' ', full_name) +1, LEN(full_name)), 2, 
		LEN(SUBSTRING(full_name, CHARINDEX(' ', full_name) +1, LEN(full_name))))))) 
		AS FullName
FROM ClubMemberCopy;

SELECT * FROM ClubMemberCopy;

--Create a new column named FullName and populate it with the result above
ALTER TABLE ClubMemberCopy
ADD FullName  VARCHAR(50);

UPDATE ClubMemberCopy
SET FullName = CONCAT(CONCAT(UPPER(SUBSTRING(full_name,1,1)), LOWER(SUBSTRING(full_name, 2, CHARINDEX(' ', full_name) -1))) , 
		CONCAT(UPPER(LEFT(SUBSTRING(full_name, CHARINDEX(' ', full_name) +1, LEN(full_name)), 1)), 
		LOWER(SUBSTRING(SUBSTRING(full_name, CHARINDEX(' ', full_name) +1, LEN(full_name)), 2, 
		LEN(SUBSTRING(full_name, CHARINDEX(' ', full_name) +1, LEN(full_name)))))));

SELECT * FROM ClubMemberCopy;

--I have to delete the full_name column
ALTER TABLE ClubMemberCopy
DROP COLUMN full_name;

/*On exploring the marital status, I discovered that 'divorced' was written as 'divored', I have to correct this*/

SELECT DISTINCT martial_status
FROM ClubMemberCopy;

UPDATE ClubMemberCopy
SET martial_status = REPLACE (martial_status, 'divored', 'divorced');

SELECT * FROM ClubMemberCopy
WHERE martial_status IS NULL;

/*There are 20 members with NULL marital status, we have 4 categories of marital status. We shared them evenly 
on average of 5 to each category.*/

   --SINGLE: Constantin De la cruz, Nixie January, Danila Teague, Tyrone Shillum, Alfreda Roches
SELECT *		
FROM ClubMemberCopy
WHERE FullName IN ('Constantin De la cruz', 'Nixie January', 'Danila Teague', 'Tyrone Shillum', 'Alfreda Roches');

UPDATE ClubMemberCopy
SET martial_status = 'single'
WHERE FullName IN ('Constantin De la cruz', 'Nixie January', 'Danila Teague', 'Tyrone Shillum', 'Alfreda Roches')

--MARRIED : Prentiss Epton, Deny Grainger, Niccolo Crosser, Dusty Baccus, Conroy Hartil
UPDATE ClubMemberCopy
SET martial_status = 'married'
WHERE FullName IN ('Prentiss Epton', 'Deny Grainger', 'Niccolo Crosser', 'Dusty Baccus', 'Conroy Hartil');

SELECT *		
FROM ClubMemberCopy
WHERE FullName IN ('Prentiss Epton', 'Deny Grainger', 'Niccolo Crosser', 'Dusty Baccus', 'Conroy Hartil');

--SEPARATED : Marjy Rain, Nobie Boldero, Hilary Von helmholtz, Sunshine Dunbleton, Callean Corradini
UPDATE ClubMemberCopy
SET martial_status = 'separated'
WHERE FullName IN ('Marjy Rain', 'Nobie Boldero', 'Hilary Von helmholtz', 'Sunshine Dunbleton', 'Callean Corradini');

SELECT *		
FROM ClubMemberCopy
WHERE FullName IN ('Marjy Rain', 'Nobie Boldero', 'Hilary Von helmholtz', 'Sunshine Dunbleton', 'Callean Corradini');

--DIVORCED: Roxanne Yvon, Bunny Axon, Laure Frier, Gerry Gonnel, Junina Held
UPDATE ClubMemberCopy
SET martial_status = 'separated'
WHERE FullName IN ('Roxanne Yvon', 'Bunny Axon', 'Laure Frier', 'Gerry Gonnel', 'Junina Held')

SELECT *		
FROM ClubMemberCopy
WHERE FullName IN ('Roxanne Yvon', 'Bunny Axon', 'Laure Frier', 'Gerry Gonnel', 'Junina Held')

SELECT * 
FROM ClubMemberCopy
WHERE martial_status IS NULL; --All marital status issues are sorted!

SELECT * FROM ClubMemberCopy;

--Let's get the details of the first and the last registered members
	-- First registered member
SELECT *
FROM ClubMemberCopy
WHERE membership_date = (SELECT  MIN(membership_date)
							FROM ClubMemberCopy);

	-- Last registered member
SELECT *
FROM ClubMemberCopy
WHERE membership_date = (SELECT  MAX(membership_date)
							FROM ClubMemberCopy);

SELECT * FROM ClubMemberCopy;

--Exploring the age column to check for any irregularities
--Categorize members by age
SELECT DISTINCT age
FROM ClubMemberCopy;

--Some members ages are outliers
SELECT age,
		LEN(age) AS age_length
FROM ClubMemberCopy
WHERE LEN(age) > 2;

--The count of members with outliers
SELECT 
		COUNT(LEN(age)) AS age_length
FROM ClubMemberCopy
WHERE LEN(age) > 2;


-- Take only the first two digits of their age
SELECT age,
		LEN(age) AS age_length,
		LEFT( CAST(age AS VARCHAR),2) AS Real_Age
FROM ClubMemberCopy
WHERE LEN(age) > 2;

SELECT *
FROM ClubMemberCopy;


--Retrieve the first 2 digits of the age of all members
SELECT age,
		LEN(age) AS age_length,
		LEFT(CAST(age AS VARCHAR), 2) AS Real_Age
FROM ClubMemberInfo
WHERE LEN(age) > 2;

--Create new column 'Real_Age'
ALTER TABLE ClubMemberInfo
ADD Real_Age INT;

--Populate the 'Real_Age' column
UPDATE ClubMemberInfo
SET Real_Age = LEFT(CAST(age AS VARCHAR), 2);

--Retrieve the data relevant to our analysis
SELECT FullName, martial_status, Age, job_title, membership_date
FROM ClubMemberInfo;

		--EXPLORATORY DATA ANALYSIS
-- The total number of club members
SELECT 
	COUNT(*) AS TotalMembers
FROM ClubMemberInfo;

--Retrieve the ages of the oldest and the youngest member
SELECT MAX(Real_Age) As Oldest_member ,
		MIN(Real_Age) AS Youngest_member
FROM ClubMemberInfo;

--Get the count of members by age category
SELECT
	CASE 
		WHEN Real_Age <= 18 THEN 'Young Member'
		WHEN Real_Age BETWEEN 19 AND 59 THEN 'Adult Member'
		ELSE 'Senior Member'
	END AS AgeCategory,
	COUNT(*) AS AgeCatCount
FROM ClubMemberInfo
WHERE Real_Age IS NOT NULL
GROUP BY CASE 
		WHEN Real_Age <= 18 THEN 'Young Member'
		WHEN Real_Age BETWEEN 19 AND 59 THEN 'Adult Member'
		ELSE 'Senior Member'
	END
ORDER BY AgeCatCount DESC;

--Top 10 job title of members
SELECT TOP 10 job_title,
		COUNT(*) AS JobTitleCount
FROM ClubMemberInfo
WHERE job_title IS NOT NULL
GROUP BY job_title
ORDER BY JobTitleCount DESC;

--Members by marital status
SELECT martial_status,
		COUNT(*) AS Marital_status_count
FROM ClubMemberInfo
GROUP BY martial_status
ORDER BY Marital_status_count DESC;
