
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



DELIMITER $$
DROP PROCEDURE IF EXISTS setInetAddr $$
create procedure setInetAddr (in bs_id bigint, in inet_addr varchar(39))
READS SQL DATA
BEGIN
declare k integer;
select count(*) into k from T_BASESTATION_INET_ADDR where T_BASESTATION_INET_ADDR.BS_ID = bs_id;
if k > 0 
	then
		UPDATE T_BASESTATION_INET_ADDR SET INET_ADDR = inet_addr 
		where T_BASESTATION_INET_ADDR.BS_ID = bs_id;
		UPDATE T_BASESTATION_INET_ADDR SET ENTRYTIME = now() 
		where T_BASESTATION_INET_ADDR.BS_ID = bs_id;
	else
		INSERT INTO T_BASESTATION_INET_ADDR(BS_ID, ENTRYTIME, INET_ADDR) values (bs_id, now(), inet_addr);
	
end if;
END $$
DELIMITER ;


DELIMITER $$
DROP PROCEDURE IF EXISTS checkTimeout $$
create procedure checkTimeout()
READS SQL DATA
BEGIN
	select * from TimeoutInformation where TimeoutInformation.ENTRYTIME < (now() - INTERVAL 20 SECOND);
END $$
DELIMITER ;
