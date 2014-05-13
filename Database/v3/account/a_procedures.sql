

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
select count(*) into i from T_ACCOUNT where T_ACCOUNT.USERNAME = username;
IF i < 1 Then
	INSERT INTO T_ACCOUNT (USERNAME, PASSWRD, ACTIVE)VALUES(username, pwd, false);	
	
	select ACC_ID into account_identification from T_ACCOUNT 
		where T_ACCOUNT.USERNAME = username and T_ACCOUNT.PASSWRD = pwd;
	
	INSERT INTO T_USERINFO(ACC_ID, FNAME, LNAME, STREET, ZIPCODE, CITY, PHONE, EMAIL) 
		VALUES (account_identification, firstname, lastname, street, postnr, city, phone, mail);
	

	INSERT INTO T_TO_BE_VALIDATED(ACC_ID, ENTRYDATE, CONFIRMATION_CODE) values(account_identification, now(), confirm);


END IF;


END $$
DELIMITER ;


DELIMITER $$
DROP PROCEDURE IF EXISTS getAccountInformation $$

create procedure getAccountInformation
(in acc_id integer)
modifies SQL DATA

BEGIN
declare i integer;

 select STREET, ZIPCODE, CITY, PHONE, EMAIL from T_USERINFO where T_USERINFO.ACC_ID = acc_id;

END $$
DELIMITER ;