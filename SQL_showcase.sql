-- create table statement

-- the table contains data about the 5000 top rated albums on rateyourmusic.com (a public rating website)
-- as of 2022-03-11

CREATE TABLE student.vc_music_table
(
"position" int4 NULL,
"release_name" varchar NULL ,
"artist_name" varchar NULL,
"release_date" date NULL,
"release_type" varchar NULL,
"primary_genres" varchar NULL,
"secondary_genres" varchar NULL,
"descriptors" varchar NULL,
"avg_rating" float4 NULL,
"rating_count" int4 NULL,
"review_count" int4 NULL
);

-- QC check examples

-- 1) count of rows
SELECT 
	count(*) AS no_of_rows
FROM
	student.vc_music_table vmt;

-- 5000
-- agreed with result in source

-- 2) count of columns
SELECT 
	count(*) AS no_of_columns
FROM
	information_schema.columns
WHERE 
	table_name = 'vc_music_table';

-- 11
-- agreed with result in source

-- 3) sum of columns
SELECT
	sum("position")+
	sum(avg_rating)+
	sum(rating_count)+
	sum(review_count) AS column_sum
FROM
	student.vc_music_table vmt ;

-- 43445216.109375
-- agreed with result in source

-- 4) sum of rows
SELECT 
	sum(position+
		avg_rating+
		rating_count+
		review_count) AS row_sum
FROM
	student.vc_music_table vmt ;

-- 43445216.11999965
-- agreed with result in source

-- 5) eyeball checks
-- row 249
SELECT
	*
FROM
	student.vc_music_table vmt 
WHERE 
	"position" = 249;
-- agreed with result in source

-- row 1763
SELECT
	*
FROM
	student.vc_music_table vmt 
WHERE 
	"position" = 1763;
-- agreed with result in source

-- row 2024
SELECT
	*
FROM
	student.vc_music_table vmt 
WHERE 
	"position" = 2024;
-- agreed with result in source

-- row 3005
SELECT
	*
FROM
	student.vc_music_table vmt 
WHERE 
	"position" = 3005;
-- agreed with result in source

-- row 4213
SELECT
	*
FROM
	student.vc_music_table vmt 
WHERE 
	"position" = 4213;
-- agreed with result in source


-- SQL queries
-- 1) 100 top rated albums
-- this is intersting to see which albums are rated best on average
-- ties are broken by the number of ratings and then number of reviews
SELECT 
	release_name,
	artist_name,
	release_date,
	avg_rating
FROM 
	student.vc_music_table vmt 
ORDER BY
	avg_rating DESC,
	rating_count DESC,
	review_count DESC
LIMIT 
	100;

-- 2) artists with 10 or more albums
-- it's impressive to make 1 album let alone 10, so that's why this query is here
SELECT 
	artist_name ,
	count(release_name) AS no_albums
FROM
	student.vc_music_table vmt 
GROUP BY
	artist_name
HAVING
	count(release_name) > 9
ORDER BY 
	count(release_name) desc;

-- 3) anything that isn't an album
-- there is a column titled 'release_type' and for a dataset of albums, i hoped that they were all albums
-- spolier alert: they are
SELECT
	*
FROM
	student.vc_music_table vmt 
WHERE 
	release_type NOT LIKE 'album';

-- 4) all albums by kendrick lamar
-- i like kendrick lamar, so ordered his albums by average rating
SELECT 
	*
FROM 
	student.vc_music_table vmt
WHERE 
	lower(artist_name) = 'kendrick lamar'
ORDER BY
	avg_rating DESC;

-- 5) albums that came out the week I was born
-- this one is the most important of course, i was born on 2001-05-24
-- i might have to give these albums a listen
SELECT 
	*
FROM 
	student.vc_music_table vmt 
WHERE 
	release_date BETWEEN '2001-05-24' AND '2001-05-30'
ORDER BY
	release_date;

-- 6) film soundtracks ordered by rating
-- i like movies as well as music so here are some highly-rated movie scores - highest rated first
SELECT 
	*
FROM 
	student.vc_music_table vmt 
WHERE 
	primary_genres ILIKE '%film soundtrack%'
ORDER BY 
	avg_rating DESC;

-- 7) albums with only one genre
-- it's sometimes difficult to label an album under just one genre, but these artists thought one was enough
-- only the top 50 of these are shown
SELECT
	*
FROM
	student.vc_music_table vmt 
WHERE
	primary_genres NOT LIKE '%,%'
ORDER BY 
	avg_rating DESC 
LIMIT 
	50;

-- 8) albums that don't have a secondary genre with a qualitative rating
-- the secondary genres give a bit more insight into what the album sounds, but they were
-- omitted here for whatever reason. also using a case query to make an extra rating system
SELECT 
	release_name,
	artist_name,
	secondary_genres,
	avg_rating,
	CASE 
		WHEN avg_rating >= 4 THEN 'HIGH'
		WHEN avg_rating >= 3 THEN 'MEDIUM'
		ELSE 'LOW'
	END	AS qual_rating
FROM 
	student.vc_music_table vmt 
WHERE 
	secondary_genres = 'NA'
ORDER BY
	avg_rating DESC 
;
	
-- 9) count of artists' albums with a score of 4 or more
-- a score of 4/5 or above is very good, so this shows how many very good albums each artist has
-- ordered by most to least
SELECT 
	artist_name,
	count("position") AS no_albums
FROM
	student.vc_music_table vmt 
WHERE
	avg_rating >= 4
GROUP BY
	artist_name
ORDER BY
	count("position") DESC; 

-- 10) artists' average rating
-- this is an average for all the ratings of each artist with more than 4 albums to see 
-- which artist make consistently good albums
SELECT
	artist_name,
	avg(avg_rating) AS overall_average
FROM
	student.vc_music_table vmt 
GROUP BY
	artist_name
HAVING 
	count(avg_rating) > 4
ORDER BY
	avg(avg_rating) DESC 
;
