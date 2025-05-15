--1. Индекс, для ускорения поиска фильмов по жанру
CREATE INDEX idx_movie_genre ON movie(genre);

--2. Индекс для ускорения поиска отзывов по фильму
CREATE INDEX idx_review_movie_id ON review(movie_id);