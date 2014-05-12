

DELIMITER $$
DROP PROCEDURE IF EXISTS addAccount $$

create procedure addAccount
(in username VARCHAR(64),in pwd VARCHAR(128),in firstname VARCHAR(64), in lastname VARCHAR(64),
 in street varchar(64),in postnr VARCHAR(5), in city varchar(32), 
 in mail varchar(64), in phone varchar(16), in confirm varchar(32))
modifies SQL DATA

BEGIN
declare i integer;
declare account_identification integer;
select count(*) into i from T_ACCOUNT where T_ACCOUNT.username = username;
IF i < 1 Then
	INSERT INTO T_ACCOUNT (username, passwrd, active)VALUES(username, pwd, false);	
	
	select acc_id into account_identification from T_ACCOUNT 
		where T_ACCOUNT.username = username and T_ACCOUNT.passwrd = pwd;
	
	INSERT INTO T_USERINFO(acc_id, FNAME, LNAME, STREET, ZIPCODE, CITY, PHONE, EMAIL) 
		VALUES (account_identification, firstname, lastname, street, postnr, city, phone, mail);
	

	INSERT INTO T_TO_BE_VALIDATED(acc_id, entrydate, confirmationcode) values(account_identification, now(), confirm);


END IF;


END $$
DELIMITER ;

#INIT BASESTATATION LÄGGER TILL BASSTATIONS ID
#
#
#Skapa lägg till basstation, den ska få ett ID, all information i BASESTATION_INFO och ett ACCOUNT ska kopplas till
#
#
#
#
#
#


DELIMITER $$
DROP PROCEDURE IF EXISTS registerBasestation $$

create procedure registerBasestation
(in BS_ID bigint, in ACC integer, in BASE_NAME varchar(32), in STREET varchar(32), in ZIPCODE varchar(32), in CITY varchar(32))
modifies SQL DATA

BEGIN
declare i integer;
select count(*) into i from T_BASESTATION where T_BASESTATION.BASE_ID = BS_ID and T_BASESTATION.acc_id is NULL;
IF i > 0 Then
	UPDATE T_BASESTATION SET acc_id = ACC where T_BASESTATION.BASE_ID = BS_ID;	
	INSERT INTO T_BASESTATION_INFO(BS_ID, BASE_NAME, STREET, ZIP, CITY) values(BS_ID, BASE_NAME, STREET, ZIPCODE, CITY);

END IF;
END $$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS addData $$

create procedure addData
(in BASE_ID bigint, in END_DEV varchar(32), in SEN_ID integer, in SEN_TYPE integer, in DATALOAD varchar(32))
modifies SQL DATA

BEGIN
declare base integer;
declare endd integer;
declare sen	integer;
select count(*) into base from T_BASESTATION where T_BASESTATION.BASE_ID = BASE_ID and T_BASESTATION.acc_id is not null;
IF base > 0 then
	select count(*) into endd from T_END_DEVICE where T_END_DEVICE.DEV_ID = END_DEV; 
	IF endd > 0 then
		select count(*) into sen from T_SENSOR where T_SENSOR.SENSOR_ID = SEN_ID;
	 	IF sen > 0 then
			INSERT INTO T_SENSOR_DATA(SEN_ID, DEV_ID, DATA_TIME, SEN_DATA) 
				values(SEN_ID, END_DEV, now(), DATALOAD);
		ELSE
			INSERT INTO T_SENSOR(SENSOR_ID, DEV_ID, SEN_TYPE, DEV_NAME)
				values(SEN_ID, END_DEV, SEN_TYPE, 'noname');
			INSERT INTO T_SENSOR_DATA(SEN_ID, DEV_ID, DATA_TIME, SEN_DATA) 
				values(SEN_ID, END_DEV, now(), DATALOAD);
				
	 	END IF;

	 	ELSE
	 		INSERT INTO T_END_DEVICE(DEV_NAME, BS_ID, devname)
	 			values (END_DEV, BASE_ID, 'noname')
			INSERT INTO T_SENSOR(SENSOR_ID, DEV_ID, SEN_TYPE, DEV_NAME)
				values(SEN_ID, END_DEV, SEN_TYPE, 'noname');
			INSERT INTO T_SENSOR_DATA(SEN_ID, DEV_ID, DATA_TIME, SEN_DATA) 
				values(SEN_ID, END_DEV, now(), DATALOAD);
	END IF;
END IF;
END $$
DELIMITER ;



