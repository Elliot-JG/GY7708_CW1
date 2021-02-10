# Connect to database using "connect" script with inputted credentials
source("RPostgreSQL_Connect.R")

## Q1 
  ## Query 2 
dbGetQuery(
  conn = pgsql_conn,
  statement = "
  SELECT person_name, date_of_birth
  FROM wikidata_htji_person
  WHERE person_name = 'Wes Anderson'
  "
)

  ## Query 4
dbGetQuery(
  conn = pgsql_conn,
  statement = "
  SELECT EXTRACT(YEAR FROM release_date) as year, SUM(boxoffice) as total_boxoffice_takings
  FROM wikidata_htji_movie
  GROUP BY year
  ORDER BY year
"
)

  ## Query 9
## retrieve the number of genres associated with the movie “Pacific Rim”
# Need to do some kind of count(*)
# Dont care what the genre is (we cant tell anyway)

# This gets counts of genres, by each movie_id
dbGetQuery(
  conn = pgsql_conn,
  statement = "
  SELECT movie_id, COUNT(genre_id)
  FROM wikidata_htji_movie_genre
  GROUP BY movie_id"
)


# Now we want to attach the actual movie name 
dbGetQuery(
  conn = pgsql_conn,
  statement = "
  with movies as
  (SELECT wikidata_htji_movie_genre.movie_id, wikidata_htji_movie.movie_title, wikidata_htji_movie_genre.genre_id
  FROM wikidata_htji_movie_genre
  LEFT JOIN wikidata_htji_movie
  ON wikidata_htji_movie.movie_id = wikidata_htji_movie_genre.movie_id
  )
  SELECT COUNT(genre_id)
  FROM movies
  WHERE movies.movie_title = 'Pacific Rim'
"

)

  ## Query 12
# Retrieve the standard deviation in the cost of producing “science fiction film” movies.
dbGetQuery(
  conn = pgsql_conn,
  statement = "
  with genres as (
  SELECT *
  FROM wikidata_htji_genre
  INNER JOIN wikidata_htji_movie_genre
  ON wikidata_htji_genre.genre_id = wikidata_htji_movie_genre.genre_id
  )

  SELECT genres.genre_name, STDDEV(wikidata_htji_movie.production_cost) as production_cost_std
  FROM wikidata_htji_movie
  INNER JOIN genres
  ON genres.movie_id = wikidata_htji_movie.movie_id
  WHERE genre_name = 'science fiction film'
  GROUP BY genre_name"
)





  ## Query 13
# retrieve the list of actors born in 1963 that have worked on a movie with a primary title starting
# with “The”, and for each actor the number of all their movies in their career.

# This gets all actors born on 1963, with a title beginning with 'The'
# actor_movie gets 
dbGetQuery(
  conn = pgsql_conn,
  statement = "
  with actor_movie as (
  SELECT wikidata_htji_movie_actor.*, wikidata_htji_movie.movie_title
  FROM wikidata_htji_movie_actor
  INNER JOIN wikidata_htji_movie
  ON wikidata_htji_movie_actor.movie_id = wikidata_htji_movie.movie_id
  )
  SELECT actor_movie.person_id, actor_movie.movie_title, wikidata_htji_person.date_of_birth
  FROM actor_movie
  INNER JOIN wikidata_htji_person
  ON actor_movie.person_id = wikidata_htji_person.person_id
  WHERE date_of_birth >= '1963-01-01' and date_of_birth < '1964-01-01' and movie_title LIKE 'The%'
"         
)




dbGetQuery(
  conn = pgsql_conn,
  statement = "
  SELECT wikidata_htji_movie_actor.person_id, COUNT(wikidata_htji_movie.movie_title) as total_movies
  FROM wikidata_htji_movie_actor
  LEFT JOIN wikidata_htji_movie
  ON wikidata_htji_movie_actor.movie_id = wikidata_htji_movie.movie_id
  GROUP BY person_id
"
)


dbGetQuery(
  conn = pgsql_conn,
  statement = "
  with actor_movie as (
  SELECT wikidata_htji_movie_actor.person_id, COUNT(wikidata_htji_movie.movie_title) as total_movies
  FROM wikidata_htji_movie_actor
  LEFT JOIN wikidata_htji_movie
  ON wikidata_htji_movie_actor.movie_id = wikidata_htji_movie.movie_id
  GROUP BY person_id
  )
  SELECT actor_movie.person_id, wikidata_htji_movie.movie_title, wikidata_htji_person.date_of_birth, actor_movie.total_movies
  FROM wikidata_htji_movie, actor_movie
  INNER JOIN wikidata_htji_person
  ON actor_movie.person_id = wikidata_htji_person.person_id
  WHERE date_of_birth >= '1963-01-01' and date_of_birth < '1964-01-01' and movie_title LIKE 'The%'
  "         
)




dbGetQuery(
  conn = pgsql_conn,
  statement = "
  with actor_movie as (
  SELECT wikidata_htji_movie_actor.person_id, COUNT(wikidata_htji_movie.movie_title) as total_movies
  FROM wikidata_htji_movie_actor
  LEFT JOIN wikidata_htji_movie
  ON wikidata_htji_movie_actor.movie_id = wikidata_htji_movie.movie_id
  GROUP BY person_id
  )
  SELECT actor_movie.person_id, actor_movie.total_movies
  FROM wikidata_htji_movie, actor_movie
  INNER JOIN wikidata_htji_person
  ON actor_movie.person_id = wikidata_htji_person.person_id
  WHERE date_of_birth >= '1963-01-01' and date_of_birth < '1964-01-01' and movie_title LIKE 'The%'
  "         
)


