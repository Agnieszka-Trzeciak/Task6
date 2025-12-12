Procedure Combine_Names 
	Combines tables for first, middle and last names. Adds optional title to the person, as well as generating email address based on the first and last name.
Arguments:
	Seed_Arg 	- random variable seed,
	locale_arg 	- 'PL' or 'ENG' locale of the fake person,
	gender_arg	- 'F' or 'M' gender of the fake person.
Notes:
	Requires prior creation of TEMP_First_Names, TEMP_Middle_Names and TEMP_Last_Names via procedures Get_First_Name, Get_Middle_Name and Get_Last_Name.

DELIMITER \\ CREATE PROCEDURE Combine_Names (
  Seed_arg int, 
  locale_arg varchar(5), 
  gender_arg char(1)
) BEGIN CREATE TABLE TEMP_Name_and_Email (
  Full_Name Varchar(255), 
  Email Varchar(255)
) 
SELECT 
  TEMP_First_Names.ID, 
  CONCAT(
    IF(
      RAND(Seed_arg + 40)> 0.3, 
      '', 
      IF(
        locale_arg = 'PL', 
        IF(gender_arg = 'M', 'Pan ', 'Pani '), 
        IF(
          gender_arg = 'M', 
          'Mr ', 
          IF(
            RAND(Seed_arg + 42)< 0.4, 
            'Mrs ', 
            'Ms '
          )
        )
      )
    ), 
    First_Name, 
    Middle_Name, 
    ' ', 
    Last_Name
  ) as Full_Name, 
  CONCAT(
    IF(
      RAND(Seed_arg + 23) < 0.5, 
      fn_remove_polish_accents(First_Name), 
      fn_remove_polish_accents(Last_Name)
    ), 
    IF(
      RAND(Seed_arg + 24) < 0.7, 
      '.', 
      IF(
        RAND(Seed_arg + 24) < 0.75, 
        '', 
        '_'
      )
    ), 
    IF(
      RAND(Seed_arg + 23) >= 0.5, 
      fn_remove_polish_accents(First_Name), 
      fn_remove_polish_accents(Last_Name)
    ), 
    IF(
      RAND(Seed_arg + 25) < 0.4, 
      floor(
        RAND(Seed_arg + 26)* 1000
      ), 
      ''
    ), 
    IF(
      RAND(Seed_arg + 22) < 0.4, 
      '@gmail.com', 
      IF(
        RAND(Seed_arg + 22) < 0.6, 
        '@yahoo.com', 
        IF(
          RAND(Seed_arg + 22) < 0.8, 
          '@outlook.com', 
          '@iCloud.com'
        )
      )
    )
  ) AS Email 
FROM 
  TEMP_First_Names 
  INNER JOIN TEMP_Last_Names ON TEMP_First_Names.ID = TEMP_Last_Names.ID 
  INNER JOIN TEMP_Middle_Names ON TEMP_First_Names.ID = TEMP_Middle_Names.ID;
END \\ DELIMITER;
