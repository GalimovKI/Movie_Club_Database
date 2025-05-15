import psycopg2
from faker import Faker
import random
from datetime import datetime, timedelta

fake = Faker()

# Параметры подключения к базе данных
db_params = {
    'dbname': 'movie_club',
    'user': 'postgres',
    'password': '*****',
    'host': 'localhost',
    'port': '5432'
}

# Подключение к базе данных
conn = psycopg2.connect(**db_params)
cur = conn.cursor()

# Установка схемы
cur.execute("SET search_path TO movie_club;")

# Генерация дополнительных режиссёров (10 новых)
filmmakers = []
for _ in range(10):
    first_name = fake.first_name()
    second_name = fake.last_name()
    birthday = fake.date_of_birth(minimum_age=30, maximum_age=80)
    sex = random.choice(['M', 'F', 'Other'])
    description = fake.text(max_nb_chars=200)
    filmmakers.append((first_name, second_name, birthday, sex, description))

cur.executemany("""
    INSERT INTO filmmaker (first_name, second_name, birthday, sex, description)
    VALUES (%s, %s, %s, %s, %s)
""", filmmakers)

# Получение ID режиссёров
cur.execute("SELECT filmmaker_id FROM filmmaker;")
filmmaker_ids = [row[0] for row in cur.fetchall()]

# Генерация дополнительных фильмов (20 новых)
genres = ['Sci-Fi', 'Drama', 'Action', 'Comedy', 'Thriller', 'Crime', 'Adventure']
movies = []
for _ in range(20):
    filmmaker_id = random.choice(filmmaker_ids)
    genre = random.choice(genres)
    name = fake.catch_phrase()
    description = fake.text(max_nb_chars=200)
    movies.append((filmmaker_id, genre, name, description))

cur.executemany("""
    INSERT INTO movie (filmmaker_id, genre, name, description)
    VALUES (%s, %s, %s, %s)
""", movies)

# Получение ID фильмов
cur.execute("SELECT movie_id FROM movie;")
movie_ids = [row[0] for row in cur.fetchall()]

# Генерация дополнительных участников (20 новых)
members = []
for _ in range(20):
    first_name = fake.first_name()
    second_name = fake.last_name()
    birthday = fake.date_of_birth(minimum_age=18, maximum_age=60)
    sex = random.choice(['M', 'F', 'Other'])
    valid_from = fake.date_between(start_date='-1y', end_date='today')
    valid_to = valid_from + timedelta(days=365 + random.randint(0, 365))  # Минимум 1 год
    members.append((first_name, second_name, birthday, sex, valid_from, valid_to))

cur.executemany("""
    INSERT INTO member (first_name, second_name, birthday, sex, valid_from, valid_to)
    VALUES (%s, %s, %s, %s, %s, %s)
""", members)

# Получение ID участников
cur.execute("SELECT member_id FROM member;")
member_ids = [row[0] for row in cur.fetchall()]

# Генерация дополнительных киновстреч (15 новых)
meetings = []
for _ in range(15):
    name = fake.sentence(nb_words=3)
    date = fake.date_time_between(start_date='now', end_date='+6m')
    meetings.append((name, date))

cur.executemany("""
    INSERT INTO meeting (name, date)
    VALUES (%s, %s)
""", meetings)

# Получение ID киновстреч
cur.execute("SELECT meeting_id FROM meeting;")
meeting_ids = [row[0] for row in cur.fetchall()]

# Генерация регистраций на киновстречи (100 новых)
meeting_registrations = []
for _ in range(100):
    member_id = random.choice(member_ids)
    meeting_id = random.choice(meeting_ids)
    meeting_registrations.append((member_id, meeting_id))

cur.executemany("""
    INSERT INTO meeting_registration (member_id, meeting_id)
    VALUES (%s, %s)
    ON CONFLICT DO NOTHING
""", meeting_registrations)

# Генерация обсуждений фильмов (50 новых)
movie_discussions = []
for _ in range(50):
    movie_id = random.choice(movie_ids)
    meeting_id = random.choice(meeting_ids)
    movie_discussions.append((movie_id, meeting_id))

cur.executemany("""
    INSERT INTO movie_discussion (movie_id, meeting_id)
    VALUES (%s, %s)
    ON CONFLICT DO NOTHING
""", movie_discussions)

# Генерация рецензий (100 новых)
reviews = []
for _ in range(100):
    member_id = random.choice(member_ids)
    movie_id = random.choice(movie_ids)
    comment = fake.text(max_nb_chars=100)
    assessment = random.randint(1, 10)
    reviews.append((member_id, movie_id, comment, assessment))

cur.executemany("""
    INSERT INTO review (member_id, movie_id, comment, assessment)
    VALUES (%s, %s, %s, %s)
""", reviews)

# Подтверждение транзакции
conn.commit()

# Закрытие соединения
cur.close()
conn.close()

print("Data generated and inserted successfully.")