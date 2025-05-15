--1. Представление "Активные участники"
CREATE OR REPLACE VIEW active_members AS
SELECT member_id, first_name, second_name, birthday, sex
FROM member
WHERE valid_from <= CURRENT_DATE AND valid_to >= CURRENT_DATE;

--2. Представление "Фильмы с количеством отзывов"
CREATE OR REPLACE VIEW movie_with_review_count AS
SELECT 
    m.movie_id,
    m.name AS movie_name,
    m.genre,
    m.rating,
    COUNT(r.review_id) AS review_count
FROM movie m
LEFT JOIN review r ON m.movie_id = r.movie_id
GROUP BY m.movie_id
ORDER BY review_count DESC;
