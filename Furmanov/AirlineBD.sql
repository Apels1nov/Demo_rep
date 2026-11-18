CREATE DATABASE AirlineBD
ON PRIMARY
(
    NAME = N'AirlineBD_Data',
    FILENAME = N'C:\SQL_Data\AirlineBD.mdf',
    SIZE = 20 MB,
    MAXSIZE = 200 MB,
    FILEGROWTH = 10 MB
),
FILEGROUP FG_Secondary (
    NAME = N'AirlineBD_Secondary',
    FILENAME = N'C:\SQL_Data\AirlineBD_Secondary.ndf',
    SIZE = 10 MB,
    MAXSIZE = 100 MB,
    FILEGROWTH = 20%
)

LOG ON (
    NAME = N'AirlineBD_Log',
    FILENAME = N'C:\SQL_Data\AirlineBD.ldf',
    SIZE = 5 MB,
    MAXSIZE = 100 MB,
    FILEGROWTH = 10%
);