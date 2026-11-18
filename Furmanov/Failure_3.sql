USE AirlineBD;
USE master;
DELETE FROM dbo.Booking;
SELECT * FROM dbo.Booking;

BACKUP LOG AirlineBD
TO DISK = 'C:\SQLBackUps\AirlineBD_TailLog.trn'
WITH NO_TRUNCATE, INIT;
-- Восстанавливаем полную копию (база в режиме Restoring)
RESTORE DATABASE AirlineBD
FROM DISK = 'C:\SQLBackUps\AirlineBD_Full.bak'
WITH REPLACE, RECOVERY;

-- Накатываем разностную копию, если она была сделана после Full, но до удаления
RESTORE DATABASE AirlineBD
FROM DISK = 'C:\SQLBackUps\AirlineBD_Diff.bak'
WITH NORECOVERY;

-- Накатываем журналы транзакций
RESTORE LOG AirlineBD
FROM DISK = 'C:\SQLBackUps\AirlineBD_Log.trn'
WITH STOPAT = '2026-10-01 15:39:00', RECOVERY;