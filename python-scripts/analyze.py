import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from scipy import stats
import numpy as np
import psycopg2
import matplotlib

# Установка стиля графиков
sns.set_style('darkgrid')
matplotlib.rcParams['font.size'] = 12

# Загрузка данных
try:
    df = pd.read_csv('genre_ratings.csv')
    if df.empty:
        print("Error: genre_ratings.csv is empty. Please check data extraction.")
        exit(1)
except FileNotFoundError:
    print("Error: genre_ratings.csv not found. Please run extract_data.py first.")
    exit(1)

# График 1: Столбчатая диаграмма среднего рейтинга по жанрам
plt.figure(figsize=(10, 6))
sns.barplot(x='avg_rating', y='genre', data=df, palette='viridis')
plt.title('Average Rating by Genre')
plt.xlabel('Average Rating')
plt.ylabel('Genre')
plt.tight_layout()
plt.savefig('bar_rating_by_genre.png')
plt.close()

# График 2: Точечная диаграмма зависимости рейтинга от количества рецензий
plt.figure(figsize=(10, 6))
sns.scatterplot(x='review_count', y='avg_rating', hue='genre', size='genre', data=df)
plt.title('Average Rating vs Review Count by Genre')
plt.xlabel('Review Count')
plt.ylabel('Average Rating')
plt.tight_layout()
plt.savefig('scatter_rating_vs_reviews.png')
plt.close()

# График 3: Коробчатая диаграмма рейтингов по жанрам
db_params = {
    'dbname': 'movie_club',
    'user': 'postgres',
    'password': '*****',
    'host': 'localhost',
    'port': '5432'
}

conn = psycopg2.connect(**db_params)
cur = conn.cursor()

cur.execute("SET search_path TO movie_club;")

query = """
    SELECT m.genre, r.assessment
    FROM movie m
    JOIN review r ON m.movie_id = r.movie_id
"""
cur.execute(query)
data = cur.fetchall()
cur.close()
conn.close()

ratings_df = pd.DataFrame(data, columns=['genre', 'assessment'])
if ratings_df.empty:
    print("Error: No ratings data found in the database.")
    exit(1)

plt.figure(figsize=(10, 6))
sns.boxplot(x='genre', y='assessment', data=ratings_df, palette='Set2')
plt.title('Rating Distribution by Genre')
plt.xlabel('Genre')
plt.ylabel('Rating')
plt.xticks(rotation=45)
plt.tight_layout()
plt.savefig('boxplot_rating_by_genre.png')
plt.close()