USE AirlineBD

ALTER DATABASE AirlineBD
ADD FILEGROUP FG_Audit;

ALTER DATABASE AirlineBD
ADD FILE (
    NAME = 'AirlineBD_Audit',
    FILENAME = 'C:\SQL_Data\AirlineBD_Audit.ndf',
    SIZE = 3MB,
    MAXSIZE = 20MB,
    FILEGROWTH = 2MB
) TO FILEGROUP FG_Audit;