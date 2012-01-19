CREATE DATABASE [$(db_name)]
GO

USE [$(db_name)]
CREATE USER [$(user)] FOR LOGIN [$(user)]
GO

sp_addrolemember 'db_owner', [$(user)]
GO
