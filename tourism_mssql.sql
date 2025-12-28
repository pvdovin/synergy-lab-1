CREATE DATABASE TourismDB;
GO

USE TourismDB;
GO

CREATE TABLE dbo.Countries (
    CountryID INT IDENTITY(1,1) PRIMARY KEY,
    CountryName NVARCHAR(100) NOT NULL
);
GO

CREATE TABLE dbo.Cities (
    CityID INT IDENTITY(1,1) PRIMARY KEY,
    CityName NVARCHAR(100) NOT NULL,
    CountryID INT NOT NULL,
    CONSTRAINT FK_Cities_Countries FOREIGN KEY (CountryID)
        REFERENCES dbo.Countries (CountryID)
);
GO

CREATE TABLE dbo.Tours (
    TourID INT IDENTITY(1,1) PRIMARY KEY,
    TourName NVARCHAR(150) NOT NULL,
    CityID INT NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    CONSTRAINT FK_Tours_Cities FOREIGN KEY (CityID)
        REFERENCES dbo.Cities (CityID)
);
GO

CREATE TABLE dbo.Services (
    ServiceID INT IDENTITY(1,1) PRIMARY KEY,
    ServiceName NVARCHAR(150) NOT NULL,
    Price DECIMAL(10,2) NOT NULL
);
GO

CREATE TABLE dbo.Orders (
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    TourID INT NOT NULL,
    ServiceID INT NOT NULL,
    OrderDate DATE NOT NULL,
    TravelersCount INT NOT NULL,
    TotalPrice DECIMAL(10,2) NOT NULL,
    CONSTRAINT FK_Orders_Tours FOREIGN KEY (TourID)
        REFERENCES dbo.Tours (TourID),
    CONSTRAINT FK_Orders_Services FOREIGN KEY (ServiceID)
        REFERENCES dbo.Services (ServiceID)
);
GO

INSERT INTO dbo.Countries (CountryName)
VALUES
    (N'Турция'),
    (N'Испания'),
    (N'Италия');
GO

INSERT INTO dbo.Cities (CityName, CountryID)
VALUES
    (N'Анталья', 1),
    (N'Барселона', 2),
    (N'Рим', 3),
    (N'Валенсия', 2);
GO

INSERT INTO dbo.Tours (TourName, CityID, Price)
VALUES
    (N'Солнечные пляжи', 1, 1200.00),
    (N'Гауди и море', 2, 1500.00),
    (N'Вечный город', 3, 1800.00),
    (N'Средиземноморский уикенд', 4, 1100.00);
GO

INSERT INTO dbo.Services (ServiceName, Price)
VALUES
    (N'Стандартный пакет', 200.00),
    (N'Экскурсии', 350.00),
    (N'VIP трансфер', 500.00);
GO

INSERT INTO dbo.Orders (TourID, ServiceID, OrderDate, TravelersCount, TotalPrice)
VALUES
    (1, 1, '2024-03-01', 2, 1600.00),
    (2, 2, '2024-03-05', 1, 1850.00),
    (3, 3, '2024-03-10', 3, 2400.00),
    (4, 1, '2024-03-12', 2, 1500.00);
GO
