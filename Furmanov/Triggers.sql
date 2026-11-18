USE AirlineDB;
GO
--AIRCRAFTS--
CREATE TRIGGER trg_Aircrafts_Audit
ON dbo.Aircrafts
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.Audit (TableName, OperationType, RecordID, NewValue, UserName)
    SELECT 'Aircrafts', 'INSERT', aircraft_id,
           CAST(model AS NVARCHAR(MAX)) + CAST(capacity AS NVARCHAR(20)),
           SYSTEM_USER
    FROM inserted
    WHERE NOT EXISTS (SELECT 1 FROM deleted WHERE deleted.aircraft_id = inserted.aircraft_id);

    INSERT INTO dbo.Audit (TableName, OperationType, RecordID, OldValue, UserName)
    SELECT 'Aircrafts', 'DELETE', aircraft_id,
           CAST(model AS NVARCHAR(MAX)) + CAST(capacity AS NVARCHAR(20)),
           SYSTEM_USER
    FROM deleted
    WHERE NOT EXISTS (SELECT 1 FROM inserted WHERE inserted.aircraft_id = deleted.aircraft_id);

    INSERT INTO dbo.Audit (TableName, OperationType, RecordID, OldValue, NewValue, UserName)
    SELECT 'Aircrafts', 'UPDATE', i.aircraft_id,
           CAST(d.model AS NVARCHAR(MAX)) + CAST(d.capacity AS NVARCHAR(20)),
           CAST(i.model AS NVARCHAR(MAX)) + CAST(i.capacity AS NVARCHAR(20)),
           SYSTEM_USER
    FROM inserted i
    INNER JOIN deleted d ON i.aircraft_id = d.aircraft_id;
END;
GO

--CREWS--
CREATE TRIGGER trg_Crews_Audit
ON dbo.Crews
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.Audit (TableName, OperationType, RecordID, NewValue, UserName)
    SELECT 'Crews', 'INSERT', crew_id,
           CAST(captain_name AS NVARCHAR(MAX)) + CAST(copilot_name AS NVARCHAR(MAX))
           + ' | cabin_crew=' + CAST(cabin_crew_count AS NVARCHAR(10)),
           SYSTEM_USER
    FROM inserted
    WHERE NOT EXISTS (SELECT 1 FROM deleted WHERE deleted.crew_id = inserted.crew_id);

    INSERT INTO dbo.Audit (TableName, OperationType, RecordID, OldValue, UserName)
    SELECT 'Crews', 'DELETE', crew_id,
           CAST(captain_name AS NVARCHAR(MAX)) + CAST(copilot_name AS NVARCHAR(MAX))
		   + CAST(cabin_crew_count AS NVARCHAR(10)),
           SYSTEM_USER
    FROM deleted
    WHERE NOT EXISTS (SELECT 1 FROM inserted WHERE inserted.crew_id = deleted.crew_id);

    INSERT INTO dbo.Audit (TableName, OperationType, RecordID, OldValue, NewValue, UserName)
    SELECT 'Crews', 'UPDATE', i.crew_id,
           CAST(d.captain_name AS NVARCHAR(MAX)) + CAST(d.copilot_name AS NVARCHAR(MAX))
           + CAST(d.cabin_crew_count AS NVARCHAR(10)),
           CAST(i.captain_name AS NVARCHAR(MAX)) + CAST(i.copilot_name AS NVARCHAR(MAX))
           + CAST(i.cabin_crew_count AS NVARCHAR(10)),
           SYSTEM_USER
    FROM inserted i
    INNER JOIN deleted d ON i.crew_id = d.crew_id;
END;
GO

--FLIGHTS--
CREATE TRIGGER trg_Flights_Audit
ON dbo.Flights
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.Audit (TableName, OperationType, RecordID, NewValue, UserName)
    SELECT 'Flights', 'INSERT', flight_id,
           CONVERT(NVARCHAR(10), flight_date, 120)
           + CONVERT(NVARCHAR(19), scheduled_departure, 120)
           + CONVERT(NVARCHAR(19), scheduled_arrival, 120)
           + Status
           + CAST(aircraft_id AS NVARCHAR(10))
           + CAST(crew_id AS NVARCHAR(10)),
           SYSTEM_USER
    FROM inserted
    WHERE NOT EXISTS (SELECT 1 FROM deleted WHERE deleted.flight_id = inserted.flight_id);

    INSERT INTO dbo.Audit (TableName, OperationType, RecordID, OldValue, UserName)
    SELECT 'Flights', 'DELETE', flight_id,
           CONVERT(NVARCHAR(10), flight_date, 120)
           + CONVERT(NVARCHAR(19), scheduled_departure, 120)
           + CONVERT(NVARCHAR(19), scheduled_arrival, 120)
           + Status
           + CAST(aircraft_id AS NVARCHAR(10))
           + CAST(crew_id AS NVARCHAR(10)),
           SYSTEM_USER
    FROM deleted
    WHERE NOT EXISTS (SELECT 1 FROM inserted WHERE inserted.flight_id = deleted.flight_id);

    INSERT INTO dbo.Audit (TableName, OperationType, RecordID, OldValue, NewValue, UserName)
    SELECT 'Flights', 'UPDATE', i.flight_id,
           CONVERT(NVARCHAR(10), d.flight_date, 120)
           + CONVERT(NVARCHAR(19), d.scheduled_departure, 120)
           + CONVERT(NVARCHAR(19), d.scheduled_arrival, 120)
           + d.Status
           + CAST(d.aircraft_id AS NVARCHAR(10))
           + CAST(d.crew_id AS NVARCHAR(10)),
           CONVERT(NVARCHAR(10), i.flight_date, 120)
           + CONVERT(NVARCHAR(19), i.scheduled_departure, 120)
           + CONVERT(NVARCHAR(19), i.scheduled_arrival, 120)
           + i.Status
           + CAST(i.aircraft_id AS NVARCHAR(10))
           + CAST(i.crew_id AS NVARCHAR(10)),
           SYSTEM_USER
    FROM inserted i
    INNER JOIN deleted d ON i.flight_id = d.flight_id;
END;
GO

--PASSENGERS--
CREATE TRIGGER trg_Passengers_Audit
ON dbo.Passengers
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.Audit (TableName, OperationType, RecordID, NewValue, UserName)
    SELECT 'Passengers', 'INSERT', passenger_id,
           CAST(full_name AS NVARCHAR(MAX)) + contact_phone,
           SYSTEM_USER
    FROM inserted
    WHERE NOT EXISTS (SELECT 1 FROM deleted WHERE deleted.passenger_id = inserted.passenger_id);

    INSERT INTO dbo.Audit (TableName, OperationType, RecordID, OldValue, UserName)
    SELECT 'Passengers', 'DELETE', passenger_id,
           CAST(full_name AS NVARCHAR(MAX)) + contact_phone,
           SYSTEM_USER
    FROM deleted
    WHERE NOT EXISTS (SELECT 1 FROM inserted WHERE inserted.passenger_id = deleted.passenger_id);

    INSERT INTO dbo.Audit (TableName, OperationType, RecordID, OldValue, NewValue, UserName)
    SELECT 'Passengers', 'UPDATE', i.passenger_id,
           CAST(d.full_name AS NVARCHAR(MAX)) + d.contact_phone,
           CAST(i.full_name AS NVARCHAR(MAX)) + i.contact_phone,
           SYSTEM_USER
    FROM inserted i
    INNER JOIN deleted d ON i.passenger_id = d.passenger_id;
END;
GO

--BOOKING--
CREATE TRIGGER trg_Booking_Audit
ON dbo.Booking
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.Audit (TableName, OperationType, RecordID, NewValue, UserName)
    SELECT 'Booking', 'INSERT', booking_id,
           CAST(passenger_id AS NVARCHAR(10))
           + CAST(flight_id AS NVARCHAR(10))
           + seat_number
           + booking_status,
           SYSTEM_USER
    FROM inserted
    WHERE NOT EXISTS (SELECT 1 FROM deleted WHERE deleted.booking_id = inserted.booking_id);

    INSERT INTO dbo.Audit (TableName, OperationType, RecordID, OldValue, UserName)
    SELECT 'Booking', 'DELETE', booking_id,
           CAST(passenger_id AS NVARCHAR(10))
           + CAST(flight_id AS NVARCHAR(10))
           + seat_number
           + booking_status,
           SYSTEM_USER
    FROM deleted
    WHERE NOT EXISTS (SELECT 1 FROM inserted WHERE inserted.booking_id = deleted.booking_id);

    INSERT INTO dbo.Audit (TableName, OperationType, RecordID, OldValue, NewValue, UserName)
    SELECT 'Booking', 'UPDATE', i.booking_id,
           CAST(d.passenger_id AS NVARCHAR(10))
           + CAST(d.flight_id AS NVARCHAR(10))
           + d.seat_number
           + d.booking_status,
           + CAST(i.passenger_id AS NVARCHAR(10))
           + CAST(i.flight_id AS NVARCHAR(10))
           + i.seat_number
           + i.booking_status,
           SYSTEM_USER
    FROM inserted i
    INNER JOIN deleted d ON i.booking_id = d.booking_id;
END;
GO

--BOARDING_PASSES--
CREATE TRIGGER trg_BoardingPasses_Audit
ON dbo.BoardingPasses
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.Audit (TableName, OperationType, RecordID, NewValue, UserName)
    SELECT 'BoardingPasses', 'INSERT', boarding_pass_id,
           CAST(booking_id AS NVARCHAR(10))+ gate_number,
           SYSTEM_USER
    FROM inserted
    WHERE NOT EXISTS (SELECT 1 FROM deleted WHERE deleted.boarding_pass_id = inserted.boarding_pass_id);

    INSERT INTO dbo.Audit (TableName, OperationType, RecordID, OldValue, UserName)
    SELECT 'BoardingPasses', 'DELETE', boarding_pass_id,
           CAST(booking_id AS NVARCHAR(10))+ gate_number,
           SYSTEM_USER
    FROM deleted
    WHERE NOT EXISTS (SELECT 1 FROM inserted WHERE inserted.boarding_pass_id = deleted.boarding_pass_id);

    INSERT INTO dbo.Audit (TableName, OperationType, RecordID, OldValue, NewValue, UserName)
    SELECT 'BoardingPasses', 'UPDATE', i.boarding_pass_id,
           CAST(d.booking_id AS NVARCHAR(10))+ d.gate_number,
           CAST(i.booking_id AS NVARCHAR(10))+ i.gate_number,
           SYSTEM_USER
    FROM inserted i
    INNER JOIN deleted d ON i.boarding_pass_id = d.boarding_pass_id;
END;
GO

