-- =====================================================================
-- Практическая работа №1: «Функциональность и архитектура СУБД Microsoft SQL Server»
-- Студент: Николаев Тимофей
-- Файл 3: Сервисные операции: отключение (Detach) и подключение (Attach) базы данных
-- =====================================================================

USE master;
GO

-- 1. Перевод базы данных в режим SINGLE_USER для безопасного отключения
-- (сброс активных пользовательских соединений)
IF EXISTS (SELECT * FROM sys.databases WHERE name = 'DELIVERY')
BEGIN
    ALTER DATABASE DELIVERY SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
END
GO

-- 2. Отключение базы данных (Detach)
-- При отключении база удаляется из системного каталога, но файлы .mdf и .ldf остаются на диске
IF EXISTS (SELECT * FROM sys.databases WHERE name = 'DELIVERY')
BEGIN
    EXEC sp_detach_db @dbname = 'DELIVERY';
END
GO

-- Проверка: базы данных DELIVERY нет в списке активных баз
SELECT name, state_desc 
FROM sys.databases 
WHERE name = 'DELIVERY';
GO

-- 3. Подключение базы данных (Attach)
-- Демонстрационный синтаксис подключения файлов БД обратно к серверу
-- (пути к файлам указываются в соответствии с расположением при создании БД)
/*
CREATE DATABASE DELIVERY ON 
( FILENAME = N'E:\PRSQL\DELIVERY.mdf' ),
( FILENAME = N'E:\PRSQL\DELIVERY_log.ldf' )
FOR ATTACH;
GO

-- Возврат базы в многопользовательский режим
ALTER DATABASE DELIVERY SET MULTI_USER;
GO
*/
