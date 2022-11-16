--list the titles of all movies released in 2008
SELECT title FROM movies WHERE year = 2008;
--determine the birth year of Emma Stone
SELECT birth FROM people WHERE name = "Emma Stone";
--list the titles of all movies with a release date on or after 2018, in alphabetical order
SELECT title FROM movies WHERE year >= 2018 ORDER BY title;
--determine the number of movies with an IMDb rating of 10.0
SELECT COUNT(title) FROM movies JOIN ratings ON movies.id = ratings.movie_id WHERE rating = 10.0;
-- list the titles and release years of all Harry Potter movies, in chronological order
SELECT title, year FROM movies WHERE title LIKE "Harry Potter%" ORDER BY year;
--determine the average rating of all movies released in 2012
SELECT AVG(rating)
FROM ratings
JOIN movies
ON (ratings.movie_id = movies.id)
WHERE movies.year = 2012;
--list all movies released in 2010 and their ratings, in descending order by rating.
--For movies with the same rating, order them alphabetically by title
SELECT title, rating
FROM movies
JOIN ratings
ON (movies.id = ratings.movie_id)
WHERE year = 2010
ORDER BY rating 
DESC, title ;
--list the names of all people who starred in Toy Story
SELECT name FROM people
JOIN stars
ON (people.id = stars.person_id)
JOIN movies
ON (movies.id = stars.movie_id)
WHERE title = "Toy Story";
--list the names of all people who starred in a movie released in 2004, ordered by birth year
SELECT DISTINCT name FROM people
JOIN stars
ON (people.id = stars.person_id)
JOIN movies
ON (movies.id = stars.movie_id)
WHERE movies.year = 2004
ORDER BY people.birth;
--list the names of all people who have directed a movie that received a rating of at least 9.0
SELECT DISTINCT name
FROM people
JOIN directors
ON (people.id = directors.person_id)
JOIN movies ON (movies.id = directors.movie_id)
JOIN ratings ON (ratings.movie_id = movies.id)
WHERE NOT rating < 9;
--list the titles of the five highest rated movies (in order) that Chadwick Boseman starred in, starting with the highest rated
SELECT title
FROM movies
JOIN stars
ON (movies.id = stars.movie_id)
JOIN people
ON (people.id = stars.person_id)
JOIN ratings
ON (ratings.movie_id = movies.id)
WHERE name = "Chadwick Boseman"
ORDER BY rating DESC
LIMIT 5;
--list the titles of all movies in which both Johnny Depp and Helena Bonham Carter starred
SELECT JD.title FROM
(
    SELECT title, id
    FROM movies
    WHERE id IN
        (
        SELECT movie_id
        FROM stars
        WHERE person_id IN
            (
            SELECT id
            FROM people
            WHERE name IN ("Johnny Depp")
            )
        )
) AS JD
JOIN
(
    SELECT title, id
    FROM movies
    WHERE id IN
        (
        SELECT movie_id
        FROM stars
        WHERE person_id IN
            (
            SELECT id
            FROM people
            WHERE name IN ("Helena Bonham Carter")
            )
        )
) AS BC
WHERE JD.id = BC.id;
-- list the names of all people who starred in a movie in which Kevin Bacon also starred
Select DISTINCT name
From people JOIN stars ON (people.id = stars.person_id) JOIN movies ON (movies.id = stars.movie_id)
Where people.id = stars.person_id
And movies.id = stars.movie_id
And movies.id in ( select movie_id from stars where person_id = (select id from people where name = 'Kevin Bacon'))
AND NOT people.id = (SELECT id FROM people WHERE name = "Kevin Bacon")
ORDER BY name;