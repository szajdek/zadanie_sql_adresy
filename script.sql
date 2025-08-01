USE [master]
GO
/****** Object:  Database [AddressBookDB]    Script Date: 17.06.2025 22:15:10 ******/
CREATE DATABASE [AddressBookDB]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'AddressBookDB', FILENAME = N'C:\Users\Tomek\AddressBookDB.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'AddressBookDB_log', FILENAME = N'C:\Users\Tomek\AddressBookDB_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [AddressBookDB] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [AddressBookDB].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [AddressBookDB] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [AddressBookDB] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [AddressBookDB] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [AddressBookDB] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [AddressBookDB] SET ARITHABORT OFF 
GO
ALTER DATABASE [AddressBookDB] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [AddressBookDB] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [AddressBookDB] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [AddressBookDB] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [AddressBookDB] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [AddressBookDB] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [AddressBookDB] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [AddressBookDB] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [AddressBookDB] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [AddressBookDB] SET  DISABLE_BROKER 
GO
ALTER DATABASE [AddressBookDB] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [AddressBookDB] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [AddressBookDB] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [AddressBookDB] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [AddressBookDB] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [AddressBookDB] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [AddressBookDB] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [AddressBookDB] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [AddressBookDB] SET  MULTI_USER 
GO
ALTER DATABASE [AddressBookDB] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [AddressBookDB] SET DB_CHAINING OFF 
GO
ALTER DATABASE [AddressBookDB] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [AddressBookDB] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [AddressBookDB] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [AddressBookDB] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [AddressBookDB] SET QUERY_STORE = OFF
GO
USE [AddressBookDB]
GO
/****** Object:  Table [dbo].[Contacts]    Script Date: 17.06.2025 22:15:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Contacts](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [nvarchar](10) NOT NULL,
	[LastName] [nvarchar](20) NOT NULL,
	[DateOfBirth] [date] NOT NULL,
	[PhoneNumber] [varchar](14) NOT NULL,
	[Status] [varchar](10) NOT NULL,
	[CityId] [int] NOT NULL,
 CONSTRAINT [PK_Contacts] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [Unique_PhoneNumber] UNIQUE NONCLUSTERED 
(
	[PhoneNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PostalCodes]    Script Date: 17.06.2025 22:15:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PostalCodes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[PostalCode] [varchar](6) NOT NULL,
	[City] [nvarchar](20) NOT NULL,
 CONSTRAINT [PK_PostalCodes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [Unique_PostalCode] UNIQUE NONCLUSTERED 
(
	[PostalCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[ContactsView]    Script Date: 17.06.2025 22:15:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ContactsView] AS
SELECT 
c.Id,
c.FirstName,
c.LastName,
c.DateOfBirth,
c.PhoneNumber,
c.Status,
pc.PostalCode,
pc.City
FROM Contacts as c
INNER JOIN PostalCodes as pc on c.CityId = pc.Id
GO
ALTER TABLE [dbo].[Contacts]  WITH CHECK ADD  CONSTRAINT [FK_Contacts_PostalCodes] FOREIGN KEY([CityId])
REFERENCES [dbo].[PostalCodes] ([Id])
GO
ALTER TABLE [dbo].[Contacts] CHECK CONSTRAINT [FK_Contacts_PostalCodes]
GO
/****** Object:  StoredProcedure [dbo].[AddCity]    Script Date: 17.06.2025 22:15:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddCity]
@PostalCode VARCHAR(6),
@City NVARCHAR(20)
AS
INSERT INTO PostalCodes(PostalCode, City)
VALUES (@PostalCode, @City)
GO
/****** Object:  StoredProcedure [dbo].[AddContact]    Script Date: 17.06.2025 22:15:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddContact]
@FirstName NVARCHAR(10),
@LastName NVARCHAR(20),
@DateOfBirth DATE,
@PhoneNumber VARCHAR(14),
@Status VARCHAR(10),
@CityId INT
AS
INSERT INTO Contacts (FirstName, LastName, DateOfBirth, PhoneNumber, Status, CityId)
VALUES (@FirstName, @LastName, @DateOfBirth, @PhoneNumber, @Status, @CityId)
GO
/****** Object:  StoredProcedure [dbo].[GetAllCities]    Script Date: 17.06.2025 22:15:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetAllCities]
AS
SELECT 
Id,
PostalCode + ' ' + City as PostalCodeAndCity
FROM PostalCodes
ORDER BY PostalCode
GO
/****** Object:  StoredProcedure [dbo].[GetAllContacts]    Script Date: 17.06.2025 22:15:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetAllContacts]
AS
SELECT *
FROM ContactsView
GO
/****** Object:  StoredProcedure [dbo].[GetContactById]    Script Date: 17.06.2025 22:15:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetContactById]
@Id INT
AS
SELECT *
FROM Contacts
WHERE Id = @Id
GO
/****** Object:  StoredProcedure [dbo].[UpdateContact]    Script Date: 17.06.2025 22:15:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateContact]
@Id INT,
@FirstName NVARCHAR(10),
@LastName NVARCHAR(20),
@DateOfBirth DATE,
@PhoneNumber VARCHAR(14),
@Status VARCHAR(10),
@CityId INT
AS
UPDATE Contacts
SET
FirstName = @FirstName,
LastName = @LastName,
DateOfBirth = @DateOfBirth,
PhoneNumber = @PhoneNumber,
Status = @Status,
CityId = @CityId
WHERE Id = @Id
GO
USE [master]
GO
ALTER DATABASE [AddressBookDB] SET  READ_WRITE 
GO
