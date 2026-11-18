USE AirlineBD;

CREATE ROLE db_Admin;
CREATE ROLE db_Dispatcher;
CREATE ROLE db_Passenger;
CREATE ROLE db_CheckInAgent;

CREATE LOGIN AdminUser WITH PASSWORD = '4DM1N';
CREATE LOGIN Dispatcher WITH PASSWORD = 'D1SP4TCHER';
CREATE LOGIN Passenger WITH PASSWORD = 'P4SseNGER';
CREATE LOGIN CheckInAgent WITH PASSWORD = 'Chck1n4gent';

CREATE USER AdminUser FOR LOGIN AdminUser;
CREATE USER Dispatcher FOR LOGIN Dispatcher;
CREATE USER Passenger FOR LOGIN Passenger;
CREATE USER CheckInAgent FOR LOGIN CheckInAgent;

ALTER ROLE db_Admin ADD MEMBER AdminUser;
ALTER ROLE db_Dispatcher ADD MEMBER Dispatcher;
ALTER ROLE db_Passenger ADD MEMBER Passenger;
ALTER ROLE db_CheckInAgent ADD MEMBER CheckInAgent;

GRANT SELECT, INSERT, UPDATE, DELETE, ALTER, REFERENCES, EXECUTE ON SCHEMA::dbo TO db_Admin;

GRANT SELECT, INSERT, UPDATE ON dbo.Flights        TO db_Dispatcher;
GRANT SELECT, INSERT, UPDATE ON dbo.Crews          TO db_Dispatcher;
GRANT SELECT ON dbo.Aircrafts					   TO db_Dispatcher;
DENY INSERT, UPDATE, DELETE	 ON dbo.Passengers     TO db_Dispatcher;
DENY INSERT, UPDATE, DELETE	 ON dbo.Booking        TO db_Dispatcher;
DENY INSERT, UPDATE, DELETE  ON dbo.BoardingPasses TO db_Dispatcher;

GRANT SELECT ON dbo.Booking    TO db_Passenger;
GRANT SELECT ON dbo.Flights    TO db_Passenger;
GRANT SELECT ON dbo.Passengers TO db_Passenger;
DENY INSERT, UPDATE, DELETE ON SCHEMA::dbo TO db_Passenger;

GRANT SELECT, UPDATE ON dbo.Booking          TO db_CheckInAgent;
GRANT SELECT, INSERT ON dbo.BoardingPasses   TO db_CheckInAgent;
GRANT SELECT ON dbo.Flights					 TO db_CheckInAgent;
GRANT SELECT ON dbo.Passengers				 TO db_CheckInAgent;
DENY INSERT, UPDATE, DELETE ON dbo.Flights   TO db_CheckInAgent;
DENY INSERT, UPDATE, DELETE ON dbo.Crews     TO db_CheckInAgent;
DENY INSERT, UPDATE, DELETE ON dbo.Aircrafts TO db_CheckInAgent;

DENY SELECT, INSERT, UPDATE, DELETE ON dbo.Audit TO db_Dispatcher;
DENY SELECT, INSERT, UPDATE, DELETE ON dbo.Audit TO db_Passenger;
DENY SELECT, INSERT, UPDATE, DELETE ON dbo.Audit TO db_CheckInAgent;
GRANT SELECT ON dbo.Audit TO db_Admin;

-- Admin (3 пользователя) 
CREATE LOGIN admin1 WITH PASSWORD = 'AdminP@ss1';
CREATE USER admin1 FOR LOGIN admin1;
ALTER ROLE db_Admin ADD MEMBER admin1;

CREATE LOGIN admin2 WITH PASSWORD = 'AdminP@ss2';
CREATE USER admin2 FOR LOGIN admin2;
ALTER ROLE db_Admin ADD MEMBER admin2;

CREATE LOGIN admin3 WITH PASSWORD = 'AdminP@ss3';
CREATE USER admin3 FOR LOGIN admin3;
ALTER ROLE db_Admin ADD MEMBER admin3;

-- Dispatcher (3 пользователя) 
CREATE LOGIN dispatcher1 WITH PASSWORD = 'DispP@ss1';
CREATE USER dispatcher1 FOR LOGIN dispatcher1;
ALTER ROLE db_Dispatcher ADD MEMBER dispatcher1;

CREATE LOGIN dispatcher2 WITH PASSWORD = 'DispP@ss2';
CREATE USER dispatcher2 FOR LOGIN dispatcher2;
ALTER ROLE db_Dispatcher ADD MEMBER dispatcher2;

CREATE LOGIN dispatcher3 WITH PASSWORD = 'DispP@ss3';
CREATE USER dispatcher3 FOR LOGIN dispatcher3;
ALTER ROLE db_Dispatcher ADD MEMBER dispatcher3;

-- Passenger (3 пользователя) 
CREATE LOGIN passenger1 WITH PASSWORD = 'PassP@ss1';
CREATE USER passenger1 FOR LOGIN passenger1;
ALTER ROLE db_Passenger ADD MEMBER passenger1;

CREATE LOGIN passenger2 WITH PASSWORD = 'PassP@ss2';
CREATE USER passenger2 FOR LOGIN passenger2;
ALTER ROLE db_Passenger ADD MEMBER passenger2;

CREATE LOGIN passenger3 WITH PASSWORD = 'PassP@ss3';
CREATE USER passenger3 FOR LOGIN passenger3;
ALTER ROLE db_Passenger ADD MEMBER passenger3;

-- CheckInAgent (3 пользователя) 
CREATE LOGIN checkin1 WITH PASSWORD = 'CheckP@ss1';
CREATE USER checkin1 FOR LOGIN checkin1;
ALTER ROLE db_CheckInAgent ADD MEMBER checkin1;

CREATE LOGIN checkin2 WITH PASSWORD = 'CheckP@ss2';
CREATE USER checkin2 FOR LOGIN checkin2;
ALTER ROLE db_CheckInAgent ADD MEMBER checkin2;

CREATE LOGIN checkin3 WITH PASSWORD = 'CheckP@ss3';
CREATE USER checkin3 FOR LOGIN checkin3;
ALTER ROLE db_CheckInAgent ADD MEMBER checkin3;