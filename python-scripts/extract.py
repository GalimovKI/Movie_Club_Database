import psycopg2
import pandas as pd

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

cur.execute("SET search_path TO movie_club;")

# Запрос для извлечения агрегированных данных
query = """
    SELECT m.genre, AVG(r.assessment) AS avg_rating, COUNT(r.review_id) AS review_count
    FROM movie m
    LEFT JOIN review r ON m.movie_id = r.movie_id
    GROUP BY m.genre
    HAVING COUNT(r.review_id) > 0
    ORDER BY avg_rating DESC;
"""

# Выполнение запроса и загрузка в DataFrame
cur.execute(query)
data = cur.fetchall()
columns = ['genre', 'avg_rating', 'review_count']
df = pd.DataFrame(data, columns=columns)

# Сохранение данных в CSV для дальнейшего анализа
df.to_csv('genre_ratings.csv', index=False)

# Закрытие соединения
cur.close()
conn.close()

print("Data extracted and saved to genre_ratings.csv")
print(df)