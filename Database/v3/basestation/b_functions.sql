
drop function if exists addBasestation;
DELIMITER $$
create function addBasestation(bs_id bigint) returns boolean
begin
	declare k integer DEFAULT 0;

	select count(*) into k from T_BASESTATION where T_BASESTATION.BS_ID = bs_id;
	if k = 0 then
		INSERT INTO T_BASESTATION(BS_ID) values (bs_id);
		return True;
	else
		return False;
end if;
END;
$$
DELIMITER ;

#Returnerar account id kopplat till en dev
#Returnerar -1 om Basstationen inte finns
#Returnerar -2 om Basstationen inte är kopplad till användare
drop function if exists deviceBoundToUser;
DELIMITER $$
create function deviceBoundToUser(bs_id bigint) returns integer
begin
	declare k integer DEFAULT 0;
	declare tmpuser integer;
	select count(*) into k from T_BASESTATION where T_BASESTATION.BS_ID = bs_id;
	if k = 0 then
		return -1;
	else
		select ACC_ID into tmpuser from T_BASESTATION where T_BASESTATION.BS_ID = bs_id;
		if tmpuser is null then
			return -2;
		else
			return tmpuser;
		end if;
end if;
END;
$$
DELIMITER ;

drop function if exists removeBasestation;
DELIMITER $$
create function removeBasestation(bs_id bigint, acc_id integer) returns boolean
begin
	declare k integer DEFAULT 0;

	select count(*) into k from T_BASESTATION where T_BASESTATION.BS_ID = bs_id;
	if k = 0 then
		return False;
	else
		DELETE FROM T_BASESTATION where T_BASESTATION.BS_ID = bs_id and T_BASESTATION.ACC_ID = acc_id;
		return True;
end if;
END;
$$
DELIMITER ;