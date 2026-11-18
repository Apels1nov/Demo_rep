ALTER DATABASE AirlineBD SET OFFLINE WITH ROLLBACK IMMEDIATE;

EXEC sp_configure 'show advanced options', 1; RECONFIGURE;
EXEC sp_configure 'xp_cmdshell', 1; RECONFIGURE;

EXEC xp_cmdshell 'del "C:\SQL_Data\AirlineBD.mdf"';
EXEC xp_cmdshell 'del "C:\SQL_Data\AirlineBD.ldf"';

EXEC sp_configure 'xp_cmdshell', 0; RECONFIGURE;
EXEC sp_configure 'show advanced options', 0; RECONFIGURE;

--Восстановление с использованием полной и разностной копий
RESTORE DATABASE AirlineBD
FROM DISK = 'C:\SQLBackUps\AirlineBD_Full.bak'
WITH REPLACE, NORECOVERY;

RESTORE DATABASE AirlineBD
FROM DISK = 'C:\SQLBackUps\AirlineBD_Diff1.bak'
WITH RECOVERY;