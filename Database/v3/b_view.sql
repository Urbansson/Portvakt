drop view if exists AccountBasestations;
create view AccountBasestations as 
	select T_BASESTATION.ACC_ID as USER_ID, T_BASESTATION_INFO.BASE_NAME AS BASESTATION_ID 
	from T_BASESTATION, T_BASESTATION_INFO 
	where T_BASESTATION.BS_ID = T_BASESTATION_INFO.BS_ID;