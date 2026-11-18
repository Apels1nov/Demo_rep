BACKUP DATABASE AirlineBD
TO DISK = 'C:\SQLBackUps\AirlineBD_Full.bak'
WITH INIT, NAME = 'Full Backup';

BACKUP LOG AirlineBD
TO DISK = 'C:\SQLBackUps\AirlineBD_Log.trn'
WITH INIT;

BACKUP DATABASE AirlineBD
TO DISK = 'C:\SQLBackUps\AirlineBD_Diff1.bak'
WITH DIFFERENTIAL, NOINIT, NAME = 'Diff 1';

BACKUP DATABASE AirlineBD
FILEGROUP = 'FG_Secondary'
TO DISK = 'C:\SQLBackUps\AirlineBD_FG_Secondary.bak'
WITH INIT;

BACKUP DATABASE AirlineBD
TO DISK = 'C:\SQLBackUps\AirlineBD_CopyOnly.bak'
WITH COPY_ONLY, INIT;