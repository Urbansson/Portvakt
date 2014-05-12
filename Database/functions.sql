#Testad och fungerar
DROP FUNCTION IF EXISTS loggin;
DELIMITER $$
CREATE FUNCTION loggin(user varchar(32), pass varchar(32))
  RETURNS boolean
  LANGUAGE SQL -- This element is optional and will be omitted from subsequent examples
begin 
	declare k integer DEFAULT 0;
	
	SELECT count(*) INTO k FROM T_ACCOUNT where T_ACCOUNT.username = user and T_ACCOUNT.passwrd = pass and T_ACCOUNT.active = true;
	
	IF k = 0 THEN 
		return -1;
	ELSE
		SELECT T_ACCOUNT.acc_id INTO k FROM T_ACCOUNT where T_ACCOUNT.username = user and T_ACCOUNT.passwrd = pass and T_ACCOUNT.active = true;
		return k;
END IF;	

END;
$$
DELIMITER ;



#Testad och fungerar
DROP FUNCTION IF EXISTS resetWithMail;

DELIMITER $$
CREATE FUNCTION resetWithMail(mail varchar(64), confirmation varchar(32))
  RETURNS boolean
  LANGUAGE SQL -- This element is optional and will be omitted from subsequent examples

begin 
	declare k integer DEFAULT 0;
	declare user varchar(64);
	declare account_id integer;
	SELECT count(*) INTO k FROM T_USERINFO where T_USERINFO.EMAIL = mail;
	
	IF k = 0 THEN 
		return FALSE;
	ELSE
		SELECT acc_id INTO account_id FROM T_USERINFO where T_USERINFO.EMAIL = mail;
		INSERT INTO T_RESET_PASSWORD ( T_RESET_PASSWORD.acc_id, entrydate, confirmationcode) 
			values (account_id, now(), confirmation);
		return TRUE;
END IF;	

END;
$$
DELIMITER ;


#Testad och fungerar
DROP FUNCTION IF EXISTS resetWithUser;

DELIMITER $$
CREATE FUNCTION resetWithUser(user varchar(64), confirmation varchar(32))
  RETURNS  varchar(64)
  LANGUAGE SQL -- This element is optional and will be omitted from subsequent examples

begin 

	declare k integer DEFAULT 0;
	declare tmpmail varchar(64);
	declare account_id integer;
	SELECT count(*) INTO k FROM T_ACCOUNT where T_ACCOUNT.username = user;
	
	IF k = 0 THEN 
		return NULL;
	ELSE
		SELECT acc_id into account_id from T_ACCOUNT where T_ACCOUNT.username = user;
		SELECT EMAIL INTO tmpmail FROM T_USERINFO where T_USERINFO.acc_id = account_id;
		INSERT INTO T_RESET_PASSWORD ( acc_id, entrydate, confirmationcode) values (account_id, now(), confirmation);
		return tmpmail;
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
	SELECT count(*) into k FROM T_TO_BE_VALIDATED where T_TO_BE_VALIDATED.confirmationcode = confirmation;

	IF k = 0 THEN 
		return FALSE;
	ELSE
		select acc_id into account_id FROM T_TO_BE_VALIDATED where T_TO_BE_VALIDATED.confirmationcode = confirmation;
		delete from T_TO_BE_VALIDATED where T_TO_BE_VALIDATED.acc_id = account_id;
		
		update T_ACCOUNT SET active = true where acc_id = account_id;
		return TRUE;
END IF;	
END;
$$
DELIMITER ;



#Testad och klar

DROP FUNCTION IF EXISTS changePassword;
DELIMITER $$
CREATE FUNCTION changePassword(username varchar(64), newpass varchar(128), confirmation varchar(32))
  RETURNS boolean
  LANGUAGE SQL -- This element is optional and will be omitted from subsequent examples
begin 
	declare k integer DEFAULT 0;
	declare account_id integer;
	select acc_id into account_id from T_ACCOUNT where T_ACCOUNT.username = username;

	SELECT count(*) into k FROM T_RESET_PASSWORD 
		where T_RESET_PASSWORD.confirmationcode = confirmation AND T_RESET_PASSWORD.acc_id = account_id;

	IF k = 0 THEN 
		return FALSE;
	ELSE
		
		delete from T_RESET_PASSWORD where T_RESET_PASSWORD.acc_id = account_id;
		
		update T_ACCOUNT SET passwrd = newpass where T_ACCOUNT.acc_id = account_id;
		return TRUE;
END IF;	
END;
$$
DELIMITER ;


#Testad och fungerar
DROP FUNCTION IF EXISTS userExists;
DELIMITER $$
CREATE FUNCTION userExists(nametocheck varchar(64))
  RETURNS boolean
  LANGUAGE SQL -- This element is optional and will be omitted from subsequent examples
begin 
	declare k integer DEFAULT 0;
	SELECT count(*) into k FROM T_ACCOUNT where T_ACCOUNT.username = nameToCheck;

	IF k = 0 THEN 
		return FALSE;
	ELSE
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
	select count(*) into k from T_USERINFO where T_USERINFO.acc_id = acc_id;
	if k = 0 then
		return NULL;
	else
		select FNAME into tmpname from T_USERINFO where T_USERINFO.acc_id = acc_id;
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
	select count(*) into k from T_USERINFO where T_USERINFO.acc_id = acc_id;
	if k = 0 then
		return NULL;
	else
		select LNAME into tmpname from T_USERINFO where T_USERINFO.acc_id = acc_id;
		return tmpname;

end if;
END;
$$
DELIMITER ;




#Returnerar account id kopplat till en dev
#Returnerar -1 om Basstationen inte finns
#Returnerar -2 om Basstationen inte är kopplad till användare
drop function if exists deviceBoundToUser;
DELIMITER $$
create function deviceBoundToUser(dev_id bigint) returns integer
begin
	declare k integer DEFAULT 0;
	declare tmpuser integer;
	select count(*) into k from T_BASESTATION where T_BASESTATION.BASE_ID = dev_id;
	if k = 0 then
		return -1;
	else
		select acc_id into tmpuser from T_BASESTATION where T_BASESTATION.BASE_ID = dev_id;
		if tmpuser is null then
			return -2;
		else
			return tmpuser;
		end if;
end if;
END;
$$
DELIMITER ;

drop function if exists addBasestation;
DELIMITER $$
create function addBasestation(dev_id bigint) returns boolean
begin
	declare k integer DEFAULT 0;

	select count(*) into k from T_BASESTATION where T_BASESTATION.BASE_ID = dev_id;
	if k = 0 then
		INSERT INTO T_BASESTATION(BASE_ID) values (dev_id);
		return True;
	else
		return False;
end if;
END;
$$
DELIMITER ;



drop function if exists removeBasestation;
DELIMITER $$
create function removeBasestation(dev_id bigint, account integer) returns boolean
begin
	declare k integer DEFAULT 0;

	select count(*) into k from T_BASESTATION where T_BASESTATION.BASE_ID = dev_id;
	if k = 0 then
		return False;
	else
		DELETE FROM T_BASESTATION where T_BASESTATION.BASE_ID = dev_id and T_BASESTATION.acc_id = account;
		return True;
end if;
END;
$$
DELIMITER ;