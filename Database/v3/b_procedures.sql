
DELIMITER $$
DROP PROCEDURE IF EXISTS registerBasestation $$

create procedure registerBasestation
(in bs_id bigint, in acc_id integer, in base_name varchar(32),
 in street varchar(32), in zipcode varchar(32), in city varchar(32))
modifies SQL DATA

BEGIN
declare i integer;
select count(*) into i from T_BASESTATION where T_BASESTATION.BS_ID = bs_id and T_BASESTATION.ACC_ID is NULL;
IF i > 0 Then
	UPDATE T_BASESTATION SET ACC_ID = acc_id where T_BASESTATION.BS_ID = bs_id;	
	INSERT INTO T_BASESTATION_INFO(BS_ID, BASE_NAME, STREET, ZIP, CITY) 
		values(bs_id, base_name, street, zipcode, city);

END IF;
END $$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS getBasestationsFromId $$
create procedure getBasestationsFromId(in id integer)
READS SQL DATA
BEGIN
	select * from AccountBasestations where AccountBasestations.USER_ID = id order by AccountBasestations.BASESTATION_ID ASC;
END $$
DELIMITER ;