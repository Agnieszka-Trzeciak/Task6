Procedure Get_Middle_Name 
	Creates a table with middle name of the fake person. There is 30% chance a user will have a middle name.
Arguments:
	Seed_Arg 	- random variable seed,
	locale_arg 	- 'PL' or 'ENG' locale of the fake person,
	gender_arg	- 'F' or 'M' gender of the fake person.
Notes:
	Requires prior creation of Dummy_Limited table for size defining


DELIMITER \\ CREATE PROCEDURE Get_Middle_Name (
  Seed_arg int, 
  locale_arg varchar(5), 
  gender_arg char(1)
) BEGIN CREATE TABLE TEMP_Middle_Names (
  ID int, 
  Middle_Name Varchar(255)
) AS (
  SELECT 
    ROW_NUMBER() OVER() AS ID, 
    IF(
      RAND(Seed_arg + 51)< 0.3, 
      CONCAT(' ', First_Name), 
      ''
    ) as Middle_Name 
  FROM 
    (
      select 
        1 + FLOOR(
          RAND(Seed_arg + 50)*(
            SELECT 
              COUNT(*) 
            FROM 
              first_names 
            WHERE 
              locale = locale_arg 
              AND gender = gender_arg
          )
        ) as RAND_ID_MN 
      from 
        Dummy_Limited
    ) AS random_select_MN 
    LEFT JOIN (
      SELECT 
        First_Name, 
        ROW_NUMBER() over () as Temp_ID_MN 
      FROM 
        first_names 
      WHERE 
        locale = locale_arg 
        AND gender = gender_arg
    ) AS names_list_MN ON random_select_MN.RAND_ID_MN = names_list_MN.Temp_ID_MN
);
END \\ DELIMITER;