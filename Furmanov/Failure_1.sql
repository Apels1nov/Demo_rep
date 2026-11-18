ALTER DATABASE AirlineBD SET RECOVERY FULL;
USE AirlineBD;
USE master;
--Сбой
UPDATE Flights SET Status = 'Cancelled';
SELECT SYSDATETIME() AS FailTime;
SELECT * FROM dbo.Flights;

BACKUP LOG AirlineBD
TO DISK = 'C:\SQLBackUps\AirlineBD_TailLog.trn'
WITH NO_TRUNCATE, INIT;
-- Восстановление базового полного бэкапа (БД уходит в состояние Restoring)
RESTORE DATABASE AirlineBD
FROM DISK = 'C:\SQLBackUps\AirlineBD_Full.bak'
WITH REPLACE, NORECOVERY;
-- Накат планового бэкапа логов (база всё еще закрыта для пользователей)
RESTORE LOG AirlineBD
FROM DISK = 'C:\SQLBackUps\AirlineBD_Log.trn'
WITH NORECOVERY;
-- Накат хвоста лога с остановкой на времени ДО сбоя и перевод БД в ONLINE 
RESTORE LOG AirlineBD
FROM DISK = 'C:\SQLBackUps\AirlineBD_TailLog.trn'
WITH STOPAT = '2026-11-18 15:55:35',
RECOVERY;