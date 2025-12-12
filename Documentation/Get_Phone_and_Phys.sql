Procedure Get_Phone_and_Phys
	Creates a table with Phone number, Height, Weight, Location on the globe and eye color of the fake person.
Arguments:
	Seed_Arg 	- random variable seed,
	locale_arg 	- 'PL' or 'ENG' locale of the fake person,
	gender_arg	- 'F' or 'M' gender of the fake person.
Notes:
	Requires prior creation of Dummy_Limited table for size defining.
	Height generated using normal distribution generated via Box-Muller transform. Calcuation based on the data for Swiss conscripts and general population.
	Weight generated using normal distribution generated via Box-Muller transform. Calculation based on ideal weight formula of Hamwi method, with additional normal variance component of std 15 kg.
	Eye color generated using data suggesting a prevelance of brown and blue eye colors.
	Location generated uniformly using latitude and longitude.

DELIMITER \\ CREATE PROCEDURE Get_Phone_and_Phys (
  Seed_arg int, 
  locale_arg varchar(5), 
  gender_arg char(1)
) BEGIN CREATE TABLE TEMP_Phone_and_Phys (
  ID int, 
  Phone varchar(255), 
  Height int, 
  Location varchar(255), 
  Weight int, 
  Eye_Color varchar(255)
) 
SELECT 
  ROW_NUMBER() OVER () as ID, 
  IF (
    locale_arg = 'ENG', 
    CONCAT(
      IF (
        RAND(Seed_arg + 7)< 0.3, 
        '(', 
        ''
      ), 
      floor(
        RAND(Seed_arg + 4)* 899
      )+ 100, 
      IF (
        RAND(Seed_arg + 7)< 0.3, 
        ')', 
        ''
      ), 
      IF (
        RAND(Seed_arg + 3)< 0.1, 
        '-', 
        ' '
      ), 
      floor(
        RAND(Seed_arg + 5)* 899
      )+ 100, 
      IF (
        RAND(Seed_arg + 3)< 0.5, 
        '-', 
        ' '
      ), 
      floor(
        RAND(Seed_arg + 6)* 8999
      )+ 1000
    ), 
    CONCAT(
      floor(
        RAND(Seed_arg + 4)* 899
      )+ 100, 
      IF (
        RAND(Seed_arg + 3)< 0.5, 
        '-', 
        ' '
      ), 
      floor(
        RAND(Seed_arg + 5)* 899
      )+ 100, 
      IF (
        RAND(Seed_arg + 3)< 0.5, 
        '-', 
        ' '
      ), 
      floor(
        RAND(Seed_arg + 6)* 899
      )+ 100
    )
  ) AS Phone, 
  Height, 
  concat(
    IF(
      RAND(Seed_arg + 30)> 0.5, 
      'N ', 
      'S '
    ), 
    round(
      rand(Seed_arg + 8)* 90
    ), 
    '°', 
    round(
      rand(Seed_arg + 9)* 60
    ), 
    '', 
    IF(
      RAND(Seed_arg + 31)> 0.5, 
      ' E ', 
      ' W '
    ), 
    round(
      rand(Seed_arg + 10)* 180
    ), 
    '°', 
    round(
      rand(Seed_arg + 11)* 60
    ), 
    ''
  ) AS Location, 
  ROUND(
    IF(gender_arg = 'F',-4.5, 0)+ 50 + 0.9 *(Height - 152)+ 15 * SQRT(
      -2 * LOG(
        RAND(Seed_arg)
      )
    )* SIN(
      2 * PI()* RAND(Seed_arg + 1)
    )
  ) AS Weight, 
  Eye_Color 
FROM 
  (
    SELECT 
      round(
        (
          165 + 6 * SQRT(
            -2 * LOG(
              RAND(Seed_arg)
            )
          )* COS(
            2 * PI()* RAND(Seed_arg + 1)
          )
        ) * IF(gender_arg = 'M', 1.08, 1)
      ) as Height, 
      IF(
        RAND(Seed_arg + 15)< 0.7, 
        'Brown', 
        IF(
          RAND(Seed_arg + 15)< 0.9, 
          'Blue', 
          IF(
            RAND(Seed_arg + 15)< 0.95, 
            'Green', 
            'Gray'
          )
        )
      ) AS Eye_color 
    FROM 
      dummy_Limited
  ) AS Height_And_Eyes;
END \\ DELIMITER;