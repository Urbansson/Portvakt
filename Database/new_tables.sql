SET FOREIGN_KEY_CHECKS=0;
DROP TABLE IF exists T_ACCOUNT ;

CREATE TABLE T_ACCOUNT  (
	username varchar(32) NOT NULL,
	acc_id integer auto_increment,
	passwrd varchar(32) NOT NULL,
	active boolean NOT NULL,
	primary key(acc_id),
	unique key(username)
);


DROP TABLE IF exists T_USERINFO;

CREATE TABLE T_USERINFO	(
	acc_id 	integer		NOT NULL,
	FNAME 	varchar(32) NOT NULL,
	LNAME 	varchar(32) NOT NULL,
	STREET 	varchar(32) NOT NULL,
	ZIPCODE	varchar(32) NOT NULL,
	CITY	varchar(32) NOT NULL,
	PHONE	varchar(32)  NOT NULL,
	EMAIL	varchar(32)  NOT NULL,
	FOREIGN KEY (acc_id) references T_ACCOUNT(acc_id) on delete cascade
);

DROP TABLE IF exists T_TO_BE_VALIDATED ;

CREATE TABLE T_TO_BE_VALIDATED(
	acc_id integer NOT NULL,
	entrydate DATETIME NOT NULL,
	confirmationcode varchar(32) NOT NULL,
	PRIMARY KEY (confirmationcode),
	FOREIGN KEY (acc_id) references T_ACCOUNT(acc_id) on delete cascade
);


DROP TABLE IF exists T_RESET_PASSWORD;

CREATE TABLE T_RESET_PASSWORD(
	acc_id integer NOT NULL,
	entrydate DATETIME NOT NULL,
	confirmationcode varchar(32) NOT NULL,
	PRIMARY KEY (confirmationcode),
	FOREIGN KEY (acc_id) references T_ACCOUNT(acc_id) on delete cascade
);




DROP TABLE IF exists T_BASESTATION;

CREATE TABLE T_BASESTATION(
	BASE_ID 	bigint,
	acc_id		integer,
	UPDATERATE	integer DEFAULT 30,
	#IP_ADDR	varchar(15)	 NOT NULL,
	primary key(BASE_ID),
	FOREIGN KEY (acc_id) references T_ACCOUNT(acc_id) on delete cascade
);


DROP TABLE IF exists T_BASESTATION_INFO;

CREATE TABLE T_BASESTATION_INFO(
	BS_ID			bigint,
	BASE_NAME	varchar(32),
	STREET		varchar(32),
	ZIP			varchar(32),
	CITY			varchar(32),

	primary key(BS_ID),
	foreign key(BS_ID) references T_BASESTATION(BASE_ID) on delete cascade
);


DROP TABLE IF exists T_BASESTATION_GROUP;

CREATE TABLE T_BASESTATION_GROUP(
	GROUP_ID	integer not null,
	GROUP_NAME	varchar(32),
	primary key(GROUP_ID)

);

DROP TABLE IF EXISTS T_GROUP_MEMBER;

CREATE TABLE T_GROUP_MEMBER(
	GROUP_ID	integer,
	ACC_ID		integer,

	foreign key(GROUP_ID) references T_BASESTATION_GROUP(GROUP_ID) on delete cascade,
	foreign key(ACC_ID) references T_ACCOUNT(ACC_ID) on delete cascade
);

DROP TABLE IF EXISTS T_GROUP_BASESTATIONS;

CREATE TABLE T_GROUP_BASESTATIONS(
	BS_ID		bigint,
	ACC_ID		integer,


	primary key(BS_ID, ACC_ID),
	foreign key(BS_ID) references T_BASESTATION(BASE_ID) on delete cascade,
	foreign key(ACC_ID) references T_ACCOUNT(ACC_ID) on delete cascade
);

DROP TABLE IF EXISTS T_BASESTATION_INET_ADDR;

CREATE TABLE T_BASESTATION_INET_ADDR(
	BS_ID	bigint,
	entrytime	datetime,
	INET_ADDR	varchar(39),
	foreign key(BS_ID) references T_BASESTATION(BASE_ID) on delete cascade,
	primary key(BS_ID)
);




DROP TABLE IF EXISTS T_END_DEVICE;

CREATE TABLE T_END_DEVICE(
	DEV_ID	varchar(32),
	BS_ID		bigint,
	devname	varchar(32),

	foreign key(BS_ID) references T_BASESTATION(BASE_ID) on delete cascade,
	primary key(DEV_ID)

);


DROP TABLE IF EXISTS T_SENSOR_TYPE;

CREATE TABLE T_SENSOR_TYPE(
	SEN_TYP		integer,
	SEN_NAME	varchar(32),
	PREFIX		varchar(8),
	DESCRIPTION	varchar(64),
	primary key(SEN_TYP)
);


DROP TABLE IF EXISTS T_SENSOR;
CREATE TABLE T_SENSOR(
	ID				integer auto_increment not null,
	SENSOR_ID 	integer,
	DEV_ID		varchar(32),
	SEN_TYPE		integer,
	DEV_NAME		varchar(32),

	foreign key(DEV_ID) references T_END_DEVICE(DEV_ID) on delete cascade,
	foreign key(SEN_TYPE) references T_SENSOR_TYPE(SEN_TYP) on delete cascade,
	primary key(ID)
);

DROP TABLE IF EXISTS T_SENSOR_DATA;
CREATE TABLE T_SENSOR_DATA(
	DATA_ID		integer auto_increment not null,
	SEN_ID		integer,
	DEV_ID		varchar(32),
	DATA_TIME	datetime,
	SEN_DATA		varchar(32),
	primary key(DATA_ID),
	foreign key(DEV_ID) references T_END_DEVICE(DEV_ID) on delete cascade
);

DROP TABLE IF EXISTS T_ALARM_LOGS;



CREATE TABLE T_ALARM_LOGS(
	LOG_ID	integer  auto_increment not null,
	BS_ID	bigint,
	END_ID	integer,
	SEN_ID	integer,
	CONTAIN	varchar(128),
	HANDLED	boolean default False,
	primary key(LOG_ID),
	foreign key(BS_ID) references T_BASESTATION(BASE_ID) on delete cascade,
	foreign key(END_ID) references T_END_DEVICE(DEV_ID) on delete cascade

);

#####################
#ATT GÖRA			#
#T_BASESTATION_INFO	#
#T_SENSORDATA		#
#T_TYPE				#
#T_BASESTATION_GROUP#
#					#
#####################
