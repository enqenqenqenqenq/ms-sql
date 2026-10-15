-- =====================================================================
-- Практическая работа №10: «Групповые операции. Агрегатные функции»
-- Студент: Николаев Тимофей
-- Файл 1: Создание базы данных uch_proc, структуры таблиц и первичное наполнение
-- =====================================================================

-- Создание базы данных uch_proc, если отсутствует
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'uch_proc')
BEGIN
    CREATE DATABASE uch_proc;
END
GO

USE uch_proc;
GO

-- Очистка таблиц перед созданием
IF OBJECT_ID('dbo.uspevaemost', 'U') IS NOT NULL DROP TABLE dbo.uspevaemost;
IF OBJECT_ID('dbo.student', 'U') IS NOT NULL DROP TABLE dbo.student;
IF OBJECT_ID('dbo.prepodavatel', 'U') IS NOT NULL DROP TABLE dbo.prepodavatel;
IF OBJECT_ID('dbo.predmet', 'U') IS NOT NULL DROP TABLE dbo.predmet;
GO

-- 1. Таблица студентов
CREATE TABLE dbo.student (
    ns VARCHAR(10) PRIMARY KEY NOT NULL,  -- Номер зачетки / студента
    fio NVARCHAR(60) NOT NULL,            -- ФИО студента
    n_group NVARCHAR(20) NOT NULL         -- Номер учебной группы
);
GO

-- 2. Таблица преподавателей
CREATE TABLE dbo.prepodavatel (
    np INT PRIMARY KEY NOT NULL,          -- Номер преподавателя
    fio NVARCHAR(60) NOT NULL,            -- Фамилия И.О. преподавателя
    kafedra NVARCHAR(60) NOT NULL         -- Кафедра
);
GO

-- 3. Таблица дисциплин (предметов)
CREATE TABLE dbo.predmet (
    kp INT PRIMARY KEY NOT NULL,          -- Код предмета
    name_predmet NVARCHAR(60) NOT NULL    -- Название предмета
);
GO

-- 4. Таблица успеваемости (оценки)
CREATE TABLE dbo.uspevaemost (
    id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    ns VARCHAR(10) NOT NULL,              -- Номер студента
    kp INT NOT NULL,                      -- Код предмета
    ozenka INT NOT NULL,                  -- Оценка (2, 3, 4, 5)
    CONSTRAINT FK_uspevaemost_student FOREIGN KEY (ns)
        REFERENCES dbo.student(ns)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT FK_uspevaemost_predmet FOREIGN KEY (kp)
        REFERENCES dbo.predmet(kp)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT CK_uspevaemost_ozenka CHECK (ozenka BETWEEN 2 AND 5)
);
GO

-- =====================================================================
-- Заполнение таблиц тестовыми данными
-- =====================================================================

INSERT INTO dbo.student (ns, fio, n_group) VALUES
('01', N'Иванов Иван Иванович', N'ИС-31'),
('02', N'Петров Петр Петрович', N'ИС-31'),
('03', N'Сидорова Анна Сергеевна', N'ИС-32'),
('04', N'Кузнецов Михаил Васильевич', N'ИС-32');
GO

INSERT INTO dbo.prepodavatel (np, fio, kafedra) VALUES
(1, N'Смирнов В.А.', N'Информатика'),
(2, N'Алексеев Д.Н.', N'Высшая математика'),
(3, N'Федорова Е.С.', N'Базы данных'),
(4, N'Борисов И.К.', N'Программирование');
GO

INSERT INTO dbo.predmet (kp, name_predmet) VALUES
(101, N'Базы данных'),
(102, N'Операционные системы'),
(103, N'Алгоритмы и структуры данных');
GO

INSERT INTO dbo.uspevaemost (ns, kp, ozenka) VALUES
('01', 101, 4),
('01', 101, 5),
('01', 102, 3),
('01', 103, 4),
('02', 101, 5),
('02', 102, 4),
('02', 103, 5),
('03', 101, 3),
('03', 102, 3),
('03', 103, 4),
('04', 101, 4),
('04', 102, 5),
('04', 103, 4);
GO

-- Проверка наполнения
SELECT COUNT(*) AS [Студентов] FROM dbo.student;
SELECT COUNT(*) AS [Преподавателей] FROM dbo.prepodavatel;
SELECT COUNT(*) AS [Предметов] FROM dbo.predmet;
SELECT COUNT(*) AS [Оценок] FROM dbo.uspevaemost;
GO
