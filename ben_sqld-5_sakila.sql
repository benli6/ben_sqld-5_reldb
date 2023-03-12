CREATE USER 'sys_temp'@'localhost' IDENTIFIED BY 'sys_temp';

SELECT User, Host FROM mysql.user;

GRANT ALL PRIVILEGES ON *.* TO 'sys_temp'@'localhost' with grant option;

SHOW grants FOR 'sys_temp'@'localhost';

REVOKE INSERT, UPDATE, DELETE ON *.* FROM 'sys_temp'@'localhost';

SHOW grants FOR 'sys_temp'@'localhost';