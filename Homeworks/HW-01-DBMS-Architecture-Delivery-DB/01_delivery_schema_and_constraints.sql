-- =====================================================================
-- Практическая работа №1: «Функциональность и архитектура СУБД Microsoft SQL Server»
-- Студент: Николаев Тимофей
-- Файл 1: Создание базы данных DELIVERY, структуры таблиц, связей и ограничений CHECK
-- =====================================================================

-- Создание базы данных DELIVERY, если она отсутствует
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'DELIVERY')
BEGIN
    CREATE DATABASE DELIVERY;
END
GO

USE DELIVERY;
GO

-- Очистка таблиц перед созданием с учетом внешних ключей
IF OBJECT_ID('dbo.Поставлено', 'U') IS NOT NULL DROP TABLE dbo.Поставлено;
IF OBJECT_ID('dbo.Договоры', 'U') IS NOT NULL DROP TABLE dbo.Договоры;
IF OBJECT_ID('dbo.ЮридическиеЛица', 'U') IS NOT NULL DROP TABLE dbo.ЮридическиеЛица;
IF OBJECT_ID('dbo.ФизическиеЛица', 'U') IS NOT NULL DROP TABLE dbo.ФизическиеЛица;
IF OBJECT_ID('dbo.Поставщики', 'U') IS NOT NULL DROP TABLE dbo.Поставщики;
GO

-- 1. Таблица «Поставщики» (базовая сущность)
CREATE TABLE dbo.Поставщики (
    КодПоставщика INT PRIMARY KEY NOT NULL,
    Адрес NVARCHAR(255) NOT NULL,
    Примечание NVARCHAR(255) NULL
);
GO

-- 2. Таблица «ФизическиеЛица» (подтип сущности Поставщики, связь 1:1)
CREATE TABLE dbo.ФизическиеЛица (
    КодПоставщика INT PRIMARY KEY NOT NULL,
    Фамилия CHAR(20) NOT NULL,
    Имя CHAR(20) NOT NULL,
    Отчество CHAR(20) NOT NULL,
    ОГРНИП CHAR(10) NOT NULL,
    CONSTRAINT FK_ФизическиеЛица_Поставщики FOREIGN KEY (КодПоставщика)
        REFERENCES dbo.Поставщики(КодПоставщика)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
GO

-- 3. Таблица «ЮридическиеЛица» (подтип сущности Поставщики, связь 1:1)
CREATE TABLE dbo.ЮридическиеЛица (
    КодПоставщика INT PRIMARY KEY NOT NULL,
    Наименование CHAR(20) NOT NULL,
    ИНН CHAR(20) NOT NULL,
    ОГРН CHAR(10) NOT NULL,
    CONSTRAINT FK_ЮридическиеЛица_Поставщики FOREIGN KEY (КодПоставщика)
        REFERENCES dbo.Поставщики(КодПоставщика)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
GO

-- 4. Таблица «Договоры» (связь 1:N с Поставщиками, автоинкремент Identity(1,1))
CREATE TABLE dbo.Договоры (
    НомерДоговора INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    ДатаДоговора DATETIME NULL,
    КодПоставщика INT NOT NULL,
    Комментарий NVARCHAR(255) NULL,
    CONSTRAINT FK_Договоры_Поставщики FOREIGN KEY (КодПоставщика)
        REFERENCES dbo.Поставщики(КодПоставщика)
        ON DELETE NO ACTION
        ON UPDATE CASCADE
);
GO

-- 5. Таблица «Поставлено» (составной PK, проверочные ограничения CHECK)
CREATE TABLE dbo.Поставлено (
    НомерДоговора INT NOT NULL,
    Товар CHAR(20) NOT NULL,
    Количество DECIMAL(5,0) NOT NULL,
    Цена DECIMAL(8,2) NOT NULL,
    CONSTRAINT PK_Поставлено PRIMARY KEY (НомерДоговора, Товар),
    CONSTRAINT FK_Поставлено_Договоры FOREIGN KEY (НомерДоговора)
        REFERENCES dbo.Договоры(НомерДоговора)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT СК_Поставлено_Количество CHECK ([Количество] > 0),
    CONSTRAINT СК_Поставлено_Цена CHECK ([Цена] > 0)
);
GO
