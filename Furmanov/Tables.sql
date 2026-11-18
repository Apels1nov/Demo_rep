USE AirlineBD

CREATE TABLE dbo.Audit(
	AuditID INT IDENTITY(1,1) PRIMARY KEY,
    TableName NVARCHAR(128) NOT NULL,
    OperationType CHAR(6) NOT NULL,
    RecordID INT NOT NULL,
    OldValue NVARCHAR(MAX) NULL,
    NewValue NVARCHAR(MAX) NULL,
    UserName NVARCHAR(128) NOT NULL,
    EventTime DATETIME2 NOT NULL DEFAULT GETDATE()
) ON FG_Audit;

-- Самолёты
CREATE TABLE dbo.Aircrafts (
    aircraft_id INT PRIMARY KEY,
    model VARCHAR(100) NOT NULL,
    capacity INT CHECK (capacity > 0) NOT NULL
) ON [PRIMARY];

-- Экипажи
CREATE TABLE dbo.Crews (
    crew_id INT PRIMARY KEY,
    captain_name VARCHAR(100) NOT NULL,
    copilot_name VARCHAR(100) NOT NULL,
    cabin_crew_count INT CHECK (cabin_crew_count >= 0)
) ON [PRIMARY];

-- Рейсы
CREATE TABLE dbo.Flights (
    flight_id INT PRIMARY KEY,
	flight_date DATE NOT NULL,
    scheduled_departure VARCHAR(100) NOT NULL,
    scheduled_arrival VARCHAR(100) NOT NULL,
    Status VARCHAR(100) DEFAULT 'Scheduled',
    aircraft_id INT NOT NULL,
    crew_id INT NOT NULL,
    FOREIGN KEY (aircraft_id) REFERENCES Aircrafts(aircraft_id),
    FOREIGN KEY (crew_id) REFERENCES Crews(crew_id),
    --Вылет раньше прилёта
	CONSTRAINT CHK_Flights_DepartureBeforeArrival 
	CHECK (scheduled_departure < scheduled_arrival),
	--Время отлета не в прошлом
	CONSTRAINT CHK_Flights_DateNotInPast 
    CHECK (flight_date >= CAST(GETDATE() AS DATE))
) ON FG_Secondary;

-- Пассажиры
CREATE TABLE dbo.Passengers (
    passenger_id INT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    contact_phone VARCHAR(20) NOT NULL,
) ON FG_Secondary;

-- Бронирования
CREATE TABLE dbo.Booking (
    booking_id INT PRIMARY KEY,
    passenger_id INT NULL,
    flight_id INT NULL,
    seat_number VARCHAR(10) NOT NULL,
    booking_status VARCHAR(20) DEFAULT 'Confirmed' NOT NULL,
    FOREIGN KEY (passenger_id) REFERENCES Passengers(passenger_id),
    FOREIGN KEY (flight_id) REFERENCES Flights(flight_id),
	--Типы статусов
	CONSTRAINT CHK_Bookings_Status 
    CHECK (booking_status IN ('Confirmed','Cancelled','CheckedIn','NoShow'))
) ON FG_Secondary;

-- Посадочные талоны
CREATE TABLE dbo.BoardingPasses (
    boarding_pass_id INT PRIMARY KEY,
    booking_id INT,
    gate_number VARCHAR(10) NOT NULL,
    FOREIGN KEY (booking_id) REFERENCES Booking(booking_id)
) ON FG_Secondary;