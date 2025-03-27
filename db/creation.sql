-- Create the schema
CREATE SCHEMA movie_club;

SET search_path TO movie_club;

CREATE TYPE sex_type AS ENUM ('M', 'F', 'Other');

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

-- Создаем триггер для автоматического обновления rating
CREATE TRIGGER update_rating_trigger
AFTER INSERT OR UPDATE OR DELETE ON review
FOR EACH ROW
EXECUTE FUNCTION update_movie_rating();

-- Table: member (with versioning data: valid_from, valid_to)
CREATE TABLE member (
    member_id SERIAL PRIMARY KEY,
    first_name VARCHAR(200) NOT NULL,
    second_name VARCHAR(200) NOT NULL,
    birthday DATE,
    sex sex_type NOT NULL, -- Используем созданный тип sex_type
    valid_from DATE NOT NULL,
    valid_to DATE NOT NULL
);

-- Таблица: filmmaker
CREATE TABLE filmmaker (
    filmmaker_id SERIAL PRIMARY KEY,
    first_name VARCHAR(200) NOT NULL,
    second_name VARCHAR(200) NOT NULL,
    birthday DATE,
    sex sex_type NOT NULL, -- Используем созданный тип sex_type
    description TEXT NOT NULL
);

-- Таблица: movie
CREATE TABLE movie (
    movie_id SERIAL PRIMARY KEY,
    filmmaker_id INTEGER NOT NULL,
    genre VARCHAR(200) NOT NULL,
    rating REAL,
    name VARCHAR(200) NOT NULL,
    description TEXT NOT NULL,
    FOREIGN KEY (filmmaker_id) REFERENCES filmmaker(filmmaker_id)
);

-- Таблица: meeting
CREATE TABLE meeting (
    meeting_id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    date TIMESTAMP NOT NULL
);

-- Таблица: meeting_registration
CREATE TABLE meeting_registration (
    member_id INTEGER NOT NULL,
    meeting_id INTEGER NOT NULL,
    PRIMARY KEY (member_id, meeting_id),
    FOREIGN KEY (member_id) REFERENCES member(member_id),
    FOREIGN KEY (meeting_id) REFERENCES meeting(meeting_id)
);

-- Таблица: movie_discussion
CREATE TABLE movie_discussion (
    movie_id INTEGER NOT NULL,
    meeting_id INTEGER NOT NULL,
    PRIMARY KEY (movie_id, meeting_id),
    FOREIGN KEY (movie_id) REFERENCES movie(movie_id),
    FOREIGN KEY (meeting_id) REFERENCES meeting(meeting_id)
);

-- Таблица: review
CREATE TABLE review (
    review_id SERIAL PRIMARY KEY,
    member_id INTEGER NOT NULL,
    movie_id INTEGER NOT NULL,
    comment TEXT,
    assessment INTEGER NOT NULL,
    FOREIGN KEY (member_id) REFERENCES member(member_id),
    FOREIGN KEY (movie_id) REFERENCES movie(movie_id)
);