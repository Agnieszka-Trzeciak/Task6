Procedure Get_Address
	Creates a table with full address of a fake user.
Arguments:
	Seed_Arg 	- random variable seed,
	locale_arg 	- 'PL' or 'ENG' locale of the fake person,
	gender_arg	- 'F' or 'M' gender of the fake person.
Notes:
	Requires prior creation of Dummy_Limited table for size defining.

DELIMITER \\ CREATE PROCEDURE Get_Address (
  Seed_arg int, 
  locale_arg varchar(5), 
  gender_arg char(1)
) BEGIN CREATE TABLE TEMP_Address (
  Address varchar(255)
) 
SELECT 
  STREET.STREET_ID AS ID, 
  CONCAT(Street, CITY) AS Address 
FROM 
  (
    SELECT 
      row_number() over() as STREET_ID, 
      IF(
        locale_arg = 'PL', 
        Concat(
          IF(
            RAND(Seed_arg + 16)< 0.3, 
            'ul ', 
            IF(
              RAND(Seed_arg + 16)< 0.8, 
              'ul. ', 
              'ulica '
            )
          ), 
          street_name, 
          ' ', 
          round(
            RAND(Seed_arg + 17)* 75
          ), 
          ', '
        ), 
        CONCAT(
          IF(
            RAND(Seed_arg + 20)< 0.6, 
            '', 
            IF(
              RAND(Seed_arg + 20)< 0.9, 
              'Apt. ', 
              'Suite '
            )
          ), 
          FLOOR(
            RAND(Seed_arg + 21)* 1000
          ), 
          ' ', 
          street_name, 
          ', '
        )
      ) as Street 
    from 
      (
        select 
          1 + FLOOR(
            RAND(Seed_arg + 17)*(
              SELECT 
                COUNT(*) 
              FROM 
                street_names 
              WHERE 
                locale = locale_arg
            )
          ) as RAND_ID_street 
        from 
          dummy_Limited
      ) as random_select_streets 
      left join (
        select 
          street_name, 
          row_number() over() as Temp_ID_streets 
        from 
          street_names 
        where 
          locale = locale_arg
      ) as streets_temp ON random_select_streets.RAND_ID_street = streets_temp.Temp_ID_streets
  ) as STREET 
  INNER JOIN (
    SELECT 
      row_number() over() as CITY_ID, 
      IF(
        locale_arg = 'PL', 
        Concat(
          IF(
            RAND(Seed_arg + 18)< 0.3, 
            CONCAT(
              floor(
                RAND(Seed_arg + 19)* 89 + 10
              ), 
              '-', 
              MOD(
                floor(
                  RAND(Seed_arg + 19)* 10000
                ), 
                900
              )+ 100, 
              ' '
            ), 
            ''
          ), 
          City_name, 
          ' ', 
          Concat(
            IF(
              RAND(Seed_arg + 18)>= 0.3, 
              CONCAT(
                floor(
                  RAND(Seed_arg + 19)* 89 + 10
                ), 
                '-', 
                MOD(
                  floor(
                    RAND(Seed_arg + 19)* 10000
                  ), 
                  900
                )+ 100, 
                ' '
              ), 
              ''
            )
          )
        ), 
        Concat(
          City_name, 
          ' ', 
          FLOOR(
            RAND(Seed_arg + 19)* 89999 + 10000
          ), 
          IF(
            RAND(Seed_arg + 18)< 0.4, 
            CONCAT(
              '-', 
              FLOOR(
                RAND(Seed_arg + 19)* 8999 + 1000
              )
            ), 
            ''
          )
        )
      ) AS CITY 
    FROM 
      (
        select 
          1 + FLOOR(
            RAND(Seed_arg + 19)*(
              SELECT 
                COUNT(*) 
              FROM 
                cities 
              WHERE 
                locale = locale_arg
            )
          ) as RAND_ID_city 
        from 
          dummy_Limited
      ) as random_select_cities 
      LEFT JOIN (
        SELECT 
          City_name, 
          ROW_NUMBER() over () as Temp_ID_cities 
        from 
          cities 
        where 
          locale = locale_arg
      ) AS cities_temp ON random_select_cities.RAND_ID_city = cities_temp.Temp_ID_cities
  ) as CITY2 ON STREET.STREET_ID = CITY2.CITY_ID;
END \\ DELIMITER;