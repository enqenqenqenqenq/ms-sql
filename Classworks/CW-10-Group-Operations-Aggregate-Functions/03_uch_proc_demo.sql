-- =====================================================================
-- Практическая работа №10: «Групповые операции. Агрегатные функции»
-- Студент: Николаев Тимофей
-- Файл 3: База данных uch_proc и пошаговые Задания 1–7 из методички
-- =====================================================================

-- Создание базы данных uch_proc
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
CREATE TABLE student (
    ns VARCHAR(10) PRIMARY KEY NOT NULL, -- Номер студента (номер зачетки)
    fio VARCHAR(50) NOT NULL,            -- ФИО студента
    n_group VARCHAR(10)                  -- Номер группы
);
GO

-- 2. Таблица преподавателей
CREATE TABLE prepodavatel (
    np INT PRIMARY KEY NOT NULL,         -- Номер преподавателя
    fio VARCHAR(50) NOT NULL,            -- Фамилия И.О. преподавателя
    kafedra VARCHAR(50)                  -- Кафедра
);
GO

-- 3. Таблица предметов
CREATE TABLE predmet (
    kp INT PRIMARY KEY NOT NULL,         -- Код предмета
    name_predmet VARCHAR(50) NOT NULL    -- Название предмета
);
GO

-- 4. Таблица успеваемости
CREATE TABLE uspevaemost (
    id INT IDENTITY(1,1) PRIMARY KEY,
    ns VARCHAR(10) NOT NULL,             -- Номер студента
    kp INT NOT NULL,                     -- Код предмета
    ozenka INT NOT NULL                  -- Оценка
);
GO

-- =====================================================================
-- Тестовые данные для демонстрации работы заданий 1–7
-- =====================================================================

INSERT INTO student (ns, fio, n_group) VALUES
('01', 'Иванов Иван Иванович', 'ИС-31'),
('02', 'Петров Петр Петрович', 'ИС-31'),
('03', 'Сидорова Анна Сергеевна', 'ИС-32'),
('04', 'Кузнецов Михаил Васильевич', 'ИС-32');

INSERT INTO prepodavatel (np, fio, kafedra) VALUES
(1, 'Смирнов В.А.', 'Информатика'),
(2, 'Алексеев Д.Н.', 'Высшая математика'),
(3, 'Федорова Е.С.', 'Базы данных'),
(4, 'Борисов И.К.', 'Программирование');

INSERT INTO predmet (kp, name_predmet) VALUES
(101, 'Базы данных'),
(102, 'Операционные системы'),
(103, 'Алгоритмы и структуры данных');

INSERT INTO uspevaemost (ns, kp, ozenka) VALUES
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

-- =====================================================================
-- ВЫПОЛНЕНИЕ ЗАДАНИЙ ИЗ МЕТОДИЧЕСКИХ УКАЗАНИЙ
-- =====================================================================

-- Задание 1. Вывести среднюю оценку по таблице Успеваемость для студента с номером '01'
USE uch_proc;
SELECT AVG(CAST(ozenka AS FLOAT)) AS [Средняя оценка студента 01]
FROM uspevaemost
WHERE ns = '01';
GO

-- Задание 2. Определить в таблице Студент количество студентов в таблице
-- Вариант 1 (подсчет значений по полю ns):
USE uch_proc;
SELECT COUNT(ns) AS [Количество студентов (по ns)]
FROM student;

-- Вариант 2 (подсчет всех строк таблицы):
USE uch_proc;
SELECT COUNT(*) AS [Общее количество строк в student]
FROM student;
GO

-- Задание 3. Определить для каждого студента по таблице Успеваемость минимальную оценку
USE uch_proc;
SELECT ns, MIN(ozenka) AS 'наихудшая'
FROM uspevaemost
GROUP BY ns;
GO

-- Задание 4. Увидеть наименьшую оценку полученную каждым студентом по каждому предмету
-- (группировка по нескольким полям: ns и kp)
USE uch_proc;
SELECT ns, MIN(ozenka) AS 'наихудшая', kp
FROM uspevaemost
GROUP BY ns, kp;
GO

-- Задание 5. Вывести наименьшую оценку полученную студентом '01' по каждому предмету (предложение HAVING)
USE uch_proc;
SELECT ns, MIN(ozenka) AS 'наихудшая', kp
FROM uspevaemost
GROUP BY ns, kp
HAVING ns = '01';
GO

-- Задание 6. Вывести по алфавиту список фамилий преподавателей
USE uch_proc;
SELECT fio
FROM prepodavatel
ORDER BY fio;
GO

-- Задание 7. Вывести по порядку номера студентов в задании 4 (GROUP BY + ORDER BY)
USE uch_proc;
SELECT ns, MIN(ozenka) AS 'наихудшая', kp
FROM uspevaemost
GROUP BY ns, kp
ORDER BY ns;
GO
