--1. Функция для автоматического обновления рейтинга фильма
CREATE OR REPLACE FUNCTION update_movie_rating()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE movie
    SET rating = (
        SELECT AVG(assessment)
        FROM review
        WHERE movie_id = NEW.movie_id
    )
    WHERE movie_id = NEW.movie_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

--2. Процедура для проверки минимального срока членства
CREATE OR REPLACE PROCEDURE restrict_short_membership_proc(
    new_valid_from DATE,
    new_valid_to DATE
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF new_valid_to < new_valid_from + INTERVAL '1 year' THEN
        RAISE EXCEPTION 'Membership period must be at least one year. Valid_from: %, Valid_to: %', new_valid_from, new_valid_to;
    END IF;
END;
$$;

--Вспомогательная функция для вызова этой процедуры
CREATE OR REPLACE FUNCTION restrict_short_membership_trigger_func()
RETURNS TRIGGER AS $$
BEGIN
    CALL restrict_short_membership_proc(NEW.valid_from, NEW.valid_to);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


--3. Функция для проверки дат киновстреч
CREATE OR REPLACE FUNCTION restrict_past_meetings()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.date < CURRENT_TIMESTAMP THEN
        RAISE EXCEPTION 'Meeting date (%) cannot be in the past.', NEW.date;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;




