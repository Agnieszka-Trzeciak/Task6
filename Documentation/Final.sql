Procedure Final
	Procedure that combines all generation of the fake user data, as well as creation of Dummy_Limited table, and deletion of unnecessery temporary tables. 
Arguments:
	N 			- number of users to generate,
	Seed_Arg 	- random variable seed,
	locale_arg 	- 'PL' or 'ENG' locale of the fake person,
	gender_arg	- 'F' or 'M' gender of the fake person.

DELIMITER \\ CREATE PROCEDURE Final (
  N int, 
  Seed_arg int, 
  locale_arg varchar(5), 
  gender_arg char(1)
) BEGIN 
DROP 
  TABLE IF EXISTS Dummy_Limited;
CREATE TABLE Dummy_Limited (col int) AS 
SELECT 
  * 
FROM 
  dummy 
LIMIT 
  N;
CALL Get_First_Name(Seed_arg, locale_arg, gender_arg);
CALL Get_Middle_Name(Seed_arg, locale_arg, gender_arg);
CALL Get_Last_Name(Seed_arg, locale_arg, gender_arg);
Call Combine_Names(Seed_arg, locale_arg, gender_arg);
DROP 
	TABLE IF EXISTS TEMP_First_Names;
DROP 
	TABLE IF EXISTS TEMP_Last_Names;
DROP 
	TABLE IF EXISTS TEMP_Middle_Names;
DROP 
	TABLE IF EXISTS TEMP_Phone_and_Phys;
DROP 
	TABLE IF EXISTS TEMP_Name_and_Email;
DROP 
	TABLE IF EXISTS TEMP_Address;
DROP 
  TABLE IF EXISTS TEMP_First_Names;
DROP 
  TABLE IF EXISTS TEMP_Last_Names;
DROP 
  TABLE IF EXISTS TEMP_Middle_Names;
CALL Get_Phone_and_Phys(Seed_arg, locale_arg, gender_arg);
CALL Get_Address(Seed_arg, locale_arg, gender_arg);
CALL Get_Result(Seed_arg, locale_arg, gender_arg);
DROP 
  TABLE IF EXISTS TEMP_Phone_and_Phys;
DROP 
  TABLE IF EXISTS TEMP_Address;
DROP 
  TABLE IF EXISTS TEMP_Name_and_Email;
DROP 
  TABLE IF EXISTS Dummy_Limited;
END \\ DELIMITER;

