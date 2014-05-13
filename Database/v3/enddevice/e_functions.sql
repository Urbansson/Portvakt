drop function if exists pushData;
DELIMITER $$
create function pushData(bs_id bigint, end_id varchar(32), sensor_id integer, sen_type integer, value varchar(32)) 
returns integer
begin
	declare k integer DEFAULT 0;
	declare i integer DEFAULT 0;
	declare b boolean default false;
	declare havedata integer;
	declare tmpID integer;
	select count(*) into k from T_BASESTATION where T_BASESTATION.BS_ID = bs_id;
	if k = 0 then
		return 0;

	else
		select count(*) into i from T_END_DEVICE where T_END_DEVICE.END_ID = end_id;

		if i = 0 then
			INSERT INTO T_END_DEVICE(END_ID, BS_ID,END_DEVNAME) values (end_id, bs_id, 'End device');
		end if;

		select count(*) into k from T_SENSOR where T_SENSOR.SENSOR_ID = sensor_id and T_SENSOR.END_ID = end_id;
		if k = 0 then
			INSERT INTO T_SENSOR(SENSOR_ID, END_ID, SEN_TYPE) values (sensor_id, end_id, sen_type);
		end if;

		select HASDATA into b from T_SENSOR_TYPE where T_SENSOR_TYPE.SEN_TYPE = sen_type;

		select ID into tmpID from T_SENSOR 
			where T_SENSOR.SENSOR_ID = sensor_id and T_SENSOR.END_ID = end_id;
		
		if b = 0 then

			select count(*) into havedata from T_SENSOR_DATA where T_SENSOR_DATA.SENSOR_ID = tmpID;
			if havedata = 0 then			
				insert into T_SENSOR_DATA( SENSOR_ID, TIMEDATE, DATALOAD ) values( tmpID, now(), value);
			else
				update T_SENSOR_DATA SET TIMEDATE = now() where T_SENSOR_DATA.SENSOR_ID = tmpID;
				update T_SENSOR_DATA SET DATALOAD = value where T_SENSOR_DATA.SENSOR_ID = tmpID;
			end if;

		else 
			insert into T_SENSOR_DATA( SENSOR_ID, TIMEDATE, DATALOAD ) values( tmpID, now(), value);
		end if;
		return 1;		
	end if;
END;
$$
DELIMITER ;