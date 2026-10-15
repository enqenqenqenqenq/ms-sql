-- =====================================================================
-- Практическая работа №10: «Групповые операции. Агрегатные функции»
-- Студент: Николаев Тимофей
-- Файл 2: Выполнение запросов с агрегатными функциями, GROUP BY, HAVING, ORDER BY
-- =====================================================================

USE uch_proc;
GO

-- =====================================================================
-- ЗАДАНИЯ ИЗ МЕТОДИЧЕСКИХ УКАЗАНИЙ (Задания 1–7)
-- =====================================================================

-- Задание 1. Вывести среднюю оценку по таблице Успеваемость для студента с номером '01'
SELECT AVG(CAST(ozenka AS FLOAT)) AS [Средняя оценка студента 01]
FROM dbo.uspevaemost
WHERE ns = '01';
GO

-- Задание 2. Определить в таблице Студент количество студентов
-- Вариант 1: подсчет значений в столбце первичного ключа
SELECT COUNT(ns) AS [Количество студентов (COUNT ns)]
FROM dbo.student;

-- Вариант 2: подсчет строк таблицы через COUNT(*)
SELECT COUNT(*) AS [Общее число строк в таблице student]
FROM dbo.student;
GO

-- Задание 3. Определить для каждого студента по таблице Успеваемость минимальную оценку
SELECT 
    ns, 
    MIN(ozenka) AS [наихудшая]
FROM dbo.uspevaemost
GROUP BY ns;
GO

-- Дополнение к заданию 3: вывод с расшифровкой ФИО студента через JOIN
SELECT 
    s.ns AS [Номер зачетки],
    s.fio AS [ФИО студента],
    MIN(u.ozenka) AS [наихудшая]
FROM dbo.student AS s
JOIN dbo.uspevaemost AS u ON s.ns = u.ns
GROUP BY s.ns, s.fio;
GO

-- Задание 4. Наименьшая оценка каждого студента по каждому предмету
-- Группировка по нескольким полям (ns, kp)
SELECT 
    ns, 
    MIN(ozenka) AS [наихудшая], 
    kp
FROM dbo.uspevaemost
GROUP BY ns, kp;
GO

-- Дополнение к заданию 4: с понятными названиями предметов и именами студентов
SELECT 
    s.fio AS [Студент],
    p.name_predmet AS [Предмет],
    MIN(u.ozenka) AS [наихудшая]
FROM dbo.uspevaemost AS u
JOIN dbo.student AS s ON u.ns = s.ns
JOIN dbo.predmet AS p ON u.kp = p.kp
GROUP BY s.fio, p.name_predmet;
GO

-- Задание 5. Вывести наименьшую оценку полученную студентом '01' по каждому предмету
-- Фильтрация сгруппированных данных с помощью предложения HAVING
SELECT 
    ns, 
    MIN(ozenka) AS [наихудшая], 
    kp
FROM dbo.uspevaemost
GROUP BY ns, kp
HAVING ns = '01';
GO

-- Задание 6. Вывести по алфавиту список фамилий преподавателей
SELECT 
    fio, 
    kafedra
FROM dbo.prepodavatel
ORDER BY fio ASC;
GO

-- Задание 7. Вывести по порядку номера студентов в задании 4
-- Совместное применение GROUP BY и ORDER BY (ORDER BY всегда идет последним)
SELECT 
    ns, 
    MIN(ozenka) AS [наихудшая], 
    kp
FROM dbo.uspevaemost
GROUP BY ns, kp
ORDER BY ns ASC, kp ASC;
GO

-- =====================================================================
-- ДОПОЛНИТЕЛЬНЫЕ ПРАКТИЧЕСКИЕ АГРЕГАТНЫЕ ЗАПРОСЫ ДЛЯ ЗАЩИТЫ
-- =====================================================================

-- 8. Комплексная успеваемость: средний балл, макс, мин и количество сданных работ
SELECT 
    s.ns AS [Номер],
    s.fio AS [Студент],
    COUNT(u.ozenka) AS [Количество оценок],
    ROUND(AVG(CAST(u.ozenka AS FLOAT)), 2) AS [Средний балл],
    MIN(u.ozenka) AS [Мин. оценка],
    MAX(u.ozenka) AS [Макс. оценка]
FROM dbo.student AS s
JOIN dbo.uspevaemost AS u ON s.ns = u.ns
GROUP BY s.ns, s.fio
ORDER BY [Средний балл] DESC;
GO

-- 9. Поиск студентов-отличников/хорошистов (средний балл >= 4.0 через HAVING)
SELECT 
    s.fio AS [Студент],
    s.n_group AS [Группа],
    ROUND(AVG(CAST(u.ozenka AS FLOAT)), 2) AS [Средний балл]
FROM dbo.student AS s
JOIN dbo.uspevaemost AS u ON s.ns = u.ns
GROUP BY s.fio, s.n_group
HAVING AVG(CAST(u.ozenka AS FLOAT)) >= 4.0
ORDER BY [Средний балл] DESC;
GO

-- 10. Статистика по дисциплинам: средняя оценка и число сдавших студентов
SELECT 
    p.name_predmet AS [Предмет],
    COUNT(DISTINCT u.ns) AS [Число сдавших студентов],
    COUNT(u.id) AS [Всего оценок],
    ROUND(AVG(CAST(u.ozenka AS FLOAT)), 2) AS [Средний балл по предмету]
FROM dbo.predmet AS p
LEFT JOIN dbo.uspevaemost AS u ON p.kp = u.kp
GROUP BY p.name_predmet
ORDER BY [Средний балл по предмету] DESC;
GO
