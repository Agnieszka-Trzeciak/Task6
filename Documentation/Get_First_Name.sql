Procedure Get_First_Name 
	Creates a table with first name of the fake person
Arguments:
	Seed_Arg 	- random variable seed,
	locale_arg 	- 'PL' or 'ENG' locale of the fake person,
	gender_arg	- 'F' or 'M' gender of the fake person.
Notes:
	Requires prior creation of Dummy_Limited table for size defining


DELIMITER \\ CREATE PROCEDURE Get_First_Name (
  Seed_arg int, 
  locale_arg varchar(5), 
  gender_arg char(1)
) BEGIN CREATE TABLE TEMP_First_Names (
  ID int, 
  First_Name Varchar(255)
) AS (
  SELECT 
    ROW_NUMBER() OVER() AS ID, 
    First_Name 
  FROM 
    (
      select 
        1 + FLOOR(
          RAND(Seed_arg + 13)*(
            SELECT 
              COUNT(*) 
            FROM 
              first_names 
            WHERE 
              locale = locale_arg 
              AND gender = gender_arg
          )
        ) as RAND_ID_FN 
      from 
        Dummy_Limited
    ) AS random_select_FN 
    LEFT JOIN (
      SELECT 
        First_Name, 
        ROW_NUMBER() over () as Temp_ID_FN 
      FROM 
        first_names 
      WHERE 
        locale = locale_arg 
        AND gender = gender_arg
    ) AS names_list_FN ON random_select_FN.RAND_ID_FN = names_list_FN.Temp_ID_FN
);
END \\ DELIMITER;