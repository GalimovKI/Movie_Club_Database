-- Active: 1742168101693@@127.0.0.1@5432@movie_club
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

INSERT INTO filmmaker (first_name, second_name, birthday, sex, description) VALUES
('Christopher', 'Nolan', '1970-07-30', 'M', 'Known for complex narratives and blockbusters.'),
('Greta', 'Gerwig', '1983-08-04', 'F', 'Director of coming-of-age films.'),
('Quentin', 'Tarantino', '1963-03-27', 'M', 'Famous for nonlinear storytelling.'),
('Sofia', 'Coppola', '1971-05-14', 'F', 'Known for introspective dramas.'),
('Martin', 'Scorsese', '1942-11-17', 'M', 'Legendary director of crime films.'),
('Ava', 'DuVernay', '1972-08-24', 'F', 'Advocate for diversity in film.'),
('Steven', 'Spielberg', '1946-12-18', 'M', 'Pioneer of the modern blockbuster.'),
('Wes', 'Anderson', '1969-05-01', 'M', 'Known for quirky, symmetrical aesthetics.'),
('Patty', 'Jenkins', '1971-07-24', 'F', 'Director of superhero films.'),
('David', 'Fincher', '1962-08-28', 'M', 'Master of psychological thrillers.'),
('Bong', 'Joon-ho', '1969-09-14', 'M', 'Acclaimed for socially conscious films.'),
('Chloé', 'Zhao', '1982-03-31', 'F', 'Known for naturalistic storytelling.'),
('James', 'Cameron', '1954-08-16', 'M', 'Creator of sci-fi epics.'),
('Taika', 'Waititi', '1975-08-16', 'M', 'Known for humorous and heartfelt films.'),
('Denis', 'Villeneuve', '1967-10-03', 'M', 'Director of thought-provoking sci-fi.');

INSERT INTO movie (filmmaker_id, genre, rating, name, description) VALUES
(1, 'Sci-Fi', NULL, 'Inception', 'A thief enters dreams to steal secrets.'),
(1, 'Action', NULL, 'The Dark Knight', 'Batman faces the Joker.'),
(2, 'Drama', NULL, 'Lady Bird', 'A teen navigates her senior year.'),
(3, 'Action', NULL, 'Pulp Fiction', 'Interwoven stories of crime.'),
(4, 'Drama', NULL, 'Lost in Translation', 'Two strangers connect in Tokyo.'),
(5, 'Crime', NULL, 'The Irishman', 'A hitman reflects on his life.'),
(6, 'Drama', NULL, 'Selma', 'The civil rights movement.'),
(7, 'Adventure', NULL, 'Jurassic Park', 'Dinosaurs break free in a theme park.'),
(8, 'Comedy', NULL, 'The Grand Budapest Hotel', 'A concierge’s adventures.'),
(9, 'Action', NULL, 'Wonder Woman', 'A warrior fights in WWI.'),
(10, 'Thriller', NULL, 'Fight Club', 'An underground fight club spirals.'),
(11, 'Drama', NULL, 'Parasite', 'A poor family infiltrates a rich one.'),
(12, 'Drama', NULL, 'Nomadland', 'A woman lives as a modern nomad.'),
(13, 'Sci-Fi', NULL, 'Avatar', 'A marine explores Pandora.'),
(14, 'Comedy', NULL, 'Thor: Ragnarok', 'Thor teams up with Loki.');

INSERT INTO meeting (name, date) VALUES
('Sci-Fi Night', '2025-01-10 18:00:00'),
('Drama Discussion', '2025-01-15 19:00:00'),
('Action Movie Marathon', '2025-01-20 17:00:00'),
('Comedy Club', '2025-01-25 18:30:00'),
('Thriller Evening', '2025-02-01 19:00:00'),
('Classic Film Night', '2025-02-05 18:00:00'),
('Indie Film Screening', '2025-02-10 19:00:00'),
('Superhero Special', '2025-02-15 17:30:00'),
('Crime Drama Night', '2025-02-20 18:00:00'),
('Adventure Film Fest', '2025-02-25 19:00:00'),
('Oscar Winners', '2025-03-01 18:00:00'),
('Foreign Film Night', '2025-03-05 19:00:00'),
('Fantasy Evening', '2025-03-10 18:30:00'),
('Romantic Drama', '2025-03-15 19:00:00'),
('Documentary Screening', '2025-03-20 18:00:00');

INSERT INTO member (first_name, second_name, birthday, sex, valid_from, valid_to) VALUES
('John', 'Doe', '1990-05-12', 'M', '2024-01-01', '2025-12-31'),
('Jane', 'Smith', '1985-03-22', 'F', '2024-01-01', '2025-12-31'),
('Alex', 'Brown', '1995-07-15', 'M', '2024-01-01', '2025-12-31'),
('Emily', 'Davis', '1992-11-30', 'F', '2024-01-01', '2025-12-31'),
('Michael', 'Wilson', '1988-09-10', 'M', '2024-01-01', '2025-12-31'),
('Sarah', 'Johnson', '1993-02-14', 'F', '2024-01-01', '2025-12-31'),
('David', 'Lee', '1990-06-25', 'M', '2024-01-01', '2025-12-31'),
('Laura', 'Martinez', '1987-12-05', 'F', '2024-01-01', '2025-12-31'),
('Chris', 'Taylor', '1994-04-18', 'M', '2024-01-01', '2025-12-31'),
('Anna', 'Garcia', '1991-08-20', 'F', '2024-01-01', '2025-12-31'),
('Mark', 'Clark', '1989-01-30', 'M', '2024-01-01', '2025-12-31'),
('Lisa', 'Rodriguez', '1996-03-10', 'F', '2024-01-01', '2025-12-31'),
('James', 'Lewis', '1986-07-22', 'M', '2024-01-01', '2025-12-31'),
('Megan', 'Walker', '1993-05-05', 'F', '2024-01-01', '2025-12-31'),
('Tom', 'Hall', '1990-09-15', 'M', '2024-01-01', '2025-12-31'),
('John', 'Doe', '1990-05-12', 'M', '2023-01-01', '2023-12-31'),
('Jane', 'Smith', '1985-03-22', 'F', '2023-01-01', '2023-12-31'),
('Alex', 'Brown', '1995-07-15', 'M', '2023-01-01', '2023-12-31'),
('Emily', 'Davis', '1992-11-30', 'F', '2023-01-01', '2023-12-31'),
('Michael', 'Wilson', '1988-09-10', 'M', '2023-01-01', '2023-12-31'),
('Sarah', 'Johnson', '1993-02-14', 'F', '2023-01-01', '2023-12-31'),
('David', 'Lee', '1990-06-25', 'M', '2023-01-01', '2023-12-31'),
('Laura', 'Martinez', '1987-12-05', 'F', '2023-01-01', '2023-12-31'),
('Chris', 'Taylor', '1994-04-18', 'M', '2023-01-01', '2023-12-31'),
('Anna', 'Garcia', '1991-08-20', 'F', '2023-01-01', '2023-12-31'),
('Mark', 'Clark', '1989-01-30', 'M', '2022-01-01', '2022-12-31'),
('Lisa', 'Rodriguez', '1996-03-10', 'F', '2022-01-01', '2022-12-31'),
('James', 'Lewis', '1986-07-22', 'M', '2022-01-01', '2022-12-31'),
('Megan', 'Walker', '1993-05-05', 'F', '2022-01-01', '2022-12-31'),
('Tom', 'Hall', '1990-09-15', 'M', '2022-01-01', '2022-12-31');

INSERT INTO meeting_registration (member_id, meeting_id) VALUES
(1, 1), (2, 1), (3, 1), (4, 1), (5, 1),
(6, 2), (7, 2), (8, 2), (9, 2), (10, 2),
(11, 3), (12, 3), (13, 3), (14, 3), (15, 3),
(1, 4), (2, 4), (3, 4), (4, 4), (5, 4),
(6, 5), (7, 5), (8, 5), (9, 5), (10, 5),
(11, 6), (12, 6), (13, 6), (14, 6), (15, 6);

INSERT INTO movie_discussion (movie_id, meeting_id) VALUES
(1, 1), (2, 1), (3, 1),
(4, 2), (5, 2), (6, 2),
(7, 3), (8, 3), (9, 3),
(10, 4), (11, 4), (12, 4),
(13, 5), (14, 5), (15, 5),
(1, 6), (2, 6), (3, 6),
(4, 7), (5, 7), (6, 7),
(7, 8), (8, 8), (9, 8),
(10, 9), (11, 9), (12, 9),
(13, 10), (14, 10), (15, 10);

INSERT INTO review (member_id, movie_id, comment, assessment) VALUES
(1, 1, 'Mind-bending plot!', 9),
(2, 1, 'Really good, but confusing.', 7),
(3, 2, 'Heath Ledger was phenomenal.', 10),
(4, 2, 'A classic!', 8),
(5, 3, 'Really touching story.', 8),
(6, 4, 'Classic Tarantino!', 9),
(7, 5, 'Beautifully shot.', 7),
(8, 6, 'Very intense.', 8),
(9, 7, 'Inspiring history lesson.', 8),
(10, 8, 'A thrilling adventure.', 9),
(11, 9, 'Visually stunning.', 8),
(12, 10, 'Great action scenes.', 7),
(13, 11, 'Thought-provoking.', 9),
(14, 12, 'A masterpiece.', 10),
(15, 13, 'Slow but beautiful.', 8);

