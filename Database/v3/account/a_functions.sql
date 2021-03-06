#DESSA FUNKTIONER ÄR TESTADE OCH KLARA

DROP FUNCTION IF EXISTS loggin;
DELIMITER $$
CREATE FUNCTION loggin(username varchar(32), passwrd varchar(32))
  RETURNS boolean
  LANGUAGE SQL -- This element is optional and will be omitted from subsequent examples
begin 
	declare k integer DEFAULT 0;
	
	SELECT count(*) INTO k FROM T_ACCOUNT 
		where T_ACCOUNT.USERNAME = username and T_ACCOUNT.PASSWRD = passwrd and T_ACCOUNT.ACTIVE = true;
	
	IF k = 0 THEN 
		return -1;
	ELSE
		SELECT T_ACCOUNT.ACC_ID INTO k FROM T_ACCOUNT 
			where T_ACCOUNT.USERNAME = username and T_ACCOUNT.PASSWRD = passwrd and T_ACCOUNT.ACTIVE = true;
		return k;
END IF;	

END;
$$
DELIMITER ;

#TESTAD OCH KLAR
DROP FUNCTION IF EXISTS verify;
DELIMITER $$
CREATE FUNCTION verify(confirmation varchar(32))
  RETURNS boolean
  LANGUAGE SQL -- This element is optional and will be omitted from subsequent examples
begin 
	declare k integer DEFAULT 0;
	declare uname varchar(64);
	declare account_id integer;
	SELECT count(*) into k FROM T_TO_BE_VALIDATED where T_TO_BE_VALIDATED.CONFIRMATION_CODE = confirmation;

	IF k = 0 THEN 
		return FALSE;
	ELSE
		select ACC_ID into account_id FROM T_TO_BE_VALIDATED 
			where T_TO_BE_VALIDATED.CONFIRMATION_CODE = confirmation;
		delete from T_TO_BE_VALIDATED where T_TO_BE_VALIDATED.ACC_ID = account_id;
		
		update T_ACCOUNT SET ACTIVE = true where ACC_ID = account_id;
		return TRUE;
END IF;	
END;
$$
DELIMITER ;


#Testad och fungerar
DROP FUNCTION IF EXISTS userExists;
DELIMITER $$
CREATE FUNCTION userExists(username varchar(32))
  RETURNS boolean
  LANGUAGE SQL -- This element is optional and will be omitted from subsequent examples
begin 
	declare k integer DEFAULT 0;
	SELECT count(*) into k FROM T_ACCOUNT where T_ACCOUNT.USERNAME = username;

	IF k = 0 THEN 
		return FALSE;
	ELSE
		return TRUE;
END IF;	
END;
$$
DELIMITER ;


#Testad och fungerar
DROP FUNCTION IF EXISTS resetWithMail;

DELIMITER $$
CREATE FUNCTION resetWithMail(email varchar(64), confirmation varchar(32))
  RETURNS boolean
  LANGUAGE SQL -- This element is optional and will be omitted from subsequent examples

begin 
	declare k integer DEFAULT 0;
	declare username varchar(64);
	declare account_id integer;
	SELECT count(*) INTO k FROM T_USERINFO where T_USERINFO.EMAIL = email;
	
	IF k = 0 THEN 
		return FALSE;
	ELSE
		SELECT ACC_ID INTO account_id FROM T_USERINFO where T_USERINFO.EMAIL = email;
		INSERT INTO T_RESET_PASSWORD ( ACC_ID, ENTRYDATE, CONFIRMATION_CODE) 
			values (account_id, now(), confirmation);
		return TRUE;
END IF;	

END;
$$
DELIMITER ;


#Testad och fungerar
DROP FUNCTION IF EXISTS resetWithUser;

DELIMITER $$
CREATE FUNCTION resetWithUser(username varchar(64), confirmation varchar(32))
  RETURNS  varchar(32)
  LANGUAGE SQL -- This element is optional and will be omitted from subsequent examples

begin 

	declare k integer DEFAULT 0;
	declare tmpmail varchar(32);
	declare account_id integer;
	SELECT count(*) INTO k FROM T_ACCOUNT where T_ACCOUNT.USERNAME = username;
	
	IF k = 0 THEN 
		return NULL;
	ELSE
		SELECT ACC_ID into account_id from T_ACCOUNT where T_ACCOUNT.USERNAME = username;
		SELECT EMAIL INTO tmpmail FROM T_USERINFO where T_USERINFO.ACC_ID = account_id;
		INSERT INTO T_RESET_PASSWORD ( ACC_ID, ENTRYDATE, CONFIRMATION_CODE) values (account_id, now(), confirmation);
		return tmpmail;
END IF;	
END;
$$
DELIMITER ;


#Testad och klar

DROP FUNCTION IF EXISTS resetPassword;
DELIMITER $$
CREATE FUNCTION resetPassword(username varchar(32), newpass varchar(128), confirmation varchar(32))
  RETURNS boolean
  LANGUAGE SQL -- This element is optional and will be omitted from subsequent examples
begin 
	declare k integer DEFAULT 0;
	declare account_id integer;
	select ACC_ID into account_id from T_ACCOUNT where T_ACCOUNT.USERNAME = username;

	SELECT count(*) into k FROM T_RESET_PASSWORD 
		where T_RESET_PASSWORD.CONFIRMATION_CODE = confirmation AND T_RESET_PASSWORD.ACC_ID = account_id;

	IF k = 0 THEN 
		return FALSE;
	ELSE
		
		delete from T_RESET_PASSWORD where T_RESET_PASSWORD.ACC_ID = account_id;
		
		update T_ACCOUNT SET PASSWRD = newpass where T_ACCOUNT.ACC_ID = account_id;
		return TRUE;
END IF;	
END;
$$
DELIMITER ;


#Testad och klar

DROP FUNCTION IF EXISTS changePassword;
DELIMITER $$
CREATE FUNCTION changePassword(acc_id varchar(32), oldpass varchar(32), newpass varchar(32))
  RETURNS boolean
  LANGUAGE SQL -- This element is optional and will be omitted from subsequent examples
begin 
	declare k integer DEFAULT 0;
	SELECT count(*) into k FROM T_ACCOUNT 
		where T_ACCOUNT.ACC_ID = acc_id AND T_ACCOUNT.PASSWRD = oldpass;

	IF k = 0 THEN 
		return FALSE;
	ELSE
		
	
		update T_ACCOUNT SET PASSWRD = newpass where T_ACCOUNT.ACC_ID = acc_id;
		return TRUE;
END IF;	
END;
$$
DELIMITER ;




drop function if exists getFirstName;

DELIMITER $$
create function getFirstName(acc_id integer) returns varchar(32) charset utf8
begin
	declare k integer DEFAULT 0;
	declare tmpname varchar(32);
	select count(*) into k from T_USERINFO where T_USERINFO.ACC_ID = acc_id;
	if k = 0 then
		return NULL;
	else
		select FNAME into tmpname from T_USERINFO where T_USERINFO.ACC_ID = acc_id;
		return tmpname;

end if;
END;
$$
DELIMITER ;

drop function if exists getLastName;

DELIMITER $$
create function getLastName(acc_id integer) returns varchar(32) charset utf8
begin
	declare k integer DEFAULT 0;
	declare tmpname varchar(32);
	select count(*) into k from T_USERINFO where T_USERINFO.ACC_ID = acc_id;
	if k = 0 then
		return NULL;
	else
		select LNAME into tmpname from T_USERINFO where T_USERINFO.ACC_ID = acc_id;
		return tmpname;

end if;
END;
$$
DELIMITER ;


drop function if exists changeUserAddress;
DELIMITER $$
create function changeUserAddress(acc_id integer, street varchar(32), zipcode varchar(32),
											 city varchar(32), phone varchar(32), email varchar(32))
returns bool
begin
	declare k integer DEFAULT 0;
	declare tmplength integer default 0;
	select count(*) into k from T_USERINFO where T_USERINFO.ACC_ID = acc_id;
	if k = 0 then
		return false;
	else
		
		if street is not null or LENGTH(street) > 0 then
			update T_USERINFO SET STREET = street where T_USERINFO.ACC_ID = acc_id;
		end if;
		if zipcode is not null or zipcode != '' then
			update T_USERINFO SET ZIPCODE = zipcode where T_USERINFO.ACC_ID = acc_id;
		end if;			
		if city is not null or city != '' then
			update T_USERINFO SET CITY = city where T_USERINFO.ACC_ID = acc_id;
		end if;
		if phone is not null or phone != '' then
			update T_USERINFO SET PHONE = phone where T_USERINFO.ACC_ID = acc_id;
		end if;
		if email is not null or email != '' then
			update T_USERINFO SET EMAIL = email where T_USERINFO.ACC_ID = acc_id;			
		end if;
		return true;

end if;
END;
$$
DELIMITER ;



drop function if exists getFullName;

DELIMITER $$
create function getFullName(acc_id integer) returns varchar(64) charset utf8
begin
	declare k integer DEFAULT 0;
	declare fullname varchar(32);
#	declare lname varchar(32);
	select count(*) into k from T_USERINFO where T_USERINFO.ACC_ID = acc_id;
	if k = 0 then
		return NULL;
	else
		select CONCAT(FNAME," ", LNAME) into fullname from T_USERINFO where T_USERINFO.ACC_ID = acc_id;
#		select LNAME into lname from T_USERINFO where T_USERINFO.ACC_ID = acc_id;
		
		return fullname;

end if;
END;
$$
DELIMITER ;
