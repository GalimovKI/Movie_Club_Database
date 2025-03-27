
--1. Фильмы с высоким рейтингом (WHERE, ORDER BY, LIMIT)
--Описание: Найти 5 фильмов с самым высоким рейтингом, у которых рейтинг больше 8, и отсортировать их по убыванию рейтинга.
SELECT m.movie_id, m.name, m.rating
FROM movie m
WHERE m.rating > 8
ORDER BY m.rating DESC
LIMIT 5;

--2. Количество рецензий на фильм (GROUP BY, HAVING, JOIN)
--Описание: Найти фильмы, на которые написано более 1 рецензии, и показать количество рецензий для каждого фильма.

SELECT m.name, COUNT(r.review_id) AS review_count
FROM movie m
LEFT JOIN review r ON m.movie_id = r.movie_id
GROUP BY m.movie_id, m.name
HAVING COUNT(r.review_id) > 1;

--3. Участники, зарегистрированные на киновстречи в определённый период (WHERE, JOIN, подзапрос с IN)
--Описание: Найти имена участников, которые зарегистрированы на киновстречи, проходящие в феврале 2025 года, и которые были активны в этот период (по valid_from и valid_to).
SELECT DISTINCT m.first_name, m.second_name
FROM member m
INNER JOIN meeting_registration mr ON m.member_id = mr.member_id
WHERE mr.meeting_id IN (
    SELECT meeting_id
    FROM meeting
    WHERE date BETWEEN '2025-02-01' AND '2025-02-28'
)
AND m.valid_from <= '2025-02-28'
AND m.valid_to >= '2025-02-01';

--4. Режиссёры с наибольшим количеством фильмов (GROUP BY, ORDER BY, подзапрос с ALL)
--Описание: Найти режиссёров, у которых количество фильмов больше, чем у всех режиссёров, родившихся после 1980 года.
SELECT f.first_name, f.second_name, COUNT(m.movie_id) AS movie_count
FROM filmmaker f
LEFT JOIN movie m ON f.filmmaker_id = m.filmmaker_id
GROUP BY f.filmmaker_id, f.first_name, f.second_name
HAVING COUNT(m.movie_id) > ALL (
    SELECT COUNT(m2.movie_id)
    FROM filmmaker f2
    LEFT JOIN movie m2 ON f2.filmmaker_id = m2.filmmaker_id
    WHERE f2.birthday > '1980-01-01'
    GROUP BY f2.filmmaker_id
)
ORDER BY movie_count DESC;

--5. Фильмы, обсуждаемые на киновстречах, с количеством участников (JOIN, GROUP BY, оконная функция)
--Описание: Для каждого фильма, обсуждаемого на киновстрече, показать количество участников, зарегистрированных на эту киновстречу, и общее количество участников по всем киновстречам для этого фильма (с использованием оконной функции).
SELECT 
    m.name AS movie_name,
    mt.name AS meeting_name,
    COUNT(mr.member_id) AS participant_count,
    SUM(COUNT(mr.member_id)) OVER (PARTITION BY m.movie_id) AS total_participants_for_movie
FROM movie m
INNER JOIN movie_discussion md ON m.movie_id = md.movie_id
INNER JOIN meeting mt ON md.meeting_id = mt.meeting_id
LEFT JOIN meeting_registration mr ON mt.meeting_id = mr.meeting_id
GROUP BY m.movie_id, m.name, mt.meeting_id, mt.name
ORDER BY m.name, mt.name;

--6. Ранжирование фильмов по рейтингу в жанре (оконная функция, JOIN)
--Описание: Для каждого фильма показать его рейтинг и ранг внутри жанра (с использованием оконной функции DENSE_RANK).
SELECT 
    m.name,
    m.genre,
    m.rating,
    DENSE_RANK() OVER (PARTITION BY m.genre ORDER BY m.rating DESC) AS rank_in_genre
FROM movie m
WHERE m.rating IS NOT NULL
ORDER BY m.genre, m.rating DESC;

--7. Участники, оставившие рецензии на фильмы определённого режиссёра (JOIN, подзапрос с EXISTS)
--Описание: Найти участников, которые оставили рецензии на фильмы режиссёра Christopher Nolan.

SELECT DISTINCT m.first_name, m.second_name
FROM member m
WHERE EXISTS (
    SELECT 1
    FROM review r
    INNER JOIN movie mv ON r.movie_id = mv.movie_id
    INNER JOIN filmmaker f ON mv.filmmaker_id = f.filmmaker_id
    WHERE r.member_id = m.member_id
    AND f.first_name = 'Christopher' AND f.second_name = 'Nolan'
);

--8. Киновстречи с фильмами, у которых рейтинг выше среднего (подзапрос, JOIN, GROUP BY)
--Описание: Найти киновстречи, на которых обсуждались фильмы с рейтингом выше среднего рейтинга всех фильмов.
SELECT mt.name AS meeting_name, COUNT(md.movie_id) AS movie_count
FROM meeting mt
INNER JOIN movie_discussion md ON mt.meeting_id = md.meeting_id
INNER JOIN movie m ON md.movie_id = m.movie_id
WHERE m.rating > (
    SELECT AVG(rating)
    FROM movie
    WHERE rating IS NOT NULL
)
GROUP BY mt.meeting_id, mt.name
ORDER BY movie_count DESC;

--9. Участники, которые посещали киновстречи чаще среднего (самосоединение, подзапрос с ANY, LIMIT/OFFSET)
--Описание: Найти участников, которые зарегистрированы на киновстречи чаще, чем среднее количество регистраций на участника, и вывести первых 5, начиная со второго (с использованием LIMIT и OFFSET).
WITH avg_registrations AS (
    SELECT AVG(reg_count) AS avg_count
    FROM (
        SELECT COUNT(*) AS reg_count
        FROM meeting_registration
        GROUP BY member_id
    ) sub
)
SELECT 
    m1.first_name,
    m1.second_name,
    COUNT(mr.meeting_id) AS meeting_count
FROM member m1
LEFT JOIN meeting_registration mr ON m1.member_id = mr.member_id
WHERE m1.valid_to >= CURRENT_DATE
GROUP BY m1.member_id, m1.first_name, m1.second_name
HAVING COUNT(mr.meeting_id) >= ANY (SELECT avg_count FROM avg_registrations)
ORDER BY meeting_count DESC
LIMIT 5;

--10. Средний рейтинг фильмов по жанрам с накопительным итогом (оконная функция, GROUP BY, ORDER BY)
--Описание: Для каждого жанра показать средний рейтинг фильмов и накопительный средний рейтинг по жанрам, отсортированным по алфавиту.
SELECT 
    m.genre,
    AVG(m.rating) AS avg_rating,
    SUM(AVG(m.rating)) OVER (ORDER BY m.genre ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_avg
FROM movie m
WHERE m.rating IS NOT NULL
GROUP BY m.genre
ORDER BY m.genre;