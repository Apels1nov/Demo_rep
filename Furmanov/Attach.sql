CREATE DATABASE AirlineBD
ON (FILENAME = 'C:\SQL_Data\AirlineBD.mdf'),
   (FILENAME = 'C:\SQL_Data\AirlineBD.ldf'),
   (FILENAME = 'C:\SQL_Data\AirlineBD_Audit.ndf'),
   (FILENAME = 'C:\SQL_Data\AirlineBD_Secondary.ndf')
FOR ATTACH;