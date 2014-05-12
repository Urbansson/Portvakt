SET FOREIGN_KEY_CHECKS=0;
DROP TABLE IF exists T_ACCOUNT ;

CREATE TABLE T_ACCOUNT  (
	usrname varchar(64) NOT NULL,
	pwd 	varchar(128) NOT NULL,
	fname 	varchar(64) NOT NULL,
	lname 	varchar(64) NOT NULL,
	street 	varchar(64) NOT NULL,
	postnr 	varchar(5) NOT NULL,
	city	varchar(32) NOT NULL,
	mail 	varchar(64) NOT NULL,
	phone	varchar(16) NOT NULL,
	valid 	boolean NOT NULL default false,
	primary key(usrname)
);



DROP TABLE IF exists T_TOBEVALIDATED ;
CREATE TABLE T_TOBEVALIDATED(
	usrname varchar(64) NOT NULL,
	entrydate DATETIME NOT NULL,
	confirmationcode varchar(32) NOT NULL,
	PRIMARY KEY (confirmationcode),
	FOREIGN KEY (usrname) references T_ACCOUNT(usrname)
);


DROP TABLE IF exists T_RESETPASSWORD;
CREATE TABLE T_RESETPASSWORD(
	usrname varchar(64) NOT NULL,
	entrydate DATETIME NOT NULL,
	confirmationcode varchar(32) NOT NULL,
	PRIMARY KEY (confirmationcode),
	FOREIGN KEY (usrname) references T_ACCOUNT(usrname)
);
