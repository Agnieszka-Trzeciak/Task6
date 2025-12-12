Procedure Get_Last_Name 
	Creates a table with last name of the fake person.
Arguments:
	Seed_Arg 	- random variable seed,
	locale_arg 	- 'PL' or 'ENG' locale of the fake person,
	gender_arg	- 'F' or 'M' gender of the fake person.
Notes:
	Requires prior creation of Dummy_Limited table for size defining


DELIMITER \\ CREATE PROCEDURE Get_Last_Name (
  Seed_arg int, 
  locale_arg varchar(5), 
  gender_arg char(1)
) BEGIN CREATE TABLE TEMP_Last_Names (
  ID int, 
  Last_Name Varchar(255)
) AS (
  SELECT 
    ROW_NUMBER() OVER() AS ID, 
    Last_Name 
  FROM 
    (
      select 
        1 + FLOOR(
          RAND(Seed_arg + 14)*(
            SELECT 
              COUNT(*) 
            FROM 
              last_names 
            WHERE 
              locale = locale_arg 
              AND (
                gender = gender_arg 
                or gender = 'N'
              )
          )
        ) as RAND_ID_LN 
      from 
        Dummy_Limited
    ) AS random_select_LN 
    LEFT JOIN (
      SELECT 
        Last_Name, 
        ROW_NUMBER() over () as Temp_ID_LN 
      FROM 
        last_names 
      WHERE 
        locale = locale_arg 
        AND (
          gender = gender_arg 
          or gender = 'N'
        )
    ) AS names_list_LN ON random_select_LN.RAND_ID_LN = names_list_LN.Temp_ID_LN
);
END \\ DELIMITER;