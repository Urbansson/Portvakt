
DROP TABLE IF exists T_BASESTATION;

CREATE TABLE T_BASESTATION(
	BS_ID 	bigint,
	ACC_ID		integer,
	UPDATERATE	integer DEFAULT 30,
	primary key(BS_ID),
	FOREIGN KEY (ACC_ID) references T_ACCOUNT(ACC_ID) on delete cascade
);


DROP TABLE IF exists T_BASESTATION_INFO;

CREATE TABLE T_BASESTATION_INFO(
	BS_ID			bigint,
	BASE_NAME	varchar(32),
	STREET		varchar(32),
	ZIP			varchar(32),
	CITY			varchar(32),

	primary key(BS_ID),
	foreign key(BS_ID) references T_BASESTATION(BS_ID) on delete cascade
);


DROP TABLE IF EXISTS T_BASESTATION_INET_ADDR;

CREATE TABLE T_BASESTATION_INET_ADDR(
	BS_ID			bigint,
	ENTRYTIME	datetime,
	INET_ADDR	varchar(39),
	foreign key(BS_ID) references T_BASESTATION(BS_ID) on delete cascade,
	primary key(BS_ID)
);

