USE AirlineBD;
GO
   --Триггер 1. Flights — статусы рейсов + назначение экипажей--

CREATE OR ALTER TRIGGER trg_Flights_Audit
ON dbo.Flights
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.Audit (TableName, OperationType, RecordID, NewValue, UserName)
    SELECT 
        'Flights',
        'INSERT',
        i.flight_id,
        CONCAT(
            'flight_date=', CONVERT(NVARCHAR(10), i.flight_date, 120),
            '; dep=', CONVERT(NVARCHAR(19), i.scheduled_departure, 120),
            '; arr=', CONVERT(NVARCHAR(19), i.scheduled_arrival, 120),
            '; Status=', i.Status,
            '; aircraft_id=', i.aircraft_id,
            '; crew_id=', i.crew_id
        ),
        SYSTEM_USER
    FROM inserted i
    WHERE NOT EXISTS (
        SELECT 1 FROM deleted d WHERE d.flight_id = i.flight_id
    );

    INSERT INTO dbo.Audit (TableName, OperationType, RecordID, OldValue, UserName)
    SELECT 
        'Flights',
        'DELETE',
        d.flight_id,
        CONCAT(
            'flight_date=', CONVERT(NVARCHAR(10), d.flight_date, 120),
            '; dep=', CONVERT(NVARCHAR(19), d.scheduled_departure, 120),
            '; arr=', CONVERT(NVARCHAR(19), d.scheduled_arrival, 120),
            '; Status=', d.Status,
            '; aircraft_id=', d.aircraft_id,
            '; crew_id=', d.crew_id
        ),
        SYSTEM_USER
    FROM deleted d
    WHERE NOT EXISTS (
        SELECT 1 FROM inserted i WHERE i.flight_id = d.flight_id
    );

    INSERT INTO dbo.Audit (TableName, OperationType, RecordID, OldValue, NewValue, UserName)
    SELECT 
        'Flights',
        'UPDATE',
        i.flight_id,
        CONCAT(
            'Status=', d.Status,
            '; crew_id=', d.crew_id,
            '; aircraft_id=', d.aircraft_id,
            '; dep=', CONVERT(NVARCHAR(19), d.scheduled_departure, 120),
            '; arr=', CONVERT(NVARCHAR(19), d.scheduled_arrival, 120)
        ),
        CONCAT(
            'Status=', i.Status,
            '; crew_id=', i.crew_id,
            '; aircraft_id=', i.aircraft_id,
            '; dep=', CONVERT(NVARCHAR(19), i.scheduled_departure, 120),
            '; arr=', CONVERT(NVARCHAR(19), i.scheduled_arrival, 120)
        ),
        SYSTEM_USER
    FROM inserted i
    INNER JOIN deleted d ON i.flight_id = d.flight_id
    WHERE i.Status				<> d.Status
       OR i.crew_id				<> d.crew_id
       OR i.aircraft_id			<> d.aircraft_id
       OR i.scheduled_departure <> d.scheduled_departure
       OR i.scheduled_arrival   <> d.scheduled_arrival;
END;
GO

   --Триггер 2. Booking — удаление бронирований + смена статусов--
 
CREATE OR ALTER TRIGGER trg_Booking_Audit
ON dbo.Booking
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.Audit (TableName, OperationType, RecordID, NewValue, UserName)
    SELECT 
        'Booking',
        'INSERT',
        i.booking_id,
        CONCAT(
            'passenger_id=', i.passenger_id,
            '; flight_id=', i.flight_id,
            '; seat=', i.seat_number,
            '; status=', i.booking_status
        ),
        SYSTEM_USER
    FROM inserted i
    WHERE NOT EXISTS (
        SELECT 1 FROM deleted d WHERE d.booking_id = i.booking_id
    );

    INSERT INTO dbo.Audit (TableName, OperationType, RecordID, OldValue, UserName)
    SELECT 
        'Booking',
        'DELETE',
        d.booking_id,
        CONCAT(
            'passenger_id=', d.passenger_id,
            '; flight_id=', d.flight_id,
            '; seat=', d.seat_number,
            '; status=', d.booking_status
        ),
        SYSTEM_USER
    FROM deleted d
    WHERE NOT EXISTS (
        SELECT 1 FROM inserted i WHERE i.booking_id = d.booking_id
    );

    INSERT INTO dbo.Audit (TableName, OperationType, RecordID, OldValue, NewValue, UserName)
    SELECT 
        'Booking',
        'UPDATE',
        i.booking_id,
        CONCAT('status= ', d.booking_status, '; seat=', d.seat_number),
        CONCAT('status= ', i.booking_status, '; seat=', i.seat_number),
        SYSTEM_USER
    FROM inserted i
    INNER JOIN deleted d ON i.booking_id = d.booking_id
    WHERE i.booking_status <> d.booking_status
       OR i.seat_number    <> d.seat_number;
END;
GO