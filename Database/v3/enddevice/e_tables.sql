DROP TABLE IF EXISTS T_END_DEVICE;

CREATE TABLE T_END_DEVICE(
	END_ID	varchar(32),
	BS_ID		bigint,
	END_DEVNAME	varchar(32),

	primary key(END_ID),
	foreign key(BS_ID) references T_BASESTATION(BS_ID) on delete cascade
);

DROP TABLE IF EXISTS T_SENSOR_TYPE;

CREATE TABLE T_SENSOR_TYPE(
	SEN_TYPE		integer,
	SEN_NAME		varchar(32),
	PREFIX		varchar(8),
	DESCRIPTION	varchar(64),
	INTERACTIVE bool default false,
	LIVEDATA		bool default false,
	primary key(SEN_TYPE)
);


DROP TABLE IF EXISTS T_SENSOR;
CREATE TABLE T_SENSOR(
	ID				integer auto_increment not null,
	SENSOR_ID 	integer,
	END_ID		varchar(32),
	SEN_TYPE		integer,

	primary key(ID),
	foreign key(END_ID) references T_END_DEVICE(END_ID) on delete cascade,
	foreign key(SEN_TYPE) references T_SENSOR_TYPE(SEN_TYPE) on delete cascade

);

DROP TABLE IF EXISTS T_SENSOR_DATA;

CREATE TABLE T_SENSOR_DATA(

	DATA_ID		integer auto_increment,
	SENSOR_ID 	integer,
	TIMEDATE		datetime,
	DATALOAD		varchar(32),

	primary key(DATA_ID),
	foreign key (SENSOR_ID) REFERENCES T_SENSOR(ID)
);
