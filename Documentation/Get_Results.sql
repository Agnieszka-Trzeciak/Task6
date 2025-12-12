Procedure Get_Result
	Displays the results of generation of fake user data by joining previously generated tables. 
Arguments:
	Seed_Arg 	- random variable seed,
	locale_arg 	- 'PL' or 'ENG' locale of the fake person,
	gender_arg	- 'F' or 'M' gender of the fake person.
Notes:
	Requires prior creation of TEMP_Name_and_Email via procedure Combine_Names, TEMP.Address via Get_Address and TEMP_Phone_and_Phys via Get_Phone_and_Phys.

DELIMITER \\ CREATE PROCEDURE Get_Result (
  Seed_arg int, 
  locale_arg varchar(5), 
  gender_arg char(1)
) BEGIN 
SELECT 
  TEMP_Address.ID, 
  Full_Name, 
  Address, 
  Location, 
  Height, 
  Weight, 
  Eye_color, 
  Phone, 
  Email 
FROM 
  TEMP_Address 
  INNER JOIN TEMP_Name_and_Email ON TEMP_Address.ID = TEMP_Name_and_Email.ID 
  INNER JOIN TEMP_Phone_and_Phys ON TEMP_Address.ID = TEMP_Phone_and_Phys.ID;
END \\ DELIMITER;