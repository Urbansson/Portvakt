CALL addAccount('emil', 'kissochbajs', 'df', 'afsf', 'dsfds', 'sdfsf', 'sdsdg', 'dfhdh', 'dsgfd', 'gdfhdh');


SELECT verify('gdfhdh');
SELECT resetWithUser('emil','abcd');
select resetWithMail('dfhdh','abcde');
select resetPassword('emil','kissbomb','abcde');
select loggin('emil','kissbob');
select userExists('efmil');
select addBasestation(123);
call registerBasestation(123,1,'123','123324','1243','23235');


select * from T_BASESTATION where T_BASESTATION.BASE_ID = 123 and T_BASESTATION.acc_id = NULL;
SELECT * FROM T_BASESTATION;
SELECT * FROM T_BASESTATION_INFO;
DROP TABLE IF EXISTS *;
SELECT removeBaseStation(123,1);
SELECT * FROM T_USERINFO;
SELECT * FROM T_ACCOUNT;
SELECT * FROM T_TO_BE_VALIDATED;
SELECT * FROM T_RESET_PASSWORD;
SELECT * FROM T_ACCOUNT, T_TOBEVALIDATED where T_ACCOUNT.usrname=T_TOBEVALIDATED.usrname;
SELECT * FROM T_ACCOUNT where T_ACCOUNT.usrname = 'teddy';





SELECT * FROM T_RESETPASSWORD where T_RESETPASSWORD.confirmationcode = 'HluGaZb5WptNACgrymKGCrsQX4Fv001L' AND T_RESETPASSWORD.usrname = 'teddy';
