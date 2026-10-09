-- =====================================================================
-- Практическая работа №10: «Групповые операции. Агрегатные функции»
-- Студент: Николаев Тимофей
-- Файл 1: Создание базы данных DB_BOOKS, таблиц и заполнение тестовыми данными
-- =====================================================================

-- Создание базы данных, если она еще не создана
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'DB_BOOKS')
BEGIN
    CREATE DATABASE DB_BOOKS;
END
GO

USE DB_BOOKS;
GO

-- Очистка таблиц перед пересозданием (с учетом внешних ключей)
IF OBJECT_ID('dbo.Purchases', 'U') IS NOT NULL DROP TABLE dbo.Purchases;
IF OBJECT_ID('dbo.Books', 'U') IS NOT NULL DROP TABLE dbo.Books;
IF OBJECT_ID('dbo.Deliveries', 'U') IS NOT NULL DROP TABLE dbo.Deliveries;
IF OBJECT_ID('dbo.Publishing_house', 'U') IS NOT NULL DROP TABLE dbo.Publishing_house;
IF OBJECT_ID('dbo.Authors', 'U') IS NOT NULL DROP TABLE dbo.Authors;
GO

-- 1. Таблица авторов
CREATE TABLE Authors(
    Code_author INT PRIMARY KEY NOT NULL, -- Код автора
    Name_author CHAR(30),                 -- Фамилия автора
    Birthday DATETIME                     -- Дата рождения
);
GO

-- 2. Таблица издательств
CREATE TABLE Publishing_house(
    Code_publish INT PRIMARY KEY NOT NULL, -- Код издательства
    Publish CHAR(30),                      -- Название издательства
    City CHAR(20)                          -- Город издательства
);
GO

-- 3. Таблица книг
CREATE TABLE Books(
    Code_book INT PRIMARY KEY NOT NULL,    -- Код книги
    Title_book CHAR(40),                   -- Название книги
    Code_author INT FOREIGN KEY REFERENCES Authors(Code_author),
    Pages INT,
    Code_publish INT FOREIGN KEY REFERENCES Publishing_house(Code_publish)
);
GO

-- 4. Таблица доставщиков
CREATE TABLE Deliveries(
    Code_delivery INT PRIMARY KEY NOT NULL, -- Код доставщика
    Name_delivery CHAR(30),                 -- Наименование доставщика
    Name_company CHAR(20),                  -- Наименование компании
    Address_company VARCHAR(100),           -- Адрес
    Phone BIGINT,                           -- Телефон
    INN CHAR(13)                            -- ИНН
);
GO

-- 5. Таблица покупок (продаж)
CREATE TABLE Purchases(
    Code_purchase INT PRIMARY KEY NOT NULL, -- Код продажи
    Code_book INT FOREIGN KEY REFERENCES Books(Code_book),
    Date_order SMALLDATETIME,               -- Дата
    Code_delivery INT FOREIGN KEY REFERENCES Deliveries(Code_delivery),
    Type_purchase BIT,                      -- Тип продажи (1 - безналичный, 0 - наличный)
    Cost FLOAT,                             -- Цена за единицу
    Amount INT                              -- Количество
);
GO

-- =====================================================================
-- Заполнение таблиц тестовыми данными для проверки агрегатных функций
-- =====================================================================

-- Авторы
INSERT INTO Authors (Code_author, Name_author, Birthday) VALUES
(1, 'Толстой Л.Н.', '1828-09-09'),
(2, 'Достоевский Ф.М.', '1821-11-11'),
(3, 'Чехов А.П.', '1860-01-29'),
(4, 'Булгаков М.А.', '1891-05-15'),
(5, 'Гоголь Н.В.', '1809-04-01');

-- Издательства
INSERT INTO Publishing_house (Code_publish, Publish, City) VALUES
(1, 'Просвещение', 'Москва'),
(2, 'Питер', 'Санкт-Петербург'),
(3, 'Эксмо', 'Москва'),
(4, 'АСТ', 'Москва'),
(5, 'БХВ-Петербург', 'Санкт-Петербург');

-- Книги
INSERT INTO Books (Code_book, Title_book, Code_author, Pages, Code_publish) VALUES
(101, 'Война и мир (Том 1)', 1, 720, 1),
(102, 'Война и мир (Том 2)', 1, 680, 1),
(103, 'Анна Каренина', 1, 864, 3),
(104, 'Преступление и наказание', 2, 608, 2),
(105, 'Идиот', 2, 640, 4),
(106, 'Вишневый сад', 3, 160, 3),
(107, 'Палата №6', 3, 128, 4),
(108, 'Мастер и Маргарита', 4, 480, 3),
(109, 'Собачье сердце', 4, 224, 2),
(110, 'Мертвые души', 5, 352, 1);

-- Доставщики
INSERT INTO Deliveries (Code_delivery, Name_delivery, Name_company, Address_company, Phone, INN) VALUES
(1, 'Иванов И.И.', 'СДЭК', 'г. Москва, ул. Ленина, д. 10', 79991112233, '7701234567890'),
(2, 'Петров П.П.', 'Деловые Линии', 'г. Москва, пр-т Мира, д. 25', 79992223344, '7702345678901'),
(3, 'Сидоров С.С.', 'Почта России', 'г. Москва, ул. Тверская, д. 7', 79993334455, '7703456789012'),
(4, 'Смирнов А.В.', 'Boxberry', 'г. Москва, ул. Арбат, д. 15', 79994445566, '7704567890123');

-- Продажи / Заказы
INSERT INTO Purchases (Code_purchase, Code_book, Date_order, Code_delivery, Type_purchase, Cost, Amount) VALUES
(1, 101, '2026-09-01 10:30', 1, 1, 950.0, 5),
(2, 102, '2026-09-02 11:15', 1, 1, 900.0, 3),
(3, 104, '2026-09-03 14:00', 2, 0, 750.0, 8),
(4, 106, '2026-09-05 16:45', 3, 1, 400.0, 15),
(5, 108, '2026-09-07 12:20', 2, 1, 850.0, 12),
(6, 109, '2026-09-10 09:50', 4, 0, 520.0, 6),
(7, 104, '2026-09-12 15:10', 1, 0, 750.0, 4),
(8, 108, '2026-09-15 17:30', 4, 1, 850.0, 7),
(9, 103, '2026-09-18 13:00', 3, 1, 1100.0, 2),
(10, 110, '2026-09-20 18:00', 2, 0, 600.0, 10);
GO
